//
//  MZGiftPresenter.m
//  MZKitDemo
//
//  Created by 李风 on 2020/9/3.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZGiftPresenter.h"

@implementation MZGiftPresenter

/**
 * 获取直播间的礼物列表
 *
 * @param ticketId 直播活动ID
 * @param offset 偏移
 * @param limit 请求条数个数
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getGiftListWithTicketId:(NSString *)ticketId offset:(NSInteger)offset limit:(NSInteger)limit success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure {
    [MZSDKBusinessManager getGiftListWithTicketId:ticketId offset:offset limit:limit success:success failure:failure];
}

/**
 * 直播间礼物支付成功，通过消息服务器发送礼物购买成功的消息
 *
 * @param ticketId 直播活动ID
 * @param giftId 发送礼物ID
 * @param quantity 发送礼物个数
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)pushGiftWithTicketId:(NSString *)ticketId giftId:(NSString *)giftId quantity:(int)quantity success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure {
    [MZSDKBusinessManager pushGiftWithTicketId:ticketId giftId:giftId quantity:quantity success:success failure:failure];
}

@end
