//
//  MZFileManager.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/9/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZFileManager : NSObject

/// 获取文件句柄
+ (NSFileManager *)fileManager;

/// 创建文件夹
+ (NSString *)createDirectoryAtPath:(NSString *)path;

/// 获取文件下的目录
+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path;

/// 文件\文件夹是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path;

/// 删除文件\文件夹
+ (BOOL)removeItemAtPath:(NSString *)path;

/// 复制文件到另一个目录
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)dstPath;

/// 移动文件到另一个目录
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

/// 获取文件\文件夹属性
+ (NSDictionary *)fileAttributesOfItemAtPath:(NSString *)path;

/// 获取文件内容
+ (NSData *)contentsAtPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
