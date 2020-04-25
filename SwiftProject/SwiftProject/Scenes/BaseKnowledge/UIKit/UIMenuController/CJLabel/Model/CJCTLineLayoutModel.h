//
//  CJCTLineLayoutModel.h
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/23.
//  Copyright © 2020 cactus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJLabelConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJCTLineLayoutModel : NSObject

@property (nonatomic, assign) CFIndex lineIndex;//第几行
@property (nonatomic, assign) CJCTLineVerticalLayout lineVerticalLayout;//所在CTLine的行高信息结构体
@property (nonatomic, assign) CGFloat selectCopyBackY;//选中后被填充背景色的复制视图的Y坐标
@property (nonatomic, assign) CGFloat selectCopyBackHeight;//选中后被填充背景色的复制视图的高度

@end

NS_ASSUME_NONNULL_END
