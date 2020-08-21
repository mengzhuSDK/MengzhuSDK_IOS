//
//  MZVoteBaseCell.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZVoteInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZVoteBaseCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *normalImage;//未选中的图标
@property (nonatomic, strong) UIImage *selectImage;//选中的图标

@property (nonatomic, strong) UIColor *voteOfMeColor;//自己投票的颜色
@property (nonatomic, strong) UIColor *voteOfOtherColor;//别人投票的颜色

@property (nonatomic, strong) MZVoteOptionModel *optionModel;//投票选项Model

/**
 * @brief 根据数据源更新UI
 *
 * @param optionModel 选项的模型
 * @param voteSelectedIds 所有已选择的选项Id,可以为空
 * @param voteInfoModel 投票的model
 * @param selectChange 选中状态更改的
 *
 */
- (void)updateInfo:(MZVoteOptionModel *)optionModel voteSelectedIds:(NSMutableSet * _Nullable)voteSelectedIds voteInfo:(MZVoteInfoModel *)voteInfoModel;

@end

NS_ASSUME_NONNULL_END
