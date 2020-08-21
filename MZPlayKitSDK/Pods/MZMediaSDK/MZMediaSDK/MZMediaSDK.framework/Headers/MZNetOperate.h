//
//  VHNetOperate.h
//  VhallIphone
//
//  Created by vhall on 15/7/3.
//  Copyright (c) 2015年 com.vhall.direct.ios. All rights reserved.
//

#ifndef VhallIphone_VHNetOperate_h
#define VhallIphone_VHNetOperate_h


//提审时注释掉⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
#define TEST_SERVER //使用测试服务器
//提审时注释掉⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️

//////////////////////////////////////////////////////////////
#ifndef TEST_SERVER

#define MZNET_SERVICEURL    @"https://api-app.zmengzhu.com/service/info?"
#define MZAPP_VER           MZ_APP_ver

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

#define MZAPP_DownLoadUrl   @"https://itunes.apple.com/us/app/meng-zhu/id1038341935?"


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

#define MZNET_SDK_Versions @"1000000"
#define MZNET_Host_Info    @"/user/liveUser"//主播信息

#define MZNET_Channel_ChannelInfo       @"/video/play"//新播放器详情
#define MZNET_WATCH_CHAT_HISTORY        @"/message/history" //推送历史消息
//获取活动商品列表
#define MZNET_Goods_List                @"/video/goods"
//获取在线用户列表
#define MZNET_Online_user_list          @"/room/onlines"
//SDK验证接口
#define MZNET_Check_server              @"/service/check"
#define MZNET_Room_Praise               @"/room/praise"//点赞

#define MZNET_Live_StartLive            @"/live/stream"//开始直播
#define MZNET_Live_StopLive             @"/live/stop"//停止直播

#define MZNET_Live_BannedUser           @"/room/forbidden"//禁言（解禁）用户
#define MZNET_Webinar_IsAllowPublicChat @"/room/allowChatAll"//是否允许公开聊天

#define MZNET_Document_DocumentList     @"/document/list"//app直播文档列表接口
#define MZNET_Document_DocumentInfo     @"/document/info"//app直播文档详情接口
#define MZNET_Document_DocumentDownload @"/document/download"//app直播文档下载接口
#define MZNET_Document_MyDocumentList   @"/document/my"//app直播文档下载接口

#define MZNET_VoteInfo                  @"/vote/channelVote"//获取投票信息
#define MZNET_VoteOptions               @"/vote/options"//获取投票选项
#define MZNET_VoteCreate                @"/vote/create"//开始投票

#define MZNet_GetLoginToken             @"/user/initToken"//获取登录token

#define MZNet_GiftList                  @"/gift/list"//获取直播间礼物列表
#define MZNet_GiftPush                  @"/gift/push"//直播间推送礼物

#define MZNet_DiscussList               @"/discuss/list"//问答列表
#define MZNet_DiscussSubmitQuestion     @"/discuss/submitQuestion"//提交问答

#endif
static BOOL isDebugs;
static NSString *mBusinessPrefix;
static NSString *mPrefix;
@interface MZNetOperate:NSObject

+(void)setDebug:(BOOL)isDebug;
+(BOOL)isDebug;

+(NSString *)netHostInfo;
+(NSString *)netChannelChannelInfo;
+(NSString *)netWatchChatHistory;
+(NSString *)netGoodsList;
+(NSString *)netOnlineUserList;
+(NSString *)netCheckServer;
+(NSString *)netRoomPraise;
+(NSString *)getSECRETKEY;
+(NSString *)getLiveStart;
+(NSString *)getLiveStop;
+(NSString *)bannedUser;
+(NSString *)allowPublicChat;
+(NSString *)documentList;
+(NSString *)documentInfo;
+(NSString *)documentDownload;
+(NSString *)getDocumentList;
+(NSString *)voteInfo;
+(NSString *)voteAllOptional;
+(NSString *)voteToDo;
+(NSString *)getLoginToken;
+(NSString *)giftList;
+(NSString *)giftPush;
+(NSString *)discussList;
+(NSString *)discussSubmitQuestion;
@end
