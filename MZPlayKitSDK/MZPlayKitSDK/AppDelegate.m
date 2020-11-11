//
//  AppDelegate.m
//  KeepAppActive
//
//  Created by 左博杨 on 2017/3/2.
//  Copyright © 2017年 左博杨. All rights reserved.
//

#import "AppDelegate.h"
#import "MZSDKConfig.h"

@interface AppDelegate ()
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgrounTask;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 设置各组件的日志打印开关
    [self setLogEnable];
    // 初始化SDK
    [[MZSDKInitManager sharedManager] initSDKWithAppID:MZSDK_AppID appSecretKey:MZSDK_SecretKey isTestServer:MZ_is_debug success:^{
        NSLog(@"SDK初始化成功");
    } failure:^(NSError * _Nullable error) {
        NSLog(@"SDK初始化出错 = %@", error.domain);
    }];
    return YES;
}

/// 设置各组件打印开关 - 发布版本的时候建议关闭日志
- (void)setLogEnable {
    // (开启/关闭）播放等相关业务的打印
    [MZSDKInitManager setLogEnable:YES];
    // (开启/关闭) 下载组件的打印 - 下载组件的日志开关可以放在你认为合适的地方
    [[MZDownLoaderCenter shareInstanced] setLogEnable:YES];
    // (开启/关闭) 推流组件的打印 - 推流组件的日志开关可以放在你认为合适的地方
    [MZPushStreamManager setLogEnable:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self backgroundMode];
}

-(void)backgroundMode{
    //创建一个背景任务去和系统请求后台运行的时间
//    self.backgrounTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        [[UIApplication sharedApplication] endBackgroundTask:self.backgrounTask];
//        self.backgrounTask = UIBackgroundTaskInvalid;
//    }];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(applyToSystemForMoreTime) userInfo:nil repeats:YES];
//    [self.timer fire];
}

- (void)applyToSystemForMoreTime {
//    if ([UIApplication sharedApplication].backgroundTimeRemaining < 30.0) {//如果剩余时间小于30秒
//        [[UIApplication sharedApplication] endBackgroundTask:self.self.backgrounTask];
//        self.backgrounTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//            [[UIApplication sharedApplication] endBackgroundTask:self.backgrounTask];
//            self.backgrounTask = UIBackgroundTaskInvalid;
//        }];
//    }
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
