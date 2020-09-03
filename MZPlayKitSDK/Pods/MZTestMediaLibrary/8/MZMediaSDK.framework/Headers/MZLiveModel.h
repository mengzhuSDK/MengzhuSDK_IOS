//
//  MZLiveModel.h
//  MengZhu
//
//  Created by vhall on 16/7/11.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZMoviePlayerModel.h"

@interface MZLiveModel : NSObject


/*!
 频道ID
 */
@property (nonatomic,strong) NSString * channelID;
/*!
 频道名称
 */
@property (nonatomic,strong) NSString * channelName;
/*!
 频道流名
 */
@property (nonatomic,strong) NSString * channelStreamName;
/*!
 频道token
 */
@property (nonatomic,strong) NSString * channelToken;
/*!
 频道封面
 */
@property (nonatomic,strong) NSString * channelCover;
/*!
 频道状态
 typedef NS_ENUM(NSUInteger, ChannelStatus) {
     ChannelStatusLive = 1,     //直播
     ChannelStatusEnd,      //回放
     ChannelStatusRelay,    //转播
     ChannelStatusPlayEnd   //播放完成
 };
 */
@property (nonatomic,assign) NSInteger  channelStatus;
/*!
 当前用户的角色
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
 */
@property (nonatomic,assign) NSInteger roleType;
/*!
 频道在线用户数
 */
@property (nonatomic,strong) NSString *  channelOnlineNums;
/*!
 用户ID
 */
@property (nonatomic,strong) NSString *  userID;

/*!
 用户昵称
 */
@property (nonatomic,strong) NSString *  userNickName;
/*!
 用户头像地址
 */
@property (nonatomic,strong) NSString *  userAvatar;
/*!
 用户等级
 */
@property (nonatomic,strong) NSString *  userLevel;

@property (nonatomic ,strong)MZMoviePlayerChat_conf *chat_conf;
@property (nonatomic ,strong)MZMoviePlayerMsg_conf *msg_conf;

@property (nonatomic,strong) NSString *  chatPublishUrl;

@property (nonatomic,assign) BOOL  is_traffic_version;
@property (nonatomic,assign) int  lave_volume;
@property (nonatomic,strong) NSString *volume_short_tip;




@end
