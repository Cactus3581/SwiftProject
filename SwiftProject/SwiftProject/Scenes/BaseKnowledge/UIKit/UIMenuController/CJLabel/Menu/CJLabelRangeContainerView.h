//
//  CJLabelRangeContainerView.h
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/23.
//  Copyright © 2020 cactus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJGlyphRunStrokeItem;
@class CJLabel;

NS_ASSUME_NONNULL_BEGIN

/**
 选择复制时候的操作视图
 CJLabelRangeContainerView 在 window 层，全局只有一个
 CJSelectTextRangeView（选中填充背景色的view）在 CJLabelRangeContainerView上
 */
@interface CJLabelRangeContainerView : UIView

+ (instancetype)instance;

/**
 CJLabel选中point点对应的文本内容

 @param label                  CJLabel
 @param point                  放大点
 @param item                   放大点对应的CJGlyphRunStrokeItem
 @param maxLineWidth           CJLabel的最大行宽度
 @param allCTLineVerticalArray CJLabel的CTLine数组
 @param allRunItemArray        CJLabel的CTRun数组
 @param hideViewBlock          复制选择view隐藏后的block
 */
- (void)showSelectViewInCJLabel:(CJLabel *)label
                        atPoint:(CGPoint)point
                        runItem:(CJGlyphRunStrokeItem *)item
                   maxLineWidth:(CGFloat)maxLineWidth
         allCTLineVerticalArray:(NSArray *)allCTLineVerticalArray
                allRunItemArray:(NSArray <CJGlyphRunStrokeItem *>*)allRunItemArray
                  hideViewBlock:(void(^)(void))hideViewBlock;

/**
 隐藏选择复制相关的view
 */
- (void)hideView;

+ (CJGlyphRunStrokeItem *)currentItem:(CGPoint)point allRunItemArray:(NSArray <CJGlyphRunStrokeItem *>*)allRunItemArray inset:(CGFloat)inset;

NS_ASSUME_NONNULL_END

@end




