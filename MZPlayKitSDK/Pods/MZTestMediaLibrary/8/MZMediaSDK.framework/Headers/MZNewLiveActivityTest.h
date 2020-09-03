//
//  MZNewLiveActivityTest.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/4/29.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZNewLiveActivityTest : NSObject
/**
 * @brief 该接口只是用于测试使用，正式环境下请不要使用此接口。
 *
 * @param liveCover 活动封皮地址
 * @param liveName 活动名字
 * @param live_style 横屏还是竖屏 0-横屏 1-竖屏
 * @param live_type 语音还是视频直播，0-视频直播 1-语音直播
 * @param success 成功回调
 * @param failure 失败回调
 * 
 */
+(void)test_createNewLiveWithLiveCover:(NSString *)liveCover liveName:(NSString *)liveName live_style:(int)live_style live_type:(int)live_type success:(void (^)(id))success failure:(void (^)(NSError *))failure;


+(void)test_createNewLiveWithLiveCover:(NSString *)liveCover liveName:(NSString *)liveName success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
