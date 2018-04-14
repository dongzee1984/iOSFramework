//
//  WYTableView.m
//  WYCore
//
//  Created by wanglidong on 13-5-24.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYTableView.h"
#import "WYBase.h"

#ifndef LOG_THIS_FILE
#define LOG_THIS_FILE 0
#endif

#pragma mark -
@interface WYTableView (Private)

- (void)sharedInit;

- (void)layoutItemRects;
- (void)layoutVisibleItems;
- (void)loadItemAtIndex:(NSUInteger)index;
- (void)loadItemAtIndexes:(NSIndexSet *)indexes;
- (void)recycleView:(UIView *)view;
- (void)recycleItemAtIndexes:(NSIndexSet *)indexes;

- (NSUInteger)leftItemIndex;
- (NSUInteger)rightItemIndex;

@end


#pragma mark -
@implementation WYTableView

@synthesize dataSource      = _dataSource;
@synthesize itemWidth       = _itemWidth;
@synthesize itemHeight      = _itemHeight;
@synthesize gapBetweenItems = _gapBetweenItems;
@synthesize visibleInsets   = _visibleInsets;

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"itemWidth"];
    [self removeObserver:self forKeyPath:@"itemHeight"];
    [self removeObserver:self forKeyPath:@"gapBetweenItems"];
    
    [_itemRects release],      _itemRects      = nil;
    [_visibleViews release],   _visibleViews   = nil;
    [_reuseableViews release], _reuseableViews = nil;
    
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self sharedInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self sharedInit];
        
        _boundSize = [UIScreen mainScreen].bounds.size;
    }
    return self;
}


#pragma mark - (Private)

- (void)sharedInit
{
    _itemRects       = [[NSMutableArray alloc] init];
    _visibleRange    = NSMakeRange(0, 0);
    _visibleViews    = [[NSMutableArray alloc] init];
    _reuseableViews  = [[NSMutableSet alloc] init];
    _itemWidth       = 44.0;
    _itemHeight      = 44.0;
    _gapBetweenItems = 0.0;
    _visibleInsets   = UIEdgeInsetsZero;
    
    self.directionalLockEnabled = YES;
    
    [self addObserver:self forKeyPath:@"itemWidth" options:0 context:nil];
    [self addObserver:self forKeyPath:@"itemHeight" options:0 context:nil];
    [self addObserver:self forKeyPath:@"gapBetweenItems" options:0 context:nil];
    
    [self setLayout];
}

- (void)layoutItemRects
{
    __block CGPoint contentOffset = CGPointZero;
    __block CGSize  contentSize   = CGSizeZero;
    
    NSEnumerationOptions enumerationOptions = 0;
    
    void(^__block contentUpdater)(CGRect) = ^(CGRect itemRect)
    {
        CGFloat step = itemRect.size.width + _gapBetweenItems;
        contentOffset.x += step;
        contentSize.width += step;
    };
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfItems])];
    
    [indexSet enumerateIndexesWithOptions:enumerationOptions usingBlock:^(NSUInteger idx, BOOL *stop)
     {
         CGRect itemRect = [[_itemRects objectAtIndex:idx] CGRectValue];
         itemRect.origin.x = contentOffset.x;
         itemRect.origin.y = contentOffset.y;
         [_itemRects replaceObjectAtIndex:idx withObject:[NSValue valueWithCGRect:itemRect]];
         contentUpdater(itemRect);
     }];
    
    contentSize.width -= _gapBetweenItems;
    
    if (contentSize.width < self.frame.size.width)
    {
        contentSize.width = self.frame.size.width;
    }
    
    self.contentSize = contentSize;
    
    [self layoutVisibleItems];
}

