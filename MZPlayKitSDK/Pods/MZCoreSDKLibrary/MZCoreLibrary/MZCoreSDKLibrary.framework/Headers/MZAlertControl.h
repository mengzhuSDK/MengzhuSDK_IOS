//
//  MZAlertControl.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/9/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MZResultType) {
    MZResultTypeSure = 1,
    MZResultTypeCancel = -1,
    MZResultTypeOther = 2,
};

@interface MZAlertControl : NSObject

/**
 显示 UIAlertController （不带输入框，可以自定义多个菜单）
 
 @note MZResultCode 确定/取消/Other，如果code是Other的值，则actionTitle是自定义菜单的点击的字符串
 */
+ (void)showAlertTitle:(NSString *)title
               message:(NSString *)message
           cancelTitle:(NSString *)cancelTitle
             sureTitle:(NSString *)sureTitle
        preferredStyle:(UIAlertControllerStyle)preferredStyle
                 block:(void (^)(MZResultType type))block;

/**
 显示 UIAlertController（带输入框，不可以自定义多个菜单）
 
 @note MZResultCode 确定/取消，  inputString 输入的字符串
 */
+ (void)showInputAlertTitle:(NSString *)title
                    message:(NSString *)message
                cancelTitle:(NSString *)cancelTitle
                  sureTitle:(NSString *)sureTitle
                      block:(void (^)(MZResultType type, NSString *inputString))block;

@end

NS_ASSUME_NONNULL_END
