//
//  MZBaseUserServer.h
//  MengZhu
//
//  Created by vhall.com on 16/6/15.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZActivityConfig.h"
#import "MZUser.h"

@interface MZBaseUserServer : NSObject

//当前用户在活动中的角色
+(UserRoleType)currentUserRoleInActivity:(NSString *)roleName;

//获取当前用户
+(MZUser *)currentUser;

+(void)signOutCurrentUser;
/*!
 更新用户登录信息
 */
+(void)updateCurrentUser:(MZUser *)userItem;

/// 获取缓存的LoginToken
+(NSString *)getLoginTokenWithUniqueId:(NSString *)uniqueId;

/// 缓存LoginToken
+(BOOL)saveLoginToken:(NSString *)loginToken uniqueId:(NSString *)uniqueId;

/// 移除掉LoginToken
+(BOOL)removeLoginTokenWithUniqueId:(NSString *)uniqueId;


/**
 *  获取当前用户基本信息
 */
+(void)getCurrentUserProfileSuccess:(void(^)(void))success failure:(void (^)(NSError *error))failure;

///**
// *  修改用户基本信息
// */
//+(void)modifyCurrentUserInfo:(NSDictionary *)parama success:(void(^)(void))success failure:(void (^)(NSError *error))failure;

//是否登录
+(BOOL)isSignIn;

+(void)saveUserMessageToPlistWithUid:(NSString *)uid dic:(NSDictionary *)dictionary;
@end

