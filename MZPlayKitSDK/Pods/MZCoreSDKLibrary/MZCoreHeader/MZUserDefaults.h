//
//  MZUserDefaults.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/9/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZUserDefaults : NSObject

/// 获取句柄
+ (NSUserDefaults *)standardUserDefaults;

/// 增加缓存到NSUserDefaults
+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName;
+ (void)setValue:(nullable id)value forKey:(NSString *)defaultName;

/// 获取缓存从NSUserDefaults
+ (nullable id)objectForKey:(NSString *)defaultName;
+ (nullable id)valueForKey:(NSString *)defaultName;

/// 清空缓存从NSUserDefaults
+ (void)removeObjectForKey:(NSString *)defaultName;

@end

NS_ASSUME_NONNULL_END
