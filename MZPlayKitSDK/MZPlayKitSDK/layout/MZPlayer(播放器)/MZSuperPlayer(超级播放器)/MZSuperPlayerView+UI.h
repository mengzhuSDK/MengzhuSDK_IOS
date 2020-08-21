//
//  MZSuperPlayerView+UI.h
//  MZKitDemo
//
//  Created by 李风 on 2020/7/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZSuperPlayerView.h"
#import "MZTipGoodsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZSuperPlayerView (UI)

/// 获取主播暂时离开的View
- (UILabel *)creatUnusualTipView;

/// 获取直播结束的View
- (UILabel *)creatRealyEndView;

/// 获取循环播放的View
- (MZTipGoodsView *)creatSpreadTipGoodsView;

@end

NS_ASSUME_NONNULL_END
