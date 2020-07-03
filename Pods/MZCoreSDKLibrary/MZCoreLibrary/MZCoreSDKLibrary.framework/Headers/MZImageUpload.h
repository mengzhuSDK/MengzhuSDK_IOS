//
//  MZImageUpload.h
//  mengzhuIOS
//
//  Created by 孙显灏 on 2019/6/20.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#import "MZApiClient.h"

@interface MZImageUpload : MZApiClient
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
-(NSURLSessionDataTask *)uploadWithMultipartUploadPath:(NSString *)uploadPath
                                           imagesArray:(NSArray *)imagesArray
                                         andParameters:(NSDictionary *)parameters progress:(UploadProgress)progress
                                        withCompletion:(ApiCompletion)completion;
@end

