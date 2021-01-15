//
//  MZMeetingInfo.h
//  MZMeetingSDK
//
//  Created by 李风 on 2020/12/1.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZMeetingInfo : NSObject

/// 会议基本信息
@property (nonatomic, copy) NSString *meeting_name;//会议名字
@property (nonatomic, copy) NSString *meeting_date_format;//会议创建时间
@property (nonatomic, copy) NSString *meeting_time;//会议创建时间戳
@property (nonatomic, copy) NSString *password;//会议密码
@property (nonatomic, copy) NSString *nickname;//参加会议的用户名字

/// 邀请别人加入会议，对外展示的会议id
@property (nonatomic, copy) NSString *title;//邀请别人加入会议，对外展示的标题
@property (nonatomic, copy) NSString *mz_meeting_id;//邀请别人加入会议，对外展示的会议id
@property (nonatomic, copy) NSString *meeting_join_url;//邀请别人加入会议，会议的加入地址
@property (nonatomic, copy) NSString *qr_code;//会议的二维码

/// 会议内部使用的参数，不对外使用
@property (nonatomic, copy) NSString *real_meeting_id;//真正的会议id，内部使用，不对外使用
@property (nonatomic, copy) NSString *real_uid;//参会者真正的id，内部使用，不对外使用

@end

NS_ASSUME_NONNULL_END
