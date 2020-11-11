//
//  MZPushStreamConst.h
//  MZPushFlowSDK
//
//  Created by 李风 on 2020/7/8.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 直播状态

///直播状态
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


#pragma mark - 视频定义

/// 直播视频分辨率
typedef NS_ENUM (NSUInteger, MZCaptureSessionPreset){
    /// 低分辨率
    MZCaptureSessionPreset360x640 = 0,
    /// 中分辨率
    MZCaptureSessionPreset540x960 = 1,
    /// 高分辨率
    MZCaptureSessionPreset720x1280 = 2
};

/// 美颜等级
typedef NS_ENUM (NSUInteger, MZBeautyFaceLevel){
    /// 美颜等级无
    MZBeautyFaceLevel_None = 9,
    /// 美颜等级低
    MZBeautyFaceLevel_Low = 0,
    /// 美颜等级中
    MZBeautyFaceLevel_Medium = 1,
    /// 美颜等级高
    MZBeautyFaceLevel_High = 2,
    /// 美颜等级最高
    MZBeautyFaceLevel_VeryHigh = 3,
};

#pragma mark - 音频定义

/// 直播音频质量
typedef NS_ENUM(NSUInteger, MZLiveAudioQuality) {
    /// 低音频质量 audio sample rate: 16KHz audio bitrate: numberOfChannels 1 : 32Kbps  2 : 64Kbps
    MZLiveAudioQuality_Low = 0,
    /// 中音频质量 audio sample rate: 44.1KHz audio bitrate: 96Kbps
    MZLiveAudioQuality_Medium = 1,
    /// 高音频质量 audio sample rate: 44.1MHz audio bitrate: 128Kbps
    MZLiveAudioQuality_High = 2,
    /// 超高音频质量 audio sample rate: 48KHz, audio bitrate: 128Kbps
    MZLiveAudioQuality_VeryHigh = 3,
};

/// 直播音频码率 (默认96Kbps)
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

/// 直播音频采样率 (默认44.1KHz)
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