- (void)layoutVisibleItems
{
    NSIndexSet *oldVisibleIndexes = [NSIndexSet indexSetWithIndexesInRange:_visibleRange];
    NSIndexSet *newVisibleIndexes = [self indexesForItemsInRect:[self visibleRect]];
    
    if (![oldVisibleIndexes isEqualToIndexSet:newVisibleIndexes])
    {
        NSIndexSet *indexesForRecycle = [oldVisibleIndexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop)
                                         {
                                             return ![newVisibleIndexes containsIndex:idx];
                                         }];
        [self recycleItemAtIndexes:indexesForRecycle];
        
        NSUInteger firstIndex = [newVisibleIndexes firstIndex];
        NSUInteger lastIndex = [newVisibleIndexes lastIndex];
        _visibleRange = (!newVisibleIndexes) ? NSMakeRange(0, 0) : NSMakeRange(firstIndex, lastIndex - firstIndex + 1);
        
        NSIndexSet *indexesForLoad = [newVisibleIndexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop)
                                      {
                                          return ![oldVisibleIndexes containsIndex:idx];
                                      }];
        [self loadItemAtIndexes:indexesForLoad];
    }
    
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    
    [newVisibleIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         UIView *view = [self viewForItemAtIndex:idx];
         CGRect itemRect = [self rectForItemAtIndex:idx];
         
         if (!view.subviews || !CGPointEqualToPoint(view.frame.origin, itemRect.origin))
         {
             [UIView setAnimationsEnabled:NO];
         }
         
         if (!CGRectEqualToRect(view.frame, itemRect))
         {
             view.frame = itemRect;
         }
         
         if (!view.superview)
         {
             if (self.tableDelegate && [self.tableDelegate respondsToSelector:@selector(tableView:willDisplayView:forItemAtIndex:)])
             {
                 [self.tableDelegate tableView:self willDisplayView:view forItemAtIndex:idx];
             }
             [self insertSubview:view atIndex:1];
         }
         
         [UIView setAnimationsEnabled:animationsEnabled];
     }];
}

- (void)loadItemAtIndex:(NSUInteger)index
{
    UIView *view = [self.dataSource tableView:self viewForItemAtIndex:index];
    [_visibleViews insertObject:view atIndex:index - _visibleRange.location];
}

- (void)loadItemAtIndexes:(NSIndexSet *)indexes
{
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         [self loadItemAtIndex:idx];
     }];
}

- (void)recycleView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    
    [view retain];
    [view removeFromSuperview];
    [_visibleViews removeObject:view];
    [_reuseableViews addObject:view];
    [view release];
}

- (void)recycleItemAtIndexes:(NSIndexSet *)indexes
{
    [indexes enumerateIndexesWithOptions:NSEnumerationReverse usingBlock:^(NSUInteger idx, BOOL *stop)
     {
         [self recycleView:[self viewForItemAtIndex:idx]];
     }];
}

- (NSUInteger)leftItemIndex
{
    NSUInteger centerItemIndex = [self indexForItemAtCenterOfBounds];
    
    if (centerItemIndex == 0)
    {
        return NSNotFound;
    }
    return centerItemIndex - 1;
}

- (NSUInteger)rightItemIndex
{
    NSUInteger centerItemIndex = [self indexForItemAtCenterOfBounds];
    
    if (centerItemIndex == [self numberOfItems] - 1)
    {
        return NSNotFound;
    }
    return centerItemIndex + 1;
}

- (void)moveToPre:(BOOL)animated
{
    NSUInteger currentItemIndex = [self indexForItemAtCenterOfBounds];
    
    if (currentItemIndex == NSNotFound)
    {
        return;
    }
    
    CGPoint contentOffset;
    CGRect currentItemRect = [self rectForItemAtIndex:currentItemIndex];
    CGFloat currentItemMinX = CGRectGetMinX(currentItemRect);
    
    if (CGRectGetMinX(self.bounds) > currentItemMinX)
    {
        if (self.bounds.size.width > CGRectGetMinX(self.bounds) - currentItemMinX)
        {
            contentOffset = CGPointMake(currentItemMinX, self.contentOffset.y);
        }
        else
        {
            contentOffset = CGPointMake(self.contentOffset.x - self.bounds.size.width, self.contentOffset.y);
        }
        [self setContentOffset:contentOffset animated:animated];
    }
    else
    {
        NSUInteger nextItemIndex = [self leftItemIndex];
        [self scrollToItemAtIndex:nextItemIndex atScrollPosition:WYTableViewScrollPositionCenterElseNone animated:animated];
    }
}
- (void)moveToNext:(BOOL)animated
{
    NSUInteger currentItemIndex = [self indexForItemAtCenterOfBounds];
    
    if (currentItemIndex == NSNotFound)
    {
        return;
    }
    
    CGPoint contentOffset;
    CGRect currentItemRect = [self rectForItemAtIndex:currentItemIndex];
    CGFloat currentItemMaxX = CGRectGetMaxX(currentItemRect);
    
    if (CGRectGetMaxX(self.bounds) < currentItemMaxX)
    {
        if (self.bounds.size.width > currentItemMaxX - CGRectGetMaxX(self.bounds))
        {
            contentOffset = CGPointMake(currentItemMaxX - self.bounds.size.width, self.contentOffset.y);
        }
        else
        {
            contentOffset = CGPointMake(self.contentOffset.x + self.bounds.size.width, self.contentOffset.y);
        }
        [self setContentOffset:contentOffset animated:animated];
    }
    else
    {
        NSUInteger nextItemIndex = [self rightItemIndex];
        [self scrollToItemAtIndex:nextItemIndex atScrollPosition:WYTableViewScrollPositionCenterElseNone animated:animated];
    }
}
#pragma mark -  (Public)

