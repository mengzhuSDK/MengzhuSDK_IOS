//
//  MZCoreSDKNetWork.h
//  MZCoreSDKLibrary
//
//  Created by LiWei on 2020/9/9.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

//提审时注释掉⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
#define TEST_SERVER //使用测试服务器
//提审时注释掉⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️

//////////////////////////////////////////////////////////////
#ifndef TEST_SERVER

#define MZNET_SERVICEURL    @"https://api-app.zmengzhu.com/service/info?"

//正式环境
#define MZ_URL_Prefix       @"https://api.zmengzhu.com"
#define MZ_Shopping_Center_URL_Prefix  @"https://s1.zmengzhu.com"
#define MZBusinessPrefixUrl       @"/business/v1"
#define MZNET_SECRETKEY     @"oWAvpi9xzqnoJzrJWuHf5pfUrlRk30vBxFaoI2dn80F5IgoG9ynXr9qVLUYP06oR"
#define MZ_ImageUpload_URL @"https://api.zmengzhu.com/_upload?prot=1"

#else
// 环境切换不注释这个
#define MZAPP_VER           MZ_APP_Build_ver

//测试环境  http://b.t.zmengzhu.com/api/live/stream?
#define MZNET_SERVICEURL    @"http://api.app.t.zmengzhu.com/service/info?"
#define MZ_URL_Prefix       @"http://b.t.zmengzhu.com"
#define MZ_Shopping_Center_URL_Prefix  @"http://s1.t.zmengzhu.com"
#define MZBusinessPrefixUrl       @"/api"
#define MZNET_SECRETKEY     @"xEyRRg4QYWbk09hfRJHYHeKPv8nWZITlBiklc44MZCxbdk4E6cGVzrXve6iVaNBn"
#define MZ_ImageUpload_URL @"http://b.t.zmengzhu.com/_upload?prot=1"



//开发环境
//#define MZNET_SERVICEURL    @"http://api.app.dev.zmengzhu.com/service/info?"//开发环境IP
//#define MZ_URL_Prefix       @"http://api.dev.zmengzhu.com"
//#define MZ_Shopping_Center_URL_Prefix  @"http://s1.dev.zmengzhu.com"
//#define MZBusinessPrefixUrl       @"/business/v1"
//#define MZNET_SECRETKEY     @"7LQ3W0AXfiHeE9euEsYSk9Gf8ifvW7zmyaBU749bxVUsGyeDrcMMdd8qwBCU3jFM"


/* 后台已统一使用正式环境极光账号
 //测试环境
 #define JPushAppKey         @"97386e637821cf7f9f0afbf9"
 #define JPushAppSecret      @"e901c13ad507daa7fed4dfc6"
 #define JPush_IsProduct     YES
 */
#endif

//首页每次加载条数
#define MZHomeViewLimit     @"20"

//直播观众/礼物列表加载数据
#define MZLiveViewLimit     @"20"

//获取网络失败文字提示
#define MZ_NET_Failure      @"获取网络数据失败"

//请求地址前后缀合成
#define MZ_SDK_NET_Url(prefixUrl,suffixUrl) [NSString stringWithFormat:@"%@%@%@?",MZ_URL_Prefix,prefixUrl,suffixUrl]
#define MZ_NET_Url_assemble(basePrefixUrl,suffixUrl) [NSString stringWithFormat:@"%@%@",basePrefixUrl,suffixUrl]

//网址前缀字段
#define MZAppApiPrefixUrl         MZNET_SEVERURL_ITEM.app_api
#define MZUserPrefixUrl           MZNET_SEVERURL_ITEM.user
#define MZWebPrefixUrl            MZNET_SEVERURL_ITEM.web
//#define MZBusinessPrefixUrl       @"/business/v1"
#define MZQuanPrefixUrl           MZNET_SEVERURL_ITEM.quan
#define MZRelationPrefixUrl       MZNET_SEVERURL_ITEM.relation
#define MZPayPrefixUrl            MZNET_SEVERURL_ITEM.pay
#define MZWebRootPrefixUrl        MZNET_SEVERURL_ITEM.web_root
#define MZH5PrefixUrl             MZNET_SEVERURL_ITEM.h5
#define MZUploadPrefixUrl         MZNET_SEVERURL_ITEM.upload
#define MZCustomPrefixUrl         MZNET_SEVERURL_ITEM.customer
#define MZSettlementfixUrl        MZNET_SEVERURL_ITEM.settlement


#import <Foundation/Foundation.h>


static BOOL isDebugs;
static NSString *mBusinessPrefix;
static NSString *mPrefix;

@interface MZCoreSDKNetWork : NSObject

+(void)setDebug:(BOOL)isDebug;
+(BOOL)isDebug;

+(NSString *)getPrefix;

+(NSString *)getBusinessPrefix;
//暂时先在这里设置，后续还需要整理
+(NSString *)getNetWatchChatHistory;

@end


