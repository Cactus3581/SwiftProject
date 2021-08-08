//
//  FeedScrollView.m
//  LarkFeed
//
//  Created by Ryan on 2021/3/29.
//

#import "FeedScrollView.h"

@interface FeedScrollView() <UIGestureRecognizerDelegate>
@end

@implementation FeedScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return _innterTableView.panGestureRecognizer == otherGestureRecognizer;
}

// 解决方案：将scroll的滑动事件，转化到当前tab下scrollView，从而实现滑动联动
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    return _innterTableView;
//}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (!self.contentOffsetDidChange) {
        super.contentOffset = contentOffset;
        return;
    }
    
    // API 调用
    if (!self.isDragging && !_innterTableView.isDragging) {
        super.contentOffset = contentOffset;
        return;
    }
    
    // 手势 调用
    CGPoint oldOffset = [self contentOffset];
    CGPoint newOffset = contentOffset;
    if (CGPointEqualToPoint(oldOffset, newOffset)) {
        return;
    }
    super.contentOffset = newOffset;
    BOOL shouldChange = self.contentOffsetDidChange(self, oldOffset, newOffset);
    if (shouldChange) {
        NSLog(@"阻尼效果-scroll-可滑动: oldY: %.2f, newY: %.2f", oldOffset.y, newOffset.y);
        return;
    }
    
    // 禁止滑动，维持原来的位置
    // 纠偏
    CGFloat y = oldOffset.y;
    CGFloat max = self.contentSize.height - self.bounds.size.height;
    if (y > max) {
        y = max;
    }
    NSLog(@"阻尼效果-scroll-不可滑动: oldY: %.2f, newY: %.2f", oldOffset.y, newOffset.y);
    super.contentOffset = CGPointMake(oldOffset.x, y);
}

@end


@interface FeedTableView() <UIGestureRecognizerDelegate>
@end

@implementation FeedTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return _outerScrollView.panGestureRecognizer == otherGestureRecognizer;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (!self.contentOffsetDidChange) {
        super.contentOffset = contentOffset;
        return;
    }
    
    // API 调用
    if (!self.isDragging && !_outerScrollView.isDragging) {
        super.contentOffset = contentOffset;
        return;
    }
    
    // 手势 调用
    CGPoint oldOffset = [self contentOffset];
    CGPoint newOffset = contentOffset;
    if (CGPointEqualToPoint(oldOffset, newOffset)) {
        return;
    }
    super.contentOffset = newOffset;
    BOOL shouldChange = self.contentOffsetDidChange(self, oldOffset, newOffset);
    if (shouldChange) {
        NSLog(@"阻尼效果-table-可滑动: oldY: %.2f, newY: %.2f", oldOffset.y, newOffset.y);
        return;
    }
    
    // 禁止滑动，维持原来的位置
    // 纠偏
    CGFloat y = oldOffset.y;
    CGFloat min = 0;
    if (y < min) {
        y = min;
    }
    NSLog(@"阻尼效果-table-不可滑动: oldOffset.y: %.2f, y: %.2f", oldOffset.y, y);
    super.contentOffset = CGPointMake(oldOffset.x, y);
}

@end