- (id <WYTableViewDelegate>)delegate
{
    return (id <WYTableViewDelegate>)[super delegate];
}

- (void)setDelegate:(id<WYTableViewDelegate>)delegate
{
    [super setDelegate:delegate];
}

- (void)setLayout
{
    NSUInteger indexCache = [self indexForItemAtCenterOfBounds];
    
    if (indexCache == NSNotFound || CGRectContainsRect(self.bounds, [self rectForItemAtIndex:0]))
    {
        indexCache = 0;
    }
    else if (CGRectContainsRect(self.bounds, [self rectForItemAtIndex:[self numberOfItems] - 1]))
    {
        indexCache = [self numberOfItems] - 1;
    }
    
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = NO;
    self.delegate = self;
    
    [self reloadData];
    [self scrollToItemAtIndex:indexCache atScrollPosition:WYTableViewScrollPositionCenter animated:NO];
    [self flashScrollIndicators];
}

- (void)reloadData
{
    if (!self.dataSource)
    {
        return;
    }
    
    for (UIView *view in [_visibleViews reverseObjectEnumerator])
    {
        [self recycleView:view];
    }
    
    _visibleRange = NSMakeRange(0, 0);
    [_itemRects removeAllObjects];
    
    NSUInteger numberOfItems = [self.dataSource numberOfItemsInTableView:self];
    
    for (int i = 0; i < numberOfItems; i ++)
    {
        [_itemRects addObject:[NSValue valueWithCGRect:CGRectNull]];
    }
    
    [self updateItemSizes];
}

- (void)reloadItemsAtIndexes:(NSIndexSet *)indexes
{
    if (!self.dataSource)
    {
        return;
    }
    
    [self recycleItemAtIndexes:indexes];
    [self updateItemSizesAtIndexes:indexes];
}

- (void)updateItemSizes
{
    NSIndexSet *allIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfItems])];
    [self updateItemSizesAtIndexes:allIndexes];
}

- (void)updateItemSizesAtIndexes:(NSIndexSet *)indexes
{
#if LOG_THIS_FILE
    NSDate *d = [NSDate date];
#endif
    CGSize(^__block sizeForItemAtIndex)(NSUInteger);
    
    if (self.tableDelegate && [self.tableDelegate respondsToSelector:@selector(tableView:widthForItemAtIndex:)])
    {
        sizeForItemAtIndex = ^CGSize(NSUInteger idx)
        {
            return CGSizeMake([self.tableDelegate tableView:self widthForItemAtIndex:idx], self.frame.size.height);
        };
    }
    else
    {
        sizeForItemAtIndex = ^CGSize(NSUInteger idx)
        {
            return CGSizeMake(_itemWidth, self.frame.size.height);
        };
    }
#if LOG_THIS_FILE
    NSLog(@"%s [%d] %f",__func__,[indexes count],[[NSDate date] timeIntervalSinceDate:d]);
#endif

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
         {
             CGRect itemRect = [self rectForItemAtIndex:idx];
             itemRect.size = sizeForItemAtIndex(idx);
             [_itemRects replaceObjectAtIndex:idx withObject:[NSValue valueWithCGRect:itemRect]];
         }];
//    });

#if LOG_THIS_FILE
    NSLog(@"%s enumerateIndexesUsingBlock*** %f",__func__,[[NSDate date] timeIntervalSinceDate:d]);
#endif
    
    [self layoutItemRects];
    
#if LOG_THIS_FILE
    NSLog(@"%s layoutItemRects*** %f",__func__,[[NSDate date] timeIntervalSinceDate:d]);
#endif
}

- (NSInteger)numberOfItems
{
    return [_itemRects count];
}

- (CGRect)rectForItemAtIndex:(NSUInteger)index
{
    if (index < [_itemRects count])
    {
        return [[_itemRects objectAtIndex:index] CGRectValue];
    }
    return CGRectNull;
}

- (UIView *)viewForItemAtIndex:(NSUInteger)index
{
    if (index - _visibleRange.location < [_visibleViews count])
    {
        return [_visibleViews objectAtIndex:index - _visibleRange.location];
    }
    return nil;
}

- (NSUInteger)indexForView:(UIView *)view
{
    if ([_visibleViews containsObject:view])
    {
        return [_visibleViews indexOfObject:view] + _visibleRange.location;
    }
    return NSNotFound;
}

