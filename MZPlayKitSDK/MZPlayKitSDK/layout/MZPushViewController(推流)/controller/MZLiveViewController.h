//
//  MZLiveViewController.h
//  MengZhu
//
//  Created by vhall on 16/6/12.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLiveViewController : UIViewController

@property (nonatomic, assign) MZBeautyFaceLevel beautyFaceLevel;//美颜等级
@property (nonatomic, assign) BOOL isLandscape;//是否横屏直播，默认关闭
@property (nonatomic, assign) int countDownNum;//开始倒计时，默认为3
@property (nonatomic, assign) MZCaptureSessionPreset videoSessionPreset;//视频分辨率

@property (nonatomic, assign) BOOL isFrontCameraType;//是否是前置摄像头，默认前置摄像头
@property (nonatomic, assign) BOOL isMirroringType;//是否是镜像，默认关闭镜像
@property (nonatomic, assign) BOOL isMuteType;//是否静音直播，默认开启静音
@property (nonatomic, assign) BOOL isTorchType;//是否使用闪光灯，默认不使用

@property (nonatomic, assign) BOOL isOnlyAudio;//是否只是语音直播

@property (nonatomic, strong) NSDictionary * liveParama;
@property (nonatomic, strong) MZChannelManagerModel *model;
@property (nonatomic, strong) MZLiveUserModel *latestUser;

- (instancetype)initWithFinishModel:(void(^)(MZLiveFinishModel *model))finishHandle;

@end
