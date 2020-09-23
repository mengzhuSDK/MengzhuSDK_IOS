//
//  MZLongPolling.h
//  MengZhu
//
//  Created by vhall on 16/7/1.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MZLongPolling;
@protocol MZLongPollingDelegate <NSObject>
-(void)longPolling:(MZLongPolling*)lp getNewMsgs:(NSArray*)msgs;
@end

typedef void (^MZLongPollingBlock) (NSArray *msgArr);

@interface MZLongPolling : NSObject
//只允许一个房间接受消息
+ (MZLongPolling*)StartLongPollingUrl:(NSString*)url Block:(MZLongPollingBlock)block;
+ (void)CloseLongPolling;
//发送聊天消息(直播）
+ (void)sendMsg:(NSString*)msg host:(NSString*)host token:(NSString*)token isBarrage:(BOOL)isBarrage success:(void(^)())success failure:(void(^)(NSError*error))failure;

//新方法
+ (MZLongPolling*)StartLongPollingUrl:(NSString*)url delegate:(id<MZLongPollingDelegate>)delegate;
- (void)stopLongPolling;
@end
