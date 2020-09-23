//
//  MZAdvertisementPlayerView.h
//  MZPlayerSDK
//
//  Created by 李风 on 2020/9/9.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZPlayerManager.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * @brief 视频广告的模型
 */
@interface MZAdvertisementModel : NSObject
@property (nonatomic,   copy) NSString *video_id;//视频ID
@property (nonatomic,   copy) NSString *video_name;//视频名称
@property (nonatomic,   copy) NSString *video_url;//视频地址
@property (nonatomic, assign) BOOL allow_skip;//是否允许跳过
@property (nonatomic, assign) int play_frequency;//播放频率 0是仅第一次播放，1是每次播放
@property (nonatomic, assign) BOOL is_watch_video_advert;//是否观看过此广告
@end

/**
 * @brief 视频广告View，如需自定义视频广告界面，视频广告接口可参考MZSDKBusinessManager
 */
@interface MZAdvertisementPlayerView : UIView

@property (nonatomic, strong) UIButton *skipButton;//跳过按钮
@property (nonatomic, strong, readonly) MZAdvertisementModel *advertModel;//广告的模型
@property (nonatomic, strong, readonly) MZPlayerManager *playerManager;//广告播放器句柄，可通过此类获取广告时长等数据

/**
 * @brief 实例化视频广告播放器 - 自动进行播放
 *
 * @param frame frame
 * @param ticketId 直播活动Id
 * @param start 广告开始播放了
 * @param finish 广告播放完毕/跳过的回调
 * @param tapHandler 点击广告回调
 */
- (instancetype)initWithFrame:(CGRect)frame ticketId:(NSString *)ticketId start:(void(^)(void))start finish:(void(^)(void))finish tapHandler:(void(^)(void))tapHandler;

/**
 * @brief 暂停广告
 */
- (void)pause;

/**
 * @brief 继续播放广告
 */
- (void)recoveryPlay;

/**
 * @brief 停止广告 - 停止广告会调用 finish 的block
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
