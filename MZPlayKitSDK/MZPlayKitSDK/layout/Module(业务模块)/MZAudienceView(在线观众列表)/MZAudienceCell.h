//
//  MZAudienceCell.h
//  MZKitDemo
//
//  Created by 李风 on 2021/6/18.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZAudienceCell : UITableViewCell

@property (nonatomic, assign) NSInteger type;//type=0是在线观众 type=1是踢出管理 type=2是
@property (nonatomic, strong) UIImageView *headerView;//头像
@property (nonatomic, strong) UILabel *nameL;//名字
@property (nonatomic, strong) MZOnlineUserListModel *model;//用户模型

@property (nonatomic, strong) UIButton *kickoutButton;//踢出按钮
@property (nonatomic, strong) UIButton *unKickoutButton;//解除踢出按钮

@property (nonatomic, strong) UIButton *blockButton;//禁言按钮
@property (nonatomic, strong) UIButton *unBlockButton;//解除禁言按钮

- (void)setModel:(MZOnlineUserListModel *)model type:(NSInteger)type chatIdOfMe:(NSString *)chatIdOfMe isLiveHost:(BOOL)isLiveHost;

@end

NS_ASSUME_NONNULL_END
