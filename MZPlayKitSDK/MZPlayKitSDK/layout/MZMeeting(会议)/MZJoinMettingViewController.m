//
//  MZJoinMettingViewController.m
//  MZMeetingFramework
//
//  Created by 李风 on 2020/11/30.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZJoinMettingViewController.h"
#import "MZJoinMeetingLayout.h"
#import <MZMeetingSDK/MZMeetingSDK.h>

@interface MZJoinMettingViewController ()
@property (nonatomic, strong) MZJoinMeetingLayout *meetingLayout;
@end

@implementation MZJoinMettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"加入会议";
    
    /// 必须设置，设置用户信息，如若已经设置，这里不需要重复设置
    MZUser *user = [MZBaseUserServer currentUser];
    if (!user) {//如果没有缓存的用户信息，这里生成一个
        user = [[MZUser alloc] init];
        user.uniqueID = @"user99999";
        user.nickName = @"盟主user999";
        user.avatar = @"http://s1.t.zmengzhu.com/upload/img/c0/63/c0638527f2fd32e1b086bae5ec61c8bf.png";

        [MZBaseUserServer updateCurrentUser:user];
    }
    
    __weak typeof(self) weakSelf = self;
    self.meetingLayout = [[MZJoinMeetingLayout alloc]initWithFrame:CGRectMake(0, kTopHeight, MZ_SW, MZTotalScreenHeight - kTopHeight)];
    [self.view addSubview:self.meetingLayout];
    self.meetingLayout.bgImageV.image = [UIImage imageNamed:@"mz_meeting_bg"];
    self.meetingLayout.logoImageV.image = [UIImage imageNamed:@"mz_meeting_logo"];
    self.meetingLayout.switchOnImage = [UIImage imageNamed:@"mz_meetingOn"];
    self.meetingLayout.switchOffImage = [UIImage imageNamed:@"mz_meetingOff"];
    self.meetingLayout.joinClickBlock = ^(NSString * _Nonnull meetingID, NSString * _Nonnull password) {
        [weakSelf loadMeettingDataWithMeetingID:meetingID password:password];
    };
}

/// 加载会议数据
- (void)loadMeettingDataWithMeetingID:(NSString *)meetingID password:(NSString *)password {
    if (meetingID.intValue == 0) {
        [self.view show:@"请输入正确的会议ID"];
        return;
    }
    
    // 监听会议的各种事件
    __weak typeof(self) weakSelf = self;
    [MZMeetingManager sharedManager].event = ^(MZMeetingEvent event, id  _Nullable data) {
        [weakSelf meetingEvent:event data:data];
    };
    
    // 加入会议
    [self.view showHud];
    [[MZMeetingManager sharedManager] joinMeetingWithMeeting_id:meetingID password:password noAudio:self.meetingLayout.voiceConnectSwitch.isOn noVideo:self.meetingLayout.cameraCloseSwitch.isOn rootVC:self];
}

/// 会议的各种事件的回调
- (void)meetingEvent:(MZMeetingEvent)event data:(id)data {
    switch (event) {
        case MZMeetingEvent_InitSDKSuccess: {//SDK初始化成功
            NSLog(@"会议SDK注册成功");
            break;
        }
        case MZMeetingEvent_InitSDKFailed: {//SDK初始化失败
            [self.view hideHud];
            NSLog(@"会议SDK注册失败 = %@",data);
            break;
        }
        case MZMeetingEvent_MeetingOver: {//会议链接断开
            [self.view hideHud];
            [self.view show:@"会议链接断开"];
            NSLog(@"会议链接断开");
            break;
        }
        case MZMeetingEvent_WaitMettingHostAgree: {//等待会议主人同意你加入会议状态
            [self.view hideHud];
            NSLog(@"等待会议主人同意你加入会议状态");
            break;
        }
        case MZMeetingEvent_JoinMeetingConfirmed: {//会议主人同意你加入会议状态
            [self.view hideHud];
            NSLog(@"主人同意你加入会议");
            break;
        }
        case MZMeetingEvent_RemovedByHost: {//拒绝你加入会议或者将你从会议里删除
            NSLog(@"拒绝你加入会议,或者将你从会议里删除");
            [self.view hideHud];
            [self.view show:@"拒绝你加入会议"];
            break;
        }
        case MZMeetingEvent_PasswordError: {//密码错误
            NSLog(@"密码错误");
            [self.view hideHud];
            [self.view show:@"密码错误"];
            break;
        }
        case MZMeetingEvent_MeetingNotExist: {//会议不存在
            NSLog(@"会议不存在");
            [self.view hideHud];
            [self.view show:@"会议不存在"];
            break;
        }
        case MZMeetingEvent_MeetingUserFull: {//会议室人员已满
            NSLog(@"会议室人员已满");
            [self.view hideHud];
            [self.view show:@"会议室人员已满"];
            break;
        }
        case MZMeetingEvent_MeetingLocked: {//会议已经被锁定
            NSLog(@"会议已经被锁定");
            [self.view hideHud];
            [self.view show:@"会议已经被锁定"];
            break;
        }
        case MZMeetingEvent_UserJoin: {//有用户加入会议
            NSLog(@"有用户加入会议 = %@", data);
            break;
        }
        case MZMeetingEvent_UserLeft: {//有用户离开会议
            NSLog(@"有用户离开会议 = %@", data);
            break;
        }
        case MZMeetingEvent_ReceiveMessage: {//收到一条消息
            NSLog(@"收到一条消息 = %@", data);
            break;
        }
        case MZMeetingEvent_UserInfoChange: {//用户信息更新
            NSLog(@"用户信息更新 = %@", data);
            break;
        }
        case MZMeetingEvent_MeetingNotStart: {//会议还未开始
            NSLog(@"会议还未开始 = %@", data);
            [self.view hideHud];
            [self.view show:@"会议还未开始"];
            break;
        }
        case MZMeetingEvent_MeetingReady: {//加入会议成功
            NSLog(@"加入会议成功 = %@", data);
            [self.view hideHud];
            [self.view show:@"加入会议成功"];
            break;
        }
        default: {
            [self.view hideHud];
            NSError *error = (NSError *)data;
            [self.view show:error.domain];
            NSLog(@"其他错误 = %@",data);
            break;
        }
    }
}

@end
