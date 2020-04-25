//
//  CJLabelConfig.m
//  SwiftProject
//
//  Created by ChiJinLian on 2017/4/13.
//  Copyright © 2017年 ChiJinLian. All rights reserved.
//

#import "CJLabelConfig.h"
#import <objc/runtime.h>

CGFloat const kCJPinLineWidth = 2;
NSInteger const kCJPinRoundPointSize = 6;

NSString * const kCJInsertViewTag                            = @"kCJInsertViewTag";

NSString * const kCJImageAttributeName                       = @"kCJImageAttributeName";
NSString * const kCJImage                                    = @"kCJImage";
NSString * const kCJImageHeight                              = @"kCJImageHeight";
NSString * const kCJImageWidth                               = @"kCJImageWidth";
NSString * const kCJImageLineVerticalAlignment               = @"kCJImageLineVerticalAlignment";

NSString * const kCJLinkAttributesName                       = @"kCJLinkAttributesName";
NSString * const kCJActiveLinkAttributesName                 = @"kCJActiveLinkAttributesName";
NSString * const kCJIsLinkAttributesName                     = @"kCJIsLinkAttributesName";
NSString * const kCJLinkIdentifierAttributesName             = @"kCJLinkIdentifierAttributesName";
NSString * const kCJLinkLengthAttributesName                 = @"kCJLinkLengthAttributesName";
NSString * const kCJLinkRangeAttributesName                  = @"kCJLinkRangeAttributesName";
NSString * const kCJLinkParameterAttributesName              = @"kCJLinkParameterAttributesName";
NSString * const kCJClickLinkBlockAttributesName             = @"kCJClickLinkBlockAttributesName";
NSString * const kCJLongPressBlockAttributesName             = @"kCJLongPressBlockAttributesName";
NSString * const kCJLinkNeedRedrawnAttributesName            = @"kCJLinkNeedRedrawnAttributesName";
NSString * const kCJNonLineWrapAttributesName                = @"kCJNonLineWrapAttributesName";

NSString * const kCJBackgroundFillColorAttributeName         = @"kCJBackgroundFillColor";
NSString * const kCJBackgroundStrokeColorAttributeName       = @"kCJBackgroundStrokeColor";
NSString * const kCJBackgroundLineWidthAttributeName         = @"kCJBackgroundLineWidth";
NSString * const kCJBackgroundLineCornerRadiusAttributeName  = @"kCJBackgroundLineCornerRadius";
NSString * const kCJActiveBackgroundFillColorAttributeName   = @"kCJActiveBackgroundFillColor";
NSString * const kCJActiveBackgroundStrokeColorAttributeName = @"kCJActiveBackgroundStrokeColor";
NSString * const kCJStrikethroughStyleAttributeName          = @"kCJStrikethroughStyleAttributeName";
NSString * const kCJStrikethroughColorAttributeName          = @"kCJStrikethroughColorAttributeName";
NSString * const kCJLinkStringIdentifierAttributesName       = @"kCJLinkStringIdentifierAttributesName";

void RunDelegateDeallocCallback(void * refCon) {
    
}

//获取图片高度
CGFloat RunDelegateGetAscentCallback(void * refCon) {
    return [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:kCJImageHeight] floatValue];
}

CGFloat RunDelegateGetDescentCallback(void * refCon) {
    return 0;
}

//获取图片宽度
CGFloat RunDelegateGetWidthCallback(void * refCon) {
    return [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:kCJImageWidth] floatValue];
}


@implementation CJLabelConfig

- (void)addAttributes:(id)attributes key:(NSString *)key {
    NSMutableDictionary *attributesDic = [NSMutableDictionary dictionaryWithCapacity:3];
    if (self.attributes) {
        [attributesDic addEntriesFromDictionary:self.attributes];
    }
    if (attributes && key.length > 0) {
        [attributesDic setObject:attributes forKey:key];
        self.attributes = attributesDic;
    }
}

