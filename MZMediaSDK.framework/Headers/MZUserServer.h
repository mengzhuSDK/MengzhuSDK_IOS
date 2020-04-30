//
//  MZUserServer.h
//  MengZhu
//
//  Created by vhall.com on 16/6/15.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZAPIManager.h"

#import "MZMyselfListModel.h"
#import "MZHomeCenterModel.h"
#import "MZBlackListModel.h"
#import "MZUser.h"
@interface MZUserServer : NSObject

//当前用户在活动中的角色
+(UserRoleType)currentUserRoleInActivity:(NSString *)roleName;

//获取当前用户
+(MZUser *)currentUser;

+(void)signOutCurrentUser;
/*!
 更新用户登录信息
 */
+(void)updateCurrentUser:(MZUser *)userItem;



/**
 *  获取当前用户基本信息
 */
+(void)getCurrentUserProfileSuccess:(void(^)())success failure:(void (^)(NSError *error))failure;

/**
 *  修改用户基本信息
 */
+(void)modifyCurrentUserInfo:(NSDictionary *)parama success:(void(^)())success failure:(void (^)(NSError *error))failure;




@end

