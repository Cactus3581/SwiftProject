//
//  CJSelectTextRangeView.h
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/23.
//  Copyright © 2020 cactus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 选中复制填充背景色的view
 */
@interface CJSelectTextRangeView : UIView
/**
 前半部分选中区域
 */
@property (nonatomic, assign) CGRect headRect;
/**
 中间部分选中区域
 */
@property (nonatomic, assign) CGRect middleRect;
/**
 后半部分选中区域
 */
@property (nonatomic, assign) CGRect tailRect;
/**
 选择内容是否包含不同行
 */
@property (nonatomic, assign) BOOL differentLine;

- (void)updateFrame:(CGRect)frame headRect:(CGRect)headRect middleRect:(CGRect)middleRect tailRect:(CGRect)tailRect differentLine:(BOOL)differentLine;

@end

NS_ASSUME_NONNULL_END
