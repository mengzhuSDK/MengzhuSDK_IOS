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
+(void)test_createNewLiveWithLiveCover:(NSString *)liveCover liveName:(NSString *)liveName success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END
