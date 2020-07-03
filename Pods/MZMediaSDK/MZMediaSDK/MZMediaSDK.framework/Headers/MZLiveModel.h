//
//  MZLiveModel.h
//  MengZhu
//
//  Created by vhall on 16/7/11.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZMoviePlayerModel.h"
#import "MZActivityComment.h"
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

@class MZLiveModel;

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
 */
@property (nonatomic,assign) ChannelStatus  channelStatus;
/*!
 当前用户的角色
 */
@property (nonatomic,assign) UserRoleType roleType;
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
