//
//  MZVoteHeaderView.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZVoteInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZVoteHeaderView : UIView

@property (nonatomic, strong) UILabel *voteInfoQuestion;//投票的问题

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *endTimeLabel;//结束时间的提示
@property (nonatomic, strong) UILabel *maxSelectLabel;//最大选项的提示

/// 实例化
- (instancetype)initWithVoteInfo:(MZVoteInfoModel *)voteInfo;

@end

NS_ASSUME_NONNULL_END
