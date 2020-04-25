//
//  CJGlyphRunStrokeItem.h
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/23.
//  Copyright © 2020 cactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJLabelConfig.h"

NS_ASSUME_NONNULL_BEGIN

/**
 响应点击以及指定区域绘制边框线辅助类
 */
@interface CJGlyphRunStrokeItem : NSObject

@property (nonatomic, strong) UIColor *fillColor;//填充背景色
@property (nonatomic, strong) UIColor *strokeColor;//描边边框色
@property (nonatomic, strong) UIColor *activeFillColor;//点击选中时候的填充背景色
@property (nonatomic, strong) UIColor *activeStrokeColor;//点击选中时候的描边边框色
@property (nonatomic, assign) CGFloat strokeLineWidth;//描边边框粗细
@property (nonatomic, assign) CGFloat cornerRadius;//描边圆角
@property (nonatomic, assign) CGFloat strikethroughStyle;//删除线
@property (nonatomic, strong) UIColor *strikethroughColor;//删除线颜色
@property (nonatomic, assign) CGRect runBounds;//描边区域在系统坐标下的rect（原点在左下角）
@property (nonatomic, assign) CGRect locBounds;//描边区域在屏幕坐标下的rect（原点在左上角），相同的一组CTRun，发生了合并
@property (nonatomic, assign) CGRect withOutMergeBounds;//每个字符对应的CTRun 在屏幕坐标下的rect（原点在左上角），没有发生合并

@property (nonatomic, assign) CGFloat runDescent;//对应的CTRun的下行高
@property (nonatomic, assign) CTRunRef runRef;//对应的CTRun

@property (nonatomic, strong) id insertView;//插入view
@property (nonatomic, assign) BOOL isInsertView;//是否是插入view
@property (nonatomic, assign) NSRange range;//链点在文本中的range
@property (nonatomic, strong) id parameter;//链点自定义参数
@property (nonatomic, assign) CJCTLineVerticalLayout lineVerticalLayout;//所在CTLine的行高信息结构体
@property (nonatomic, assign) BOOL isLink;//判断是否为点击链点
@property (nonatomic, assign) BOOL needRedrawn;//标记点击该链点是否需要重绘文本
@property (nonatomic, copy) CJLabelLinkModelBlock linkBlock;//点击链点回调
@property (nonatomic, copy) CJLabelLinkModelBlock longPressBlock;//长按点击链点回调
/** 是否不允许换行的字符*/
@property (nonatomic, assign) BOOL isNonLineWrap;

//与选择复制相关的属性
@property (nonatomic, assign) NSInteger characterIndex;//字符在整段文本中的index值
@property (nonatomic, assign) NSRange characterRange;//字符在整段文本中的range值

@end

NS_ASSUME_NONNULL_END
