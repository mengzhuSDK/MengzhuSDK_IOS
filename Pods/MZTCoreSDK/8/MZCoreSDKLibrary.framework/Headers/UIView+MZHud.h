//
//  UIView+MZHud.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MZHud)

- (void)showHud;
- (void)hideHud;

- (void)show:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
