//
//  WYActionSheet.m
//  WYCore
//
//  Created by wanglidong on 13-5-2.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYActionSheet.h"
#import "WYBase.h"
#import "WYUIBase.h"

#define LOG_THIS_FILE 0

@interface WYActionSheet ()
{
    NSMutableArray *m_blocks;
}
@end

@implementation WYActionSheet
- (void)dealloc
{
#if LOG_THIS_FILE
    NSLog(@"%s",__func__);
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self terminate];
    
    [super dealloc];
}
//
- (void)terminate
{
    for (dispatch_block_t block in m_blocks) {
        Block_release(block);
    }
    [m_blocks removeAllObjects], [m_blocks release], m_blocks = nil;
}

#pragma mark notify
- (void)dismissWhenOtherShow
{
    //hide it
    [self dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)dismissWhenDeviceRotate
{
    //hide it
    if(self.shouldDismissWhenDeviceRotate)
    {
        [self dismissWithClickedButtonIndex:0 animated:NO];
    }
}

//app resign notify method
- (void)dismissWhenAppEnterBackground
{
    //hide it
    if(self.shouldDismissWhenAppEnterBackground)
    {
        [self dismissWithClickedButtonIndex:0 animated:NO];
    }
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WYActionSheetClickedButtonAtIndexBlock block = [m_blocks objectAtIndex:buttonIndex];
    if(![block isEqual:[NSNull null]])
    {
        dispatch_async(dispatch_get_current_queue(),^{
            block(buttonIndex);
        });
    }
#if LOG_THIS_FILE
    NSLog(@"%s [%d]%@",__func__,buttonIndex,block);
#endif
//    [self terminate];
}

// title & block 成对添加
- (void)addOtherButtons:(NSString *)title withBlock:(WYActionSheetClickedButtonAtIndexBlock)block
{
    [self addButtonWithTitle:title];
    if(block)
    {
        [m_blocks addObject:Block_copy(block)];
    }
    else
    {
        [m_blocks addObject:[NSNull null]];
    }
}
// title & block 成对添加, 遇到nil就结束
- (void)addOtherButtons:(NSString *)otherButtonTitles withVAList:(va_list)list
{
    id t = otherButtonTitles;
    id b = va_arg(list,id);
    
    while (b) {
        
        [self addButtonWithTitle:t];
        [m_blocks addObject:Block_copy(b)];
        
        t = va_arg(list,id);
        // 按钮内容为空或不为String时即认为结束
        if (nil == t || ![t isKindOfClass:[NSString class]]) {
            break;
        }
        
        b = va_arg(list,id);
    }
}

// 初始化actionSheet
- (id)initWithTitle:(NSString *)title
{
    [WYUIBase dismissAllActionView];
    self = [super initWithTitle:title
                       delegate:self
              cancelButtonTitle:nil
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
    
    if(self)
    {
        m_blocks = [[NSMutableArray alloc]initWithCapacity:1];

        self.shouldDismissWhenAppEnterBackground = YES;
        self.shouldDismissWhenDeviceRotate = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissWhenAppEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissWhenDeviceRotate)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissWhenOtherShow)
                                                     name:dismissAllActionViewNotify
                                                   object:nil];

    }
    return self;
}
//
//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    
//    if (!IS_RETINA()) {
//        UILabel *tb = (UILabel *)[[self subviews] objectAtIndex:0];
//        tb.font = [UIFont systemFontOfSize:20.0];
//        NSLog(@"%s tb %@",__func__,tb);
//    }
//
//}

- (void)setCancelButtonWithLastIndex
{
    [self setCancelButtonIndex:(self.numberOfButtons - 1 )];
}

- (void)setDestructiveButtonWithFirstIndex
{
    [self setDestructiveButtonIndex:0];
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        [self initWithTitle:title];
        
        if(self)
        {
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [self addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            
            // 添加取消按钮
            [self addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [self setCancelButtonWithLastIndex];
        }

    }
    return self;
}

+ (void)showInview:(UIView *)view withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        
        if(sheet)
        {
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showInView:view];
        }
    }
}

+ (void)showFromTabBar:(UITabBar *)view withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        
        if(sheet)
        {
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showFromTabBar:view];
        }

    }
}

+ (void)showFromToolbar:(UIToolbar *)view withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        
        if(sheet)
        {
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showFromToolbar:view];
        }
    }
}

+ (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        
        if(sheet)
        {
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showFromBarButtonItem:item animated:animated];
        }

    }
}

+ (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        
        if(sheet)
        {
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showFromRect:rect inView:view animated:animated];
        }

    }
}

#pragma mark - destructiveButton

+ (void)showInview:(UIView *)view
         withTitle:(NSString *)title
 cancelButtonTitle:(NSString *)cancelButtonTitle
       cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        if(sheet)
        {
            // 添加destructiveButton
            if(destructiveButtonTitle && destructiveBlock)
            {
                [sheet addOtherButtons:destructiveButtonTitle withBlock:destructiveBlock];
                [sheet setDestructiveButtonWithFirstIndex];
            }
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showInView:view];
        }
    }
}

+ (void)showFromTabBar:(UITabBar *)view
             withTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
           cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle
      destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
     otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        if(sheet)
        {
            // 添加destructiveButton
            if(destructiveButtonTitle && destructiveBlock)
            {
                [sheet addOtherButtons:destructiveButtonTitle withBlock:destructiveBlock];
                [sheet setDestructiveButtonWithFirstIndex];
            }
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showFromTabBar:view];
        }
    }
}

+ (void)showFromToolbar:(UIToolbar *)view
              withTitle:(NSString *)title
      cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
 destructiveButtonTitle:(NSString *)destructiveButtonTitle
       destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
      otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        if(sheet)
        {
            // 添加destructiveButton
            if(destructiveButtonTitle && destructiveBlock)
            {
                [sheet addOtherButtons:destructiveButtonTitle withBlock:destructiveBlock];
                [sheet setDestructiveButtonWithFirstIndex];
            }
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showFromToolbar:view];
        }
    }
}

+ (void)showFromBarButtonItem:(UIBarButtonItem *)item
                     animated:(BOOL)animated
                    withTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
                  cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
             destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        if(sheet)
        {
            // 添加destructiveButton
            if(destructiveButtonTitle && destructiveBlock)
            {
                [sheet addOtherButtons:destructiveButtonTitle withBlock:destructiveBlock];
                [sheet setDestructiveButtonWithFirstIndex];
            }
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showFromBarButtonItem:item animated:animated];
        }
    }
}

+ (void)showFromRect:(CGRect)rect
              inView:(UIView *)view
            animated:(BOOL)animated
           withTitle:(NSString *)title
   cancelButtonTitle:(NSString *)cancelButtonTitle
         cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle
    destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
   otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (cancelButtonTitle) {
        
        WYActionSheet *sheet = [[[WYActionSheet alloc] initWithTitle:title]autorelease];
        
        if(sheet)
        {
            // 添加destructiveButton
            if(destructiveButtonTitle && destructiveBlock)
            {
                [sheet addOtherButtons:destructiveButtonTitle withBlock:destructiveBlock];
                [sheet setDestructiveButtonWithFirstIndex];
            }
            if(otherButtonTitles)
            {
                va_list list;
                va_start(list,otherButtonTitles);
                [sheet addOtherButtons:otherButtonTitles withVAList:list];
                va_end(list);
            }
            
            // 添加取消按钮
            [sheet addOtherButtons:cancelButtonTitle withBlock:cancelBlock];
            [sheet setCancelButtonWithLastIndex];
            
            // 显示
            [sheet showFromRect:rect inView:view animated:animated];
        }
    }
}


@end
