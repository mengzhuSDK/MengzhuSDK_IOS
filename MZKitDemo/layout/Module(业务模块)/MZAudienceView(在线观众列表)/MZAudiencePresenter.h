//
//  MZAudiencePresenter.h
//  MZKitDemo
//
//  Created by 李风 on 2020/7/13.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZAudiencePresenter : NSObject

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

NS_ASSUME_NONNULL_END
