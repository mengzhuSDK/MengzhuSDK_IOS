//
//  MZApiClient.h
//  MengZhu
//
//  Created by ZhangHeng on 15/5/22.
//  Copyright (c) 2015年 MengZhu. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "MZBaseNetModel.h"

typedef void(^ApiCompletion)(NSURLSessionDataTask *task, NSDictionary *aResponse, NSError* anError);
typedef void (^UploadProgress)(long long sent, long long expectSend);


@interface MZApiClient : AFHTTPSessionManager

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

/**
 *  @author Henry
 *
 *  带进度block的上传
 *
 *  @param path        相对路径
 *  @param paremeters  参数
 *  @param data        二进制数据
 *  @param name        数据名
 *  @param aCompletion 完成回调
 *  @param progress    进度跟踪block
 *
 *  @return
 */
-(NSURLSessionDataTask *)postPathForUpload:(NSString *)path
                             andParameters:(NSDictionary *)paremeters
                                   andData:(NSData *)data
                                 withName:(NSString *)name
                               andProgress:(UploadProgress)progress
                                completion:(ApiCompletion)aCompletion;


/**
 *  @author Henry
 *
 *  多表单上传图片
 *
 *  @param uploadPath  上传路径
 *  @param imagePaths  图片路径地址
 *  @param parameters 参数
 *  @param progress     进度回调
 *  @param completion 完成回调
 *
 *  @return
 */
-(NSURLSessionDataTask *)uploadWithMultipartFormsparam:(NSString *)uploadPath
                                             imageUrls:(NSArray *)imagePaths
                                         andParameters:(NSDictionary *)parameters
                                              progress:(UploadProgress)progress
                                        withCompletion:(ApiCompletion)completion;

//仅用于处理请求失败时，查看返回的实际数据问题
+(NSString *)getReturnStringWithError:(NSError *)error;

@end
