//
//  CJLabelRangeContainerView.m
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/23.
//  Copyright © 2020 cactus. All rights reserved.
//

#import "CJLabelRangeContainerView.h"
#import <objc/runtime.h>
#import "CJLabelConfig.h"
#import "CJLabel.h"
#import "CJSelectTextRangeView.h"
#import "CJFloatMenuView.h"
#import "CJWindowView.h"
#import "CJCTLineLayoutModel.h"
#import "CJGlyphRunStrokeItem.h"

static BOOL isShow = NO;

@interface CJLabelRangeContainerView()<UIGestureRecognizerDelegate> {
    CGFloat _lineVerticalMaxWidth;//每一行文字中的最大宽度
    NSArray *_CTLineVerticalLayoutArray;//记录 所有CTLine在垂直方向的对齐方式的数组
    NSArray <CJGlyphRunStrokeItem *>*_allRunItemArray;//CJLabel包含所有CTRun信息的数组
    CJGlyphRunStrokeItem *_firstRunItem;//第一个StrokeItem
    CJGlyphRunStrokeItem *_lastRunItem;//最后一个StrokeItem
    CJGlyphRunStrokeItem *_startCopyRunItem;//选中复制的第一个StrokeItem
    CGFloat _startCopyRunItemY;//_startCopyRunItem Y坐标 显示Menu（选择、全选、复制菜单时用到）
    CJGlyphRunStrokeItem *_endCopyRunItem;//选中复制的最后一个StrokeItem
    BOOL _haveMove;
}

@property (nonatomic, strong) UITapGestureRecognizer *singleTapGes;//单击手势
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGes;//双击手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;//长按手势

@property (nonatomic, weak) CJLabel *label;//选择复制对应的label
@property (nonatomic, strong) CJSelectTextRangeView *textRangeView;//选中复制填充背景色的view
@property (nonatomic, strong) CJFloatMenuView *menuView;//选中复制填充背景色的view

@property (nonatomic, assign) CJSelectViewAction selectViewAction;//用于判断选中移动的是左边还是右边的大头针
@property (nonatomic, strong) CJWindowView *backWindView;//添加在window层的view，用来检测点击任意view时隐藏CJLabelRangeContainerView
@property (nonatomic, strong) NSMutableArray *scrlooViewArray;//记录CJLabel所属的superview数组

@property (nonatomic, copy) void(^hideViewBlock)(void);

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSAttributedString *attributedText;

@end


@implementation CJLabelRangeContainerView

+ (instancetype)instance {
    static CJLabelRangeContainerView *rangeContainerView = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        rangeContainerView = [[CJLabelRangeContainerView alloc] initWithFrame:CGRectZero];
        rangeContainerView.backgroundColor = [UIColor clearColor];

        rangeContainerView.backWindView = [[CJWindowView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        __weak typeof(rangeContainerView)wManager = rangeContainerView;
        rangeContainerView.backWindView.hitTestBlock = ^(BOOL hide) {
            [wManager hideView];
        };

        /*
         *选择复制填充背景色视图
         */
        rangeContainerView.textRangeView = [[CJSelectTextRangeView alloc]init];
        rangeContainerView.textRangeView.hidden = YES;
        [rangeContainerView addSubview:rangeContainerView.textRangeView];

        rangeContainerView.menuView = [CJFloatMenuView share];
        rangeContainerView.menuView.hidden = YES;
        //[CJkeyWindow() addSubview:rangeContainerView.menuView];
        [rangeContainerView addSubview:rangeContainerView.menuView];

        rangeContainerView.singleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:rangeContainerView action:@selector(tapOneAct:)];
        [rangeContainerView addGestureRecognizer:rangeContainerView.singleTapGes];

        rangeContainerView.doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:rangeContainerView action:@selector(tapTwoAct:)];
        //双击时触发事件 ,默认值为1
        rangeContainerView.doubleTapGes.numberOfTapsRequired = 2;
        rangeContainerView.doubleTapGes.delegate = rangeContainerView;
        [rangeContainerView addGestureRecognizer:rangeContainerView.doubleTapGes];
        //当单击操作遇到了 双击 操作时，单击失效
        [rangeContainerView.singleTapGes requireGestureRecognizerToFail:rangeContainerView.doubleTapGes];

        rangeContainerView.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:rangeContainerView
                                                                                            action:@selector(longPressGestureDidFire:)];
        rangeContainerView.longPressGestureRecognizer.delegate = rangeContainerView;
        [rangeContainerView addGestureRecognizer:rangeContainerView.longPressGestureRecognizer];

        [[NSNotificationCenter defaultCenter] addObserver:rangeContainerView selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];

        rangeContainerView.scrlooViewArray = [NSMutableArray arrayWithCapacity:3];

    });
    return rangeContainerView;
}

