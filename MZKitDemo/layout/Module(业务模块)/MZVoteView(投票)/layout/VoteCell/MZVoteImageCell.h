//
//  MZVoteImageCell.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZVoteBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZVoteImageCell : MZVoteBaseCell

@property (nonatomic, strong) UIView *bgView;//背景View
@property (nonatomic, strong) UIImageView *voteImageView;//投票的该选项的图片
@property (nonatomic, strong) UILabel *titleLabel;//标题Label
@property (nonatomic, strong) UIButton *selectButton;//选择按钮
@property (nonatomic, strong) UILabel *voteNumberLabel;//该选项的投票数

@end

NS_ASSUME_NONNULL_END
