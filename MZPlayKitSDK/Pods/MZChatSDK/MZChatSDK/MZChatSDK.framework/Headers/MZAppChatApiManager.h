//
//  MZAppChatApiManager.h
//  MZChatSDK
//
//  Created by 李风 on 2020/9/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZAppChatApiManager : NSObject

//回放历史数据
+(void)requestWatchChatHistoryWithTicket_id:(NSString *)ticketId  offset: (NSInteger)offset limit:(NSInteger)limit last_id:(NSString *)last_id success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
