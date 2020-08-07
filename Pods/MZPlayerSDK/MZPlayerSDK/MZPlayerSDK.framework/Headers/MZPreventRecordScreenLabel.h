//
//  MZPreventRecordScreenLabel.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/9.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZPreventRecordScreenLabel : UILabel

/// 显示防录屏label
+ (void)showRandomLabelWithShowView:(UIView *)showView text:(NSString *)text;

/// 隐藏防录屏label
+ (void)hideRandomLabel;

/// 更改防录屏的字体颜色
+ (void)updateTextColor:(UIColor *)textColor;

/// 更改防录屏的字号
+ (void)updateFont:(UIFont *)textFont;

/// 更改防录屏的时间间隔 - 最低5秒
+ (void)updateTimeInterval:(NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END
