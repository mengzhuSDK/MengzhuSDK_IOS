//
//  MZPushStreamManager.h
//  MZMediaSDK
//
//  Created by 孙显灏 on 2018/10/19.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//直播状态
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

/// 直播视频分辨率
typedef NS_ENUM (NSUInteger, MZCaptureSessionPreset){
    /// 低分辨率
    MZCaptureSessionPreset360x640 = 0,
    /// 中分辨率
    MZCaptureSessionPreset540x960 = 1,
    /// 高分辨率
    MZCaptureSessionPreset720x1280 = 2
};

@protocol MZAVCaptureDelegate <NSObject>
/**
 * 直播状态的变更
 *
 * @param fromState 更改前的状态
 * @param toState 更改后的状态
 */
-(void) avCapture:(mz_rtmp_state) fromState toState:(mz_rtmp_state) toState;
/**
 * 获取实时码率
 *
 * @param currentBandwidth 带宽
 */
-(void) videoBitrateCurrentBandwidth:(CGFloat)currentBandwidth;
@end

@interface MZPushStreamManager : NSObject
//状态变化回调
@property (nonatomic, weak) id<MZAVCaptureDelegate> stateDelegate;
//预览view
@property (nonatomic, strong) UIView *preview;

/**
 * 初始化
 *
 * @param videoSessionPreset 视频分辨率(码率，帧率fps, 都是根据分辨率自动配置的最优选项)
 * @param outputImageOrientation 直播方向
 * @return self
 */
-(instancetype) initWithVideoSessionPreset:(MZCaptureSessionPreset)videoSessionPreset
                    outputImageOrientation:(UIInterfaceOrientation)outputImageOrientation;

/**
 * 初始化
 *
 * @param videoSessionPreset 分辨率
 * @param videoBitRate 码率 单位是 bps
 * @param videoFrameRate 帧率fps
 * @param outputImageOrientation 直播方向
 * @return self
 */
-(instancetype) initWithVideoSessionPreset:(MZCaptureSessionPreset)videoSessionPreset
                              videoBitRate:(NSUInteger)videoBitRate
                            videoFrameRate:(NSUInteger)videoFrameRate
                    outputImageOrientation:(UIInterfaceOrientation)outputImageOrientation;

/**
 * 开始直播
 *
 * @param rtmpUrl 推流地址
 * @return 是否成功
 */
-(BOOL) startCaptureWithRtmpUrl:(NSString *)rtmpUrl;

/**
 * 停止直播
 */
-(void) stopCapture;

/**
 * 切换摄像头
 *
 * @param isFront 是否设置为前置摄像头
 */
-(void) switchCameraIsFront:(BOOL)isFront;

/**
 * 美颜开关
 */
- (void) setBeautyFace:(BOOL)beautyFace;

/**
 * 镜像开关
 */
-(void) setMirroring:(BOOL)isMirroring;

/**
 * 设置是否静音
 */
-(void) setMute:(BOOL)isMute;

/**
 * 开启闪光灯（只有后置摄像头有此功能）
 */
-(BOOL) setTorch:(BOOL)isTorch;

/**
 * 是否正在推流
 */
-(BOOL) isCapturing;

@end

