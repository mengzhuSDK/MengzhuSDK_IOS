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
 */
+(void)test_createNewLiveWithLiveCover:(NSString *)liveCover liveName:(NSString *)liveName live_style:(int)live_style live_type:(int)live_type success:(void (^)(id))success failure:(void (^)(NSError *))failure;


+(void)test_createNewLiveWithLiveCover:(NSString *)liveCover liveName:(NSString *)liveName success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
