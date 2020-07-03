//
//  MZAlertController.h
//  MZKitDemo
//
//  Created by 李风 on 2020/6/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MZResultCode) {
    MZResultCodeSure = 0,//确定
    MZResultCodeCancel,//取消
};

@interface MZAlertController : NSObject

/**
 * @brief 展示系统的AlertController
 *
 * @param title 标题
 * @param message 内容
 * @param cancelTitle 取消标题
 * @param sureTitle 确定标题
 * @param preferredStyle 弹出模式
 * @param handle 结果回调
 *
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
          cancelTitle:(NSString *)cancelTitle
            sureTitle:(NSString *)sureTitle
       preferredStyle:(UIAlertControllerStyle)preferredStyle
               handle:(void (^)(MZResultCode code))handle;

@end

NS_ASSUME_NONNULL_END
