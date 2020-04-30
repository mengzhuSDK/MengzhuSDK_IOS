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
    // Do any additional setup after loading the view.
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;//设置只要是导航控制器就是竖屏
}

@end
