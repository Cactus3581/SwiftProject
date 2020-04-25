//
//  CJWindowView.m
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/24.
//  Copyright © 2020 cactus. All rights reserved.
//

#import "CJWindowView.h"

@implementation CJWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!CGRectContainsPoint(self.bounds, point)) {
        self.hitTestBlock(YES);
    }
    return nil;
}

@end
