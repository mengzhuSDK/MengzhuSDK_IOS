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
@property (nonatomic ,strong)NSString *receive_url;
@property (nonatomic ,strong)NSString *room;
@property (nonatomic ,strong)NSString *chat_uid;
@end


@interface MZMoviePlayerVideoModel : NSObject
@property (nonatomic ,strong)NSString *url;
@property (nonatomic ,strong)NSString *http_url;

@end



@interface MZMoviePlayerModel : NSObject
@property (nonatomic,strong) NSString * channel_id;//频道ID
@property (nonatomic,strong) NSString * cover;//活动封面
@property (nonatomic,assign) int status;// 直播状态 1:直播 2:回放 3:断流
@property (nonatomic,assign) int live_type; // 直播类型 0:视频 1:语音
@property (nonatomic ,strong)NSString *popular;//活动pv
@property (nonatomic ,strong)MZMoviePlayerMsg_conf *msg_config;
@property (nonatomic ,strong)MZMoviePlayerChat_conf *chat_config;
@property (nonatomic ,strong)MZMoviePlayerVideoModel *video;
@property (nonatomic ,strong)NSString *chat_uid;
@property (nonatomic,assign) int view_mode;// 观看权限 1:免费 2:vip 3:付费 4:密码  5:白名单观看 6:F码观看
@property (nonatomic ,strong)NSString *ticket_id;
@property (nonatomic,assign) int user_status;// 用户状态 1:正常 2:被踢出 3:禁言
@property (nonatomic ,strong)NSString *like_num;// 用户点赞数量
@property (nonatomic,strong)NSString *uv;
@property (nonatomic,assign)int *live_style;// 直播样式 0:横屏 1:竖屏




@end
