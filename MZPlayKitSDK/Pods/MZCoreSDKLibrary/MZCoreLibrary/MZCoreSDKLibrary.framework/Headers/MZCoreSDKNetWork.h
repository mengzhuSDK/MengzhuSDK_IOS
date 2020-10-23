//
//  MZCoreSDKNetWork.h
//  MZCoreSDKLibrary
//
//  Created by LiWei on 2020/9/9.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


static BOOL isDebugs;//是否是测试服务器
static NSString *sdk_appID;//SDK的appID
static NSString *sdk_secretKey;//SDK的secretKey
static NSString *mBusinessPrefix;
static NSString *mPrefix;

@interface MZCoreSDKNetWork : NSObject

+(void)setDebug:(BOOL)isDebug;
+(BOOL)isDebug;

+(void)setAppID:(NSString *)appID;
+(NSString *)appID;

+(void)setSecretKey:(NSString *)secretKey;
+(NSString *)secretKey;

+(NSString *)getPrefix;

+(NSString *)getBusinessPrefix;
//暂时先在这里设置，后续还需要整理
+(NSString *)getNetWatchChatHistory;

@end



