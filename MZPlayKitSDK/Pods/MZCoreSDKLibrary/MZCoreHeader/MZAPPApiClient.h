//
//  MZAPPApiClient.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/8/22.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ApiCompletion)(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError* anError);
typedef void (^UploadProgress)(long long sent, long long expectSend);

@interface MZAPPApiClient : NSObject
+(id)sharedClient;

+(NSString *)addAtomUrlWithUrl;

/**
 *  @author Henry
 *
 *  基本post方法
 *
 *  @param aPath       路径
 *  @param parameters  参数
 *  @param aCompletion 回调
 *
 *  @return
 */
-(NSURLSessionDataTask *)postPath:(NSString *)aPath parameters:(NSDictionary *)parameters completion:(ApiCompletion)aCompletion;

/**
 *  @author Henry
 *
 *  基本get方法
 *
 *  @param aPath      路径
 *  @param parameters 参数
 *  @param completion 完成的回调
 *
 *  @return
 */
-(NSURLSessionDataTask *)getPath:(NSString *)aPath parameters:(NSDictionary *)parameters completion:(ApiCompletion)completion;

//仅用于处理请求失败时，查看返回的实际数据问题
+(NSString *)getReturnStringWithError:(NSError *)error;

//设置超时时间
- (void)setRequestTimeoutInterval:(double)time;

@end

NS_ASSUME_NONNULL_END
