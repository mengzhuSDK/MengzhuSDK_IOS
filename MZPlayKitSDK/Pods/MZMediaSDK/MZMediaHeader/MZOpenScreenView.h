//
//  MZOpenScreenView.h
//  MZMediaSDK
//
//  Created by LiWei on 2020/9/14.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZOpenScreenDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MZVideoOpenADViewProtocol <NSObject>
/// 点击图片的回调 link 图片对应的连接
- (void)videoOpenADViewTapImageLink:(NSString *)link;
/// 图片全部加载完成
- (void)ADScrollViewLoadImagesSuccess;
/// 图片全部加载失败
- (void)ADScrollViewLoadImagesFailure;
/// 开屏广告界面关闭的回调
- (void)videoOpenADViewClose;

 /// 开屏广告接口请求返回数据
/// @param data 原始数据回调
/// @param modelData 解析数据回调
/// @param error 错误回调
- (void)ADOpenScreenDataIsReadyWithSuccessData:(id)data modelData:(MZOpenScreenDataModel *)modelData error:(NSError *)error;

@end

@interface MZOpenScreenView : UIView

@property (nonatomic ,strong) UIButton *ignoreButton;//跳过按钮
@property (nonatomic ,strong) UIView *dotBGView; //页码指示器背景
@property (nonatomic ,strong) UIView *currentDot;//当前页展示view
@property (nonatomic ,strong) UILabel *tipLabel;//暖场图提示


@property (nonatomic ,weak) id<MZVideoOpenADViewProtocol> delegate;//代理

/// 调用这个方法可以一键自动请求数据，无需设置图片(若需要传图片，自行传图片相关数组)
/// @param ticket_id 视频ID
/// @param delegate 代理
- (instancetype)initializationADViewWithTicketID:(NSString *)ticket_id delegate:(id<MZVideoOpenADViewProtocol>)delegate;

/// 获取接口返回数据
- (MZOpenScreenDataModel *)getOpenScreenADData;


/// 调用这个方法可以直接展示图片链接
/// @param imageUrlArray 图片链接数组
/// @param showTime 展示的时间
/// @param delegate MZVideoOpenADViewProtocol代理
- (instancetype)initializationADViewWithImageUrlArray:(NSMutableArray <NSString *> *)imageUrlArray showTime:(NSInteger)showTime delegate:(id<MZVideoOpenADViewProtocol>)delegate;

/// 调用这个方法可以直接展示图片
/// @param imageArray 图片数组
/// @param showTime 展示的时间
/// @param delegate MZVideoOpenADViewProtocol代理
- (instancetype)initializationADViewWithImageArray:(NSMutableArray <UIImage *> *)imageArray showTime:(NSInteger)showTime delegate:(id<MZVideoOpenADViewProtocol>)delegate;

/// 强制关闭开场图页面，***没有回调，倒计时结束
- (void)closeTheOpenADViewNOCallBack;

@end

NS_ASSUME_NONNULL_END
