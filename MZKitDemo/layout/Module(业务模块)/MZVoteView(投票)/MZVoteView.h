//
//  MZVoteView.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTopMenuView.h"
#import "MZVoteHeaderView.h"
#import "MZVoteBaseCell.h"
#import "MZVoteImageCell.h"
#import "MZVoteTextCell.h"
#import "MZVoteInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZVoteView : UIView

@property (nonatomic, strong) UIView *bgView;//背景View
@property (nonatomic, strong) MZVoteHeaderView *voteHeaderView;//collectionView的tableHeaderView
@property (nonatomic, strong) UICollectionView *collectionView;//collectionView

@property (nonatomic, strong) MZTopMenuView *topMenuView;//顶部标题栏
@property (nonatomic, strong) UIButton *voteButton;//投票按钮

/**
 * @brief 初始化
 * @param closeHandler 关闭的回调
 * @return self
 *
 */
- (instancetype)initWithCloseHander:(void(^)(void))closeHandler;

/**
 * @brief 展示投票页面
 *
 * @param channelId 频道ID
 * @param ticketId 活动ID
 */
- (void)showWithChannelId:(NSString *)channelId ticketId:(NSString *)ticketId;

@end

NS_ASSUME_NONNULL_END
