//
//  MZDownLoadManager.h
//  MengZhu
//
//  Created by 李伟 on 2018/9/12.
//  Copyright © 2018年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownloadProgressBlock)(NSProgress *downloadProgress);

@interface MZDownLoadManager : NSObject

@property (nonatomic,assign) BOOL isDownLoading;
@property (nonatomic,copy) NSString *downLoadingDocID;
@property (nonatomic,copy) DownloadProgressBlock progressBlock;
+(instancetype)shareDownLoadManager;

-(void)downLoadFileWithUrl:(NSString *)url fileLocationStr:(NSString *)fileLocationStr docID:(NSString *)docID progress:(void(^)(NSProgress *progress))progress success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end
