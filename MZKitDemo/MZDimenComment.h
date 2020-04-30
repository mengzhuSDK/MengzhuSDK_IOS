//
//  MZAdaptiveComment.h
//  mengzhuIOS
//
//  Created by 孙显灏 on 2019/6/20.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#ifndef MZAdaptiveComment_h
#define MZAdaptiveComment_h
#pragma mark 获取物理屏幕的尺寸

//判断iPhoneX
#define isiPhone      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//是不是iphone X系列（有刘海的设计）
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
//#define iPhoneX       [[UIScreen mainScreen] bounds].size.width >= 375.0f && [[UIScreen mainScreen] bounds].size.height >= 812.0f && isiPhone


#define MZScreenHeight  (IPHONE_X ? ( [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size.height - 34) :  ( [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size.height))
#define MZTotalScreenHeight   [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size.height
#define MZScreenWidth   ([UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size.width)
#define MZ_SW           ((MZScreenWidth<MZScreenHeight)?MZScreenWidth:MZScreenHeight) // 取小值
#define MZ_SH           ((MZScreenWidth<MZScreenHeight)?MZScreenHeight:MZScreenWidth)
#define MZ_RATE         (MZ_SW/375.0)//以ip6为标准 ip5缩小 ip6p放大 zoom
#define MZ_RATE_6P      ((MZ_SW>375.0)?MZ_SW/375.0:1.0)//只有6p会放大
#define MZ_RATE_SCALE   ((MZ_RATE>1)?1:MZ_RATE)         //只有小设备会缩小  6p不放大
#define WeaklySelf(weakSelf)  __weak __typeof(&*self)weakSelf = self

//横屏
#define MZ_FULL_SW    MZ_SH
#define MZ_FULL_SH    MZ_SW
#define MZ_FULL_RATE  ((MZ_FULL_SW/667.0) > 1.15 ? 1.15 : (MZ_FULL_SW/667.0))

#define IS_WIDESCREEN_4                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < __DBL_EPSILON__)
#define IS_WIDESCREEN_5                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6Plus                        (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < __DBL_EPSILON__)
#define IS_IPHONE                                  ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone"] || [[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"])
#define IS_IPOD                                    ([[[UIDevice currentDevice] model] isEqualToString: @"iPod touch"])
#define IS_IPHONE_4                                (IS_IPHONE && IS_WIDESCREEN_4)
#define IS_IPHONE_5                                (IS_IPHONE && IS_WIDESCREEN_5)
#define IS_IPHONE_6                                (IS_IPHONE && IS_WIDESCREEN_6)
#define IS_IPHONE_6Plus                            (IS_IPHONE && IS_WIDESCREEN_6Plus)

#define kStatusBarHeight     [[UIApplication sharedApplication] statusBarFrame].size.height

#define kNavBarHeight 44.0

#define kTabBarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height>20?49:49)//tabBar高

#define kTopHeight    (kStatusBarHeight + kNavBarHeight)//导航栏高

#define KBottomEmptyH   (IPHONE_X ? 34 : 0)  //底部空白区域大小（iPhone X空出来34）


#endif /* MZAdaptiveComment_h */
