//
//  MZSocketIOClient.h
//  MengZhu
//
//  Created by vhall on 16/7/1.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZSocketIOClient : NSObject

/**
 * @brief 初始化Socket
 *
 * @param URLString 初始化的URL
 * @param token 监听消息的token
 * @param creatResult Socket创建成功回调
 *
 * @return self
 */
- (MZSocketIOClient *)initWithURLString:(NSString*)URLString socketToken:(NSString*)token creatResult:(void(^)(BOOL result))creatResult;

/**
 * @brief 发送事件
 *
 * @param event 事件名字/类型
 * @param content 事件内容
 */
- (void)sendSocketMessageWithEvent:(NSString *)event content:(NSArray *)content;

/**
 * @brief 关闭socket
 */
- (void)close;

@end
