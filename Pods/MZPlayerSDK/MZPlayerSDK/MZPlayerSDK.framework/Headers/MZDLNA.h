//
//  MZDLNA.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZCLUPnPDevice.h"

@protocol MZDLNADelegate <NSObject>
@optional
/**
 * @brief DLNA局域网搜索设备结果
 * @param devicesArray <MZCLUPnPDevice *> 搜索到的设备
 */
- (void)searchDLNAResult:(NSArray *)devicesArray;

/**
 * @brief 投屏成功开始播放
 */
- (void)dlnaStartPlay;

@end

@interface MZDLNA : NSObject

@property(nonatomic,   weak) id<MZDLNADelegate> delegate;//代理
@property(nonatomic,   copy) NSString *playUrl;//投屏播放的地址
@property(nonatomic, assign) NSInteger searchTime;//搜索时间

@property(nonatomic, strong) MZCLUPnPDevice *device;//投屏的设备

/**
 * @brief 单例
 * @return self
 */
+(instancetype)sharedMZDLNAManager;

/**
 * @brief 搜设备
 */
- (void)startSearch;

/**
 * @brief DLNA开始投屏
 * @param device (MZCLUPnPDevice类型)，从搜索结果的代理获取
 */
- (void)startDLNA:(id)device;

/**
 * @brief DLNA投屏(首先停止)---投屏不了可以使用这个方法
 * 【流程: 停止 ->设置代理 ->设置Url -> 播放】
 */
- (void)startDLNAAfterStop;

/**
 * @brief 退出DLNA
 */
- (void)endDLNA;

/**
 * @brief 播放
 */
- (void)dlnaPlay;

/**
 * @brief 暂停
 */
- (void)dlnaPause;

/**
 * @brief 设置音量
 * @param volume 音量 volume建议传0-100之间字符串
 */
- (void)volumeChanged:(NSString *)volume;

/**
 * @brief 设置播放进度
 * @param seek 秒
 */
- (void)seekChanged:(NSInteger)seek;

/**
 * @brief 播放切集
 * @param url 切集url
 */
- (void)playTheURL:(NSString *)url;

@end
