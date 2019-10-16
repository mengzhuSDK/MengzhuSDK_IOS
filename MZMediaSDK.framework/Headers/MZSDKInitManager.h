//
//  MZSDKInitManager.h
//  MZMediaSDK
//
//  Created by 孙显灏 on 2018/10/30.
//  Copyright © 2018 孙显灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MZ_ONLINE_TYPE 0
#define MZ_TEST_TYPE 1
#define MZ_DEV_TYPE 2

@interface MZSDKInitManager : NSObject
@property(nonatomic,readonly) NSString* errorMsg;
@property(nonatomic,readonly) NSString* errorCode;
@property(nonatomic,readonly) BOOL isPassValidation;
+ (MZSDKInitManager *)sharedManager;
-(void)initSDK:(void (^)(id responseObject))success failure:(void(^)(NSError*error))failure;

@end

