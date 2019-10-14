//
//  MZPushStreamManager.h
//  MZMediaSDK
//
//  Created by 孙显灏 on 2018/10/19.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MZAVCaptureTypeNone,
    MZAVCaptureTypeSystem,
    MZAVCaptureTypeGPUImage,
} MZAVCaptureType;
typedef enum : NSUInteger {
    MZVideoEncoderTypeNone,
    MZVideoEncoderTypeHWH264,
    MZVideoEncoderTypeSWX264,
} MZVideoEncoderType;

typedef enum : NSUInteger {
    MZAudioEncoderTypeNone,
    MZAudioEncoderTypeHWAACLC,
    MZAudioEncoderTypeSWFAAC,
} MZAudioEncoderType;

typedef enum mz_rtmp_state{
    mz_rtmp_state_idle,//默认情况
    mz_rtmp_state_connecting,//连接中
    mz_rtmp_state_connected,//连接成功
    mz_rtmp_state_opened,//已打开，可以streaming了
    mz_rtmp_state_closed,//关闭，发送后回到idle状态
    mz_rtmp_state_error_write,//写入失败，发送完毕回到open状态
    mz_rtmp_state_error_open,//打开失败，发送后回到idle
    mz_rtmp_state_error_net,//多次连接失败，网络错误
}mz_rtmp_state;
//音频码率
typedef NS_ENUM (NSUInteger, MZLiveAudioBitRate) {
    /// 32Kbps 音频码率
    MZLiveAudioBitRate_32Kbps = 32000,
    /// 64Kbps 音频码率
    MZLiveAudioBitRate_64Kbps = 64000,
    /// 96Kbps 音频码率
    MZLiveAudioBitRate_96Kbps = 96000,
    /// 128Kbps 音频码率
    MZLiveAudioBitRate_128Kbps = 128000,
    /// 默认音频码率，默认为 96Kbps
    MZLiveAudioBitRate_Default = MZLiveAudioBitRate_96Kbps
};

/// 音频采样率 (默认44.1KHz)
typedef NS_ENUM (NSUInteger, MZLiveAudioSampleRate){
    /// 16KHz 采样率
    MZLiveAudioSampleRate_16000Hz = 16000,
    /// 44.1KHz 采样率
    MZLiveAudioSampleRate_44100Hz = 44100,
    /// 48KHz 采样率
    MZLiveAudioSampleRate_48000Hz = 48000,
    /// 默认音频采样率，默认为 44.1KHz
    MZLiveAudioSampleRate_Default = MZLiveAudioSampleRate_44100Hz
};

@protocol MZAVCaptureDelegate <NSObject>
-(void) avCapture:(mz_rtmp_state) fromState toState:(mz_rtmp_state) toState;
@end

@interface MZPushStreamManager : NSObject
//状态变化回调
@property (nonatomic, weak) id<MZAVCaptureDelegate> stateDelegate;
//预览view
@property (nonatomic, strong) UIView *preview;
/**
 初始化（设置默认录音录像配置）
 */
-(instancetype)init:(MZAudioEncoderType)audioEncoderType videoEncoderType:(MZVideoEncoderType)videoEncoderType;

/**
 录音配置
 bitrate;//可自由设置
 channelCount;//可选 1 2
 sampleRate;//可选 44100 22050 11025 5500
 sampleSize;//可选 16 8
 */
-(void) audioConfigDeploy:(long)audioBitrate channelCount:(int)channelCount sampleSize:(int)sampleSize sampleRate:(int)sampleRate;


/**
 视频配置
 width;//可选，系统支持的分辨率，采集分辨率的宽
 height;//可选，系统支持的分辨率，采集分辨率的高
 bitrate;//自由设置
 fps;//自由设置
 dataFormat;//目前软编码只能是X264_CSP_NV12，硬编码无需设置
 orientation;//推流方向
  推流分辨率宽高，目前不支持自由设置，只支持旋转。
  UIInterfaceOrientationLandscapeLeft 和 UIInterfaceOrientationLandscapeRight 为横屏，其他值均为竖屏。
 */
-(void) videoConfigDeploy: (int)width height:(int)height bitrate:(int)bitrate fps:(int)fps dataFormat:(int)dataFormat orientation:(int)orientation;

//开始直播
-(BOOL) startCaptureWithRtmpUrl:(NSString *)rtmpUrl;
//-(BOOL) startCaptureWithRtmpUrl:(NSString *)rtmpUrl isBackstagePush:(BOOL)isBackstagePush;

//停止直播
-(void) stopCapture;

//切换摄像头
-(void) switchCamera;

//美颜开关
- (void)setBeautyFace:(BOOL)beautyFace;

//镜像开关
-(void)setMirroring:(BOOL)isMirroring;

//修改fps
-(void) updateFps:(NSInteger) fps;


-(BOOL) isPlugFlow;
//是否正在推流
-(BOOL) isCapturing;

@end

