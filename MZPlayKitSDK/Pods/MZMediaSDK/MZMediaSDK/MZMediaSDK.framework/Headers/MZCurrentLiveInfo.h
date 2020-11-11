//
//  MZCurrentLiveInfo.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/11/6.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

/**
 当前正在直播的活动详细信息
 */
@interface MZCLiveInfo : NSObject

@property (nonatomic, copy) NSString *ticket_id;//直播活动 ticket id
@property (nonatomic, copy) NSString *live_tk;//直播推流信息的token

@end

@interface MZCurrentLiveInfo : NSObject

@property (nonatomic, assign) BOOL is_multipath;//当前频道 是否支持同时发起多路推流 0:否 1:是
@property (nonatomic, assign) BOOL is_live;//当前频道  是否正在直播中 0:否 1:是

@property (nonatomic, strong) MZCLiveInfo *live_info;//当前频道 正在直播的活动详细信息

@end

NS_ASSUME_NONNULL_END