- (void)applicationEnterBackground {
    [self hideView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIResponder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ( (action == @selector(select:) && self.attributedText) // 需要有文字才能支持选择复制
        || (action == @selector(selectAll:) && self.attributedText)
        || (action == @selector(copyText:) && self.attributedText)) {
        return YES;
    }
    return NO;
}

- (void)select:(nullable id)sender {
    _endCopyRunItem = [_startCopyRunItem copy];
    CGPoint point = CGPointMake(_startCopyRunItem.withOutMergeBounds.origin.x, _startCopyRunItem.withOutMergeBounds.origin.y);
    [self showCJSelectViewWithPoint:point
                         selectType:ShowAllSelectView
                               item:_startCopyRunItem
                   startCopyRunItem:_startCopyRunItem
                     endCopyRunItem:_endCopyRunItem
             allCTLineVerticalArray:_CTLineVerticalLayoutArray];
    [self showMenuView];
}

- (void)selectAll:(nullable id)sender {
    _startCopyRunItem = [_firstRunItem copy];
    _endCopyRunItem = [_lastRunItem copy];
    CGPoint point = CGPointMake(_startCopyRunItem.withOutMergeBounds.origin.x, _startCopyRunItem.withOutMergeBounds.origin.y);
    [self showCJSelectViewWithPoint:point
                         selectType:ShowAllSelectView
                               item:_startCopyRunItem
                   startCopyRunItem:_startCopyRunItem
                     endCopyRunItem:_endCopyRunItem
             allCTLineVerticalArray:_CTLineVerticalLayoutArray];
    [self showMenuView];
}

- (void)copyText:(nullable id)sender {
    if (_startCopyRunItem && _endCopyRunItem) {

        NSUInteger loc = _startCopyRunItem.characterRange.location;
        loc = loc<=0?0:loc;

        NSUInteger length = _endCopyRunItem.characterRange.location+_endCopyRunItem.characterRange.length - loc;

        if (length >= self.attributedText.string.length-loc) {
            length = self.attributedText.string.length-loc;
        }

        @autoreleasepool {
            NSRange rangeCopy = NSMakeRange(loc,length);
            NSString *str = [self.attributedText.string substringWithRange:rangeCopy];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = str;
            NSLog(@"%@",str);
        }
    }
    [self hideView];
}

- (void)showMenuView {
    if (!self.textRangeView.hidden) {
        [self becomeFirstResponder];
        CGRect rect = CGRectMake((self.bounds.origin.x - (_lineVerticalMaxWidth/2 - _startCopyRunItem.withOutMergeBounds.origin.x)),
                                 _startCopyRunItemY-5,
                                 _lineVerticalMaxWidth,
                                 _endCopyRunItem.withOutMergeBounds.origin.y + _endCopyRunItem.withOutMergeBounds.size.height + 16);

        CGFloat bottom = 5;
        self.menuView.text = @"Copy";
        if (_startCopyRunItem.withOutMergeBounds.origin.y == _endCopyRunItem.withOutMergeBounds.origin.y) {
            self.menuView.center = CGPointMake(_startCopyRunItem.withOutMergeBounds.origin.x + (_endCopyRunItem.withOutMergeBounds.origin.x+_endCopyRunItem.withOutMergeBounds.size.width -  _startCopyRunItem.withOutMergeBounds.origin.x)/2.0,_startCopyRunItem.withOutMergeBounds.origin.y -self.menuView.bounds.size.height/2-bottom);
        } else {
            self.menuView.center = CGPointMake(_startCopyRunItem.withOutMergeBounds.origin.x+(self.bounds.size.width - _startCopyRunItem.withOutMergeBounds.origin.x)/2, _startCopyRunItem.withOutMergeBounds.origin.y-self.menuView.bounds.size.height/2-bottom);
        }
        [self addSubview:self.menuView];
        CGRect rectInWindow = [self.menuView convertRect:self.menuView.bounds toView:CJkeyWindow()];
        [CJkeyWindow() addSubview:self.menuView];
        self.menuView.frame = rectInWindow;
        self.menuView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.menuView.alpha = 1;
        }];

        __weak typeof (self) weakSelf = self;
        self.menuView.didClick = ^{
            [weakSelf copyText:nil];
            [weakSelf hideView];
        };
        //        [[UIMenuController sharedMenuController] setTargetRect:rect inView:self];
        //        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

- (void)scrollViewUnable:(BOOL)unable {
    if (unable) {
        for (NSDictionary *viewDic in self.scrlooViewArray) {
            UIScrollView *view = viewDic[@"ScrollView"];
            view.delaysContentTouches = [viewDic[@"delaysContentTouches"] boolValue];
            view.canCancelContentTouches = [viewDic[@"canCancelContentTouches"] boolValue];
        }
        [self.scrlooViewArray removeAllObjects];
    }
    else {
        [self.scrlooViewArray removeAllObjects];
        [self setScrollView:self.superview scrollUnable:NO];
    }
}

- (void)setScrollView:(UIView *)view scrollUnable:(BOOL)unable {
    if (view.superview) {
        if ([view.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view.superview;
            [self.scrlooViewArray addObject:@{@"ScrollView":scrollView,
                                              @"delaysContentTouches":@(scrollView.delaysContentTouches),
                                              @"canCancelContentTouches":@(scrollView.canCancelContentTouches)
            }];
            scrollView.delaysContentTouches = NO;
            scrollView.canCancelContentTouches = NO;
        }
        [self setScrollView:view.superview scrollUnable:unable];
    }else {
        return;
    }
}

#pragma mark - 显示选择视图
- (void)showSelectViewInCJLabel:(CJLabel *)label
                        atPoint:(CGPoint)point
                        runItem:(CJGlyphRunStrokeItem *)item
                   maxLineWidth:(CGFloat)maxLineWidth
         allCTLineVerticalArray:(NSArray *)allCTLineVerticalArray
                allRunItemArray:(NSArray <CJGlyphRunStrokeItem *>*)allRunItemArray
                  hideViewBlock:(void(^)(void))hideViewBlock {
    if (_startCopyRunItem && CGRectEqualToRect(_startCopyRunItem.withOutMergeBounds, item.withOutMergeBounds) ) {
        return;
    }
    [self hideView];
    self.label = label;
    self.attributedText = label.attributedText;
    self.font = label.font;
    CGRect labelFrame = label.bounds;
    self.frame = labelFrame;
    //self.frame = CGRectMake(0, 0, labelFrame.size.width, labelFrame.size.height+0);
    _lineVerticalMaxWidth = maxLineWidth;
    _CTLineVerticalLayoutArray = allCTLineVerticalArray;
    _allRunItemArray = allRunItemArray;
    _firstRunItem = [[allRunItemArray firstObject] copy];
    _lastRunItem = [[allRunItemArray lastObject] copy];

    _startCopyRunItem = [item copy];
    _endCopyRunItem = _startCopyRunItem;
    [self showCJSelectViewWithPoint:point selectType:ShowAllSelectView item:_startCopyRunItem startCopyRunItem:_startCopyRunItem endCopyRunItem:_startCopyRunItem allCTLineVerticalArray:_CTLineVerticalLayoutArray];

    CGRect windowFrame = [label.superview convertRect:self.label.frame toView:CJkeyWindow()];
    self.backWindView.frame = windowFrame;
    self.backWindView.hidden = NO;
    [CJkeyWindow() addSubview:self.backWindView];

    [label addSubview:self];
    [label bringSubviewToFront:self];
    [self showMenuView];
    [self scrollViewUnable:NO];
    self.hideViewBlock = hideViewBlock;
}

#pragma mark - 隐藏选择视图
- (void)hideView {
    self.attributedText = nil;
    self.font = nil;
    _lineVerticalMaxWidth = 0;
    _CTLineVerticalLayoutArray = nil;
    _allRunItemArray = nil;
    _firstRunItem = nil;
    _lastRunItem = nil;
    _startCopyRunItem = nil;
    _endCopyRunItem = nil;
    [self scrollViewUnable:YES];
    [self hideAllCopySelectView];
    if (self.hideViewBlock) {
        self.hideViewBlock();
    }
    self.hideViewBlock = nil;
}

/**
 隐藏所有与选择复制相关的视图
 */
- (void)hideAllCopySelectView {
    _startCopyRunItem = nil;
    _endCopyRunItem = nil;

    self.textRangeView.hidden = YES;
    self.menuView.hidden = YES;
    self.backWindView.hidden = YES;
    [self.backWindView removeFromSuperview];
    if (isShow) {
        isShow = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FloatMenuViewHidden" object:nil];
    }

    //    self.textRangeView.alpha = 1;
    //    self.menuView.alpha = 1;
    //    [UIView animateWithDuration:0.25 animations:^{
    //        self.textRangeView.alpha = 0;
    //        self.menuView.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        self.textRangeView.hidden = YES;
    //        self.menuView.hidden = YES;
    //        self.backWindView.hidden = YES;
    //        self.textRangeView.alpha = 1;
    //        self.menuView.alpha = 1;
    //        [self.backWindView removeFromSuperview];
    //        if (isShow) {
    //            isShow = NO;
    //            [[NSNotificationCenter defaultCenter] postNotificationName:@"FloatMenuViewHidden" object:nil];
    //        }
    //    }];

    [self resignFirstResponder];
    [self removeFromSuperview];
    //[[UIMenuController sharedMenuController] setMenuVisible:NO];
}

- (void)showCJSelectViewWithPoint:(CGPoint)point
                       selectType:(CJSelectViewAction)type
                             item:(CJGlyphRunStrokeItem *)item
                 startCopyRunItem:(CJGlyphRunStrokeItem *)startCopyRunItem
                   endCopyRunItem:(CJGlyphRunStrokeItem *)endCopyRunItem
           allCTLineVerticalArray:(NSArray *)allCTLineVerticalArray {
    //隐藏“选择、全选、复制”菜单
    //[[UIMenuController sharedMenuController] setMenuVisible:NO];
    //选中部分填充背景色
    [self updateSelectTextRangeViewStartCopyRunItem:startCopyRunItem endCopyRunItem:endCopyRunItem allCTLineVerticalArray:allCTLineVerticalArray];
}

/**
 更新选中复制的背景填充色
 */
- (void)updateSelectTextRangeViewStartCopyRunItem:(CJGlyphRunStrokeItem *)startCopyRunItem
                                   endCopyRunItem:(CJGlyphRunStrokeItem *)endCopyRunItem
                           allCTLineVerticalArray:(NSArray *)allCTLineVerticalArray {
    CGRect frame = self.bounds;
    CGRect headRect = CGRectNull;
    CGRect middleRect = CGRectNull;
    CGRect tailRect = CGRectNull;
    CJCTLineLayoutModel *lineLayoutModel = nil;
    CGFloat maxWidth = _lineVerticalMaxWidth;
    //headRect 坐标
    NSInteger startIndex = startCopyRunItem.lineVerticalLayout.line;
    lineLayoutModel = allCTLineVerticalArray[startIndex];
    _startCopyRunItemY = lineLayoutModel.selectCopyBackY;
    CGFloat headWidth = maxWidth - startCopyRunItem.withOutMergeBounds.origin.x;
    CGFloat headHeight = lineLayoutModel.selectCopyBackHeight;
    headRect = CGRectMake(startCopyRunItem.withOutMergeBounds.origin.x, _startCopyRunItemY, headWidth, headHeight);

    //tailRect 坐标
    NSInteger endIndex = startCopyRunItem.lineVerticalLayout.line;
    lineLayoutModel = allCTLineVerticalArray[endIndex];
    CGFloat tailWidth = endCopyRunItem.withOutMergeBounds.origin.x+endCopyRunItem.withOutMergeBounds.size.width;
    CGFloat tailHeight = lineLayoutModel.selectCopyBackHeight;
    CGFloat tailY = lineLayoutModel.selectCopyBackY;
    if (endCopyRunItem.lineVerticalLayout.line - 1 >= 0) {
        CJCTLineLayoutModel *endLastlineLayoutModel = allCTLineVerticalArray[endCopyRunItem.lineVerticalLayout.line-1];
        tailY = endLastlineLayoutModel.selectCopyBackY + endLastlineLayoutModel.selectCopyBackHeight;
        tailHeight = tailHeight + lineLayoutModel.selectCopyBackY - tailY;
    }
    tailRect = CGRectMake(0, tailY, tailWidth, tailHeight);

    CGFloat maxHeight = tailY + tailHeight - _startCopyRunItemY;

    BOOL differentLine = YES;
    if (startCopyRunItem.lineVerticalLayout.line == endCopyRunItem.lineVerticalLayout.line) {
        differentLine = NO;
        headRect = CGRectNull;
        middleRect = CGRectMake(startCopyRunItem.withOutMergeBounds.origin.x,
                                _startCopyRunItemY,
                                endCopyRunItem.withOutMergeBounds.origin.x+endCopyRunItem.withOutMergeBounds.size.width-startCopyRunItem.withOutMergeBounds.origin.x,
                                headHeight);
        tailRect = CGRectNull;
    }else {
        //相差一行
        if (startCopyRunItem.lineVerticalLayout.line + 1 == endCopyRunItem.lineVerticalLayout.line) {
            middleRect = CGRectNull;
        }else {
            middleRect = CGRectMake(0, _startCopyRunItemY+headHeight, maxWidth, maxHeight-headHeight-tailHeight);
        }
    }

    [self.textRangeView updateFrame:frame headRect:headRect middleRect:middleRect tailRect:tailRect differentLine:differentLine];

    self.textRangeView.hidden = NO;
    self.menuView.hidden = NO;
    if (!isShow) {
        isShow = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FloatMenuViewShow" object:nil];
    }
    [self bringSubviewToFront:self.textRangeView];
    [self bringSubviewToFront:self.menuView];
}

- (CJSelectViewAction)choseSelectView:(CGPoint)point {
    if (self.textRangeView.hidden) {
        return ShowAllSelectView;
    }

    CJCTLineLayoutModel *lineLayoutModel = nil;

    CGFloat offsetX = 1;
    //headRect 坐标
    NSInteger startIndex = _startCopyRunItem.lineVerticalLayout.line;
    lineLayoutModel = _CTLineVerticalLayoutArray[startIndex];
    _startCopyRunItemY = lineLayoutModel.selectCopyBackY;
    CGFloat headHeight = lineLayoutModel.selectCopyBackHeight;
    CGRect leftRect = CGRectMake(_startCopyRunItem.withOutMergeBounds.origin.x-kCJPinRoundPointSize/2, _startCopyRunItemY-kCJPinRoundPointSize, kCJPinRoundPointSize/2+kCJPinLineWidth+offsetX, kCJPinRoundPointSize+headHeight);

    //rightRect 坐标
    NSInteger endIndex = _endCopyRunItem.lineVerticalLayout.line;
    if (endIndex < _CTLineVerticalLayoutArray.count) {
        lineLayoutModel = _CTLineVerticalLayoutArray[endIndex];
    } else {
        lineLayoutModel = _CTLineVerticalLayoutArray[_CTLineVerticalLayoutArray.count-1];
    }
    CGFloat tailWidth = _endCopyRunItem.withOutMergeBounds.origin.x+_endCopyRunItem.withOutMergeBounds.size.width;
    CGFloat tailHeight = lineLayoutModel.selectCopyBackHeight;
    CGFloat tailY = lineLayoutModel.selectCopyBackY;
    CGRect rightRect = CGRectMake(tailWidth-offsetX, tailY, offsetX+kCJPinLineWidth+kCJPinRoundPointSize/2, tailHeight+kCJPinRoundPointSize);

    CJSelectViewAction selectView = [self choseSelectView:point inset:1 leftRect:leftRect rightRect:rightRect time:0];
    return selectView;
}

- (CJSelectViewAction)choseSelectView:(CGPoint)point inset:(CGFloat)inset leftRect:(CGRect)leftRect rightRect:(CGRect)rightRect time:(NSInteger)time {
    CJSelectViewAction selectView = ShowAllSelectView;
    if (time > 15) {
        //超过15次还判断不到，那就退出
        return selectView;
    }
    time ++;

    BOOL inLeftView = CGRectContainsPoint(CGRectInset(leftRect, inset, inset), point);
    BOOL inRightView = CGRectContainsPoint(CGRectInset(rightRect, inset, inset), point);

    if (!inLeftView && !inRightView) {
        //加大点击区域判断
        return [self choseSelectView:point inset:inset+(-0.35) leftRect:leftRect rightRect:rightRect time:time];
    }
    else if (inLeftView && !inRightView) {
        selectView = MoveLeftSelectView;
        return selectView;
    }
    else if (!inLeftView && inRightView) {
        selectView = MoveRightSelectView;
        return selectView;
    }
    else if (inLeftView && inRightView) {
        //缩小点击区域判断
        return [self choseSelectView:point inset:inset+(0.25) leftRect:leftRect rightRect:rightRect time:time];
    }else {
        return selectView;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    //接收任意视图的点击响应
    return YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.bounds, point)) {
        return self;
    }else {
        [self hideView];
        return nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.doubleTapGes) {
        objc_setAssociatedObject(self.doubleTapGes, &kAssociatedUITouchKey, touch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else if (gestureRecognizer == self.longPressGestureRecognizer) {
        objc_setAssociatedObject(self.longPressGestureRecognizer, &kAssociatedUITouchKey, touch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return YES;
}

- (void)tapOneAct:(UITapGestureRecognizer *)sender {
    if (!_haveMove) {
        [self hideView];
    }
}

- (void)tapTwoAct:(UITapGestureRecognizer *)sender {
    UITouch *touch = objc_getAssociatedObject(self.doubleTapGes, &kAssociatedUITouchKey);
    CGPoint point = [touch locationInView:self];
    CJGlyphRunStrokeItem *currentItem = [CJLabelRangeContainerView currentItem:point allRunItemArray:_allRunItemArray inset:1];
    if (currentItem) {
        _startCopyRunItem = currentItem;
        _endCopyRunItem = currentItem;
        [self showCJSelectViewWithPoint:point selectType:ShowAllSelectView item:currentItem startCopyRunItem:currentItem endCopyRunItem:currentItem allCTLineVerticalArray:_CTLineVerticalLayoutArray];
        [self showMenuView];
    }
}

#pragma mark - UILongPressGestureRecognizer
- (void)longPressGestureDidFire:(UILongPressGestureRecognizer *)sender {
    UITouch *touch = objc_getAssociatedObject(self.longPressGestureRecognizer, &kAssociatedUITouchKey);
    CGPoint point = [touch locationInView:self];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateEnded:{
            CJGlyphRunStrokeItem *currentItem = [CJLabelRangeContainerView currentItem:point allRunItemArray:_allRunItemArray inset:1.5];
            if (currentItem) {
                _startCopyRunItem = currentItem;
                _endCopyRunItem = currentItem;
                [self showCJSelectViewWithPoint:point selectType:ShowAllSelectView item:currentItem startCopyRunItem:currentItem endCopyRunItem:currentItem allCTLineVerticalArray:_CTLineVerticalLayoutArray];
                [self showMenuView];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            break;
        }
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _haveMove = NO;
    CGPoint point = [[touches anyObject] locationInView:self];
    //复制选择正在移动的大头针
    self.selectViewAction = [self choseSelectView:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.textRangeView.hidden) {
        [self showMenuView];
    }
    _haveMove = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (!self.textRangeView.hidden) {
        [self showMenuView];
    }
    _haveMove = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
    _haveMove = YES;
    CGPoint point = [[touches anyObject] locationInView:self];

    CJGlyphRunStrokeItem *currentItem = nil;
    //最后一个CTRun选中判断
    CGFloat lastRunItemX = _lastRunItem.withOutMergeBounds.origin.x;
    CGFloat lastRunItemY = _lastRunItem.withOutMergeBounds.origin.y;
    CGFloat lastRunItemHeight = _lastRunItem.withOutMergeBounds.size.height;
    CGFloat lastRunItemWidth = _lastRunItem.withOutMergeBounds.size.width;

    if ((point.x >= lastRunItemX + lastRunItemWidth) && (point.y >= lastRunItemY)) {
        currentItem = [_lastRunItem copy];
    }
    else if (point.y > lastRunItemY + lastRunItemHeight + 1) {
        currentItem = [_lastRunItem copy];
    }

    if (!currentItem) {
        currentItem = [CJLabelRangeContainerView currentItem:point allRunItemArray:_allRunItemArray inset:0.5];
    }

    if (currentItem && self.selectViewAction != ShowAllSelectView) {
        CGPoint selectPoint = CGPointMake(point.x, (currentItem.lineVerticalLayout.lineRect.size.height/2)+currentItem.lineVerticalLayout.lineRect.origin.y);
        if (self.selectViewAction == MoveLeftSelectView) {
            if (currentItem.characterIndex < _endCopyRunItem.characterIndex) {
                _startCopyRunItem = currentItem;
                [self showCJSelectViewWithPoint:selectPoint
                                     selectType:MoveLeftSelectView
                                           item:currentItem
                               startCopyRunItem:_startCopyRunItem
                                 endCopyRunItem:_endCopyRunItem
                         allCTLineVerticalArray:_CTLineVerticalLayoutArray
                           ];
            }
            else if (currentItem.characterIndex == _endCopyRunItem.characterIndex){
                _startCopyRunItem = [currentItem copy];
                _endCopyRunItem = _startCopyRunItem;
                [self showCJSelectViewWithPoint:selectPoint
                                     selectType:ShowAllSelectView
                                           item:_startCopyRunItem
                               startCopyRunItem:_startCopyRunItem
                                 endCopyRunItem:_endCopyRunItem
                         allCTLineVerticalArray:_CTLineVerticalLayoutArray
                           ];
            }
        }
        else if (self.selectViewAction == MoveRightSelectView) {
            if (currentItem.characterIndex > _startCopyRunItem.characterIndex) {
                _endCopyRunItem = [currentItem copy];
                [self showCJSelectViewWithPoint:selectPoint
                                     selectType:MoveRightSelectView
                                           item:currentItem
                               startCopyRunItem:_startCopyRunItem
                                 endCopyRunItem:_endCopyRunItem
                         allCTLineVerticalArray:_CTLineVerticalLayoutArray
                           ];
            }
            else if (currentItem.characterIndex == _startCopyRunItem.characterIndex){
                _startCopyRunItem = [currentItem copy];
                _endCopyRunItem = _startCopyRunItem;
                [self showCJSelectViewWithPoint:selectPoint
                                     selectType:ShowAllSelectView
                                           item:_startCopyRunItem
                               startCopyRunItem:_startCopyRunItem
                                 endCopyRunItem:_endCopyRunItem
                         allCTLineVerticalArray:_CTLineVerticalLayoutArray];
            }
        }
    }
}

+ (CJGlyphRunStrokeItem *)currentItem:(CGPoint)point allRunItemArray:(NSArray <CJGlyphRunStrokeItem *>*)allRunItemArray inset:(CGFloat)inset {
    __block CJGlyphRunStrokeItem *currentItem = nil;
    [allRunItemArray enumerateObjectsUsingBlock:^(CJGlyphRunStrokeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(CGRectInset(obj.withOutMergeBounds, -inset, -inset), point)) {
            currentItem = [obj copy];
            *stop = YES;
        }
    }];
    return currentItem;
}

@end

