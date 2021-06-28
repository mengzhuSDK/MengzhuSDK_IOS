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
 * 获取当前频道有没有正在直播的活动
 *
 * @param channel_id 活动所属的频道ID，此ID从服务器获取或者找对接人员索要
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)getLiveInfoOfChannel:(NSString *)channel_id success:(void(^)(id responseData))success failure:(void(^)(NSError *error))failure;

/**
 * 创建直播活动接口 - 此接口建议只是测试使用，该接口返回需要的数据请从自己服务端获取
 *
 * @param channel_id 活动所属的频道ID，此ID从服务器获取或者找对接人员索要
 * @param liveCover 活动封皮地址
 * @param liveName 活动名字
 * @param liveIntroduction 活动简介
 * @param live_style 横屏还是竖屏 0-横屏 1-竖屏
 * @param live_type 语音还是视频直播，0-视频直播 1-语音直播
 * @param auto_record 是否生成回放 YES=生成 NO=不生成
 * @param view_mode 观看方式 0=免费，5=白名单观看，6=F码观看
 * @param white_id 观看方式为白名单时，填写服务器生成的白名单组的ID
 * @param fcode_id 观看方式为F码时，填写服务器生成的F码组的ID
 * @param pay_notice 非免费观看方式时，显示的提示语，eg. 视频设置了F码，请输入F码观看
 * @param category_id 直播所属的分类ID eg. 生活类
 * @param success 成功回调
 * @param failure 失败回调
 *
 */
+ (void)createNewLiveWithChannel_id:(NSString *)channel_id liveCover:(NSString *)liveCover liveName:(NSString *)liveName liveIntroduction:(NSString *)liveIntroduction live_style:(int)live_style live_type:(int)live_type auto_record:(BOOL)auto_record  view_mode:(int)view_mode white_id:(int)white_id fcode_id:(int)fcode_id pay_notice:(NSString *)pay_notice category_id:(int)category_id success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 * 获取分类列表
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)getCategoryListSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 获取F码列表
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)getFCodeListSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 创建F码分组
 * @param name F码分组名称
 * @param desc F码分组描述
 * @param num F码分组里的个数
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)createFCodeWithName:(NSString *)name desc:(NSString *)desc num:(int)num success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 删除F码分组
 * @param FCode_id F码分组ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)deleteFCodeWithFCode_id:(NSString *)FCode_id success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 添加F码
 * @param FCode_id F码分组ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)addFCodeWithFCode_id:(NSString *)FCode_id num:(int)num success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * F码未使用列表
 * @param FCode_id F码分组ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)getUnUseFCodeListWithFCode_id:(NSString *)FCode_id offset : (NSInteger)offset limit :(NSInteger)limit success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 获取白名单列表
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)getWhiteListSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 创建白名单分组
 * @param name 白名单分组名称
 * @param desc 白名单分组描述
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)createWhiteWithName:(NSString *)name desc:(NSString *)desc success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 白名单分组批量添加用户
 * @param whiteId 白名单分组ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)batchfAddUserWhiteWithWhiteId:(NSString *)whiteId phones:(NSString *)phones success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 删除白名单分组
 * @param whiteId 白名单分组ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)deleteWhiteWithWhiteId:(NSString *)whiteId success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 删除白名单分组里的某个用户
 * @param whiteId 白名单分组ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)deleteWhiteUserWithWhiteId:(NSString *)whiteId phone:(NSString *)phone success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 清空白名单分组里的所有用户
 * @param whiteId 白名单分组ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)clearWhiteUserWithWhiteId:(NSString *)whiteId success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 * 查询白名单用户列表
 * @param whiteId 白名单分组ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)getWhiteUserListWithWhiteId:(NSString *)whiteId offset : (NSInteger)offset limit :(NSInteger)limit success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

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

/**
 * 获取该活动配置详情
 *
 * @param ticketId 直播活动ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+ (void)getWebinarToolsList:(NSString *)ticketId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

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
 * 活动商品列表 - 带过滤条件
 *
 * @param ticketId 直播活动ID
 * @param offset 数据获取偏移
 * @param limit 获取数据条数
 * @param filter 过滤条件
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)reqGoodsList:(NSString *)ticketId offset : (NSInteger)offset limit :(NSInteger)limit filter:(NSDictionary *)filter success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;

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
 * 获取禁言列表
 *
 * @param ticketId 活动ID
 * @param channelId 频道ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getBlockUserListWithTicketId:(NSString *)ticketId channelId:(NSString *)channelId offset:(NSInteger)offset limit:(NSInteger)limit success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 * 查询用户禁言状态
 *
 * @param ticketId 活动ID
 * @param uid 需要查选的用户ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getUserBlockStateWithTicketId:(NSString *)ticketId uid:(NSString *)uid success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 * 获取踢出列表
 *
 * @param ticketId 活动ID
 * @param channelId 频道ID
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getKickoutUserListWithTicketId:(NSString *)ticketId channelId:(NSString *)channelId offset:(NSInteger)offset limit:(NSInteger)limit success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 * 踢出单个用户
 *
 * @param ticketId 直播活动ID
 * @param channelId 频道ID
 * @param uid 用户ID
 * @param isKickout 是否踢出用户 e.g YES=踢出，NO=解除踢出
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)kickoutUserWithTicketId:(NSString *)ticketId channelId:(NSString *)channelId uid:(NSString *)uid isKickout:(BOOL)isKickout success:(void (^)(id))success failure:(void (^)(NSError *))failure;

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

/**
 * 更新用户头像和昵称
 * @param unique_id 用户唯一ID
 * @param nickname 用户昵称
 * @param avatar 用户头像地址
 */
+ (void)updateUserInfoWithUnique_id:(NSString *)unique_id nickname:(NSString *)nickname avatar:(NSString *)avatar success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 * 创建红包
 *
 * @param unique_id 用户唯一ID
 * @param pay_method 支付方式
 * @param amount 红包金额
 * @param quantity 红包个数
 * @param mode 红包方式 1-随机 2-固定
 * @param ticket_id 活动ID
 * @param channel_id 频道ID
 * @param slogan 红包留言
 *
 */
+ (void)createRedPackageWithUnique_id:(NSString *)unique_id pay_method:(NSString *)pay_method amount:(NSString *)amount quantity:(NSString *)quantity mode:(int)mode ticket_id:(NSString *)ticket_id channel_id:(NSString *)channel_id slogan:(NSString *)slogan success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 * 红包领取记录
 *
 * @param unique_id 用户唯一ID
 * @param bonus_id 红包ID
 * @param offset 偏移
 * @param limit 个数
 *
 */
+ (void)getBonusDrawListWithUnique_id:(NSString *)unique_id bonus_id:(NSString *)bonus_id offset:(NSInteger)offset limit:(NSInteger)limit success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 * 查询红包状态
 *
 * @param unique_id 用户唯一ID
 * @param bonus_id 红包ID
 *
 */
+ (void)getCheckBonusWithUnique_id:(NSString *)unique_id bonus_id:(NSString *)bonus_id success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 * 领取红包
 *
 * @param unique_id 用户唯一ID
 * @param bonus_id 红包ID
 *
 */
+ (void)obtainBonusWithUnique_id:(NSString *)unique_id bonus_id:(NSString *)bonus_id success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end


