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
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//nil对象处理为@""
#define EmptyForNil(a) [MZGlobalTools emptyForNil:a]

//未倒入通讯录两周后提醒
#define kNumberOfDaysShowAgain   14
#define kTimeFlag                @"timeFlag"
#define kTime                    @"time"

#endif /* MZConstantConfig_h */
