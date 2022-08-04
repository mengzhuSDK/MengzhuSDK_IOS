//
//  MZPlayerManager.h
//  MZMediaSDK
//
//  Created by 孙显灏 on 2018/10/23.
//  Copyright © 2018 孙显灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum MZLogLevel {
    k_MZ_LOG_UNKNOWN = 0,
    k_MZ_LOG_DEFAULT = 1,
    
    k_MZ_LOG_VERBOSE = 2,
    k_MZ_LOG_DEBUG   = 3,
    k_MZ_LOG_INFO    = 4,
    k_MZ_LOG_WARN    = 5,
    k_MZ_LOG_ERROR   = 6,
    k_MZ_LOG_FATAL   = 7,
    k_MZ_LOG_SILENT  = 8,
} MZLogLevel;

//开始播放状态回调
typedef NS_OPTIONS(NSUInteger, MZMPMovieLoadState) {
    MZMPMovieLoadStateUnknown        = 0,
    MZMPMovieLoadStatePlayable       = 1 << 0,
    MZMPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    MZMPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
};
//结束状态
typedef NS_ENUM(NSInteger, MZMPMovieFinishReason) {
    MZMPMovieFinishReasonPlaybackEnded,
    MZMPMovieFinishReasonPlaybackError,
    MZMPMovieFinishReasonUserExited
};
//播放状态
typedef NS_ENUM(NSInteger, MZMPMoviePlaybackState) {
    MZMPMoviePlaybackStateStopped,
    MZMPMoviePlaybackStatePlaying,
    MZMPMoviePlaybackStatePaused,
    MZMPMoviePlaybackStateInterrupted,
    MZMPMoviePlaybackStateSeekingForward,
    MZMPMoviePlaybackStateSeekingBackward,
    MZInitPlayerError
    
};
//播放视频的填充模式
typedef NS_ENUM(NSInteger, MZMPMovieScalingMode) {
    MZMPMovieScalingModeNone,       // No scaling
    MZMPMovieScalingModeAspectFit,  // Uniform scale until one dimension fits
    MZMPMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    MZMPMovieScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

@protocol MZPlayerDelegate <NSObject>
@optional
/**
 开始播放状态回调
 */
- (void)loadStateDidChange:(MZMPMovieLoadState)type;
/**
 播放结束状态 包含异常停止
 */
- (void)moviePlayBackDidFinish:(MZMPMovieFinishReason)type;
/**
  已经准备好，开始播放
 */
- (void)mediaIsPreparedToPlayDidChange;
/**
 播放状态回调
 */
- (void)moviePlayBackStateDidChange:(MZMPMoviePlaybackState)type;
/**
 加载第一个画面，此方法只在isLive为YES情况下才会回调
 */
- (void)moviePlayFirstVideoFrameRendered;

@end

@interface MZPlayerManager : NSObject
@property (nonatomic,     weak) id<MZPlayerDelegate> delegate;
@property (nonatomic, readonly) UIView *view;//播放器的View
@property (nonatomic          ) NSTimeInterval currentPlaybackTime;//当前播放进度
@property (nonatomic, readonly) NSTimeInterval duration;//总时间
@property (nonatomic, readonly) NSTimeInterval playableDuration;//缓存的时间
@property (nonatomic, readonly) NSInteger bufferingProgress;//缓存进度

@property (nonatomic, readonly) BOOL isPreparedToPlay;//是否准备好播放
@property (nonatomic, readonly) int64_t numberOfBytesTransferred;//传输的字节数

@property (nonatomic, readonly) CGSize naturalSize;//自然大小
@property (nonatomic          ) BOOL shouldAutoplay;//是否自动播放

@property (nonatomic          ) BOOL allowsMediaAirPlay;//allowsMediaAirPlay
@property (nonatomic          ) BOOL isDanmakuMediaAirPlay;//isDanmakuMediaAirPlay
@property (nonatomic, readonly) BOOL airPlayMediaActive;//airPlayMediaActive

@property (nonatomic          ) float playbackRate;//播放倍速
@property (nonatomic          ) float playbackVolume;//声音
@property (nonatomic, readonly) CGFloat fpsInMeta;//fpsInMeta
@property (nonatomic, readonly) CGFloat fpsAtOutput;//fpsOutput
@property (nonatomic          ) BOOL shouldShowHudView;//是否展示状态
@property (nonatomic, readonly) MZMPMoviePlaybackState playbackState;//播放器播放状态
@property (nonatomic, readonly) MZMPMovieLoadState loadState;//播放器读取状态

///初始化，兼容旧版本
- (instancetype)initWithContentURL:(NSURL *)aUrl movieModel:(MZMPMovieScalingMode)movieModel frame:(CGRect)frame;//兼容旧版本
- (instancetype)initWithContentURLString:(NSString *)aUrlString movieModel:(MZMPMovieScalingMode)movieModel frame:(CGRect)frame;//兼容旧版本

///初始化，推荐使用此方法
- (instancetype)initWithContentURL:(NSURL *)aUrl movieModel:(MZMPMovieScalingMode)movieModel frame:(CGRect)frame isLive:(BOOL)isLive;
- (instancetype)initWithContentURLString:(NSString *)aUrlString movieModel:(MZMPMovieScalingMode)movieModel frame:(CGRect)frame isLive:(BOOL)isLive;
///准备播放
- (void)prepareToPlay;
///播放
- (void)play;
///暂停
- (void)pause;
///停止
- (void)stop;
///是否播放
- (BOOL)isPlaying;
///销毁
- (void)shutdown;
///实时下载速度
- (int64_t)trafficStatistic;
///bit率
- (float)dropFrameRate;//bit率
///设置frame
- (void)setViewFrame:(CGRect)frame;
///设置进入后台是否停止播放
- (void)setPauseInBackground:(BOOL)pause;
///获取进入后台是否停止播放的配置孩子 NO=后台不暂停 YES=后台暂停
- (BOOL)getPauseInBackground;
///解码器是否开启 是否开始解码
- (BOOL)isVideoToolboxOpen;
///是否开启日志
+ (void)setLogReport:(BOOL)preferLogReport;
///设置指定位置log输出
+ (void)setLogLevel:(MZLogLevel)logLevel;
///检查ffmpeg版本匹配
+ (BOOL)checkIfFFmpegVersionMatch:(BOOL)showAlert;
///检查player版本匹配
+ (BOOL)checkIfPlayerVersionMatch:(BOOL)showAlert version:(NSString *)version;
///关闭
- (void)didShutdown;

@end

