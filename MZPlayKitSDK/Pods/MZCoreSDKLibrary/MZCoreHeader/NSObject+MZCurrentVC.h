//
//  NSObject+MZCurrentVC.h
//  MZUILibrary
//
//  Created by 李风 on 2020/7/22.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 
 这个需要放到核心组件里。
 
 */

@interface NSObject (MZCurrentVC)

/// 获取当前控制器
- (UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END
