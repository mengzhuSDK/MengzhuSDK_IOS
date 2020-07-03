//
//  MZSmallPlayerView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/11.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZSmallPlayerView : UIView

/// 显示小窗口
+ (void)show:(MZMediaPlayerView *)playView finished:(void(^)(void))finished;

/// 隐藏小窗口
+ (void)hide;

@end

NS_ASSUME_NONNULL_END
