

#import <UIKit/UIKit.h>
#import "SYMediaControl.h"
#import "MZPlayerManager.h"

@class MZMediaPlayerView;

@protocol MZMediaPlayerViewDelegate <NSObject>



/**
 *  全屏/非全屏切换
 */
- (void)playerView:(MZMediaPlayerView *)player fullscreen:(BOOL)fullscreen;
/**
 *  播放失败
 */
- (void)playerViewFailePlay:(MZMediaPlayerView *)player;

- (BOOL)playerViewWillBeginPlay:(MZMediaPlayerView *)player;
/**
 播放按钮
 */
- (void)playerPlayClick:(BOOL)isPlay;
/**
 快进退 进度回调
 */
-(void)playerSeekProgress:(NSTimeInterval)progress;

/**
 快进退 手势回调
 */
-(void)playerSeekLocation:(float)location;

/**
 声音大小手势回调
 */
-(void)playerVoiceSize:(float)size;
/**
 亮度手势回调
 */
-(void)playerLuminance:(float)luminance;
- (void)isPlayToolsShow:(BOOL)isShow;//是否显示下方工具栏

@end


@interface MZMediaPlayerView : UIView


@property (nonatomic, weak)   id<MZMediaPlayerViewDelegate> delegate;

@property (nonatomic, strong) SYMediaControl   *mediaControl;//播放器控制栏view 可更改ui
@property (nonatomic, assign) BOOL              shouldAutoplay;
@property (nonatomic, assign) BOOL              isFullScreen;
@property (nonatomic, assign) BOOL              pushPlayerPause;//是否push到下个界面
@property (nonatomic, assign) NSString  *     historyPlayingTime;//历史播放时间
@property (nonatomic, strong) UIView *        preview;
@property (nonatomic, strong) MZPlayerManager * playerManager;//控制播放器
@property(nonatomic, weak)id<MZPlayerDelegate> playerDelegate;


- (instancetype)initWithFrame:(CGRect)frame uRL:(NSURL *)url movieModel:(MZMPMovieScalingMode)movieModel isLive:(BOOL)isLive;
-(void)playerViewWithUrl:(NSString*)urlString isLive:(BOOL)isLive WithView:(UIView*)view WithDelegate:(UIViewController*)viewController;
- (void)setIsFullScreen:(BOOL)isFullScreen;



- (void)playerWillShow;
- (void)playerWillHide;

-(void)pausePlayer;
-(void)startPlayer;
//快进退
-(void)seekTo:(NSTimeInterval*)progress;


/**
 *  预览图
 */
- (void)showPreviewImage:(NSString *)imagePath;
- (void)showLocalPreviewImage:(NSString *)imageName;

@end

