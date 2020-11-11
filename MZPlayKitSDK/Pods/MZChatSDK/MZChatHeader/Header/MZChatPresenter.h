//
//  MZChatPresenter.h
//  MZChatSDK
//
//  Created by LiWei on 2020/8/4.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZChatPresenter : NSObject
//获取历史消息
+(void)getHistoryChatHistoryWithTicket_id:(NSString *)ticket_id offset:(int)offset limit:(int)limit last_id:(NSString *)last_id tableDataArr:(NSMutableArray *)tableDataArr resultCallBack:(void (^)(NSMutableArray *dataArr,NSError *error))resultCallBack;

@end

NS_ASSUME_NONNULL_END
