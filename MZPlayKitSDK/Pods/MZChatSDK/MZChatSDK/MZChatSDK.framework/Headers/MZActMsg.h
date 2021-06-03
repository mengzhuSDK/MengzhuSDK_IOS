//
//  MZBaseActMsg.h
//  MZChatSDK
//
//  Created by LiWei on 2020/8/4.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZRightModel.h"
#import "MZSingleContentModel.h"
#import "MZGlobalContentModel.h"
#import "HDAutoADModel.h"
@class MZBonusRainSendInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface MZSingleContentRightModel:NSObject
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *image;
@property (nonatomic ,assign)BOOL is_auto_pop;
@property (nonatomic ,strong)NSString *status;
@property (nonatomic ,assign)BOOL is_force;

@property (nonatomic ,strong)NSString *online_gift_id;
@property (nonatomic ,assign)int recive_gift_level;
@property (nonatomic ,assign)int can_recived_level;
@property (nonatomic ,strong)NSArray *online_gift_rule;
@property (nonatomic ,strong)NSString *url;
@end

@interface MZActMsg : NSObject

#pragma mark 聊天消息
@property (nonatomic,strong) NSString * msgText;
@property (nonatomic,assign) BOOL barrage;
@property (nonatomic,strong) NSString * imgSrc;
@property (nonatomic,strong) NSString *uniqueID;//用户传过来的唯一id
@property (nonatomic ,strong)NSString *unique_id;
@property (nonatomic,strong) NSString *accountNo;//用户传过来的唯一id


#pragma mark -红包消息
@property (nonatomic ,copy) NSString *bonus_id;
@property (nonatomic ,copy) NSString *ticket_id;
@property (nonatomic ,copy) NSString *slogan;
@property (nonatomic ,copy) NSString *money_type;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *data_money;
@property (nonatomic ,copy) NSString *event;
@property (nonatomic ,copy) NSString *isme;
@property (nonatomic ,copy) NSString *lid;
@property (nonatomic ,copy) NSString *lottery;
@property (nonatomic ,copy) NSString *real_room;
@property (nonatomic ,copy) NSString *role;
@property (nonatomic ,copy) NSString *role_pic;
@property (nonatomic ,copy) NSString *room;
@property (nonatomic ,copy) NSString *text;
@property (nonatomic ,copy) NSString *time;
@property (nonatomic ,copy) NSString *to;
@property (nonatomic ,copy) NSString *user_id;
@property (nonatomic ,copy) NSString *user_name;

#pragma mark -名片红包消息
@property (nonatomic ,copy) NSString *card_id;
@property (nonatomic ,copy) NSString *amount;

#pragma mark 上下线消息
//用户角色
@property (nonatomic,strong) NSString * userRole;
//sockIO
@property (nonatomic,strong) NSString * socketID;
//当前在线人数
@property (nonatomic,strong) NSString * currentUserCount;
//是否禁言
@property (nonatomic,strong) NSString * disableChat;
//参会人数
@property (nonatomic,strong) NSString * attendCount;
// 发起直播者是否隐藏通知，1：隐藏通知，0：或者字段不存在则显示上线通知
@property (nonatomic,strong) NSString * is_hidden;

#pragma mark 直播观看人数变化
//channel type
@property (nonatomic,strong) NSString * channelType;
@property (nonatomic,strong) NSString * uv;
@property (nonatomic,strong) NSString * last_pv;//最新的pv值


#pragma mark CMD命令
//CMD type
@property (nonatomic,strong) NSString * CMDType;
//踢出用户ID
@property (nonatomic,strong) NSString * tickOutUserID;
//禁言用户ID
@property (nonatomic,strong) NSString * disableChatUserID;
//取消用户禁言
@property (nonatomic,strong) NSString * ableChatUserID;



#pragma mark Complete类(收到的打赏/礼物) + push类(推送签到/求打赏/礼物)
//push type
@property (nonatomic,strong) NSString * pushType;

//签到
@property (nonatomic,strong) NSString * signID;
@property (nonatomic ,strong)NSString *sign_uid;

//打赏金额
@property (nonatomic,strong) NSString * rewardMoney;
@property (nonatomic,strong) NSString * pay_method;

//问答新回复未读个书
@property (nonatomic,strong) NSString * discussNoReadReplyCount;

//礼物ID
@property (nonatomic,strong) NSString * giftID;
//礼物名称
@property (nonatomic,strong) NSString * giftName;
@property(nonatomic,assign)int animation_status;//礼物动画样式 ，0普通  1全屏
@property(nonatomic,strong)NSString *animation_json;//礼物动画样式 ，0普通  1全屏
//礼物头像
@property (nonatomic,strong) NSString * giftIcon;
//礼物价格
@property (nonatomic,strong) NSString * giftPrice;
//礼物个数
@property (nonatomic,strong) NSString * giftCount;
//礼物总价
@property (nonatomic,strong) NSString * giftAmount;
@property (nonatomic,strong) NSString * continuous;// 连发礼物数量
@property (nonatomic ,assign)BOOL is_continuous_msg;

