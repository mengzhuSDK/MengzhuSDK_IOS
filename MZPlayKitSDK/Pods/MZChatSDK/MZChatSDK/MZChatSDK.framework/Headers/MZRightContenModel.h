//
//  MZRightContenModel.h
//  MZChatSDK
//
//  Created by LiWei on 2020/8/4.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZRightContenModel : NSObject

@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *channel_id;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSString *image;
@property (nonatomic ,assign)BOOL is_auto_pop;
@property (nonatomic ,strong)NSString *created_at;
@property (nonatomic ,strong)NSString *updated_at;
@property (nonatomic ,strong)NSString *online_gift_id;
@property (nonatomic ,strong)NSString *start_at;//在线礼包用到了
@property (nonatomic ,strong)NSString *end_at;
@property (nonatomic ,assign)int recive_gift_level;
@property (nonatomic ,assign)int can_recived_level;  // 是否可以领取0-1 BOOL
@property (nonatomic ,strong)NSString *begin_countdown;

@property (nonatomic ,strong)NSArray *online_gift_rule;
@property (nonatomic ,strong)NSString *url;
@property (nonatomic ,strong)NSString *answer_bonus_id;
@property (nonatomic ,strong)NSString *app_url;

@property (nonatomic ,strong)NSString *status;//0:未开始 1:进行中 2:已结束
@property (nonatomic ,assign)BOOL is_sign;//是否已签到is_expired;
//@property (nonatomic ,assign)BOOL is_expired;//签到是否过期
@property (nonatomic ,assign)int is_force;//是否是强制签到
@property (nonatomic ,strong)NSString *sign_id;//签到ID
@property (nonatomic,assign) BOOL redirect_sign;//是否需要弹web签到
@property (nonatomic,assign) int force_type;  //1,填写后可观看   2，可跳过
@property (nonatomic,assign) int delay_time;
@property (nonatomic ,copy) NSString *ticket_id;
@property (nonatomic ,strong)NSString *svote_id;//投票ID
//广告图相关字段
@property (nonatomic ,copy) NSString *adver_id;
@property (nonatomic ,strong) NSArray *content;
@property (nonatomic ,strong)NSString *stay_duration;//暖场图倒计时秒数

//集章
@property (nonatomic ,copy) NSString *app_medal_url;//集章详情链接
@property (nonatomic ,copy) NSString *mid;//集章id

@end

NS_ASSUME_NONNULL_END
