//
//  FeedScrollView.h
//  LarkFeed
//
//  Created by Ryan on 2021/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedScrollView : UIScrollView

@property(nullable, nonatomic, copy) BOOL (^contentOffsetDidChange)(UIScrollView*, CGPoint, CGPoint);
@property(nullable, nonatomic, weak) UITableView* innterTableView;

@end

@interface FeedTableView : UITableView

@property(nullable, nonatomic, copy) BOOL (^contentOffsetDidChange)(UIScrollView*, CGPoint, CGPoint);
@property(nullable, nonatomic, weak) UIScrollView* outerScrollView;

@end

NS_ASSUME_NONNULL_END
