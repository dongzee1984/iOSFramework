//
//  WYTableView.h
//  WYCore
//
//  Created by wanglidong on 13-5-24.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYTableView;

typedef enum {
    WYTableViewScrollPositionNone   = UITableViewScrollPositionNone,
    WYTableViewScrollPositionCenter = UITableViewRowAnimationMiddle,
    WYTableViewScrollPositionCenterElseNone // center if the view size is smaller than bounds size, else none
} WYTableViewScrollPosition;


@protocol WYTableViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInTableView:(WYTableView *)tableView;
- (UIView *)tableView:(WYTableView *)tableView viewForItemAtIndex:(NSUInteger)index;

@end


@protocol WYTableViewDelegate <UIScrollViewDelegate>
@optional
- (void)tableView:(WYTableView *)tableView willDisplayView:(UIView *)view forItemAtIndex:(NSUInteger)index;

- (CGFloat)tableView:(WYTableView *)tableView widthForItemAtIndex:(NSUInteger)index;  // for horizontal layouts

- (void)tableView:(WYTableView *)tableView didShowItemAtIndex:(NSUInteger)index;

@end


@interface WYTableView : UIScrollView<UIScrollViewDelegate> {
    @package
    NSMutableArray *_itemRects;
    NSRange         _visibleRange;
    NSMutableArray *_visibleViews;
    NSMutableSet   *_reuseableViews;
    
    NSInteger _currentIndex;
    CGSize _boundSize;
}

@property (nonatomic, assign) IBOutlet id <WYTableViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id <WYTableViewDelegate>   tableDelegate;

@property (nonatomic) CGFloat          itemWidth;       // for horizontal layouts. default is 44.0
@property (nonatomic) CGFloat          itemHeight;      // for vertical layouts. default is 44.0
@property (nonatomic) CGFloat          gapBetweenItems; // default is zero
@property (nonatomic) UIEdgeInsets     visibleInsets;   // set negative values to load views outside bounds. default is UIEdgeInsetsZero

- (void)reloadData;
- (void)reloadItemsAtIndexes:(NSIndexSet *)indexes;

- (void)updateItemSizes;
- (void)updateItemSizesAtIndexes:(NSIndexSet *)indexes;

- (NSInteger)numberOfItems;

- (CGRect)rectForItemAtIndex:(NSUInteger)index;         // returns CGRectNull if index is out of range
- (UIView *)viewForItemAtIndex:(NSUInteger)index;       // returns nil if view is not visible or index is out of range

- (NSUInteger)indexForView:(UIView *)view;              // returns NSNotFound if view is not visible
- (NSUInteger)indexForItemAtPoint:(CGPoint)point;       // returns NSNotFound if point is outside tableView
- (NSUInteger)indexForItemAtCenterOfBounds;
- (NSIndexSet *)indexesForItemsInRect:(CGRect)rect;     // returns nil if rect is outside tableView

- (CGRect)visibleRect;
- (NSArray *)visibleViews;
- (NSIndexSet *)indexesForVisibleItems;

- (void)scrollToItemAtIndex:(NSUInteger)index atScrollPosition:(WYTableViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)moveToPre:(BOOL)animated;// 返回前一个
- (void)moveToNext:(BOOL)animated;// 下一个

- (UIView *)dequeueReusableView;   // similar to UITableView's dequeueReusableCellWithIdentifier:

- (void)willRotate:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)didRotate;
- (void)fitToSize;

@end

