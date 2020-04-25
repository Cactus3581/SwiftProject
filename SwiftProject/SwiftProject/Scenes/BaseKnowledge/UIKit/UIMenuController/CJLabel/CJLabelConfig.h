//
//  CJLabelConfig.h
//  SwiftProject
//
//  Created by ChiJinLian on 2017/4/13.
//  Copyright © 2017年 ChiJinLian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@class CJLabelLinkModel;

NS_ASSUME_NONNULL_BEGIN

 //当text bounds小于label bounds时，文本的垂直对齐方式
typedef NS_ENUM(NSInteger, CJLabelVerticalAlignment) {
    CJVerticalAlignmentCenter   = 0,//垂直居中
    CJVerticalAlignmentTop      = 1,//居上
    CJVerticalAlignmentBottom   = 2,//靠下
};

/**
 当CTLine包含插入图片时，描述当前行文字在垂直方向的对齐方式
 */
struct CJCTLineVerticalLayout {
    CFIndex line;//第几行
    CGFloat lineAscentAndDescent;//上行高和下行高之和
    CGRect  lineRect;//当前行对应的CGRect
    CGFloat maxRunHeight;//当前行run的最大高度（不包括图片）
    CGFloat maxRunAscent;//CTRun的最大上行高
    CGFloat maxImageHeight;//图片的最大高度
    CGFloat maxImageAscent;//图片的最大上行高
    CJLabelVerticalAlignment verticalAlignment;//对齐方式（默认底部对齐）
};

/**
 大头针的显示类型
 */
typedef NS_ENUM(NSInteger, CJSelectViewAction) {
    ShowAllSelectView    = 0,//显示大头针（长按或者双击）
    MoveLeftSelectView   = 1,//移动左边大头针
    MoveRightSelectView  = 2 //移动右边大头针
};

typedef struct CJCTLineVerticalLayout CJCTLineVerticalLayout;
typedef void (^CJLabelLinkModelBlock)(CJLabelLinkModel *linkModel);

#define CJLabelIsNull(a) ((a)==nil || (a)==NULL || (NSNull *)(a)== [NSNull null])
#define CJUIRGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])

static char kAssociatedUITouchKey;
extern CGFloat const kCJPinLineWidth;
extern NSInteger const kCJPinRoundPointSize;

extern NSString * const kCJInsertViewTag;
extern NSString * const kCJImageAttributeName;
extern NSString * const kCJImage;
extern NSString * const kCJImageHeight;
extern NSString * const kCJImageWidth;
extern NSString * const kCJImageLineVerticalAlignment;

extern NSString * const kCJLinkAttributesName;
extern NSString * const kCJActiveLinkAttributesName;
extern NSString * const kCJIsLinkAttributesName;
//点击链点唯一标识
extern NSString * const kCJLinkIdentifierAttributesName;
extern NSString * const kCJLinkLengthAttributesName;
extern NSString * const kCJLinkRangeAttributesName;
extern NSString * const kCJLinkParameterAttributesName;
extern NSString * const kCJClickLinkBlockAttributesName;
extern NSString * const kCJLongPressBlockAttributesName;
extern NSString * const kCJLinkNeedRedrawnAttributesName;
/**
 不允许换行字符
 */
extern NSString * const kCJNonLineWrapAttributesName;

static CGFloat const CJFLOAT_MAX = 100000;

/**
 背景填充颜色。值为UIColor。默认 `nil`。
 该属性优先级低于NSBackgroundColorAttributeName，如果设置NSBackgroundColorAttributeName会覆盖kCJBackgroundFillColorAttributeName
 */
extern NSString * const kCJBackgroundFillColorAttributeName;

/**
 背景边框线颜色。值为UIColor。默认 `nil`
 */
extern NSString * const kCJBackgroundStrokeColorAttributeName;

/**
 背景边框线宽度。值为NSNumber。默认 `1.0f`
 */
extern NSString * const kCJBackgroundLineWidthAttributeName;

/**
 背景边框线圆角角度。值为NSNumber。默认 `5.0f`
 */
extern NSString * const kCJBackgroundLineCornerRadiusAttributeName;

/**
 点击时候的背景填充颜色。值为UIColor。默认 `nil`。
 该属性优先级低于NSBackgroundColorAttributeName，如果设置NSBackgroundColorAttributeName会覆盖kCJActiveBackgroundFillColorAttributeName
 */
