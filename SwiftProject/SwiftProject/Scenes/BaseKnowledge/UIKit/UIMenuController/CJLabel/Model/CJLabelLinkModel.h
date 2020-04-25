//
//  CJLabelLinkModel.h
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/23.
//  Copyright © 2020 cactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CJLabel;

NS_ASSUME_NONNULL_BEGIN

/**
 点击链点model
 */
@interface CJLabelLinkModel : NSObject
/**
 当前CJLabel实例
 */
@property (readonly, nonatomic, strong) CJLabel *label;
/**
 链点文本
 */
@property (readonly, nonatomic, strong) NSAttributedString *attributedString;
/**
 链点自定义参数
 */
@property (readonly, nonatomic, strong) id parameter;
/**
 链点在整体文本中的range值
 */
@property (readonly, nonatomic, assign) NSRange linkRange;
/**
 链点view的Rect（相对于CJLabel坐标的rect)
 */
@property (readonly, nonatomic, assign) CGRect insertViewRect;
/**
 插入链点view
 */
@property (readonly, nonatomic, strong) id insertView;

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString
                              insertView:(id)insertView
                          insertViewRect:(CGRect)insertViewRect
                               parameter:(id)parameter
                               linkRange:(NSRange)linkRange
                                   label:(CJLabel *)label;
@end


@interface CJCTRunUrl: NSURL

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSValue *rangeValue;

@end

NS_ASSUME_NONNULL_END
