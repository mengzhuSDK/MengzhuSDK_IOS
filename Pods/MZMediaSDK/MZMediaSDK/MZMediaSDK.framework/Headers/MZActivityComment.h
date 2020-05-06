//
//  MZActivityComment.h
//  MengZhu
//
//  Created by vhall on 16/7/11.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#ifndef MZActivityComment_h
#define MZActivityComment_h


#pragma mark 观看端卡顿
typedef NS_ENUM(NSUInteger, ActivityFeedbackType) {
    ActivityFeedbackKaDun = 1,    //卡顿
    ActivityFeedbackHeiPing,      //黑屏
    ActivityFeedbackBuTongBu,     //不同步
    ActivityFeedbackQiTa,         //其他
};

#pragma mark 频道状态
typedef NS_ENUM(NSUInteger, ChannelStatus) {
    ChannelStatusLive = 1,     //直播
    ChannelStatusEnd,      //回放
    ChannelStatusRelay,    //转播
    ChannelStatusPlayEnd   //播放完成
};

#pragma mark 用户身份
typedef NS_ENUM(NSUInteger, UserRoleType) {
    UserRoleTypeUser,      //普通用户
    UserRoleTypeHost,      //主播
    UserRoleTypeSub_account,//子账号
    
    UserRoleTypeGuest,     //嘉宾
    UserRoleTypeAssistant, //助理
    
    UserRoleTypeSystem,     //系统
    UserRoleTypeRobot,    //机器人
    UserRoleTypeAnonymous//游客
};

#pragma mark 消息类型
typedef NS_ENUM(NSUInteger, MsgType) {
    //直播、观看公用
    MsgTypeOnline,    //上线消息
    MsgTypeOffline,   //下线消息
    MsgTypeOtherChat, //他人发的聊天消息
    MsgTypeMeChat,    //自己发的聊天消息
    MsgTypeNotice,    //系统公告
    MsgTypeGoodsUrl,  //商品链接
    MsgTypeLiveTip,    //直播提示
    MsgTypeLogin,     //登录通知
    MsgTypeGetReward, //别人打赏消息
    MsgTypeGetGift,   //别人送礼物消息
    
    MsgTypeSendRedBag,   //发红包消息
    MsgTypeSendVisitCardRedBag,   //名片红包消息

    //直播(主播)
    MsgTypeNoDisPlay,      //直播(主播)不接受(自己和助理)推送的消息
    
    //观看端(看直播)
    MsgTypeLiveStart,     //直播开始
    MsgTypeChannelLiveStart,     //频道开始新直播
    MsgTypeLiveOver,      //直播中途结束
    MsgTypeRelayRecordOver, //转播回放结束
    MsgTypeKickout,       //踢出用户
    MsgTypeDisableChat,   //用户禁言
    MsgTypeAbleChat,      //取消禁言
    MsgTypeAllowPublicChat,  //允许公开聊天
    MsgTypeForbidPublicChat, //禁止公开聊天(除主播、嘉宾、助理之外，其他人不显示聊天类消息)
    MsgTypePPTFlipOver,   //ppt翻页
    MsgTypePPTDraw,       //ppt画笔绘图(rev 1.0 暂时没有)
    MsgTypePPTClearStroke,//ppt撤销上一个画笔(rev 1.0 暂时没有)
    MsgTypeAudienceChange,//观看人数变化uv
    //(主播和助理)推送，观看端收到的推送消息
    MsgTypePushSign,      //主播和助理推送签到
    MsgTypePushReward,    //主播和助理推送求打赏
    MsgTypePushGift,      //主播和助理推送礼物消息
    MsgTypePushProduct,   //主播和助理推送产品消息
    MsgTypePushSheet,     //主播和助理推送表单消息
    
    //商城消息
    MsgTypeSalerGetUserPay,   //商家收到用户付款消息
    MsgTypeAudienceGetUserBuy,//用户收到其它用户购买的消息
    
    //其他命令
    MSgTypeObtainResult,//抢红包结果
    MsgTypeOther,

    //收到历史消息 的时间标签
    MsgTypeHistoryRecordLabel,
    MsgTypeLiveReallyEnd,//直播真正结束
    MsgTypeLiveForbidden,
    //开启关闭投票
    MsgTypeVoteStart,
    MsgTypeVoteEnd,
    //开启关闭付费投票
    MsgTypeSpendVoteStart,
    MsgTypeSpendVoteEnd,
    //开启关闭抽奖
    MsgTypePrizeStart,
    MsgTypePrizeEnd,
    //频道查看用户开启
    MsgTypeAllowCheckUser,
    //频道查看用户关闭
    MsgTypeForbidCheckUser,
    //抽奖签到通知
    MsgTypePrizeSign,
    //抽奖活动中奖通知
    MsgTypePrizeWinner,
    
    //允许查看历史消息
    MsgTypeAllowShowHistoryMsg,//不需要实时的
    //禁止查看历史消息
    MsgTypeForbidShowHistoryMsg,
    //圈子推广
    MsgTypeCicrleGeneralizeMsg,
    MsgTypeDocSwitchPageMsg,//控制台频道管理员切换文档翻页消息
    MsgTypeDocConfigStatusMsg,//频道管理员变更文档
    
    MsgTypeLiveRoomCloseMsg,//主播关闭房间的消息
    MsgTypeLiveRoomForbidPublicMsg,//连麦主播开启全员禁言
    MsgTypeLiveRoomAllowPublicMsg,//连麦主播解除全员禁言
    MsgTypeLiveRoomAllowUserChatMsg,//禁止单个用户发言
    MsgTypeLiveRoomForbidUserChatMsg,//解除单个用户禁言
    MsgTypeLiveRoomKickOutUserMsg,//连麦踢出事件
    MsgTypeLiveRoomNoticeUpdataMsg,//频道更新公告
    MsgTypeLiveRoomNoticeCircleIsOnMsg,//频道公告循环时间更改
    MsgTypeGlobalFunctionMsg,//活动页面全局功能配置更新消息通知
    MsgTypeWebinarFunctionMsg,//活动页面单场活动配置更新消息通知
    MsgTypeTipSignInWebViewMsg,//强制弹签到的webView的消息通知
    MsgTypePrizeWhirlingMsg,//主播开始抽奖通知
    MsgTypeDisChargeTipMsg,//流量预警提示
};


#pragma mark 权限类型
typedef NS_ENUM(NSUInteger, MZProductAccessRightType) {

    MZProductAccessRightChannel_ChannelList,//列表频道位后端
    MZProductAccessRightWebinar_BeautyStart,//APP端发起直播（一键美颜）
    MZProductAccessRightLive_host,//PC直播
    MZProductAccessRightMember_AddCategory,//会员
    MZProductAccessRightWebinar_Start,//密码付费
    MZProductAccessRightAdvance_Add,//预告
    MZProductAccessRightRecore_Show,//回放显示
    MZProductAccessRightRecord_SetDefault,//默认回放数
    MZProductAccessRightInviteContest_CreatePay,//邀约大赛
    MZProductAccessRightProductExten_List,//199推广购买
    MZProductAccessRightStore_Save //店铺（pc）
};


#endif /* MZActivityComment_h */