- (NSUInteger)indexForItemAtPoint:(CGPoint)point
{
    NSIndexSet *indexes = [self indexesForItemsInRect:CGRectMake(point.x, point.y, 1, 1)];
    if (indexes)
    {
        return [indexes lastIndex];
    }
    return NSNotFound;
}

- (NSUInteger)indexForItemAtCenterOfBounds
{
    return [self indexForItemAtPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
}

- (NSIndexSet *)indexesForItemsInRect:(CGRect)rect
{
    if ([self numberOfItems] == 0)
    {
        return nil;
    }
    
    CGRect firstItemRect = [self rectForItemAtIndex:0];
    
    NSUInteger minIndex = 0;
    NSUInteger maxIndex = [self numberOfItems] - 1;
    
    while (YES)
    {
        NSUInteger centerIndex = minIndex + (maxIndex - minIndex) / 2;
        CGRect centerItemRect = [self rectForItemAtIndex:centerIndex];
        
        if (CGRectIntersectsRect(centerItemRect, rect))
        {
            NSUInteger firstIndex = centerIndex;
            NSUInteger lastIndex = centerIndex;
            
            while (firstIndex > 0 && CGRectIntersectsRect([self rectForItemAtIndex:firstIndex - 1], rect))
            {
                firstIndex --;
            }
            while (lastIndex < [self numberOfItems] - 1 && CGRectIntersectsRect([self rectForItemAtIndex:lastIndex + 1], rect))
            {
                lastIndex ++;
            }
            
            NSRange indexRange = NSMakeRange(firstIndex, lastIndex - firstIndex + 1);
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:indexRange];
            return indexes;
        }
        else if (minIndex == maxIndex)
        {
            return nil;
        }
        else
        {
            if (!CGRectIntersectsRect(CGRectUnion(firstItemRect, centerItemRect), rect))
            {
                minIndex = centerIndex + 1;
            }
            else
            {
                maxIndex = centerIndex - 1;
            }
        }
    }
    
    return nil;
}

- (CGRect)visibleRect
{
    return UIEdgeInsetsInsetRect(self.bounds, _visibleInsets);
    
    //    if (!_isRotate) {
    //        return UIEdgeInsetsInsetRect(self.bounds, _visibleInsets);
    //    }
    //
    //    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
    //        [self setContentOffset:CGPointMake(self.bounds.size.width * _currentIndex, 0.0)];
    //        CGRect rect = self.bounds;
    //        rect.size.width = self.bounds.size.height;
    //        rect.size.height = self.bounds.size.width;
    //        return UIEdgeInsetsInsetRect(rect, _visibleInsets);
    //    }
    //    else
    //    {
    //        [self setContentOffset:CGPointMake(self.bounds.size.height * _currentIndex, 0.0)];
    //        return UIEdgeInsetsInsetRect(self.bounds, _visibleInsets);
    //    }
}

- (NSArray *)visibleViews
{
    return _visibleViews;
}

- (NSIndexSet *)indexesForVisibleItems
{
    return [NSIndexSet indexSetWithIndexesInRange:_visibleRange];
}

- (void)scrollToItemAtIndex:(NSUInteger)index atScrollPosition:(WYTableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    if (index >= [self numberOfItems])
    {
        return;
    }
    
    CGPoint offset;
    CGRect itemRect = [self rectForItemAtIndex:index];
    
    if (scrollPosition == WYTableViewScrollPositionNone)
    {
        if (CGRectContainsRect(itemRect, self.bounds))
        {
            return;
        }
        else
        {
            if (itemRect.size.width == self.bounds.size.width ||
                (itemRect.size.width < self.bounds.size.width && CGRectGetMidX(itemRect) < CGRectGetMidX(self.bounds)) ||
                (itemRect.size.width > self.bounds.size.width && CGRectGetMidX(itemRect) > CGRectGetMidX(self.bounds)))
            {
                offset = CGPointMake(CGRectGetMinX(itemRect), self.contentOffset.y);
                [self setContentOffset:offset animated:animated];
            }
            else if ((itemRect.size.width < self.bounds.size.width && CGRectGetMidX(itemRect) > CGRectGetMidX(self.bounds)) ||
                     (itemRect.size.width > self.bounds.size.width && CGRectGetMidX(itemRect) < CGRectGetMidX(self.bounds)))
            {
                offset = CGPointMake(CGRectGetMaxX(itemRect) - self.bounds.size.width, self.contentOffset.y);
                [self setContentOffset:offset animated:animated];
            }
        }
    }
    else if (scrollPosition == WYTableViewScrollPositionCenter)
    {
        offset = CGPointMake((itemRect.origin.x - (self.frame.size.width - itemRect.size.width) / 2), self.contentOffset.y);
        if (offset.x < 0)
        {
            offset.x = 0;
        }
        if (offset.x > self.contentSize.width - self.frame.size.width)
        {
            offset.x = self.contentSize.width - self.frame.size.width;
        }
        [self setContentOffset:offset animated:animated];
    }
    else if (scrollPosition == WYTableViewScrollPositionCenterElseNone)
    {
        if (itemRect.size.width <= self.bounds.size.width)
        {
            [self scrollToItemAtIndex:index atScrollPosition:WYTableViewScrollPositionCenter animated:animated];
        }
        else
        {
            [self scrollToItemAtIndex:index atScrollPosition:WYTableViewScrollPositionNone animated:animated];
        }
    }
    
    _currentIndex = index;
}

