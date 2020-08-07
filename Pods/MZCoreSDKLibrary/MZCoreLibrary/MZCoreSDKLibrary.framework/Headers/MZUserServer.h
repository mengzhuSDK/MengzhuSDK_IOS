//
//  MZUserServer.h
//  MengZhu
//
//  Created by vhall.com on 16/6/15.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZAPIManager.h"
#import "MZUser.h"
#import "MZActivityConfig.h"
@interface MZUserServer : NSObject

/// 当前用户在活动中的角色
+(UserRoleType)currentUserRoleInActivity:(NSString *)roleName;

/// 获取当前用户
+(MZUser *)currentUser;

/// 退出登录用户（自动）
+(void)signOutCurrentUser;

/// 更新用户登录信息
+(void)updateCurrentUser:(MZUser *)userItem;

/// 获取缓存的LoginToken
+(NSString *)getLoginTokenWithUniqueId:(NSString *)uniqueId;

/// 缓存LoginToken
+(BOOL)saveLoginToken:(NSString *)loginToken uniqueId:(NSString *)uniqueId;

/// 移除掉LoginToken
+(BOOL)removeLoginTokenWithUniqueId:(NSString *)uniqueId;

@end