extern NSString * const kCJActiveBackgroundFillColorAttributeName;

/**
 点击时候的背景边框线颜色。值为UIColor。默认 `nil`
 */
extern NSString * const kCJActiveBackgroundStrokeColorAttributeName;

/**
 删除线宽度。值为NSNumber。默认 `0.0f`，表示无删除线
 */
extern NSString * const kCJStrikethroughStyleAttributeName;

/**
 删除线颜色。值为UIColor。默认 `[UIColor blackColor]`。
 */
extern NSString * const kCJStrikethroughColorAttributeName;

/**
 对NSAttributedString文本设置链点属性时候的唯一标识
 */
extern NSString * const kCJLinkStringIdentifierAttributesName;


static inline CGFLOAT_TYPE CGFloat_ceil(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return ceil(cgfloat);
#else
    return ceilf(cgfloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_floor(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return floor(cgfloat);
#else
    return floorf(cgfloat);
#endif
}

static inline CGFloat CJFlushFactorForTextAlignment(NSTextAlignment textAlignment) {
    switch (textAlignment) {
        case NSTextAlignmentCenter:
            return 0.5f;
        case NSTextAlignmentRight:
            return 1.0f;
        case NSTextAlignmentLeft:
        default:
            return 0.0f;
    }
}

static inline CGColorRef CGColorRefFromColor(id color) {
    return [color isKindOfClass:[UIColor class]] ? [color CGColor] : (__bridge CGColorRef)color;
}

static inline NSAttributedString * NSAttributedStringByScalingFontSize(NSAttributedString *attributedString, CGFloat scale) {
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    [mutableAttributedString enumerateAttribute:(NSString *)kCTFontAttributeName inRange:NSMakeRange(0, [mutableAttributedString length]) options:0 usingBlock:^(id value, NSRange range, BOOL * __unused stop) {
        UIFont *font = (UIFont *)value;
        if (font) {
            NSString *fontName;
            CGFloat pointSize;

            if ([font isKindOfClass:[UIFont class]]) {
                fontName = font.fontName;
                pointSize = font.pointSize;
            } else {
                fontName = (NSString *)CFBridgingRelease(CTFontCopyName((__bridge CTFontRef)font, kCTFontPostScriptNameKey));
                pointSize = CTFontGetSize((__bridge CTFontRef)font);
            }

            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:range];
            CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, CGFloat_floor(pointSize * scale), NULL);
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
            CFRelease(fontRef);
        }
    }];

    return mutableAttributedString;
}

static inline CGSize CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(CTFramesetterRef framesetter, NSAttributedString *attributedString, CGSize size, NSUInteger numberOfLines) {
    CFRange rangeToSize = CFRangeMake(0, (CFIndex)[attributedString length]);
    CGSize constraints = CGSizeMake(size.width, CJFLOAT_MAX);

    if (numberOfLines == 1) {
        constraints = CGSizeMake(CJFLOAT_MAX, CJFLOAT_MAX);
    } else if (numberOfLines > 0) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, constraints.width, CJFLOAT_MAX));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);

        if (CFArrayGetCount(lines) > 0) {
            NSInteger lastVisibleLineIndex = MIN((CFIndex)numberOfLines, CFArrayGetCount(lines)) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);

            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            rangeToSize = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }

        CFRelease(frame);
        CGPathRelease(path);
    }

    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, NULL, constraints, NULL);

    return CGSizeMake(CGFloat_ceil(suggestedSize.width), CGFloat_ceil(suggestedSize.height));
};

static inline CGFloat compareMaxNum(CGFloat firstNum, CGFloat secondNum, BOOL max){
    CGFloat result = firstNum;
    if (max) {
        result = (firstNum >= secondNum)?firstNum:secondNum;
    }else {
        result = (firstNum <= secondNum)?firstNum:secondNum;
    }
    return result;
}

static inline UIColor * colorWithAttributeName(NSDictionary *dic, NSString *key){
    UIColor *color = nil;
    if (dic[key] && nil != dic[key]) {
        color = dic[key];
    }
    return color;
}

