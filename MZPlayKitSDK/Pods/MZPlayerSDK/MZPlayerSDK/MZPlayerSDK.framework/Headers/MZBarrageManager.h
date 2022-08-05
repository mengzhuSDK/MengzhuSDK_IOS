//
//  MZBarrageManager.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/11.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZBarrageManager : NSObject

@property (nonatomic, strong) NSBundle *privateBundle;

/**
 * @brief 打开展示弹幕功能
 *
 * @param view 弹幕展示的view
 */
+ (void)startWithView:(UIView *)view;

/**
 * @brief 发送弹幕
 *
 * @param message 消息内容，为空不发
 * @param userName 发消息的人的名字
 * @param avatar 发消息的人的头像地址
 * @param isMe 是否是自己发的消息
 * @param result 发送消息的结果回调
 *
 */
+ (void)sendBarrageWithMessage:(NSString *)message
                      userName:(NSString *)userName
                        avatar:(NSString *)avatar
                          isMe:(BOOL)isMe
                        result:(void(^)(BOOL isSuccess, NSError *error))result;

/**
 * @brief 销毁弹幕功能
 *
 */
+ (void)destory;

@end

NS_ASSUME_NONNULL_END
