//
//  MZRollingADView.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/9/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZRollingADPresenter.h"
#import "MZRollingADModel.h"
#import "MZRollingPageControl.h"
#import "MZRollingADCollectionView.h"
#import "MZRollingADCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZRollingADView : UIView

@property (nonatomic, strong) MZRollingPageControl *pageControl;//页数索引
@property (nonatomic, strong) MZRollingADCollectionView *collectionView;//collectionView
@property (nonatomic, strong, readonly) NSArray <MZRollingADModel *> *dataArray;//数据源

/**
 * @brief 实例化滚动广告的view
 *
 * @param frame frame
 * @param ticketId 直播活动ID
 * @param initResultHandler 初始化结果，如果失败，该View的高度自动置为0
 * @param selectADHandler 点击广告的回调, 回调里使用weakSelf
 * @return self
 */
- (instancetype)initWithFrame:(CGRect)frame ticketId:(NSString *)ticketId initResultHandler:(void(^)(BOOL isSuccess))initResultHandler selectADHandler:(void(^)(MZRollingADModel *adModel))selectADHandler;

/**
 * @brief 刷新广告数据源
 *
 * @param data 广告数据源
 */
- (void)refresh:(NSArray <MZRollingADModel *> *)data;

@end

NS_ASSUME_NONNULL_END
