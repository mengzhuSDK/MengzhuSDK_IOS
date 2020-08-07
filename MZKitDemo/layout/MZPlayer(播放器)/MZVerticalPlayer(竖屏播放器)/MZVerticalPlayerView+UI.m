//
//  MZVerticalPlayerView+UI.m
//  MZKitDemo
//
//  Created by 李风 on 2020/7/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZVerticalPlayerView+UI.h"

@implementation MZVerticalPlayerView (UI)

/// 获取主播暂时离开的View
- (UILabel *)creatUnusualTipView {
    UILabel *unusualTipView = [[UILabel alloc] initWithFrame:CGRectZero];
    unusualTipView.backgroundColor = MakeColorRGBA(0x000000, 0.6);
    unusualTipView.textAlignment = NSTextAlignmentCenter;
    unusualTipView.textColor = MakeColorRGB(0xffffff);
    unusualTipView.font = [UIFont systemFontOfSize:20*MZ_RATE];
    unusualTipView.text = @"主播暂时离开，\n稍等一下马上回来";
    unusualTipView.numberOfLines = 2;
    return unusualTipView;
}

/// 获取直播结束的View
- (UILabel *)creatRealyEndView {
    UILabel *realyEndView = [[UILabel alloc]initWithFrame:CGRectZero];
    realyEndView.backgroundColor = MakeColorRGBA(0x000000, 0.6);
    realyEndView.textAlignment = NSTextAlignmentCenter;
    realyEndView.textColor = MakeColorRGB(0xffffff);
    realyEndView.font = [UIFont systemFontOfSize:20*MZ_RATE];
    realyEndView.text = @"直播已结束";
    realyEndView.numberOfLines = 1;
    [realyEndView setHidden:YES];
    return realyEndView;
}

/// 获取循环播放的View
- (MZTipGoodsView *)creatSpreadTipGoodsView {
    MZTipGoodsView *spreadTipGoodsView = [[MZTipGoodsView alloc] initWithFrame:CGRectZero];
    spreadTipGoodsView.alpha = 0;
    spreadTipGoodsView.goodsListModelArr = [NSMutableArray array];
    return spreadTipGoodsView;
}

@end