- (void)removeAttributesForKey:(NSString *)key {
    if (self.attributes && key.length > 0) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:self.attributes];
        [attributes removeObjectForKey:key];
        self.attributes = attributes;
    }
}

- (void)addActiveAttributes:(id)activeAttributes key:(NSString *)key {
    NSMutableDictionary *activeAttributesDic = [NSMutableDictionary dictionaryWithCapacity:3];
    if (self.activeLinkAttributes) {
        [activeAttributesDic addEntriesFromDictionary:self.activeLinkAttributes];
    }
    if (activeAttributes && key.length > 0) {
        [activeAttributesDic setObject:activeAttributes forKey:key];
        self.activeLinkAttributes = activeAttributesDic;
    }
}

- (void)removeActiveLinkAttributesForKey:(NSString *)key {
    if (self.activeLinkAttributes && key.length > 0) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:self.activeLinkAttributes];
        [attributes removeObjectForKey:key];
        self.activeLinkAttributes = attributes;
    }
}

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
                                                      islink:(BOOL)isLink {
    NSParameterAssert((loc <= attrStr.length) && (!CJLabelIsNull(image)));
    if ([image isKindOfClass:[NSString class]]) {
        NSParameterAssert([image length] != 0);
    }
    
    NSDictionary *imgInfoDic = @{kCJImage:image,
                                 kCJImageWidth:@(size.width),
                                 kCJImageHeight:@(size.height),
                                 kCJImageLineVerticalAlignment:@(verticalAlignment)};
    
    //创建CTRunDelegateRef并设置回调函数
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)imgInfoDic);
    
    unichar imgReplacementChar = 0xFFFC;
    NSString *imgReplacementString = [NSString stringWithCharacters:&imgReplacementChar length:1];
    //插入图片 空白占位符
    NSMutableString *imgPlaceholderStr = [[NSMutableString alloc]initWithCapacity:3];
    [imgPlaceholderStr appendString:imgReplacementString];
    NSRange imgRange = NSMakeRange(0, imgPlaceholderStr.length);
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:imgPlaceholderStr];
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:imgRange];
    [imageAttributedString addAttribute:kCJImageAttributeName value:imgInfoDic range:imgRange];
    
    if (!CJLabelIsNull(linkAttributes) && linkAttributes.count > 0) {
        [imageAttributedString addAttribute:kCJLinkAttributesName value:linkAttributes range:imgRange];
    }
    if (!CJLabelIsNull(activeLinkAttributes) && activeLinkAttributes.count > 0) {
        [imageAttributedString addAttribute:kCJActiveLinkAttributesName value:activeLinkAttributes range:imgRange];
    }
    if (!CJLabelIsNull(parameter)) {
        [imageAttributedString addAttribute:kCJLinkParameterAttributesName value:parameter range:imgRange];
    }
    if (!CJLabelIsNull(clickLinkBlock)) {
        [imageAttributedString addAttribute:kCJClickLinkBlockAttributesName value:clickLinkBlock range:imgRange];
    }
    if (!CJLabelIsNull(longPressBlock)) {
        [imageAttributedString addAttribute:kCJLongPressBlockAttributesName value:longPressBlock range:imgRange];
    }
    if (isLink) {
        [imageAttributedString addAttribute:kCJIsLinkAttributesName value:@(YES) range:imgRange];
        [imageAttributedString addAttribute:kCJLinkIdentifierAttributesName value:@(arc4random()) range:imgRange];
        [imageAttributedString addAttribute:kCJLinkLengthAttributesName value:@(imgRange.length) range:imgRange];
    }else {
        [imageAttributedString addAttribute:kCJIsLinkAttributesName value:@(NO) range:imgRange];
        [imageAttributedString addAttribute:kCJLinkLengthAttributesName value:@(0) range:imgRange];
    }
    NSRange range = NSMakeRange(loc, imgPlaceholderStr.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    
    /* 设置默认换行模式为：NSLineBreakByCharWrapping
     * 当Label的宽度不够显示内容或图片的时候就自动换行, 不自动换行, 部分图片将会看不见
     */
    NSRange attributedStringRange = NSMakeRange(0, attributedString.length);
    NSDictionary *dic = nil;
    if (attributedStringRange.length > 0) {
        dic = [attributedString attributesAtIndex:0 effectiveRange:&attributedStringRange];
    }
    //判断是否有设置NSParagraphStyleAttributeName属性
    NSMutableParagraphStyle *paragraph = dic[NSParagraphStyleAttributeName];
    //判断linkAttributes中是否有设置NSParagraphStyleAttributeName属性
    if (CJLabelIsNull(paragraph)) {
        paragraph = linkAttributes[NSParagraphStyleAttributeName];
    }
    //都没有设置，取默认值
    if (CJLabelIsNull(paragraph)) {
        paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByCharWrapping;
    }
    
    [attributedString insertAttributedString:imageAttributedString atIndex:range.location];
    if (!CJLabelIsNull(paragraph)) {
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attributedString.length)];
    }
    CFRelease(runDelegate);
    
    return attributedString;
}

