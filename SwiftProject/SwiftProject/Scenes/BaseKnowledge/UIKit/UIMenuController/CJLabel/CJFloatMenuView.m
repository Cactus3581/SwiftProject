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

static CJFloatMenuView *menuView = nil;
static CGFloat imageViewWidth = 18;
static CGFloat imageViewHeight = 9;

@interface CJFloatMenuView()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *label;

@end


@implementation CJFloatMenuView

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

- (void)setText: (NSString *)text {
    _text = text;
    _label.text = text;
    CGFloat labelWidth = [_label sizeThatFits:CGSizeZero].width;
    self.bounds = CGRectMake(0, 0, labelWidth + FloatMenuViewInset*2, FloatMenuViewHeight);
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    UIView *contentView = [[UIView alloc] init];
    _contentView = contentView;
    contentView.layer.cornerRadius = 8;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = UIColor.blackColor;
    [self addSubview:contentView];

    UILabel *label = [[UILabel alloc] init];
    _label = label;
    label.backgroundColor = UIColor.blackColor;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [contentView addSubview:label];

    UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"icon-copy-bg"]];
    _imageView = imageView;
    [self addSubview:imageView];

    self.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-imageViewHeight);
    [_label sizeToFit];
    _label.center = _contentView.center;
    _imageView.frame = CGRectMake(self.bounds.size.width/2-imageViewWidth/2, self.bounds.size.height-imageViewHeight, imageViewWidth, imageViewHeight);
}

- (void)show {
//    [CdJJkeyWindow() addSubview:self];
}

- (void)click {
    if (self.didClick) {
        self.didClick();
    }
}

@end