- (void)willRotate:(UIInterfaceOrientation)toInterfaceOrientation
{
#if LOG_THIS_FILE
    NSLog(@"%s [%d] %0.0f / %0.0f",__func__,_currentIndex,self.contentOffset.x,self.bounds.size.width);
#endif
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        [self setContentSize:CGSizeMake(_boundSize.width * [self numberOfItems],0.0)];
        [self setContentOffset:CGPointMake(_boundSize.width * _currentIndex, 0.0)];
    }
    else if (IS_PAD())
    {
        [self setContentSize:CGSizeMake((_boundSize.height - 321.0) * [self numberOfItems],0.0)];
        [self setContentOffset:CGPointMake((_boundSize.height - 321.0) * _currentIndex, 0.0)];
    }
    else
    {
        [self setContentSize:CGSizeMake(_boundSize.height * [self numberOfItems],0.0)];
        [self setContentOffset:CGPointMake(_boundSize.height * _currentIndex, 0.0)];
    }
#if LOG_THIS_FILE
    NSLog(@"%s [%d] %0.0f / %0.0f",__func__,_currentIndex,self.contentOffset.x,self.bounds.size.width);
#endif
}
- (void)didRotate
{
    [self scrollToItemAtIndex:_currentIndex atScrollPosition:WYTableViewScrollPositionCenter animated:NO];
}
- (void)fitToSize
{
#if LOG_THIS_FILE
    NSLog(@"%s [%d] %0.0f / %0.0f",__func__,_currentIndex,self.contentOffset.x,self.bounds.size.width);
#endif
//    self.frame = self.superview.bounds;
    
    [self setContentSize:CGSizeMake(self.bounds.size.width * [self numberOfItems],0.0)];
    [self setContentOffset:CGPointMake(self.bounds.size.width * _currentIndex, 0.0)];
//    [self scrollToItemAtIndex:_currentIndex atScrollPosition:WYTableViewScrollPositionCenter animated:NO];
//    [self viewForItemAtIndex:_currentIndex].frame = self.bounds;
}
- (UIView *)dequeueReusableView
{
    UIView *reuseableView = [_reuseableViews anyObject];
    if (reuseableView)
    {
        [[reuseableView retain] autorelease];
        [_reuseableViews removeObject:reuseableView];
    }
    return reuseableView;
}


#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    static CGSize frameSizeCache = {0.0, 0.0};
    
    if (CGSizeEqualToSize(frameSizeCache, CGSizeZero))
    {
        frameSizeCache = self.frame.size;
    }
    
    if (!CGSizeEqualToSize(self.frame.size, frameSizeCache))
    {
        [self updateItemSizes];
        frameSizeCache = self.frame.size;
    }
    else
    {
        [self layoutVisibleItems];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = [self indexForItemAtCenterOfBounds];
    if (self.tableDelegate && [self.tableDelegate respondsToSelector:@selector(tableView:didShowItemAtIndex:)])
    {
        [self.tableDelegate tableView:self didShowItemAtIndex:[self indexForItemAtCenterOfBounds]];
    }
#if LOG_THIS_FILE
    NSLog(@"%s [%d] %0.0f / %0.0f",__func__,_currentIndex,self.contentOffset.x,self.bounds.size.width);
#endif
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self)
    {
        if ([keyPath isEqualToString:@"itemWidth"] || [keyPath isEqualToString:@"itemHeight"])
        {
            [self updateItemSizes];
        }
        else if ([keyPath isEqualToString:@"gapBetweenItems"])
        {
            [self layoutItemRects];
        }
    }
}

@end
