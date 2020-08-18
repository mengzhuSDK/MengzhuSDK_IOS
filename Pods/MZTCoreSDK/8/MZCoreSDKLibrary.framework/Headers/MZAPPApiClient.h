//
//  MZAPPApiClient.h
//  mengzhuIOS
//
//  Created by 孙显灏 on 2019/6/20.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "MZBaseStatisticsStystem.h"

typedef void(^ApiCompletion)(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError* anError);
typedef void (^UploadProgress)(long long sent, long long expectSend);

@interface MZAPPApiClient  : AFHTTPSessionManager
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
@end
