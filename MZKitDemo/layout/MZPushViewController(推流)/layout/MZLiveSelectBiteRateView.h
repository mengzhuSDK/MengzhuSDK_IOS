//
//  MZLiveSelectBiteRateView.h
//  MengZhu
//
//  Created by xu on 2019/3/12.
//  Copyright © 2019 www.mengzhu.com. All rights reserved.
//

#import "MZBaseView.h"

typedef void(^SelectBiteRateBlock)(NSInteger index);

@interface MZLiveSelectBiteRateView : MZBaseView

@property (nonatomic, copy) SelectBiteRateBlock biteRateBlock;

/*
 titleArray:清晰度列表
 index:所选清晰度索引
 */

- (instancetype)initWithFrame:(CGRect )frame BiteRateArray:(NSArray *)titleArray SelectIndex:(NSInteger)index;

@end

