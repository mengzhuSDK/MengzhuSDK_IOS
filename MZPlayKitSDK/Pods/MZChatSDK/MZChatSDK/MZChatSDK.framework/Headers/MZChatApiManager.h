//
//  MZChatApiManager.h
//  MZChatSDK
//
//  Created by LiWei on 2020/8/4.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

NS_ASSUME_NONNULL_BEGIN


@interface MZChatApiManager : NSObject

/// 是否是只看主播聊天信息，默认为NO
@property (nonatomic, assign) BOOL isOnlyHost;
/// 过滤条件 - 里面存的是需要过滤的用户ID，模版里传入主播ID和自己的ID，
/// 比如 @[@"1",@"3"],会把所有消息里用户ID为1或者3的消息摘出来，放到filterMessages里
/// 如果再添加新的过滤条件，已经过滤过的消息将不再二次过滤过滤
@property (nonatomic, strong) NSMutableSet <NSString *> *filterUserIds;

/// 所有的历史聊天消息数据源
@property (nonatomic, strong, readonly) NSMutableArray <MZLongPollDataModel *> *allMessages;
/// 过滤出来的消息数据源
@property (nonatomic, strong, readonly) NSMutableArray <MZLongPollDataModel *> *filterMessages;

/// 请求历史消息 - 会根据 isOnlyHost状态，filterUserIds过滤条件，返回最终显示的数据
/// @param ticketId 活动ID
/// @param offset 请求位置
/// @param limit 请求条数
/// @param last_id 最后一条消息的消息ID
/// @param success 成功返回
/// @param failure 错误返回
- (void)reqChatHistoryWith:(NSString *)ticketId offset:(NSInteger)offset limit:(NSInteger)limit last_id:(NSString *)last_id success:(void(^)(NSMutableArray *responseObject))success failure:(void(^)(NSError * error))failure;

/// 本地新添加一条聊天消息
/// @param message 新添加的一条消息
/// @param success 新消息添加后返回需要显示的所有消息
- (void)addMessage:(MZLongPollDataModel *)message success:(void(^)(NSMutableArray <MZLongPollDataModel *> *showMessages))success;

/// 本地新添加一条公告消息
/// @param notice 公告消息
/// @param success 新公告消息添加后返回需要显示的所有消息
- (void)addNotice:(MZLongPollDataModel *)notice success:(void(^)(NSMutableArray <MZLongPollDataModel *> *showMessages))success;

@end

NS_ASSUME_NONNULL_END
