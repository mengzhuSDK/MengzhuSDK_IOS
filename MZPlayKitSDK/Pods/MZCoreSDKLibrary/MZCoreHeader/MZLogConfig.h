//
//  MZLogConfig.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/11/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  自定义Log，可配置开关（用于替换NSLog）
 */
#define MZLog(format,...) MZ_CustomLog(__FUNCTION__,__LINE__,format,##__VA_ARGS__)

void MZ_CustomLog(const char *func, int lineNumber, NSString *format, ...);

@interface MZLogConfig : NSObject

/// 设置是否打印日志，默认关闭
+ (void)setLogEnable:(BOOL)logEnable;

/// 是否开启了 Log 输出
+ (BOOL)logEnable;

@end

NS_ASSUME_NONNULL_END
