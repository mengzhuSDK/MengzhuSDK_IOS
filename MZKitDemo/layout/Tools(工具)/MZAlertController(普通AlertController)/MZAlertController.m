//
//  MZAlertController.m
//  MZKitDemo
//
//  Created by 李风 on 2020/6/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZAlertController.h"

/// 跳转
static __inline__ __attribute__((always_inline)) void PresentViewController(__unsafe_unretained UIAlertController *alertController) {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    
    [topRootViewController presentViewController:alertController animated:YES completion:^{
    }];
}

@implementation MZAlertController

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
          cancelTitle:(NSString *)cancelTitle
            sureTitle:(NSString *)sureTitle
       preferredStyle:(UIAlertControllerStyle)preferredStyle
               handle:(void (^)(MZResultCode code))handle {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIAlertControllerStyleAlert : preferredStyle];
    
    if (cancelTitle.length) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            handle(MZResultCodeCancel);
        }]];
    }
    
    if (sureTitle.length) {
        [alertController addAction:[UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handle(MZResultCodeSure);
        }]];
    }
    
    PresentViewController(alertController);
}

@end
