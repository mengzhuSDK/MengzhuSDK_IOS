//
//  MZMoviePlayerModel.h
//  MengZhu
//
//  Created by 李伟 on 2018/10/15.
//  Copyright © 2018年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MZMoviePlayerMsg_conf : NSObject
@property (nonatomic ,strong)NSString *msg_srv;
@property (nonatomic ,strong)NSString *msg_listen_srv;
@property (nonatomic ,strong)NSString *pub_url;
@property (nonatomic ,strong)NSString *msg_online_srv;
@property (nonatomic ,strong)NSString *domain;
@property (nonatomic ,strong)NSString *room;
@property (nonatomic ,strong)NSString *msg_token;
@property (nonatomic ,strong)NSString *chat_uid;
@end

@interface MZMoviePlayerChat_conf : NSObject
@property (nonatomic ,strong)NSString *pub_url;
@property (nonatomic ,strong)NSString *token;
@property (nonatomic ,strong)NSString *receive_url;
@property (nonatomic ,strong)NSString *room;
@property (nonatomic ,strong)NSString *chat_uid;
@end


@interface MZMoviePlayerVideoModel : NSObject
@property (nonatomic ,strong)NSString *url;
@property (nonatomic ,strong)NSString *http_url;

@end



@interface MZRightContenModel:NSObject
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *channel_id;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSString *image;
@property (nonatomic ,assign)BOOL is_auto_pop;
@property (nonatomic ,strong)NSString *created_at;
@property (nonatomic ,strong)NSString *updated_at;
@property (nonatomic ,strong)NSString *online_gift_id;
@property (nonatomic ,assign)int recive_gift_level;
@property (nonatomic ,assign)int can_recived_level;  // 是否可以领取0-1 BOOL
@property (nonatomic ,strong)NSArray *online_gift_rule;
@property (nonatomic ,strong)NSString *url;
@property (nonatomic ,strong)NSString *answer_bonus_id;
@property (nonatomic ,strong)NSString *app_url;

@property (nonatomic ,strong)NSString *status;//0:未开始 1:进行中 2:已结束
@property (nonatomic ,assign)BOOL is_sign;//是否已签到is_expired;
//@property (nonatomic ,assign)BOOL is_expired;//签到是否过期
//@property (nonatomic ,assign)int is_force;//是否是强制签到
@property (nonatomic,assign) BOOL redirect_sign;//是否需要弹web签到（这个包含了is_expired和is_force）
@property (nonatomic,assign) int force_type;
@property (nonatomic ,copy) NSString *ticket_id;
//广告图相关字段
@property (nonatomic ,copy) NSString *adver_id;
@property (nonatomic ,strong) NSArray *content;

@end


@interface MZRightModel:NSObject
@property (nonatomic ,strong)NSString *type;
@property (nonatomic,assign) BOOL is_open;
@property (nonatomic ,strong)MZRightContenModel *content;
@end


@interface MZMoviePlayerModel : NSObject
@property (nonatomic, strong) NSString * channel_id;//频道ID
@property (nonatomic, strong) NSString * cover;//活动封面
@property (nonatomic, assign) int status;// 直播状态 1:直播 2:回放 3:断流
@property (nonatomic, assign) int live_type; // 直播类型 0:视频 1:语音
@property (nonatomic, strong)NSString *popular;//活动pv
@property (nonatomic, strong)MZMoviePlayerMsg_conf *msg_config;
@property (nonatomic, strong)MZMoviePlayerChat_conf *chat_config;
@property (nonatomic, strong)MZMoviePlayerVideoModel *video;
@property (nonatomic, strong)NSString *chat_uid;
@property (nonatomic, assign) int view_mode;// 观看权限 1:免费 2:vip 3:付费 4:密码  5:白名单观看 6:F码观看
@property (nonatomic, strong)NSString *ticket_id;
@property (nonatomic, assign) int user_status;// 用户状态 1:正常 2:被踢出 3:禁言
@property (nonatomic, strong)NSString *like_num;// 用户点赞数量
@property (nonatomic, strong)NSString *uv;
@property (nonatomic, assign)int live_style;// 直播样式 0:横屏 1:竖屏

@property (nonatomic, assign)BOOL isChat;//聊天室是否可以聊天
@property (nonatomic, assign)BOOL isBarrage;//聊天室配置是否可以发送弹幕
@property (nonatomic, assign)BOOL isRecord_screen;//活动是否开启防录屏

@end

