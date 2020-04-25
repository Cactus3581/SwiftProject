//
//  CJWindowView.h
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/24.
//  Copyright © 2020 cactus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJWindowView : UIView

@property (nonatomic, copy) void(^hitTestBlock)(BOOL hide);

@end




NS_ASSUME_NONNULL_END
