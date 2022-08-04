

#import <UIKit/UIKit.h>

#import "MZPlayerManager.h"

#import "MZMediaControl.h"
#import "MZNewMediaControl.h"
#import "MZOnlyVerticalMediaControl.h"
#import "MZAdvertisementPlayerView.h"

@class MZMediaPlayerView;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 播放工具的代理 && 播放状态的代理
@protocol MZMediaPlayerViewDelegate <NSObject>
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
/**
 倍速按钮点击
 */
- (void)playRateButtonClick:(id)sender;
/**
 投屏按钮点击
*/
- (void)dlnaButtonClick:(id)sender;
/**
 片前广告开始播放
 */
- (void)videoAdvertStartPlay:(MZAdvertisementModel *)advertModel;
/**
 点击了片前广告
 */
- (void)clickVideoAdvert:(MZAdvertisementModel *)advertModel;
/**
 片前广告播放完成，包括点击了跳过
 */
- (void)finishVideoAdvert:(MZAdvertisementModel *)advertModel;
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
/**
 网络连接后重新进行播放
 */
- (void)connectToPlay;

@end


typedef enum : NSUInteger {//播放器控制栏的UI版本
    MZMediaControlInterfaceOrientationMaskAll_old = 0,//播放器控制栏（横屏/二分屏自适应）旧版
    MZMediaControlInterfaceOrientationMaskAll_new,//播放器控制栏（横屏/二分屏自适应）新版
    MZMediaControlInterfaceOrientationMaskPortrait,//播放器控制栏（纯竖屏版本）
} MZMediaControlInterfaceOrientation;

@interface MZMediaPlayerView : UIView

@property (nonatomic, weak)   id<MZMediaPlayerViewDelegate> mediaPlayerViewDelegate;//mediaPlayerViewDelegate栏代理

@property (nonatomic, assign) BOOL                        shouldAutoplay;//是否自动播放
@property (nonatomic, assign) BOOL                        isFullScreen;//是否全屏播放
@property (nonatomic, assign) BOOL                        pushPlayerPause;//是否push到下个界面
@property (nonatomic, assign) NSString                    *historyPlayingTime;//历史播放时间
@property (nonatomic, strong) UIView                      *preview;//预览view
@property (nonatomic, strong) MZPlayerManager             *playerManager;//控制播放器
@property (nonatomic, strong) UIImageView                 *previewImage;//封面图

/// 播放器的控制栏UI，有多套，同时只能使用一套，参考 MZMediaControlInterfaceOrientation
@property (nonatomic, strong) MZMediaControl              *mediaControl;//旧版播放器控制栏view 可更改ui,
@property (nonatomic, strong) MZNewMediaControl           *newMediaControl;//默认（横屏/二分屏）播放器控制栏第二版view，可更改ui，
@property (nonatomic, strong) MZOnlyVerticalMediaControl  *onlyVerticalMediaControl;//只支持竖版的播放器控制栏

/// 广告播放完毕后是否自动播放主视频 默认是 YES
@property (nonatomic, assign) BOOL isAutoPlayVideoAfterAdvert;
/// 广告播放视图,广告的数据，控制通过此类操作
@property (nonatomic, strong) MZAdvertisementPlayerView *advertPlayerView;

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

/**
 * @brief 播放 - 添加了ticketId参数，可以自动播放该活动绑定的片前视频广告
 *
 * @param URLString 直播地址/视频地址
 * @param isLive 是否是直播
 * @param showView 展示在哪个view上
 * @param delegate 代理
 * @param interfaceOrientation 使用哪套播放器控制UI，详见 MZMediaControlInterfaceOrientation
 * @param movieModel 播放模型
 * @param ticketId 直播活动Id，可以通过此ID播放绑定该活动的视频广告
 *
 */
- (void)playWithURLString:(NSString *)URLString isLive:(BOOL)isLive showView:(UIView*)showView delegate:(id)delegate interfaceOrientation:(MZMediaControlInterfaceOrientation)interfaceOrientation movieModel:(MZMPMovieScalingMode)movieModel ticketId:(NSString *)ticketId;

/// 兼容旧版本的播放方法，不推荐使用
- (void)playerViewWithUrl:(NSString *)mvUrl isLive:(BOOL)isLive WithView:(UIView *)withView WithDelegate:(id)delegate;

///显示播放
- (void)playerWillShow;
///隐藏播放
- (void)playerWillHide;
///暂停播放
- (void)pausePlayer;
///开始播放
- (void)startPlayer;
///快进退
- (void)seekTo:(NSTimeInterval)progress;
///网络预览图
- (void)showPreviewImage:(NSString *)imagePath;
///本地预览图
- (void)showLocalPreviewImage:(NSString *)imageName;
///被动进行切换横竖屏，非用户主动点击
- (void)fullScreen;
///主动隐藏播放栏
- (void)hideMediaControl;
///更新全屏按钮是否选中（兼容旧版本）
- (void)updateFullscreenIsSelected:(BOOL)isSelected;
///设置控制栏延迟隐藏的秒数,默认为5秒
- (void)updateSecondOfAfterDelayToHide:(double)second;
///设置控制栏常驻
- (void)updateToolToHideAtDistantFuture;
///设置是否响应手势事件
- (void)updateReponseTouchEvent:(BOOL)isReponse;

///网络再次链接后是否重新自动播放,默认不自动播放
- (void)updateIsAutoConnectAndPlay:(BOOL)isAutoConnectAndPlay;

#pragma mark - 下面方法支持MZMediaControlInterfaceOrientationMaskAll_new和MZMediaControlInterfaceOrientationMaskPortrait)
///更换全屏按钮的图片
- (void)setFullScreenButtonImage:(UIImage *_Nonnull)image;
/// 设置倍速按钮图片
- (void)setPlayBackRateButtonImage:(UIImage * _Nonnull)image;
/// 设置投屏按钮图片
- (void)setDLNAButtonImage:(UIImage * _Nonnull)image;

/// 设置全屏按钮是否隐藏
- (void)setFullScreenButtonIsHidden:(BOOL)isHidden;
/// 设置倍速按钮是否隐藏
- (void)setPlayRateButtonIsHidden:(BOOL)isHidden;
/// 设置投屏按钮是否隐藏
- (void)setDLNAButtonIsHidden:(BOOL)isHidden;

///设置控制栏距离右边距
- (void)setRightToInset:(CGFloat)rightInset;

NS_ASSUME_NONNULL_END

@end

