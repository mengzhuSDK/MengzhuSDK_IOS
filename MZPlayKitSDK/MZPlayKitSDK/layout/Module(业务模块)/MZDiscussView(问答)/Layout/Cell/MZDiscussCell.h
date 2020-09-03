//
//  MZDiscussCell.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDiscussModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZDiscussCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;//背景View
@property (nonatomic, strong) UILabel *replyLabel;//回复label

- (void)update:(MZDiscussReplyModel *)reply;

/// 获取cell的高，内部默认缓存
+ (CGFloat)getRowHeight:(MZDiscussReplyModel *)reply;

@end

NS_ASSUME_NONNULL_END
