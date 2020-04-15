//
//  CJFloatMenuView.m
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/14.
//  Copyright © 2020 cactus. All rights reserved.
//

#import "CJFloatMenuView.h"

NSInteger const FloatMenuViewHeight = 48;
NSInteger const FloatMenuViewInset = 16;

@interface CJFloatMenuView()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *label;

@end

static CJFloatMenuView *menuView = nil;

@implementation CJFloatMenuView

#pragma mark - 初始化 单例
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [[self alloc] init];
    });
    return menuView;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIView *contentView = [[UIView alloc] init];
    _contentView = contentView;
    contentView.layer.cornerRadius = 8;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = UIColor.blackColor;
    [self addSubview:contentView];

    UILabel *label = [[UILabel alloc] init];
    _label = label;
    label.backgroundColor = UIColor.blackColor;
    label.text = @"Copy";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [contentView addSubview:label];

    UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"icon-copy-bg"]];
    _imageView = imageView;
    [self addSubview:imageView];

    CGFloat labelWidth = [label sizeThatFits:CGSizeZero].width;
    self.bounds = CGRectMake(0, 0, labelWidth + FloatMenuViewInset*2, FloatMenuViewHeight);

    self.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-12);
    [_label sizeToFit];
    _label.center = _contentView.center;
    _imageView.frame = CGRectMake(self.bounds.size.width/2-20/2, self.bounds.size.height-12, 20, 12);
}

- (void)click {
    if (self.didClick) {
        self.didClick();
    }
}

@end
