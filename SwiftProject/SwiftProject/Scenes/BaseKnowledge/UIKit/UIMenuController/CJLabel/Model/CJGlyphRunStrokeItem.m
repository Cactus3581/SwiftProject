//
//  CJGlyphRunStrokeItem.m
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/23.
//  Copyright © 2020 cactus. All rights reserved.
//

#import "CJGlyphRunStrokeItem.h"

@implementation CJGlyphRunStrokeItem

- (id)copyWithZone:(NSZone *)zone {
    CJGlyphRunStrokeItem *item = [[[self class] allocWithZone:zone] init];
    item.fillColor = self.fillColor;
    item.strokeColor = self.strokeColor;
    item.activeFillColor = self.activeFillColor;
    item.activeStrokeColor = self.activeStrokeColor;
    item.strokeLineWidth = self.strokeLineWidth;
    item.cornerRadius = self.cornerRadius;
    item.runBounds = self.runBounds;
    item.locBounds = self.locBounds;
    item.withOutMergeBounds = self.withOutMergeBounds;
    item.runDescent = self.runDescent;
    item.runRef = self.runRef;

    item.insertView = self.insertView;
    item.isInsertView = self.isInsertView;
    item.range = self.range;
    item.parameter = self.parameter;
    item.lineVerticalLayout = self.lineVerticalLayout;
    item.isLink = self.isLink;
    item.needRedrawn = self.needRedrawn;
    item.linkBlock = self.linkBlock;
    item.longPressBlock = self.longPressBlock;
    item.characterIndex = self.characterIndex;
    item.characterRange = self.characterRange;
    item.strikethroughStyle = self.strikethroughStyle;
    item.strikethroughColor = self.strikethroughColor;
    return item;
}

@end
