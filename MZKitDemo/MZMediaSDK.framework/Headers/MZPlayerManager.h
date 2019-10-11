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

typedef NS_ENUM(NSInteger, MZMPMovieScalingMode) {
    MZMPMovieScalingModeNone,       // No scaling
    MZMPMovieScalingModeAspectFit,  // Uniform scale until one dimension fits
    MZMPMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    MZMPMovieScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

@protocol MZPlayerDelegate <NSObject>
/**
 开始播放状态回调
 */
- (void)loadStateDidChange:(MZMPMovieLoadState)type;
/**
 播放结束状态 包含异常停止
 */
- (void)moviePlayBackDidFinish:(MZMPMovieFinishReason)type;

/**
 是否准备完成
 */
- (void)mediaIsPreparedToPlayDidChange;
/**
 播放状态回调
 */
- (void)moviePlayBackStateDidChange:(MZMPMoviePlaybackState)type;

/**
 加载第一个画面
 */
- (void)moviePlayFirstVideoFrameRendered;


@end

@interface MZPlayerManager : NSObject
@property(nonatomic, weak)id<MZPlayerDelegate> delegate;
@property(nonatomic, readonly)  UIView *view;
@property(nonatomic)            NSTimeInterval currentPlaybackTime;
@property(nonatomic, readonly)  NSTimeInterval duration;
@property(nonatomic, readonly)  NSTimeInterval playableDuration;
@property(nonatomic, readonly)  NSInteger bufferingProgress;

@property(nonatomic, readonly)  BOOL isPreparedToPlay;
@property(nonatomic, readonly) int64_t numberOfBytesTransferred;

@property(nonatomic, readonly) CGSize naturalSize;
@property(nonatomic) BOOL shouldAutoplay;

@property (nonatomic) BOOL allowsMediaAirPlay;
@property (nonatomic) BOOL isDanmakuMediaAirPlay;
@property (nonatomic, readonly) BOOL airPlayMediaActive;

@property (nonatomic) float playbackRate;
@property (nonatomic) float playbackVolume;
@property(nonatomic, readonly) CGFloat fpsInMeta;
@property(nonatomic, readonly) CGFloat fpsAtOutput;
@property(nonatomic) BOOL shouldShowHudView;
@property(nonatomic, readonly)  MZMPMoviePlaybackState playbackState;
@property(nonatomic, readonly)  MZMPMovieLoadState loadState;
//@property (nonatomic,assign) MZMPMovieScalingMode movieScalingMode;


//初始化
- (instancetype)initWithContentURL:(NSURL *)aUrl movieModel:(MZMPMovieScalingMode)movieModel frame:(CGRect)frame;

- (instancetype)initWithContentURLString:(NSString *)aUrlString  movieModel:(MZMPMovieScalingMode)movieModel frame:(CGRect)frame;
- (void)prepareToPlay;//准备播放
- (void)play;//播放
- (void)pause;//暂停
- (void)stop;//停止
- (BOOL)isPlaying;//是否播放
- (void)shutdown;
- (int64_t)trafficStatistic;//实时下载速度
- (float)dropFrameRate;//bit率

-(void)setViewFrame:(CGRect)frame;

- (void)setPauseInBackground:(BOOL)pause;//有背景方式暂停
-(BOOL)getPauseInBackground;//获取背景是否暂停 NO=后台不暂停 YES=后台暂停
- (BOOL)isVideoToolboxOpen;//解码器是否开启 是否开始解码

+ (void)setLogReport:(BOOL)preferLogReport;//是否开启日志
+ (void)setLogLevel:(MZLogLevel)logLevel;//设置指定位置log输出
+ (BOOL)checkIfFFmpegVersionMatch:(BOOL)showAlert;//检查ffmpeg版本匹配
+ (BOOL)checkIfPlayerVersionMatch:(BOOL)showAlert
                          version:(NSString *)version;//检查player版本匹配
- (void)didShutdown;//关闭




@end

