//
//  MZAudiencePresenter.m
//  MZKitDemo
//
//  Created by 李风 on 2020/7/13.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZAudiencePresenter.h"

@implementation MZAudiencePresenter

/**
 * @brief 获取直播间前50位观众
 *
 * @param ticket_id 活动凭证ID
 * @param chat_idOfMe 自己再直播间的ID
 */
+ (void)getOnlineUsersWithTicket_id:(NSString *)ticket_id
                        chat_idOfMe:(NSString *)chat_idOfMe
                           finished:(void(^)(NSArray <MZOnlineUserListModel *> *onlineUsers))finished
                             failed:(void (^)(NSString *))failed {

    __block NSString *meChatId =  chat_idOfMe;
    
    [MZSDKBusinessManager reqGetUserList:ticket_id offset:0 limit:50 success:^(NSArray* responseObject) {
        NSMutableArray *tempArr = responseObject.mutableCopy;
        
        BOOL isHasMe = NO;
        
        for (MZOnlineUserListModel* model in responseObject) {
            if(model.uid.longLongValue > 5000000000){//uid大于五十亿是游客
                [tempArr removeObject:model];
            }
            if ([model.uid isEqualToString:meChatId]) {
                isHasMe = YES;
            }
        }
        if (isHasMe == NO) {
            MZOnlineUserListModel *meModel = [[MZOnlineUserListModel alloc] init];
            
            MZUser *user = [MZBaseUserServer currentUser];
            
            meModel.nickname = user.nickName;
            meModel.avatar = user.avatar;
            meModel.uid = meChatId;
            meModel.unique_id = user.uniqueID;
            
            [tempArr addObject:meModel];
        }
        
        finished(tempArr);
    } failure:^(NSError *error) {
        failed(error.localizedDescription);
    }];
}

@end
