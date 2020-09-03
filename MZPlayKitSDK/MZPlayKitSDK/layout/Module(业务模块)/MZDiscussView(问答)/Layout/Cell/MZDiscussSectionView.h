//
//  MZDiscussSectionView.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDiscussModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZDiscussSectionView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *bgView;//背景View
@property (nonatomic, strong) UIImageView *avatarImageView;//头像
@property (nonatomic, strong) UILabel *nicknameLabel;//名字
@property (nonatomic, strong) UILabel *dateLabel;//时间
@property (nonatomic, strong) UILabel *questionLabel;//问题

- (void)update:(MZDiscussModel *)discussModel;

/// 获取section的高，内部默认缓存
+ (CGFloat)getSectionHeaderHeight:(MZDiscussModel *)discussModel;

@end

NS_ASSUME_NONNULL_END
