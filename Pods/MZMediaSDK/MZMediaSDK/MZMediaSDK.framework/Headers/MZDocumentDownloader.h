//
//  MZDocumentDownloader.h
//  MZKitDemo
//
//  Created by 李风 on 2020/7/15.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZDocumentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MZDocumentDownloaderProgressDelegate <NSObject>
@optional
/// 下载进度更新
- (void)updateProgress:(CGFloat)downloadProgress documentID:(NSString *)documentID;
@end

@interface MZDocumentDownloader : NSObject

@property (nonatomic, assign) BOOL isDownLoading;//是否正在下载
@property (nonatomic,   copy) NSString *downLoadingDocID;//当前下载的文档ID
@property (nonatomic,   weak) id <MZDocumentDownloaderProgressDelegate> delegate;

+ (instancetype)shareDownLoadManager;

/**
 * @brief 下载文档
 *
 * @param url 文档下载地址
 * @param fileLocationStr 下载完成后保存的本地路径
 * @param document 文档模型
 * @param progress 进度回调
 * @param success 成功毁掉
 * @param failure 失败回调
 */
- (void)downLoadFileWithUrl:(NSString *)url
           fileLocationStr:(NSString *)fileLocationStr
                   document:(MZDocumentInfo *)document
                  progress:(void(^)(NSProgress *progress))progress
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure;

/// 获取下载的主路径
+ (NSString *)getRootPath;

/// 获取所有的下载文档
+ (NSMutableArray *)getCacheDocumentArray;

/// 获取某个ID的文档是否已经下载过了
+ (BOOL)getDocumentIsDownloadedWithDocumentId:(NSString *)documentId;

/// 添加下载文档到缓存plist中
+ (BOOL)addDownloadDocumentToPlist:(MZDocumentInfo *)document;

/// 添加代理接受事件
- (void)addDelegateWithTarget:(id)target;

/// 移除代理
- (void)removeDelegate;

@end

NS_ASSUME_NONNULL_END
