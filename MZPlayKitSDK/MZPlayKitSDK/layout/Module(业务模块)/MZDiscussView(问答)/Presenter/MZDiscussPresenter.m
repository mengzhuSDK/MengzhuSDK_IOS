//
//  MZDiscussPresenter.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/22.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZDiscussPresenter.h"

@implementation MZDiscussPresenter

/**
 * 获取问答列表
 *
 * @param ticketId 直播活动ID
 * @param isNewReply 是否查询最新未读回复 0:否 1:是
 * @param offset 偏移
 * @param limit 请求条数个数
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getDiscussListWithTicketId:(NSString *)ticketId isNewReply:(BOOL)isNewReply offset:(NSInteger)offset limit:(NSInteger)limit success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure {
    [MZSDKBusinessManager getDiscussListWithTicketId:ticketId isNewReply:isNewReply offset:offset limit:limit success:success failure:failure];
}

/**
 * 提交问题
 *
 * @param ticketId 直播活动ID
 * @param content 提问问题
 * @param isAnonymous 是否匿名 0否 1是
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)submitDiscussWithTicketId:(NSString *)ticketId content:(NSString *)content isAnonymous:(BOOL)isAnonymous success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure {
    [MZSDKBusinessManager submitDiscussWithTicketId:ticketId content:content isAnonymous:isAnonymous success:success failure:failure];
}

@end
