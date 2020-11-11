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

typedef enum : NSUInteger {
    RefundStatus_Normal = 0,//未退款
    RefundStatus_submit,//已申请退款
    RefundStatus_refunding,//退款中
    RefundStatus_refundSuccessed,//退款完成
    RefundStatus_refundReject,//拒绝退款
} RefundStatus;

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
