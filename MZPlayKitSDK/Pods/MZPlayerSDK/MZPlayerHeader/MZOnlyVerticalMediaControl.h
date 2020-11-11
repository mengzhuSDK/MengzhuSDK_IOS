
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MZMediaGesturesView.h"
#import "MZPlayerManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MZOnlyVerticalMediaControlDelegate <NSObject>

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

- (void)playRateButtonClick:(id)sender;//倍速按钮点击
- (void)dlnaButtonClick:(id)sender;//投屏按钮点击

@end

@interface MZOnlyVerticalMediaControl : UIView

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
@property (strong, nonatomic) CADisplayLink *link;//以屏幕刷新率进行定时操作
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view
@property (strong, nonatomic) UISlider *volumeViewSlider;//控制音量

/*****************************************************************////

@property (nonatomic, weak) MZPlayerManager* delegatePlayer;
@property (nonatomic, weak) id<MZOnlyVerticalMediaControlDelegate>delegate;

@property (nonatomic, assign) BOOL autoHideCloseBtn;//是否竖屏状态下隐藏自带的关闭按钮
@property (nonatomic, assign) BOOL showHUDInfo;//是否显示HUD信息按钮

@property (nonatomic, assign) BOOL hasTopMargin;//是否头部预留电池栏高度

@property (nonatomic, assign) BOOL showCenterPlayBtn;//是否显示中心 播放状态按钮 默认

@property (nonatomic, assign) BOOL showActivite;//显示进度条

@property (nonatomic, strong) UIView    *overlayPanel;

@property (nonatomic, strong) MZMediaGesturesView  *gesturesView;

@property (nonatomic, strong) UIView    *topPanel;
@property (nonatomic, strong) UIButton  *closeBtn;
@property (nonatomic, strong) UILabel   *titleLabel;

@property (nonatomic, strong) UIView    *bottomPanel;//底部背景View
@property (nonatomic, strong) UIButton  *playButton;//播放按钮

@property (nonatomic, strong) UILabel   *timeBackgroungView;//播放总时长和当前时长的背景View
@property (nonatomic, strong) UILabel   *currentTimeLabel;//当前时间
@property (nonatomic, strong) UILabel   *totalDurationLabel;//总事件
@property (nonatomic, strong) UISlider  *mediaProgressSlider;//进度条

@property (nonatomic, strong) UIButton  *hudInfoBtn;

@property (nonatomic, assign) CGFloat rightToInset;//右侧向左偏移，方便位置放自定义的图标

@property (nonatomic, assign) BOOL isResponseTouchEvent;//是否响应手势事件

@property (nonatomic, strong) UIButton *playRateButton;//倍速播放按钮
@property (nonatomic, strong) UIButton *dlnaButton;//投屏按钮

// 播放
- (void)playControl;

// 拖拽结束后调用的方法
- (void)seekFinishToHideControl;

///设置控制栏延迟隐藏的秒数,默认为5秒
- (void)updateSecond:(double)second;

/// 设置倍速按钮是否隐藏
- (void)setPlayRateButtonIsHidden:(BOOL)isHidden;
/// 设置投屏按钮是否隐藏
- (void)setDLNAButtonIsHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
