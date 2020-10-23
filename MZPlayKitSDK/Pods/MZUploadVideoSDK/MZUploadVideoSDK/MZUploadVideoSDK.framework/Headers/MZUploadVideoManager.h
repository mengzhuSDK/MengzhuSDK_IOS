//
//  MZUploadVideoManager.h
//  MZUploadVideoSDK
//
//  Created by 李风 on 2020/10/9.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MZUploadVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZUploadVideoManager : NSObject

/// 任务列表的数据源，内部会自动维护这套列表
@property (nonatomic, strong, readonly) NSMutableArray <MZUploadVideoModel *> *uploadModels;

@property (nonatomic, assign, readonly) NSInteger uploadingCount;//当前正在上传中的任务个数
@property (nonatomic, strong, readonly) AVAudioPlayer *player;//后台常驻音乐播放器，内部会根据下载状态自动播放和暂停

@property (nonatomic, assign) uint64_t partSize;//视频上传的时候，设置每一次传的part大小，单位byte，默认100kb，(1024 * 100)

+ (instancetype)shareInstanced;

/**
 生成上传任务
 
 @param videoFullPath 上传文件的本地索引路径，完整路径
 @param videoObjectKey 文件的唯一key，自定义，每次启动app后，文件地址更换后可以使用此key拼接完整的路径
 @param file_name 自定义的上传名字
 @param success success
 @param failure failure
 */
- (void)creatUploadTaskWithFullPath:(NSString *)videoFullPath
                     videoObjectKey:(NSString *)videoObjectKey
                          file_name:(NSString *)file_name
                            success:(void(^_Nullable)(MZUploadVideoModel *uploadVideoModel))success
                            failure:(void(^_Nullable)(NSError *error))failure;

/**
 开始/恢复上传任务（支持断点续传)
 
 @param uploadVideoModel 开始/恢复上传任务的模型
 */
- (void)resumeTask:(MZUploadVideoModel *)uploadVideoModel;

/**
 暂停上传任务
 */
- (void)pauseTask:(MZUploadVideoModel *)uploadVideoModel finish:(void(^)(void))finish;

/**
 取消/删除上传任务
 */
- (void)cancelTask:(MZUploadVideoModel *)uploadVideoModel finish:(void(^)(void))finish;

/**
 清空所有任务
 */
- (void)clearAllTasksFinish:(void(^)(void))finish;

@end

NS_ASSUME_NONNULL_END
