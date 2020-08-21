//
//  MZSDKSimpleHud.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/6.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZSDKSimpleHud : UIView

// 显示
+ (void)show;
// 隐藏,默认0.2秒后隐藏
+ (void)hide;
// 隐藏几秒后
+ (void)hideAfterDelay:(CGFloat)second;

@end

NS_ASSUME_NONNULL_END
