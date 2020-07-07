//
//  MZRefreshAutoGifFooter.h
//  MZRefreshExample
//
//  Created by MZ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MZRefreshAutoStateFooter.h"

@interface MZRefreshAutoGifFooter : MZRefreshAutoStateFooter
@property (weak, nonatomic, readonly) UIImageView *gifView;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MZRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MZRefreshState)state;
@end
