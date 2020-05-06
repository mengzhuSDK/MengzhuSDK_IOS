//
//  MZLiveFinishModel.h
//  MengZhu
//
//  Created by vhall on 16/7/4.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZBaseNetModel.h"

@interface MZLiveFinishModel : MZBaseNetModel

@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString * channelName;
@property (nonatomic,strong) NSString * channeCover;//频道封皮
@property (nonatomic,strong) NSString * webinarName;
@property (nonatomic,strong) NSString * webinarId;
@property (nonatomic,strong) NSString * webinarCover;//活动封皮
@property (nonatomic,strong) NSString * view_num;
@property (nonatomic,strong) NSString * profit;
@property (nonatomic,strong) NSString * live_length;
@property (nonatomic,strong) NSString * tips;
@property (nonatomic,strong) NSString * nickName;

@property (nonatomic,strong) NSString * shareUrl;
@property (nonatomic,strong) NSString * shareTitle;
@property (nonatomic,strong) NSString * shareImage;
@property (nonatomic,strong) NSString * shareDesc;
@property (nonatomic,strong) NSString * is_show_record;

@property (nonatomic,strong) NSString * duration;//新加的使用直播时长
@property (nonatomic,strong) NSString * uv;//新加的使用观看人数
+ (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
