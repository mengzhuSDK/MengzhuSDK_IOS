//
//  VHNetOperate.h
//  VhallIphone
//
//  Created by vhall on 15/7/3.
//  Copyright (c) 2015年 com.vhall.direct.ios. All rights reserved.
//

#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

#ifndef VhallIphone_VHNetOperate_h
#define VhallIphone_VHNetOperate_h
#define MZAPP_DownLoadUrl   @"https://itunes.apple.com/us/app/meng-zhu/id1038341935?"


#define MZNET_SDK_Versions              @"1000000"
#define MZNET_GetCurrentLiveOfChannel   @"/channel/getliveinfo"//获取当前是否有正在直播的活动
#define MZNET_Create_NewLive            @"/live/create"//创建新的直播活动
#define MZNET_GetCategoryList           @"/category/list"//获取分类列表
#define MZNET_GetFCodeList              @"/fcode/list"//获取F码列表
#define MZNET_GetWhiteList              @"/white/list"//获取白名单列表
#define MZNET_Host_Info                 @"/user/liveUser"//主播信息

#define MZNET_Channel_ChannelInfo       @"/video/play"//新播放器详情
#define MZNET_GetWebinarToolsList       @"/setting/getWebinarToolsList"//新播放器配置详情

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

#define MZNet_webinarAdvert     @"/video/screenAdvert"//开屏广告接口
#define MZNet_PlayPermissionCheck       @"/watchauth/check"//观看权限检测
#define MZNet_UseFCodeToPlay            @"/watchauth/usefcode"//使用F码

#define MZNet_Video_VideoAdvert         @"/video/videoAdvert"//活动的视频广告
#define MZNet_Video_RollAdvert          @"/video/rollAdvert"//活动的滚动广告

#define MZNet_UserInfo_Update          @"/user/updateUserInfo"//更新用户昵称和头像

#define MZNET_createFCode              @"/fcode/create"//创建F码分组
#define MZNET_deleteFCode              @"/fcode/del"//删除F码分组
#define MZNET_AddFCode                 @"/fcode/add"//添加F码
#define MZNET_UnUseFCode               @"/fcode/unuseList"//F码未使用列表

#define MZNET_createWhite              @"/white/create"//创建白名单分组
#define MZNET_deleteWhite              @"/white/del"//删除白名单分组
#define MZNET_usersWhite               @"/white/users"//查询白名单用户列表
#define MZNET_batchAddUser             @"/white/batch-add-user"//批量添加白名单
#define MZNET_deleteUserWhite          @"/white/deluser"//删除白名单里的某个用户
#define MZNET_clearUserWhite           @"/white/clear"//清空白名单里的所有用户

#define MZNET_kickoutUser              @"/live/kick"//踢出用户
#define MZNET_unKickoutUser            @"/live/restorekicked"//恢复踢出用户

#define MZNET_kickedUserList           @"/live/kickedUsers"//踢出列表
#define MZNET_silencedUserList         @"/live/silencedUsers"//禁言列表
#define MZNET_getUserBlockState        @"/room/chat-state"//获取用户禁言状态

#define MZNET_getCheckBonus            @"/bonus/check"//获取红包状态
#define MZNET_getBonusDrawList         @"/bonus/drawList"//红包领取记录
#define MZNET_createBonus              @"/bonus/create"//创建红包
#define MZNET_obtainBonus              @"/bonus/obtain"//领取红包

#endif

//static BOOL isDebugs;
//static NSString *mBusinessPrefix;
//static NSString *mPrefix;
@interface MZNetOperate:NSObject

//+(void)setDebug:(BOOL)isDebug;
//+(BOOL)isDebug;

+(NSString *)getCurrentLiveOfChannel;
+(NSString *)createNewLive;
+(NSString *)getCategoryList;
+(NSString *)getFCodeList;
+(NSString *)getWhiteList;
+(NSString *)netHostInfo;
+(NSString *)netChannelChannelInfo;
+(NSString *)netGetWebinarToolsList;
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
+(NSString *)getVideoBeforeADList;//暖场广告
+(NSString *)playPermissionCheck;
+(NSString *)useFCodeToPlay;
+(NSString *)video_VideoAdvert;
+(NSString *)video_RollAdvert;
+(NSString *)updateUserInfo;

+(NSString *)generalURLString:(NSString *)URLString;
@end
