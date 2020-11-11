//
//  MZMoviePlayerModel.h
//  MengZhu
//
//  Created by 李伟 on 2018/10/15.
//  Copyright © 2018年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 活动msg类型 */
@interface MZMoviePlayerMsg_conf : NSObject
@property (nonatomic, strong) NSString *msg_srv;
@property (nonatomic, strong) NSString *msg_listen_srv;
@property (nonatomic, strong) NSString *pub_url;
@property (nonatomic, strong) NSString *msg_online_srv;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *msg_token;
@property (nonatomic, strong) NSString *chat_uid;
@end

/** 活动chat模型 */
@interface MZMoviePlayerChat_conf : NSObject
@property (nonatomic, strong) NSString *pub_url;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *receive_url;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *chat_uid;
@end

/** 活动地址 */
@interface MZMoviePlayerVideoModel : NSObject
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *http_url;
@end


/** 公告配置 */
@interface MZRoomNotice : NSObject
@property (nonatomic, assign) BOOL is_top_notice;//公告是否置顶
@property (nonatomic,   copy) NSString *notice_content;//公告内容
@end

/** 公告配置 */
@interface MZPrizeInfo : NSObject
@property (nonatomic, strong) NSString *access_url;//抽奖链接
@property (nonatomic, strong) NSString *prize_modify_address;//完善地址链接
@property (nonatomic, strong) NSString *id;//抽奖ID
@property (nonatomic,assign) BOOL show_tips;
@end

/** 签到配置 */
@interface MZSignInfo : NSObject
@property (nonatomic,   copy) NSString *channel_id;//频道ID
@property (nonatomic,   copy) NSString *ticket_id;//活动ID
@property (nonatomic,   copy) NSString *title;//签到标题
@property (nonatomic, assign) int sign_id;//签到的ID
@property (nonatomic, assign) int status;//签到的状态，0-未开始，1-已开始， 2-已结束

@property (nonatomic, assign) BOOL is_sign;//是否已经签到
@property (nonatomic, assign) int delay_time;//延迟多久展示投票界面

@property (nonatomic, assign) BOOL is_force;//是否强制显示
@property (nonatomic, assign) int force_type;//1,填写后才可观看   2，可跳过观看

@property (nonatomic,   copy) NSString *access_url;//签到web地址

@property (nonatomic, assign) int redirect_sign;//是否显示webView签到
@property (nonatomic, assign) int is_expired;//是否过期

@end

/** 活动详细数据 */
@interface MZMoviePlayerModel : NSObject
@property (nonatomic, strong) NSString * channel_id;//频道ID
@property (nonatomic, strong) NSString * cover;//活动封面
@property (nonatomic, assign) int status;// 直播状态 0:未开播 1:直播 2:回放 3:断流
@property (nonatomic, assign) int live_type; // 直播类型 0:视频 1:语音
@property (nonatomic, strong) NSString *popular;//活动pv
@property (nonatomic, strong) MZMoviePlayerMsg_conf *msg_config;
@property (nonatomic, strong) MZMoviePlayerChat_conf *chat_config;
@property (nonatomic, strong) MZMoviePlayerVideoModel *video;
@property (nonatomic, strong) NSString *chat_uid;//自己在聊天室里的id
@property (nonatomic, strong) NSString *unique_id;//第三方传递过来的唯一id
@property (nonatomic, assign) int view_mode;// 观看权限 1:免费 2:vip 3:付费 4:密码  5:白名单观看 6:F码观看
@property (nonatomic, strong) NSString *ticket_id;
@property (nonatomic, assign) int user_status;// 用户状态 1:正常 2:被踢出 3:禁言
@property (nonatomic, strong) NSString *like_num;// 用户点赞数量
@property (nonatomic, strong) NSString *uv;
@property (nonatomic, assign) int live_style;// 直播样式 0:横屏 1:竖屏

@property (nonatomic,   copy) NSString *webinar_onlines;//进入频道的时候的总在线人数

@property (nonatomic, assign) BOOL isChat;//聊天室是否可以聊天
@property (nonatomic, assign) BOOL isBarrage;//聊天室配置是否可以发送弹幕
@property (nonatomic, assign) BOOL isRecord_screen;//活动是否开启防录屏

@property (nonatomic, strong) MZRoomNotice *notice;//公告配置

@property (nonatomic, assign) BOOL isHideChatHistory;//是否隐藏历史记录

@property (nonatomic, assign) BOOL isShowVote;//是否显示投票

@property (nonatomic, assign) BOOL isShowDocument;//是否显示文档

@property (nonatomic, assign) BOOL isShowSign;//是否显示签到
@property (nonatomic, assign) BOOL isShowPrize;//是否显示抽奖
@property (nonatomic, assign) BOOL isShowVideoBeforeAD;//是否暖场图
@property (nonatomic, strong) MZSignInfo *signInfo;//签到配置
@property (nonatomic, strong) MZPrizeInfo *prizeInfo;//抽奖配置

@property (nonatomic, assign) BOOL video_advert;//是否有视频前广告
@end