static inline BOOL isNotClearColor(UIColor *color){
    if (CJLabelIsNull(color)) {
        return NO;
    }
    BOOL notClearColor = YES;
    if (CGColorEqualToColor(color.CGColor, [UIColor clearColor].CGColor)) {
        notClearColor = NO;
    }
    return notClearColor;
}

static inline BOOL isSameColor(UIColor *color1, UIColor *color2){
    BOOL same = YES;
    if (!CGColorEqualToColor(color1.CGColor, color2.CGColor)) {
        same = NO;
    }
    return same;
}

static inline UIWindow *CJkeyWindow() {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]) {
        return [app.delegate window];
    } else {
        return [app keyWindow];
    }
}

/**
 设置链点属性辅助类，可设置链点正常属性、点击高亮属性、链点自定义参数、点击回调以及长按回调
 */
@interface CJLabelConfig : NSObject
/**
 设置链点的自定义属性
 */
@property (nonatomic, strong) NSDictionary<NSString *, id> *attributes;
/**
 是否为可点击链点，设置 isLink=YES 时，activeLinkAttributes、parameter、clickLinkBlock、longPressBlock才有效
 */
@property (nonatomic, assign) BOOL isLink;
/**
 设置链点点击高亮时候的自定义属性
 */
@property (nonatomic, strong) NSDictionary<NSString *, id> *activeLinkAttributes;
/**
 点击链点的自定义参数
 */
@property (nonatomic, strong) id parameter;
/**
 点击链点回调block
 */
@property (nonatomic, copy) CJLabelLinkModelBlock clickLinkBlock;
/**
 长按链点的回调block
 */
@property (nonatomic, copy) CJLabelLinkModelBlock longPressBlock;

/**
 添加 attributes 属性
 
 @param attributes 属性值
 @param key        属性
 */
- (void)addAttributes:(id)attributes key:(NSString *)key;
/**
 移除 attributes 指定属性
 
 @param key 属性
 */
- (void)removeAttributesForKey:(NSString *)key;
/**
 添加 activeAttributes 属性
 
 @param activeAttributes 属性值
 @param key              属性
 */
- (void)addActiveAttributes:(id)activeAttributes key:(NSString *)key;
/**
 移除 activeAttributes 指定属性
 
 @param key 属性
 */
- (void)removeActiveLinkAttributesForKey:(NSString *)key;

/**
 在指定位置插入图片链点！！！
 */
+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                    addImage:(id)image
                                                   imageSize:(CGSize)size
                                                     atIndex:(NSUInteger)loc
                                           verticalAlignment:(CJLabelVerticalAlignment)verticalAlignment
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(CJLabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(CJLabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink;
/**
 根据指定NSRange配置富文本链点！！！
 */
+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                     atRange:(NSRange)range
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(CJLabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(CJLabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink;


/**
 对文本中跟withString相同的文字配置富文本链点！！！
 */
+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                  withString:(NSString *)withString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(CJLabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(CJLabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink;

/**
 对文本中跟withAttString相同的NSAttributedString配置富文本链点！！！
 */
+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                               withAttString:(NSAttributedString *)withAttString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(CJLabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(CJLabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink;
/**
 对文本中指定strIdentifier标识的NSAttributedString配置富文本链点！！！
 */
+ (NSMutableAttributedString *)configureAttrString:(NSAttributedString *)attrString
                                     strIdentifier:(NSString *)strIdentifier
                                         configure:(CJLabelConfig *)configure
                                      linkRangeAry:(NSArray *)linkRangeAry;

/**
 生成string链点的NSAttributedString（请保证identifier的唯一性！！！）
 
 @param string 点击链点的string
 @param attrs 链点属性
 @param identifier 点击链点的唯一标识
 @return 返回点击链点的NSMutableAttributedString
 */
+ (NSMutableAttributedString *)linkAttStr:(NSString *)string
                               attributes:(NSDictionary <NSString *,id>*)attrs
                               identifier:(NSString *)identifier;

+ (NSArray <NSValue *>*)getLinkStringRangeArray:(NSString *)linkString inAttString:(NSAttributedString *)attString;
+ (NSArray <NSValue *>*)getLinkAttStringRangeArray:(NSAttributedString *)linkAttString inAttString:(NSAttributedString *)attString;

@end

NS_ASSUME_NONNULL_END
