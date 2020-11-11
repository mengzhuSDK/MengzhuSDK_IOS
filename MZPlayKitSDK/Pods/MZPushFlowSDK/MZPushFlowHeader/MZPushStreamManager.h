//
//  MZPushStreamManager.h
//  MZMediaSDK
//
//  Created by 孙显灏 on 2018/10/19.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZPushStreamConst.h"

/**
 *  自定义Log，可配置开关（用于替换NSLog）
 */
#define MZPushFlowLog(format,...) MZ_PushFlow_CustomLog(__FUNCTION__,__LINE__,format,##__VA_ARGS__)

void MZ_PushFlow_CustomLog(const char *func, int lineNumber, NSString *format, ...);

@protocol MZAVCaptureDelegate <NSObject>

/**
 * 直播状态的变更
 *
 * @param fromState 更改前的状态
 * @param toState 更改后的状态
 */
- (void)avCapture:(mz_rtmp_state)fromState toState:(mz_rtmp_state)toState;

/**
 * 获取实时码率
 *
 * @param currentBandwidth 带宽
 */
- (void)videoBitrateCurrentBandwidth:(CGFloat)currentBandwidth;

@end


@interface MZPushStreamManager : NSObject
@property (nonatomic,   weak) id<MZAVCaptureDelegate> stateDelegate;//状态变化回调
@property (nonatomic, strong) UIView *preview;//预览view

/**
 * @brief 日志开关
 * @param logEnable 是否打印日志，默认为NO
 */
+ (void)setLogEnable:(BOOL)logEnable;

/**
 * @brief 视频推流初始化 - 推荐此方法 (码率，帧率fps，音频, 都是根据分辨率自动配置的最优选项)
 *
 * @param videoSessionPreset 视频分辨率 参考 MZCaptureSessionPreset
 * @param outputImageOrientation 直播方向
 * @return self
 */
- (instancetype)initWithVideoSessionPreset:(MZCaptureSessionPreset)videoSessionPreset
                    outputImageOrientation:(UIInterfaceOrientation)outputImageOrientation;

/**
 * @brief 视频推流初始化 - 自定义帧率，码率
 *
 * @param videoSessionPreset 分辨率 参考 MZCaptureSessionPreset
 * @param videoBitRate 码率 单位是 bps（范围 400*1000 - 1440*1000）
 * @param videoFrameRate 帧率fps （范围 10 - 30）
 * @param outputImageOrientation 直播方向
 * @return self
 */
- (instancetype)initWithVideoSessionPreset:(MZCaptureSessionPreset)videoSessionPreset
                              videoBitRate:(NSUInteger)videoBitRate
                            videoFrameRate:(NSUInteger)videoFrameRate
                    outputImageOrientation:(UIInterfaceOrientation)outputImageOrientation;

/**
 * @brief 音频推流初始化 - 推荐此方法 （码率，采样率，都是根据音频质量自动适配的最优选项）（音频推流只支持竖屏）
 *
 * @param audioQuality 音频质量
 * @return self
 */
- (instancetype)initWithAudioQuality:(MZLiveAudioQuality)audioQuality;

/**
 * @brief 音频推流初始化 - 自定义码率，采样率（音频推流只支持竖屏）
 *
 * @param numberOfChannels 声道数目(default 2)
 * @param audioSampleRate 采样率
 * @param audioBitrate 码率
 * @return self
 */
- (instancetype)initWithAudioQuality:(MZLiveAudioQuality)audioQuality
                    numberOfChannels:(NSUInteger)numberOfChannels
                     audioSampleRate:(MZLiveAudioSampleRate)audioSampleRate
                        audioBitrate:(MZLiveAudioBitRate)audioBitrate;

/**
 * 开始直播
 *
 * @param rtmpUrl 推流地址
 * @return 是否成功
 */
- (BOOL)startCaptureWithRtmpUrl:(NSString *)rtmpUrl;

/**
 * 停止直播
 */
- (void)stopCapture;

/**
 * 切换摄像头
 *
 * @param isFront 是否设置为前置摄像头
 */
- (void)switchCameraIsFront:(BOOL)isFront;

/**
 * 美颜开关 主意：此方法不推荐使用，请使用 setBeautyFaceLevel: 方法来控制开关美颜
 */
- (void)setBeautyFace:(BOOL)beautyFace;

/**
  * 美颜等级
 */
- (void)setBeautyFaceLevel:(MZBeautyFaceLevel)beautyFaceLevel;

/**
 * 设置分辨率等级
 */
- (void)setCaptureSessionPreset:(MZCaptureSessionPreset)captureSessionPreset;

/**
 * 镜像开关
 */
- (void)setMirroring:(BOOL)isMirroring;

/**
 * 设置是否静音
 */
- (void)setMute:(BOOL)isMute;

/**
 * 开启闪光灯（只有后置摄像头有此功能）
 */
- (BOOL)setTorch:(BOOL)isTorch;

/**
 * 是否正在推流
 */
- (BOOL)isCapturing;

@end

