//
//  MZDownLoaderCenter.h
//  批量下载和m3u8批量下载
//
//  Created by 李风 on 2020/3/23.
//  Copyright © 2020 李风. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

typedef enum : NSUInteger {
    MZDownLoaderState_Wait = 0,//等待
    MZDownLoaderState_Downloading,//下载
    MZDownLoaderState_Pause,//暂停
    MZDownLoaderState_Finish,//完成
    MZDownLoaderState_Fail,//失败
    MZDownLoaderState_Stop,//停止
} MZDownLoaderState;

NS_ASSUME_NONNULL_BEGIN

@class MZDownLoader;
@protocol MZDownLoaderDelegate <NSObject>
@optional
/**
 单个任务下载成功
 */
-(void)downloaderFinished:(MZDownLoader *)download;
/**
 单个任务下载失败
 */
-(void)downloaderFailed:(MZDownLoader *)download;
/**
 单个任务的下载进度
 */
-(void)downloader:(MZDownLoader *)download Progress:(double)progess;
/**
 单个任务下载开始/继续
 */
- (void)downloaderStart:(MZDownLoader *)download;
/**
 单个任务下载暂停
 */
- (void)downloaderPause:(MZDownLoader *)download;
@end



@interface MZDownLoaderCenter : NSObject

+ (instancetype)shareInstanced;

/**
 设置打印log
 
 @param isEnable 是否打印log
 */
- (void)setLogEnable:(BOOL)isEnable;

/**
 设置同时下载最大任务数（建议为2,默认为2）
 
 @param maxCount 最大同时下载任务数
 */
- (void)setTaskMaxCount:(NSInteger)maxCount;

/**
 添加下载任务
 
 @param url 下载地址
 */
- (void)addDownloadWithM3u8URL:(NSURL *)url completeBlock:(void (^)(MZDownLoader *downloader, NSString *errorString))completeBlock;

/**
 通过下载链接，获取下载模型
 
 @param url 下载地址
 @return MZDownLoader
 */
- (MZDownLoader * _Nullable)getDownLoader:(NSURL *)url;

/**
 开始所有的任务
 */
- (void)startAll;
/**
 开始/继续单一任务
 
 @param loader 任务模型
 */
- (BOOL)start:(MZDownLoader *)loader;

/**
 暂停所有的任务
 */
- (void)pauseAll;
/**
 暂停单一任务
 
 @param loader 任务模型
 */
- (void)pause:(MZDownLoader *)loader;

/**
 取消所有的任务，删除不可恢复
 */
- (void)cancelAll;
/**
 取消单一任务，，删除不可恢复
 
 @param loader 任务模型
 */
- (void)cancel:(MZDownLoader *)loader;

/**
 给某个任务添加代理
 
 @param target 接受代理的target
 @param loader 任务模型
 */
- (void)addDelegateWithTarget:(id)target loader:(MZDownLoader *)loader;
/**
 给某个任务移除代理
 
 @param loader 任务模型
 */
- (void)removeDelegateWithLoader:(MZDownLoader *)loader;

/**
 获取某个任务的状态
 
 @param loader 任务模型
 @return MZDownLoaderState
 */
- (MZDownLoaderState)getTaskState:(MZDownLoader *)loader;

/**
 获取某个任务的大小（只有下载完成才会获取到）
 
 @param loader 任务模型
 @return 文件大小字符串 eg. 3.5M
 */
- (NSString *)getFileSize:(MZDownLoader *)loader;

/**
 获取某个任务的m3u8的下载地址
 
 @param loader 任务模型
 */
- (NSString *)getTaskM3U8DownLoadURLString:(MZDownLoader *)loader;

/**
 获取某个任务的当前缓存进度
 
 @param loader 任务模型
 */
- (double)getTaskCacheProgress:(MZDownLoader *)loader;

/**
 获取本地的m3u8文件的播放地址
 
 @param loader 任务模型
 */
- (void)getLocalPlayM3U8URLString:(MZDownLoader *)loader handle:(void(^)(NSString *m3u8URLString, NSString *errorString))handle;

/**
 获取全部任务
 */
- (NSMutableArray <MZDownLoader *>*)getAllTask;

/**
 获取所有未完成的下载任务
 
 @return 返回模型列表，为空则返回空
 */
- (NSMutableArray <MZDownLoader *>*)getAllNotCompleteTask;

/**
 获取所有已完成的下载任务
 
 @return 返回模型列表，为空则返回空
 */
- (NSMutableArray <MZDownLoader *>*)getAllCompleteTask;

/**
 获取所有执行中的任务
 
 @return 返回模型列表，为空则返回空
 */
- (NSMutableArray <MZDownLoader *>*)getAllDownLoadingTask;

/**
 分页获取所有已经完成的任务
 
 @param page 当前页，不能小于1
 @param number 每页数量，不能小于1
 @return 返回模型列表，为空则返回空
 */
- (NSMutableArray <MZDownLoader *>*)getAllCompleteTaskWithPage:(NSInteger)page number:(NSInteger)number;

/**
 分页获取所有未完成的普通任务
 
 @param page 当前页，不能小于1
 @param number 每页数量，不能小于1
 @return 返回模型列表，为空则返回空
 */
- (NSMutableArray <MZDownLoader *>*)getAllNotCompleteTaskWithPage:(NSInteger)page number:(NSInteger)number;

/**
 分页获取所有下载任务
 
 @param page 当前页，不能小于1
 @param number 每页数量，不能小于1
 @return 返回模型列表，为空则返回空
 */
- (NSMutableArray <MZDownLoader *>*)getAllTaskWithPage:(NSInteger)page number:(NSInteger)number;

/**
 下载任务是否存在
 @param url 下载地址
 @return bool
 */
- (BOOL)taskExits:(NSURL *)url;

/**
 获取所有正在下载的线程
 */
- (NSMutableArray *)getAllQueue;

@end

NS_ASSUME_NONNULL_END
