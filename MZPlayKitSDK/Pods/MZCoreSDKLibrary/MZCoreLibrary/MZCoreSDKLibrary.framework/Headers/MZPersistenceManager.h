//
//  MZPersistenceManager.h
//  MengZhu
//
//  Created by vhall on 16/6/30.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZUser;

@interface MZPersistenceManager : NSObject

/*!
 持久化当前用户，登录时sign为yes，退出时sign为no
 */
+(void)persistenceUser:(MZUser*)currentUser signIn:(BOOL)sign;
/*!
 返回持久化的已登录用户
 */
+(MZUser*)getPersistentUser;
/*!
 获取化当前用户ukey
 */
+(void)persistenceSid:(NSString*)sid;
/*!
 获取ukey
 */
+(NSString*)getPersistenceSid;
@end
