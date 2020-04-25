//
//  CJLabelLinkModel.m
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/23.
//  Copyright © 2020 cactus. All rights reserved.
//

#import "CJLabelLinkModel.h"
#import "CJLabel.h"

@implementation CJLabelLinkModel

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString
                              insertView:(id)insertView
                          insertViewRect:(CGRect)insertViewRect
                               parameter:(id)parameter
                               linkRange:(NSRange)linkRange
                                   label:(CJLabel *)label {
    self = [super init];
    if (self) {
        _attributedString = attributedString;
        if ([insertView isKindOfClass:[UIView class]]) {
            _insertView = [(UIView *)insertView viewWithTag:[kCJInsertViewTag hash]];
        }else {
            _insertView = insertView;
        }
        _insertViewRect = insertViewRect;
        _parameter = parameter;
        _linkRange = linkRange;
        _label = label;
    }
    return self;
}

@end


@implementation CJCTRunUrl

@end
