//
//  MZLiveAudienceHeaderView.h
//  MengZhuPush
//
//  Created by LiWei on 2019/9/24.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface MZLiveAudienceHeaderView : UIView

@property (nonatomic, strong) NSArray *userArr;//展示头像的几个数据源

@property (nonatomic, strong) void(^clickBlock)(void);

/// 更新当前总在线人数
- (void)updateOnlineUserTotalCount:(int)count;

@end

NS_ASSUME_NONNULL_END
