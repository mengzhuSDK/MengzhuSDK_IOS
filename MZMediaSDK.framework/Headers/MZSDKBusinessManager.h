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

@end


