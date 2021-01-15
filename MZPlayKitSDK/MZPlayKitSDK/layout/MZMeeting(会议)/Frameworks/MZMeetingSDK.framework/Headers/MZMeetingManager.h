//
//  MZMeetingManager.h
//  MZMeetingSDK
//
//  Created by LiWei on 2020/9/15.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MZMeetingInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MZMeetingEvent_InitSDKSuccess = 0,//SDK注册成功
    MZMeetingEvent_InitSDKFailed = 1,//SDK注册失败
    
    MZMeetingEvent_MeetingNotStart = 2,//会议还未开始
    MZMeetingEvent_MeetingReady = 3,//加入会议成功
    
    MZMeetingEvent_PasswordError = 4,//密码错误
    MZMeetingEvent_MeetingOver = 6,//会议链接断开
    MZMeetingEvent_MeetingNotExist = 8,//会议不存在
    MZMeetingEvent_MeetingUserFull = 9,//会议室人员已满
    MZMeetingEvent_MeetingLocked = 12,//会议已经被锁定
    
    MZMeetingEvent_RemovedByHost = 61,//不同意加入会议或者将你从会议里删除
    
    MZMeetingEvent_WaitMettingHostAgree = 81,//等待会议主人同意你加入会议
    MZMeetingEvent_JoinMeetingConfirmed = 82,//会议主人同意你加入会议
    
    MZMeetingEvent_UserJoin = 101,//有用户加入会议
    MZMeetingEvent_UserLeft = 102,//有用户离开会议
    
    MZMeetingEvent_ReceiveMessage = 103,//收到一条消息
    MZMeetingEvent_UserInfoChange = 104,//用户信息更新
    
    MZMeetingEvent_OtherError = 106,//其他错误
} MZMeetingEvent;

typedef void(^MZListenMeetingEvent)(MZMeetingEvent event, id _Nullable data);

@interface MZMeetingManager : NSObject

@property (nonatomic, weak, readonly) UIViewController *rootVC;//跳转过来的VC
@property (nonatomic, strong, readonly) MZMeetingInfo *meetingInfo;//会议完整信息，加入会议方法后可获得
@property (nonatomic, assign, readonly) BOOL isNOVideo;//获取是否不开启音频
@property (nonatomic, assign, readonly) BOOL isNOAudio;//获取是否不开启语音

@property (nonatomic,   copy) MZListenMeetingEvent event;//监听会议的各种事件


/// 单例模式
+ (MZMeetingManager *)sharedManager;

/// 加入会议
/// @param meeting_id 会议id
/// @param password 会议密码
/// @param noAudio 默认是否关闭语音
/// @param noVideo 默认是否关闭摄像头
/// @param rootVC 跳转的VC
- (void)joinMeetingWithMeeting_id:(NSString *)meeting_id
                         password:(NSString * _Nullable)password
                          noAudio:(BOOL)noAudio
                          noVideo:(BOOL)noVideo
                           rootVC:(UIViewController *)rootVC;

#pragma mark - 会议界面的UI相关的方法
#pragma mark - 顶部工具栏
/// 刷新顶部工具栏Frame
- (void)updateTopPanelFrame;

/// 隐藏顶部工具栏
-  (void)hideTopPanel;

/// 展示顶部工具栏
- (void)showTopPanel;

/// 获取前后摄像头按钮，获取后可自定义
- (UIButton *)getCameraSwitchButton;

/// 获取标题label，获取后可自定义
- (UILabel *)getTitleLabel;

/// 获取离开按钮，获取后可自定义
- (UIButton *)getLeaveButton;

#pragma mark - 底部工具栏
/// 刷新底部工具栏Frame
- (void)updateBottomPanelFrame;

/// 隐藏底部工具栏
- (void)hideBottomPanel;

/// 展示底部工具栏
- (void)showBottomPanel;

/// 更新音频按钮状态
- (void)updateMyAudioStatus;

/// 更新视频按钮状态
- (void)updateMyVideoStatus;

/// 获取音频按钮，获取后可自定义
- (UIButton *)getMyAudioButton;

/// 获取视频按钮，获取后可自定义
- (UIButton *)getMyVideoButton;

/// 获取参与者按钮，获取后可自定义
- (UIButton *)getChatButton;

/// 获取更多按钮，获取后可自定义
- (UIButton *)getMoreButton;

@end

NS_ASSUME_NONNULL_END
