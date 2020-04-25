//
//  CJSelectTextRangeView.m
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/23.
//  Copyright © 2020 cactus. All rights reserved.
//

#import "CJSelectTextRangeView.h"
#import "CJLabelConfig.h"

@implementation CJSelectTextRangeView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)updateFrame:(CGRect)frame headRect:(CGRect)headRect middleRect:(CGRect)middleRect tailRect:(CGRect)tailRect differentLine:(BOOL)differentLine {
    self.differentLine = differentLine;
    self.frame = frame;
    self.headRect = headRect;
    self.middleRect = middleRect;
    self.tailRect = tailRect;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //背景色
    UIColor *backColor = CJUIRGBColor(0,84,166,0.2);

    if (self.differentLine) {
        [backColor set];
        CGContextAddRect(ctx, self.headRect);
        if (!CGRectEqualToRect(self.middleRect,CGRectNull)) {
            CGContextAddRect(ctx, self.middleRect);
        }
        CGContextAddRect(ctx, self.tailRect);
        CGContextFillPath(ctx);

        [self updatePinLayer:ctx point:CGPointMake(self.headRect.origin.x, self.headRect.origin.y) height:self.headRect.size.height isLeft:YES];

        [self updatePinLayer:ctx point:CGPointMake(self.tailRect.origin.x + self.tailRect.size.width, self.tailRect.origin.y) height:self.tailRect.size.height isLeft:NO];
    }else {

        [backColor set];
        CGContextAddRect(ctx, self.middleRect);
        CGContextFillPath(ctx);

        [self updatePinLayer:ctx point:CGPointMake(self.middleRect.origin.x, self.middleRect.origin.y) height:self.middleRect.size.height isLeft:YES];

        [self updatePinLayer:ctx point:CGPointMake(self.middleRect.origin.x + self.middleRect.size.width, self.middleRect.origin.y) height:self.middleRect.size.height isLeft:NO];
    }

    CGContextStrokePath(ctx);
}

- (void)updatePinLayer:(CGContextRef)ctx point:(CGPoint)point height:(CGFloat)height isLeft:(BOOL)isLeft {
    UIColor *color = [UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0];

    NSInteger width = kCJPinRoundPointSize;
    CGRect roundRect = CGRectMake(point.x - width/2,
                                  isLeft?(point.y - width):(point.y + height),
                                  width,
                                  width);
    //画圆
    CGContextAddEllipseInRect(ctx, roundRect);
    [color set];
    CGContextFillPath(ctx);

    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextAddLineToPoint(ctx, point.x, point.y + height);
    CGContextSetLineWidth(ctx, kCJPinLineWidth);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);

    CGContextStrokePath(ctx);
}


@end
