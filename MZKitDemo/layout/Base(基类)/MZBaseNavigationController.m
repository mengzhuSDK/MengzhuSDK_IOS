//
//  MZBaseNavigationController.m
//  MZKitDemo
//
//  Created by 李风 on 2020/4/27.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZBaseNavigationController.h"

@interface MZBaseNavigationController ()

@end

@implementation MZBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return self.topViewController.supportedInterfaceOrientations;
}


/**
    这个是横竖屏控制，直接添加到需要控制的viewcontroller就好
 

 #pragma mark - 横竖屏控制
 - (BOOL)shouldAutorotate {
     return YES;
 }

 - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     if (self.isLandSpace) {
         return UIInterfaceOrientationMaskLandscapeRight;
     }
     return UIInterfaceOrientationMaskPortrait;
 }

 - (void)setIsLandSpace:(BOOL)isLandSpace {
     _isLandSpace = isLandSpace;
     
     if([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
         SEL selector = NSSelectorFromString(@"setOrientation:");
         NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
         [invocation setSelector:selector];
         [invocation setTarget: [UIDevice currentDevice]];
         
         int val = UIInterfaceOrientationPortrait;
         if (_isLandSpace) val = UIInterfaceOrientationLandscapeRight;
         
         [invocation setArgument:&val atIndex:2];

         [invocation invoke];
     }
 }
 
 
 */


@end
