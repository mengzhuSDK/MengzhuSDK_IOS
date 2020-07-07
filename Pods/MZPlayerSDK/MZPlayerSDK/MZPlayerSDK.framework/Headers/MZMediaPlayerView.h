

#import <UIKit/UIKit.h>
#import "MZOldMediaControl.h"
#import "MZNewMediaControl.h"
#import "MZOnlyVerticalMediaControl.h"
#import "MZPlayerManager.h"

@class MZMediaPlayerView;

#pragma mark - 播放工具的代理
@protocol MZMediaPlayerViewToolDelegate <NSObject>
@optional
/**
 全屏/非全屏切换
 */
- (void)playerView:(MZMediaPlayerView *)player fullscreen:(BOOL)fullscreen;
/**
 播放按钮
 */
- (void)playerPlayClick:(BOOL)isPlay;
/**
 快进退 进度回调
 */
- (void)playerSeekProgress:(NSTimeInterval)progress;
/**
 快进退 手势回调
 */
- (void)playerSeekLocation:(float)location;
/**
 声音大小手势回调
 */
- (void)playerVoiceSize:(float)size;
/**
 亮度手势回调
 */
- (void)playerLuminance:(float)luminance;
/**
 是否显示下方工具栏
 */
- (void)isPlayToolsShow:(BOOL)isShow;
@end

#pragma mark - 播放状态的代理
@protocol MZMediaPlayerViewPlayDelegate <NSObject>
@optional
/**
 开始播放状态回调
 */
- (void)loadStateDidChange:(MZMPMovieLoadState)type;
/**
 播放中状态回调
 */
- (void)moviePlayBackStateDidChange:(MZMPMoviePlaybackState)type;
/**
 播放结束状态 包含异常停止
 */
- (void)moviePlayBackDidFinish:(MZMPMovieFinishReason)type;
/**
 已经准备好，开始播放
 */
- (void)mediaIsPreparedToPlayDidChange;
/**
 播放失败
 */
- (void)playerViewFailePlay:(MZMediaPlayerView *)player;
@end


typedef enum : NSUInteger {
    MZMediaControlInterfaceOrientationMaskAll_old = 0,//播放器控制栏（横屏/二分屏自适应）旧版
    MZMediaControlInterfaceOrientationMaskAll_new,//播放器控制栏（横屏/二分屏自适应）新版
    MZMediaControlInterfaceOrientationMaskPortrait,//播放器控制栏（纯竖屏版本）
} MZMediaControlInterfaceOrientation;

@interface MZMediaPlayerView : UIView

@property (nonatomic, weak)   id<MZMediaPlayerViewToolDelegate> toolDelegate;
@property (nonatomic, weak)   id<MZMediaPlayerViewPlayDelegate> playDelegate;

/**
 * @brief 播放器的控制栏UI，有多套，同时只能使用一套，
 */
@property (nonatomic, strong) MZOldMediaControl           *oldMediaControl;//播放器控制栏view 可更改ui,
@property (nonatomic, strong) MZNewMediaControl           *newMediaControl;//播放器控制栏第二版view，可更改ui，
@property (nonatomic, strong) MZOnlyVerticalMediaControl  *onlyVerticalMediaControl;//只支持竖版的播放器控制栏

@property (nonatomic, assign) BOOL                        shouldAutoplay;//是否自动播放
@property (nonatomic, assign) BOOL                        isFullScreen;//是否全屏播放
@property (nonatomic, assign) BOOL                        pushPlayerPause;//是否push到下个界面
@property (nonatomic, assign) NSString                    *historyPlayingTime;//历史播放时间
@property (nonatomic, strong) UIView                      *preview;//预览view
@property (nonatomic, strong) MZPlayerManager             *playerManager;//控制播放器

/**
 * @brief 播放
 *
 * @param URLString 直播地址/视频地址
 * @param isLive 是否是直播
 * @param showView 展示在哪个view上
 * @param delegate 代理
 * @param interfaceOrientation 使用哪套播放器控制UI，详见 MZMediaControlInterfaceOrientation
 * @param movieModel 播放模型
 *
 */
- (void)playWithURLString:(NSString *)URLString isLive:(BOOL)isLive showView:(UIView*)showView delegate:(id)delegate interfaceOrientation:(MZMediaControlInterfaceOrientation)interfaceOrientation movieModel:(MZMPMovieScalingMode)movieModel;

- (void)playerWillShow;
- (void)playerWillHide;

- (void)pausePlayer;
- (void)startPlayer;

///快进退
- (void)seekTo:(NSTimeInterval)progress;

///预览图
- (void)showPreviewImage:(NSString *)imagePath;
- (void)showLocalPreviewImage:(NSString *)imageName;

///被动转换横竖屏,非用户点击。
- (void)fullScreen;
///主动隐藏播放栏
- (void)hideMediaControl;
///更新全屏按钮是否选中
- (void)updateFullscreenIsSelected:(BOOL)isSelected;
///设置横屏下，从右侧偏移向左(MZMediaControlInterfaceOrientationMaskAll_new有效)
- (void)landSpaceRightToInset:(CGFloat)rightInset;


///设置竖屏全屏播放下，从右侧偏移向左(MZMediaControlInterfaceOrientationMaskPortrait有效)
- (void)portraitRightToInset:(CGFloat)rightInset;

///设置控制栏延迟隐藏的秒数,默认为5秒
- (void)updateSecondOfAfterDelayToHide:(double)second;

@end

