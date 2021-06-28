//
//  MZAudienceView.h
//  MengZhu
//
//  Created by vhall on 16/6/24.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZBaseView.h"

/// 在线观众列表View
@interface MZAudienceView : MZBaseView

@property (nonatomic, strong) UIView *bgView;//背景View

@property (nonatomic, strong) UITableView *tableView;//tableView

/**
 * @brief 实例化在线观众列表的View
 *
 * @param frame frame
 * @param ticket_id 活动凭证ID
 * @param channel_id 频道ID
 * @param chat_idOfMe 我自己在聊天服务器里的ID
 * @param isLiveHost 是否是主播直播端
 * @param selectUserHandle 选择了其中一个观众的回调
 * @param closeHandle 关闭界面的回调
 */
- (instancetype)initWithFrame:(CGRect)frame
                    ticket_id:(NSString *)ticket_id
                   channel_id:(NSString *)channel_id
                  chat_idOfMe:(NSString *)chat_idOfMe
                   isLiveHost:(BOOL)isLiveHost
             selectUserHandle:(void(^)(MZOnlineUserListModel *userModel))selectUserHandle
                  closeHandle:(void(^)(void))closeHandle;


/**
 * @brief 获取直播间前50位观众,用于显示右上侧的在线人头列表
 *
 * @param ticket_id 活动凭证ID
 * @param chat_idOfMe 自己再直播间的ID
 */
+ (void)getOnlineUsersWithTicket_id:(NSString *)ticket_id
                        chat_idOfMe:(NSString *)chat_idOfMe
                           finished:(void(^)(NSArray <MZOnlineUserListModel *> *onlineUsers))finished
                             failed:(void(^)(NSString *errorString))failed;

@end
