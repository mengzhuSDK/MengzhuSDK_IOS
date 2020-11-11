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

/// 实例化SDK，旧版本，不建议使用
- (void)initSDK:(void (^)(id responseObject))success failure:(void(^)(NSError*error))failure;

/// 实例化SDK，推荐使用
/// @param appID 分配的appID
/// @param secretKey 分配的secretKey
/// @param isTestServer 是否使用SDK的测试服务器，默认为NO，一般都是使用SDK的正式服务器
/// @param success SDK初始化成功回调
/// @param failure SDK初始化失败回调
- (void)initSDKWithAppID:(NSString *)appID
            appSecretKey:(NSString *)secretKey
            isTestServer:(BOOL)isTestServer
                 success:(void(^ _Nullable)(void))success
                 failure:(void(^ _Nullable)(NSError * _Nullable error))failure;

/// 设置是否打印日志，默认关闭
+ (void)setLogEnable:(BOOL)logEnable;


@end

