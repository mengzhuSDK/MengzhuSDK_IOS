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
#import "MZLiveFinishModel.h"

@interface MZSDKBusinessManager : NSObject
/**
 * 获取主播信息
 *
 * @param ticketId 直播活动ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
 + (void)reqHostInfo:(NSString*)ticketId success:(void (^)(MZHostModel*  responseObject))success failure:(void (^)(NSError *error))failure;

/**
 * 视频详情
 *
 * @param ticketId 直播活动ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)reqPlayInfo:(NSString*)ticketId success:(void (^)(MZMoviePlayerModel*  responseObject))success failure:(void (^)(NSError *error))failure;

///**
// * 回放历史数据，请使用MZChatSDK里的 MZChatApiManager 类
// *
// * @param ticketId 直播活动ID
// * @param offset 数据获取偏移
// * @param limit 获取数据条数
// * @param last_id 获取的最后一条数据
// * @param success 成功回调
// * @param failure 失败原因回调
// */
//+(void)reqChatHistoryWith:(NSString *)ticketId  offset: (NSInteger)offset limit :(NSInteger)limit last_id:(NSString *)last_id success:(void(^)(NSMutableArray *responseObject))success failure:(void(^)(NSError * error))failure;

/**
 * 活动商品列表
 *
 * @param ticketId 直播活动ID
 * @param offset 数据获取偏移
 * @param limit 获取数据条数
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)reqGoodsList:(NSString *)ticketId offset : (NSInteger)offset limit :(NSInteger)limit success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;

/**
 * 获取在线用户
 *
 * @param ticketId 直播活动ID
 * @param offset 数据获取偏移
 * @param limit 获取数据条数
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)reqGetUserList:(NSString *)ticketId offset :(NSInteger)offset limit :(NSInteger)limit success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;

/**
 * 点赞
 *
 * @param ticketId 直播活动ID
 * @param channel_id 频道ID
 * @param praises 点赞次数
 * @param chat_uid 点赞用户的uid
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)reqPostPraise:(NSString *)ticketId channel_id:(NSString *)channel_id praises:(NSString *)praises chat_uid:(NSString *)chat_uid success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;

/**
 * 设置是否debug
 *
 * @param isDebug 是否debug
 */
+(void)setDebug:(BOOL)isDebug;

/**
 * 获取是否debug
 *
 */
+(BOOL)isDebug;

#pragma mark - 直播
/**
 * 开始直播
 *
 * @param username 用户名字
 * @param userAvatar 用户头像
 * @param uniqueId 用户唯一ID
 * @param ticketId 直播活动ID
 * @param live_tk 直播活动凭证
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)startLiveWithUsername:(NSString *)username userAvatar:(NSString *)userAvatar uniqueId:(NSString *)uniqueId ticketId:(NSString *)ticketId live_tk:(NSString *)live_tk success:(void(^)(id response))success failure:(void (^)(NSError *error))failure;

/// 兼容旧版本
+(void)startLiveWithUsername:(NSString *)username userAvatar:(NSString *)userAvatar userId:(NSString *)uniqueId ticketId:(NSString *)ticketId live_tk:(NSString *)live_tk success:(void(^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 * 结束直播
 *
 * @param channelId 频道ID
 * @param ticketId 直播活动ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)stopLive:(NSString *)channelId ticketId:(NSString *)ticketId success:(void(^)(MZLiveFinishModel * model))success failure:(void (^)(NSError *))failure;

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
/// 兼容旧版本
+(void)blockAllOrAlowChatWithChannelId:(NSString *)channelId ticketId:(NSString *)ticketId type:(BOOL)type success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 * 获取文档列表信息
 *
 * @param channelId 频道ID
 * @param ticketId 直播活动ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getDocumentListWithChannelId:(NSString *)channelId ticketId:(NSString *)ticketId success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 * 获取文档详情
 *
 * @param documentId 文档ID - 直播的时候文档ID为空
 * @param ticketId 直播活动ID
 * @param isLive 是否是直播
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getDocumentInfoWithDocumentId:(NSString *)documentId ticketId:(NSString *)ticketId isLive:(BOOL)isLive success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 * 获取文档下载信息
 *
 * @param channelId 频道ID
 * @param ticketId 直播活动ID
 * @param documentId 文档ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getDocumentURLStringWithChannelId:(NSString *)channelId ticketId:(NSString *)ticketId documentId:(NSString *)documentId success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 * 获取我下载的文档列表
 *
 * @param offset 偏移
 * @param limit  请求个数
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getMyDocumentListWithOffset:(NSInteger)offset limit:(NSInteger)limit success:(void(^)(NSMutableArray *responseObject))success failure:(void(^)(NSError * error))failure;

/**
 * 获取该活动的投票信息
 *
 * @param channelId 频道ID
 * @param ticketId 直播活动ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getVoteInfoWithChannelId:(NSString *)channelId ticketId:(NSString *)ticketId success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;


/**
 * 获取该投票的所有选项
 *
 * @param voteId 该场投票的ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getVoteOptionWithVoteId:(NSString *)voteId success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;


/**
 * 对该场投票进行投票操作
 *
 * @param ticketId 直播活动ID
 * @param voteId 该场投票的ID
 * @param optionId 选项ID，多选的话，每个选项的ID用逗号连接
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)goToVoteWithTicketId:(NSString *)ticketId voteId:(NSString *)voteId optionId:(NSString *)optionId success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 * 获取直播间的礼物列表
 *
 * @param ticketId 直播活动ID
 * @param offset 偏移
 * @param limit 请求条数个数
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getGiftListWithTicketId:(NSString *)ticketId offset:(NSInteger)offset limit:(NSInteger)limit success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 * 直播间礼物支付成功，通过消息服务器发送礼物购买成功的消息
 *
 * @param ticketId 直播活动ID
 * @param giftId 发送礼物ID
 * @param quantity 发送礼物个数
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)pushGiftWithTicketId:(NSString *)ticketId giftId:(NSString *)giftId quantity:(int)quantity success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

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
+(void)getDiscussListWithTicketId:(NSString *)ticketId isNewReply:(BOOL)isNewReply offset:(NSInteger)offset limit:(NSInteger)limit success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 * 提交问题
 *
 * @param ticketId 直播活动ID
 * @param content 提问问题
 * @param isAnonymous 是否匿名 0否 1是
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)submitDiscussWithTicketId:(NSString *)ticketId content:(NSString *)content isAnonymous:(BOOL)isAnonymous success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;


/// 获取活动的开屏广告信息
/// @param ticket_id 活动ID
/// @param success 成功回调
/// @param failure 失败原因回调
+(void)getVideoOpenAdMessageWithTicketID:(NSString *)ticket_id success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;
/**
 * 观看视频权限检测
 *
 * @param ticketId 直播活动Id
 * @param phone 用户手机号，选填参数，仅验证白名单使用
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)checkPlayPermissionWithTicketId:(NSString *)ticketId phone:(NSString *)phone success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 * 观看视频 使用F码
 *
 * @param ticketId 直播活动Id
 * @param fCode F码
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)useFCodeWithTicketId:(NSString *)ticketId fCode:(NSString *)fCode success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 * 获取活动视频广告
 *
 * @param ticketId 直播活动Id
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getVideoAdvertWithTicketId:(NSString *)ticketId success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 * 获取活动滚动广告
 *
 * @param ticketId 直播活动Id
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getRollAdvertWithTicketId:(NSString *)ticketId success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;


@end


