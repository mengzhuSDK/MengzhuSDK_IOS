//
//  MZMediaControl.h
//  MZPlayerSDK
//
//  Created by 李风 on 2020/8/6.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MZMediaGesturesView.h"
#import "MZPlayerManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MZMediaControlDelegate <NSObject>

- (void)onClickFullscreen:(BOOL)isFull;
- (void)onClickMediaControl:(id)sender;

- (void)onClickHUD:(id)sender;
- (void)onClickDone:(id)sender;
- (void)onClickPlayButton:(id)sender;
- (void)onPlayerLuminance:(float)luminance;//亮度
- (void)onPlayerVoiceSize:(float)size;//声音
- (void)onPlayerSeekLocation:(float)location;//快进的手势
- (void)onPlayerSeekProgress:(NSTimeInterval)progress;//快进的位置
- (void)isPlayToolsShow:(BOOL)isShow;//是否显示下方工具栏

@end

@interface MZMediaControl : UIView

- (void)showAndFade;
- (void)hide;
- (void)refreshMediaControl;

- (void)beginDragMediaSlider;
- (void)endDragMediaSlider;
- (void)continueDragMediaSlider;

-(void)liveHideAndShowView:(BOOL)isLive;//直播回放处理UI

/**
 *  播放失败
 */
- (void)failPlayVideo;
/****************************************/

/**
 *  单击时/双击时,判断tap的numberOfTapsRequired
 */
- (void)userTapGestureAction:(UITapGestureRecognizer*)xjTap;

//上下左右手势操作
@property (assign, nonatomic) Direction direction;
@property (assign, nonatomic) CGPoint startPoint;//手势触摸起始位置
@property (assign, nonatomic) CGFloat startVB;//记录当前音量/亮度
@property (assign, nonatomic) CGFloat startVideoRate;//开始进度
@property (strong, nonatomic) CADisplayLink *link;//以屏幕刷新率进行定时操作
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view
@property (strong, nonatomic) UISlider *volumeViewSlider;//控制音量

/*****************************************************************////

@property (nonatomic, weak) MZPlayerManager* delegatePlayer;
@property (nonatomic, weak) id<MZMediaControlDelegate>delegate;

@property (nonatomic, assign) BOOL autoHideCloseBtn;//是否竖屏状态下隐藏自带的关闭按钮
@property (nonatomic, assign) BOOL showHUDInfo;//是否显示HUD信息按钮
@property (nonatomic, assign) BOOL isFullscreen;//标示是否处于全屏状态

@property (nonatomic, assign) BOOL hasTopMargin;//是否头部预留电池栏高度

@property (nonatomic, assign) BOOL showCenterPlayBtn;//是否显示中心 播放状态按钮 默认

@property (nonatomic, assign) BOOL showActivite;//显示进度条

@property (nonatomic, strong) UIView    *overlayPanel;

@property (nonatomic, strong) MZMediaGesturesView  *gesturesView;

@property (nonatomic, strong) UIView    *topPanel;
@property (nonatomic, strong) UIButton  *closeBtn;
@property (nonatomic, strong) UILabel   *titleLabel;

@property (nonatomic, strong) UIView    *bottomPanel;
@property (nonatomic, strong) UIButton  *playButton;
@property (nonatomic, strong) UILabel   *currentTimeLabel;
@property (nonatomic, strong) UILabel   *totalDurationLabel;
@property (nonatomic, strong) UISlider  *mediaProgressSlider;

@property (nonatomic, strong) UIButton  *fullScreenBtn;
@property (nonatomic, assign) BOOL isShowFullScreenBtn;//是否强制显示/隐藏全屏按钮（比如纯音频活动就需要强制隐藏）

@property (nonatomic, strong) UIButton  *hudInfoBtn;

@property (nonatomic, assign) BOOL isResponseTouchEvent;//是否响应手势事件

// 播放
- (void)playControl;

// 拖拽结束后调用的方法
- (void)seekFinishToHideControl;

///设置控制栏延迟隐藏的秒数,默认为5秒
- (void)updateSecond:(double)second;

@end

NS_ASSUME_NONNULL_END