//抽奖相关
@property (nonatomic,strong) NSString *winner_user_id;
@property (nonatomic,strong) NSString *prize_id;
@property (nonatomic,strong) NSString *prize_name;
@property (nonatomic,strong) NSString *award_name;
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *award_pic;//中奖图片

//产品ID
@property (nonatomic,strong) NSString * productID;
//产品名称
@property (nonatomic,strong) NSString * productName;
//产品图标
@property (nonatomic,strong) NSString * productIcon;
//产品价格
@property (nonatomic,strong) NSString * productPrices;
//产品价格描述
@property (nonatomic,strong) NSString * productText;
//产品备注
@property (nonatomic,strong) NSString * productNote;


#pragma mark 商城订单(Complete类)
//商城频道ID
@property (nonatomic,strong) NSString * channelID;
//卖家ID
@property (nonatomic,strong) NSString * salerID;
//买家ID
@property (nonatomic,strong) NSString * buyerID;
//买家昵称
@property (nonatomic,strong) NSString * nickname;
//买家盟主号
@property (nonatomic,strong) NSString * buyerAliasId;
//买家头像
@property (nonatomic,strong) NSString * buyerAvatar;
//付款描述
@property (nonatomic,strong) NSString * orderPayState;
//订单创建时间
@property (nonatomic,strong) NSString * creatTime;
//邮寄方式(线下/快递)
@property (nonatomic,strong) NSString * buy_way;// 快递方式：1:快递 2:现场取货 3:无需物流 4:自提商品
//购买数量
@property (nonatomic,strong) NSString * buyNum;
//收款总计
@property (nonatomic,strong) NSString * payTotalAmount;
//付款人数
@property (nonatomic,strong) NSString * payOrderCount;

@property (nonatomic ,strong)NSString *send_uid;
#pragma mark 公告
//公告内容
@property (nonatomic,strong) NSString * noticeContent;
@property (nonatomic,assign) BOOL is_loop;// 是否循环播放 0:关闭循环 1:开启循环
@property (nonatomic,assign) int loop_interval;// 循环播放间隔时间（单位分钟）


#pragma mark 登录通知
//登录guid
@property (nonatomic,strong) NSString * guid;
//设备ID
@property (nonatomic,strong) NSString * device;

#pragma mark --直播中分享结束
@property (nonatomic,strong) NSString * live_status;
@property (nonatomic,strong) NSString * cid;

#pragma mark --圈子推广
//type=money
@property (nonatomic,strong) NSString * id;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * create_name;
@property (nonatomic,strong) NSString * pic;

#pragma mark --商品推广
//type=money
@property (nonatomic,assign) int goods_type;
@property (nonatomic,strong) NSString * goods_id;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * price;

#pragma mark --投票
@property (nonatomic,strong) NSString * svote_id;
#pragma mark --文档相关
@property (nonatomic,strong) NSString * webinar_id;// 直播活动id
@property (nonatomic,strong) NSString * url;// 图片文档访问地址
@property (nonatomic,strong) NSString * file_Name;// 图片文档名字
@property (nonatomic,assign) BOOL doc_is_allow_show;// 频道文档是否允许展示 0:否 1：是
@property (nonatomic,assign) BOOL doc_is_allow_show_onlive;// 直播状态下是否显示文档 0:不显示 1:显示
@property (nonatomic ,strong)NSString *room_name;//连麦房间
@property (nonatomic ,strong)NSString *uid;//连麦uid
#pragma mark --新改的播放器开关
@property (nonatomic ,strong)NSArray <MZGlobalContentModel *>*global_content;//全局开关配置
@property (nonatomic ,strong)NSArray <MZRightModel *>*webinar_content;//单场活动配置

#pragma mark --流量用完的提示
@property (nonatomic ,strong)NSString *msg;// 提示消息
@property (nonatomic ,strong)NSString *traffic_buy_url;/// PC客户端登录浏览器购买流量(暂时不用)
//修改或置顶商品价格消息
@property (nonatomic ,strong)NSString *adver_id;
@property (nonatomic,assign) BOOL is_top;
//删除聊天消息通知
@property (nonatomic,strong) NSArray *msg_unique_id;//删除的聊天信息ID
@property (nonatomic,strong) NSArray <HDAutoADModel *>* contentADModelArr;
//秒杀组ID
@property (nonatomic ,strong)NSString *seckill_group_id;

#pragma mark ----红包雨提示时间
@property (nonatomic ,strong)NSString *duration;
#pragma mark ----红包雨开始
@property (nonatomic ,strong)NSString *rain_id;
@property (nonatomic ,strong)NSString *app_url;
@property (nonatomic ,strong)MZBonusRainSendInfoModel *send_info;

#pragma mark ----集章推送消息
@property (nonatomic ,strong)NSString *image;//勋章图片
@property (nonatomic ,strong)NSString *info_id;
@property (nonatomic ,strong)NSString *mid;//勋章ID

@end

NS_ASSUME_NONNULL_END