+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                     atRange:(NSRange)range
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(CJLabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(CJLabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink {
    NSParameterAssert(attrStr.length > 0);
    NSParameterAssert((range.location + range.length) <= attrStr.length);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    UIFont *linkFont = nil;
    UIFont *activeLinkFont = nil;
    if (!CJLabelIsNull(linkAttributes) && linkAttributes.count > 0) {
        linkFont = linkAttributes[NSFontAttributeName];
        [attributedString addAttribute:kCJLinkAttributesName value:linkAttributes range:range];
    }
    if (!CJLabelIsNull(activeLinkAttributes) && activeLinkAttributes.count > 0) {
        activeLinkFont = activeLinkAttributes[NSFontAttributeName];
        [attributedString addAttribute:kCJActiveLinkAttributesName value:activeLinkAttributes range:range];
    }
    //正常状态跟点击高亮状态下字体大小不同，标记需要重绘
    if ((linkFont && activeLinkFont) && (![linkFont.fontName isEqualToString:activeLinkFont.fontName] || linkFont.pointSize != activeLinkFont.pointSize)) {
        [attributedString addAttribute:kCJLinkNeedRedrawnAttributesName value:@(YES) range:range];
    }else {
        [attributedString addAttribute:kCJLinkNeedRedrawnAttributesName value:@(NO) range:range];
    }
    if (!CJLabelIsNull(parameter)) {
        [attributedString addAttribute:kCJLinkParameterAttributesName value:parameter range:range];
    }
    if (!CJLabelIsNull(clickLinkBlock)) {
        [attributedString addAttribute:kCJClickLinkBlockAttributesName value:clickLinkBlock range:range];
    }
    if (!CJLabelIsNull(longPressBlock)) {
        [attributedString addAttribute:kCJLongPressBlockAttributesName value:longPressBlock range:range];
    }
    if (isLink) {
        [attributedString addAttribute:kCJIsLinkAttributesName value:@(YES) range:range];
        [attributedString addAttribute:kCJLinkIdentifierAttributesName value:@(arc4random()) range:range];
        [attributedString addAttribute:kCJLinkLengthAttributesName value:@(range.length) range:range];
    }else {
        [attributedString addAttribute:kCJIsLinkAttributesName value:@(NO) range:range];
        [attributedString addAttribute:kCJLinkLengthAttributesName value:@(0) range:range];
    }
    return attributedString;
}

+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                                  withString:(NSString *)withString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(CJLabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(CJLabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    if (!sameStringEnable) {
        NSRange range = [self getFirstRangeWithString:withString inAttString:attrStr];
        if (range.location != NSNotFound) {
            attributedString = [self configureLinkAttributedString:attributedString atRange:range linkAttributes:linkAttributes activeLinkAttributes:activeLinkAttributes parameter:parameter clickLinkBlock:clickLinkBlock longPressBlock:longPressBlock islink:isLink];
        }
    }else {
        NSArray *rangeAry = [self getLinkStringRangeArray:withString inAttString:attrStr];
        if (rangeAry.count > 0) {
            for (NSValue *rangeValue in rangeAry) {
                attributedString = [self configureLinkAttributedString:attributedString atRange:rangeValue.rangeValue linkAttributes:linkAttributes activeLinkAttributes:activeLinkAttributes parameter:parameter clickLinkBlock:clickLinkBlock longPressBlock:longPressBlock islink:isLink];
            }
        }
    }
    return attributedString;
}

+ (NSMutableAttributedString *)configureLinkAttributedString:(NSAttributedString *)attrStr
                                               withAttString:(NSAttributedString *)withAttString
                                            sameStringEnable:(BOOL)sameStringEnable
                                              linkAttributes:(NSDictionary *)linkAttributes
                                        activeLinkAttributes:(NSDictionary *)activeLinkAttributes
                                                   parameter:(id)parameter
                                              clickLinkBlock:(CJLabelLinkModelBlock)clickLinkBlock
                                              longPressBlock:(CJLabelLinkModelBlock)longPressBlock
                                                      islink:(BOOL)isLink {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    if (!sameStringEnable) {
        NSRange range = [self getFirstRangeWithAttString:withAttString inAttString:attrStr];
        if (range.location != NSNotFound) {
            attributedString = [self configureLinkAttributedString:attributedString atRange:range linkAttributes:linkAttributes activeLinkAttributes:activeLinkAttributes parameter:parameter clickLinkBlock:clickLinkBlock longPressBlock:longPressBlock islink:isLink];
        }
    }else {
        NSArray *rangeAry = [self getLinkAttStringRangeArray:withAttString inAttString:attrStr];
        if (rangeAry.count > 0) {
            for (NSValue *rangeValue in rangeAry) {
                attributedString = [self configureLinkAttributedString:attributedString atRange:rangeValue.rangeValue linkAttributes:linkAttributes activeLinkAttributes:activeLinkAttributes parameter:parameter clickLinkBlock:clickLinkBlock longPressBlock:longPressBlock islink:isLink];
            }
        }
    }
    return attributedString;
}

+ (NSMutableAttributedString *)configureAttrString:(NSAttributedString *)attrString strIdentifier:(NSString *)strIdentifier configure:(CJLabelConfig *)configure linkRangeAry:(NSArray *)linkRangeAry {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attrString];
    if (linkRangeAry.count > 0) {
        for (NSValue *rangeValue in linkRangeAry) {
            attributedString = [self configureLinkAttributedString:attributedString atRange:rangeValue.rangeValue linkAttributes:configure.attributes activeLinkAttributes:configure.activeLinkAttributes parameter:configure.parameter clickLinkBlock:configure.clickLinkBlock longPressBlock:configure.longPressBlock islink:configure.isLink];
        }
    }
    return attributedString;
}

+ (NSMutableAttributedString *)linkAttStr:(NSString *)string
                               attributes:(NSDictionary <NSString *,id>*)attrs
                               identifier:(NSString *)identifier {
    NSParameterAssert(string);
    if (CJLabelIsNull(identifier) || identifier.length == 0) {
        identifier = @"";
    }
    
    NSDictionary *dic = CJLabelIsNull(attrs)?[[NSDictionary alloc] init]:[[NSDictionary alloc]initWithDictionary:attrs];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string attributes:dic];
    [attStr addAttribute:kCJLinkStringIdentifierAttributesName value:identifier range:NSMakeRange(0, attStr.length)];
    
    return attStr;
}

#pragma mark - 获取链点的NSRange
+ (NSRange)getFirstRangeWithString:(NSString *)withString inAttString:(NSAttributedString *)attString {
    NSRange range = [attString.string rangeOfString:withString];
    if (range.location == NSNotFound) {
        return range;
    }
    return range;
}

+ (NSArray <NSValue *>*)getLinkStringRangeArray:(NSString *)linkString inAttString:(NSAttributedString *)attString {
    NSArray *strRanges = [self getRangeArrayWithString:linkString inString:attString.string lastRange:NSMakeRange(0, 0) rangeArray:[NSMutableArray array]];
    return strRanges;
}

+ (NSRange)getFirstRangeWithAttString:(NSAttributedString *)withAttString inAttString:(NSAttributedString *)attString {
    NSRange range = [attString.string rangeOfString:withAttString.string];
    if (range.location == NSNotFound) {
        return range;
    }
    
    NSAttributedString *str = [attString attributedSubstringFromRange:range];
    NSRange strRange = NSMakeRange(0, str.length);
    NSDictionary *strDic = nil;
    if (strRange.length > 0) {
        strDic = [str attributesAtIndex:0 effectiveRange:&strRange];
    }
    NSString *identifier = strDic[kCJLinkStringIdentifierAttributesName];
    
    NSRange withStrRange = NSMakeRange(0, withAttString.length);
    NSDictionary *withStrDic = nil;
    if (withStrRange.length > 0) {
        withStrDic = [withAttString attributesAtIndex:0 effectiveRange:&withStrRange];
    }
    NSString *withIdentifier = withStrDic[kCJLinkStringIdentifierAttributesName];
    
    if (!identifier || !identifier || ![identifier isEqualToString:withIdentifier]) {
        range = NSMakeRange(NSNotFound, 0);
    }
    return range;
}

+ (NSArray <NSValue *>*)getLinkAttStringRangeArray:(NSAttributedString *)linkAttString inAttString:(NSAttributedString *)attString {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
    NSArray *strRanges = [self getRangeArrayWithString:linkAttString.string inString:attString.string lastRange:NSMakeRange(0, 0) rangeArray:[NSMutableArray array]];
    
    if (strRanges.count > 0) {
        
        NSRange withStrRange = NSMakeRange(0, linkAttString.length);
        NSDictionary *withStrDic = nil;
        if (withStrRange.length > 0) {
            withStrDic = [linkAttString attributesAtIndex:0 effectiveRange:&withStrRange];
        }
        NSString *withKey = withStrDic[kCJLinkStringIdentifierAttributesName];
        
        [strRanges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSValue *rangeValue = (NSValue *)obj;
            NSRange range = rangeValue.rangeValue;
            NSAttributedString *str = [attString attributedSubstringFromRange:range];
            NSRange strRange = NSMakeRange(0, str.length);
            NSDictionary *strDic = nil;
            if (strRange.length > 0) {
                strDic = [str attributesAtIndex:0 effectiveRange:&strRange];
            }
            NSString *key = strDic[kCJLinkStringIdentifierAttributesName];
            
            if (key.length > 0) {
                if ([key isEqualToString:withKey]) {
                    [array addObject:rangeValue];
                }
            }else {
                if (withKey.length > 0) {
                    [array addObject:rangeValue];
                }
            }
        }];
    }
    
    return array;
}

/**
 *  遍历string，获取withString在string中的所有NSRange数组
 *
 *  @param withString 需要匹配的string
 *  @param string     string文本
 *  @param lastRange  withString上一次出现的NSRange值，初始为NSMakeRange(0, 0)
 *  @param array      初始NSRange数组
 *
 *  @return           返回最后的NSRange数组
 */
+ (NSArray <NSValue *>*)getRangeArrayWithString:(NSString *)withString
                                       inString:(NSString *)string
                                      lastRange:(NSRange)lastRange
                                     rangeArray:(NSMutableArray *)array {
    NSRange range = [string rangeOfString:withString];
    if (range.location == NSNotFound){
        return array;
    }else {
        NSRange curRange = NSMakeRange(lastRange.location+lastRange.length+range.location, range.length);
        [array addObject:[NSValue valueWithRange:curRange]];
        NSString *tempString = [string substringFromIndex:(range.location+range.length)];
        [self getRangeArrayWithString:withString inString:tempString lastRange:curRange rangeArray:array];
        return array;
    }
}

@end



