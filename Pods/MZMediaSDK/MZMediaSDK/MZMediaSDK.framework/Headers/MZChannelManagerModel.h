//
//  MZChannelManagerModel.h
//  MengZhu
//
//  Created by vhall on 16/6/27.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZBaseNetModel.h"
#import "MZUser_info.h"
#import "MZWebinar_info.h"
#import "MZHost.h"
#import "MZShare_info.h"
#import "MZMoviePlayerModel.h"

@class MZChannelManagerLastWebinarInfoModel;

@interface MZChannelManagerModel : MZBaseNetModel

@property (nonatomic,strong) NSString * channelId;//频道ID
@property (nonatomic,strong) NSString * channelName;//频道名称
@property (nonatomic,strong) NSString * startTime;//开始时间
@property (nonatomic,strong) NSString * endTime;//结束时间
@property (nonatomic,strong) NSString * cover;//封面图片
@property (nonatomic,assign) int status;//频道状态  1直播 2结束
@property (nonatomic,strong) NSString * builderNickname;//创建者
@property (nonatomic,strong) NSString * userID;//创建者ID
@property (nonatomic,strong) NSString * lecturerName;//讲师
@property (nonatomic,strong) NSString * coin;//银两
@property (nonatomic,strong) NSString * balance;//现金
@property (nonatomic,strong) NSString * isAllow;//是否能发直播
@property (nonatomic,strong) NSString * popular;//观看人数
@property (nonatomic,strong) NSString * shareImageUrl;
@property (nonatomic,strong) NSString * shareTitle;
@property (nonatomic,strong) NSString * shareDesc;
@property (nonatomic,strong) NSString * shareUrl;
@property (nonatomic,strong) NSString   *introduction;//频道简介
@property (nonatomic,strong) NSString   *ticket_id;//活动id
@property (nonatomic,assign) BOOL   isExpanded;
@property (nonatomic,assign) BOOL is_company_channel;
@property (nonatomic,assign) int    live_id;
@property (nonatomic,assign) BOOL   is_bonus;
@property (nonatomic,assign) BOOL is_create_record;
@property (nonatomic ,strong)NSString *push_url;

@property (nonatomic ,strong)MZMoviePlayerChat_conf *chat_conf;
@property (nonatomic ,strong)MZMoviePlayerMsg_conf *msg_conf;

@property (nonatomic,strong)MZHost          *host;
@property (nonatomic,strong)MZShare_info    *share_info;
@property (nonatomic,strong)MZUser_info     *user_info;
@property (nonatomic,strong)NSString  *webinar_id;
@property (nonatomic,strong)MZWebinar_info  *webinar_info;
@property (nonatomic,strong)NSMutableArray  *quan_list;
@property (nonatomic,strong)MZChannelManagerLastWebinarInfoModel *last_webinar_info;//预直播配置信息
@property (nonatomic,assign) BOOL is_traffic_version;// 是否是流量版 0:否 1:是
@property (nonatomic,assign) int lave_volume;// 弹窗状态  0:不需要弹窗 1:流量不足，允许继续直播 2:已无流量，点击关闭退出
@property (nonatomic ,strong)NSString *volume_short_tip;// 流量不足提醒
+(NSArray *)initDictionary:(id)data;
@end

@interface MZChannelManagerLastWebinarInfoModel : MZBaseNetModel

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * cover_url;//封面图片绝对路径
@property (nonatomic,strong) NSString * cover;//封面图片相对路径
@property (nonatomic,strong) NSString  *introduction;//频道简介
@property (nonatomic,strong) NSString  *id;
@property (nonatomic,strong) NSString  *uid;
@property (nonatomic,strong) NSString  *video_id;
@property (nonatomic,strong) NSString  *video_url;
@property (nonatomic,strong) NSString  *view_config_id;
@property (nonatomic,strong) NSString  *channel_id;//频道号
@property (nonatomic,strong) NSString  *category_id;//分类idcategory_name;
@property (nonatomic,strong) NSString  *category_name;//分类名称
@property (nonatomic,strong) NSString  *ticket_id;//上次配置活动id
@property (nonatomic,strong) NSString  *group_id;//分组id
@property (nonatomic,strong) NSString  *group_name;//分组名称
@property (nonatomic,strong) NSString  *created_at;//创建时间
@property (nonatomic,strong) NSString  *deleted_at;
@property (nonatomic,strong) NSString  *updated_at;
@property (nonatomic,strong) NSString  *duration;
@property (nonatomic,strong) NSString  *live_at;
@property (nonatomic,strong) NSString  *pv_level;
@property (nonatomic,strong) NSString  *status;
@property (nonatomic,strong) NSString  *weight;
@property (nonatomic,strong) NSString  *weight_sort;
@property (nonatomic,assign) BOOL is_default;
@property (nonatomic,assign) BOOL is_deleted;
@property (nonatomic,assign) BOOL is_display;
@property (nonatomic,assign) BOOL is_stick;
@property (nonatomic,assign) BOOL is_record;//是否生产回到
@property (nonatomic,assign) int view_mode;//观看方式 1免费 2vip 3付费 4密码 5白名单 6F码
@property (nonatomic,strong) NSDictionary  *view_mode_ext;
@property (nonatomic,assign) int live_type;
@property (nonatomic,assign) BOOL is_traffic_version;// 是否是流量版 0:否 1:是
@property (nonatomic,assign) int lave_volume;//0 不需要弹窗，1 小于50G 2 流量用光了
@property (nonatomic,strong) NSString *volume_short_tip;// 流量不足提醒

@end
