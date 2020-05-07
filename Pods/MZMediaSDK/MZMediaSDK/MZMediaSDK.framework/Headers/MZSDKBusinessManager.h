//
//  MZSDKBusinessManager.h
//  MZMediaSDK
//
//  Created by 孙显灏 on 2019/9/24.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZMoviePlayerModel.h"
#import "MZHostModel.h"
#import "MZShareModel.h"
#import "MZLiveFinishModel.h"

@interface MZSDKBusinessManager : NSObject
//获取主播信息
+ (void)reqHostInfo:(NSString*)ticketId success:(void (^)(MZHostModel*  responseObject))success failure:(void (^)(NSError *error))failure;
//视频详情
+ (void)reqPlayInfo:(NSString*)ticketId success:(void (^)(MZMoviePlayerModel*  responseObject))success failure:(void (^)(NSError *error))failure;

//回放历史数据
+(void)reqChatHistoryWith :(NSString *)ticketId  offset : (NSInteger)offset limit :(NSInteger)limit last_id:(NSString *)last_id success:(void(^)(NSMutableArray *responseObject))success failure:(void(^)(NSError * error))failure;
//活动商品列表
+(void)reqGoodsList:(NSString *)ticketId offset : (NSInteger)offset limit :(NSInteger)limit success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;
//获取在线用户
+(void)reqGetUserList:(NSString *)ticketId offset :(NSInteger)offset limit :(NSInteger)limit success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;
//点赞
+(void)reqPostPraise:(NSString *)ticketId channel_id:(NSString *)channel_id praises:(NSString *)praises chat_uid:(NSString *)chat_uid success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;

+(void)setDebug:(BOOL)isDebug;

+(BOOL)isDebug;

#pragma mark - 直播
/**
 * 开始直播
 *
 * @param username 用户名字
 * @param userAvatar 用户头像
 * @param userId 用户ID
 * @param ticketId 直播活动ID
 * @param live_tk 直播活动凭证
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)startLiveWithUsername:(NSString *)username userAvatar:(NSString *)userAvatar userId:(NSString *)userId ticketId:(NSString *)ticketId live_tk:(NSString *)live_tk success:(void(^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 * 结束直播
 *
 * @param channelId 频道ID
 * @param ticketId 直播活动ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)stopLive:(NSString *)channelId ticketId:(NSString *)ticketId success:(void(^)(MZLiveFinishModel * model))success failure:(void (^)(NSError *))failure;

/**
 * 禁言单个用户
 *
 * @param ticketId 直播活动ID
 * @param uid 用户ID
 * @param isBanned 是否开启禁言 e.g YES=开启，NO=关闭
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)bannedOrUnBannedUserWithTicketId:(NSString *)ticketId uid:(NSString *)uid isBanned:(BOOL)isBanned success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 * 聊天室里是否可以聊天
 *
 * @param channelId 频道ID
 * @param ticketId 直播活动ID
 * @param isChat 是否可以聊天 e.g YES=可以，NO=不可以
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)blockAllOrAlowChatWithChannelId:(NSString *)channelId ticketId:(NSString *)ticketId isChat:(BOOL)isChat success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

@end


