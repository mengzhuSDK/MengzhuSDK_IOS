//
//  MZConstantConfig.h
//  MZPlayKitSDK
//
//  Created by sunxianhao on 2020/6/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#ifndef MZConstantConfig_h
#define MZConstantConfig_h
/***************************系统相关参数*************************/
#pragma mark 系统相关参数

#define MZ_IOS_ver       [[UIDevice currentDevice] systemVersion]
#define MZ_APP_ver       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define MZ_APP_Build_ver [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//nil对象处理为@""
#define EmptyForNil(a) [MZGlobalTools emptyForNil:a]

//未倒入通讯录两周后提醒
#define kNumberOfDaysShowAgain   14
#define kTimeFlag                @"timeFlag"
#define kTime                    @"time"

#define FontSystemSize(a)                   [UIFont systemFontOfSize:a]
#define ImageName(name)                      [UIImage imageNamed:name]
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define isiPhone      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define MZ_RATE         ([UIScreen mainScreen].bounds.size.width/375.0)//以ip6为标准 ip5缩小 ip6p放大 zoom
#define WeaklySelf(weakSelf)  __weak __typeof(&*self)weakSelf = self

#pragma mark 颜色设置宏

#define MakeColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define MakeColorRGB(hex)  ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:1.0])
#define MakeColorRGBA(hex,a) ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:a])

//（16进制->10进制）
#define _UIColorFromHexadecimal(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define UIColorFromHexadecimal(hexadecimalValue) _UIColorFromHexadecimal(hexadecimalValue, 1.0)
#define UIColorFromHexadecimal_0x(hexadecimalValue) _UIColorFromHexadecimal(0x##hexadecimalValue, 1.0)
#define UIColorAFromHexadecimal_0x(hexadecimalValue, alphaValue) _UIColorFromHexadecimal(0x##hexadecimalValue, alphaValue)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define MZSafeScreenHeight  (IPHONE_X ? ( [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size.height - 34) :  ( [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size.height))
#define MZTotalScreenHeight   [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size.height
#define MZScreenWidth   ([UIApplication sharedApplication].keyWindow.rootViewController.view.bounds.size.width)
#define MZ_SW           ((MZScreenWidth<MZSafeScreenHeight)?MZScreenWidth:MZSafeScreenHeight) // 取小值
#define MZ_SH           ((MZScreenWidth<MZSafeScreenHeight)?MZSafeScreenHeight:MZScreenWidth)

//横屏
#define MZ_FULL_SW    MZ_SH
#define MZ_FULL_SH    MZ_SW
#define MZ_FULL_RATE  ((MZ_FULL_SW/667.0) > 1.15 ? 1.15 : (MZ_FULL_SW/667.0))

#endif /* MZConstantConfig_h */





