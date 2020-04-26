//
//  CJFloatMenuView.h
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/14.
//  Copyright © 2020 cactus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSInteger const FloatMenuViewHeight;
extern NSInteger const FloatMenuViewInset;

@interface CJFloatMenuView : UIView

+ (instancetype)share;
- (instancetype)init NS_UNAVAILABLE;
- (void)show;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) dispatch_block_t didClick;

@end

NS_ASSUME_NONNULL_END
