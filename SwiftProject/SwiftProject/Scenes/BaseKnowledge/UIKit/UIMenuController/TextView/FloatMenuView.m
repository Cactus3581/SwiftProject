//
//  FloatMenuView.m
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/14.
//  Copyright © 2020 cactus. All rights reserved.
//

#import "FloatMenuView.h"

@interface FloatMenuView()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *button;

@end

static FloatMenuView *menuView = nil;

@implementation FloatMenuView

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
    self.userInteractionEnabled = true;
    UIImageView *imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@""]];
    _imageView = imageView;
    [self addSubview:imageView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button = button;
    button.backgroundColor = UIColor.greenColor;
    [button setTitle:@"Copy" forState:UIControlStateNormal];
    [self addSubview:button];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    [_button.titleLabel sizeToFit];
    _button.frame = self.bounds;
}

- (void)click {
    if (self.didClick) {
        self.didClick();
    }
}

@end
