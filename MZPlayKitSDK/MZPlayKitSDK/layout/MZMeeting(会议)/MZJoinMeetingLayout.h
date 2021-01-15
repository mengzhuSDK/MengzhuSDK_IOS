//
//  MZJoinMeetingLayout.h
//  MZMeetingSDK
//
//  Created by LiWei on 2020/9/16.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZJoinMeetingLayout : UIView
@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) UIImageView *logoImageV;
@property (nonatomic, strong) UIImage *switchOnImage;
@property (nonatomic, strong) UIImage *switchOffImage;

@property (nonatomic, strong) NSString *meetingID;//初始值（一进来显示的）
@property (nonatomic, strong) NSString *meetingPassword;//初始值

@property (nonatomic, strong) UISwitch *voiceConnectSwitch;
@property (nonatomic, strong) UISwitch *cameraCloseSwitch;

@property (nonatomic,   copy) void(^joinClickBlock)(NSString *meetingID, NSString *password);

@end

NS_ASSUME_NONNULL_END
