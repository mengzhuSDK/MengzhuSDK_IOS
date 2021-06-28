//
//  MZCurrentLive.h
//  MZKitDemo
//
//  Created by 李风 on 2020/12/23.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

NS_ASSUME_NONNULL_BEGIN

/**
 当前正在直播的活动详细信息
 */
@interface MZCurLiveInfo : NSObject

@property (nonatomic, copy) NSString *ticket_id;//直播活动 ticket id
@property (nonatomic, copy) NSString *live_tk;//直播推流信息的token

@property (nonatomic, assign) int status;//0 未开播 1直播中 2回放 3断流；只需要处理1和3状态
@property (nonatomic, assign) int live_style;//0:横屏 1:竖屏
@end

@interface MZCurrentLive : MZBaseModel

@property (nonatomic, assign) BOOL is_multipath;//当前频道 是否支持同时发起多路推流 0:否 1:是
@property (nonatomic, assign) BOOL is_live;//当前频道  是否正在直播中 0:否 1:是

@property (nonatomic, strong) MZCurLiveInfo *live_info;//当前频道 正在直播的活动详细信息

@end

NS_ASSUME_NONNULL_END
