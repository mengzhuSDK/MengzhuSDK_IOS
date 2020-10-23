//
//  MZConstantConfig.h
//  MZPlayKitSDK
//
//  Created by sunxianhao on 2020/6/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//
#import "MZBaseGlobalTools.h"

#ifndef MZConstantConfig_h
#define MZConstantConfig_h
/***************************系统相关参数*************************/
#pragma mark 系统相关参数

#define MZ_IOS_ver       [[UIDevice currentDevice] systemVersion]
#define MZ_APP_ver       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define MZ_APP_Build_ver [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//nil对象处理为@""
#define EmptyForNil(a) [MZBaseGlobalTools emptyForNil:a]

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

//竖屏
#define MZ_RATE         (MZ_SW/375.0)//以ip6为标准 ip5缩小 ip6p放大 zoom

//抽象类异常处理
#define AbstractMethodNotImplemented() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
userInfo:nil]

//全局高亮
#define PublicSelectHighlighted UIColorFromRGB(0xF5F5F5, 0.8)

#pragma mark 获取物理屏幕的尺寸

#define KeyWindow [UIApplication sharedApplication].delegate.window
#define KeyWindowView [UIApplication sharedApplication].delegate.window.rootViewController.view
#define KeyRootVC [UIApplication sharedApplication].delegate.window.rootViewController

#define MZScreenHeight  (IPHONE_X ? ( [UIApplication sharedApplication].delegate.window.rootViewController.view.bounds.size.height - 34) :  ( [UIApplication sharedApplication].delegate.window.rootViewController.view.bounds.size.height))

#define MZ_RATE_6P      ((MZ_SW>375.0)?MZ_SW/375.0:1.0)//只有6p会放大
#define MZ_RATE_SCALE   ((MZ_RATE>1)?1:MZ_RATE)

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



#pragma mark - B端的新定义

/// 某个系统版本是否有效
#define kAvailabel(systemVersion) @available(iOS systemVersion, *)

/// 设备宽高
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

/// 这个是设计比例按照实际设备比例的备注,最大1.15倍
#define kMultiple MIN(1.15, [UIScreen mainScreen].bounds.size.width / 375)

/// 切到 主线程
#ifndef MZDispatchAsyncMainQueue
#define MZDispatchAsyncMainQueue(block) dispatch_async(dispatch_get_main_queue(), ^{\
{block}\
});
#endif

/// 几秒之后切到主线程
#ifndef MZDispatchAfterTimeAsyncMainQueue
#define MZDispatchAfterTimeAsyncMainQueue(time, block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
{block}\
});
#endif

/// 切到 全局异步线程(并行)
#ifndef MZDispatchAsyncGlobalQueue
#define MZDispatchAsyncGlobalQueue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{\
{block}\
});
#endif

/// 切到 自定义的异步线程(并行)
#ifndef MZDispatchAsyncCustomQueue
#define MZDispatchAsyncCustomQueue(name, block) dispatch_queue_t customQueue = dispatch_queue_create([name UTF8String], DISPATCH_QUEUE_CONCURRENT);\
dispatch_async(customQueue, ^{\
{block}\
});
#endif

/// 断言
#ifndef MZAssert
#define MZAssert(condition, desc) NSAssert(condition, desc)
#endif

/// 强制内联
#ifndef mz_inline
#define mz_inline __inline__ __attribute__((always_inline))
#endif

static dispatch_semaphore_t mz_semaphore() {
    static dispatch_semaphore_t _semaphore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _semaphore = dispatch_semaphore_create(0);
    });
    return _semaphore;
}

/// 阻塞线程等待任务完成
static mz_inline void MZTaskWaitUntilFinished() {
    if ([NSThread isMainThread]) {
        NSCAssert(0, @"不可以在主线程里阻塞线程");
    }
    dispatch_semaphore_wait(mz_semaphore(), DISPATCH_TIME_FOREVER);
}

/// 任务完成，解锁线程
static mz_inline void MZTaskFinished() {
    dispatch_semaphore_signal(mz_semaphore());
}

/// 比例放大缩小bounds
static mz_inline float kRATE(float value) {
    return value * kMultiple;
}

/// 比例放大缩小字体
static mz_inline float kFont(float value) {
    return value * kMultiple;
}

/// 是否是暗黑模式
static mz_inline BOOL isDark() {
    if (@available(iOS 12.0, *)) {
        return [UIScreen mainScreen].traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
    }
    return false;
}

/// 计算文字宽高度
static mz_inline CGSize MZGetContentSize(__unsafe_unretained NSString *content, CGSize size, double font) {
    UIFont *curFont = [UIFont systemFontOfSize:font];
    CGRect contentBounds = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:curFont forKey:NSFontAttributeName] context:nil];
    return contentBounds.size;
}

/// 状态栏的高
#define kStatusBarHeight   (IPHONE_X ? 44 : 20)

/// 导航栏的高
#define kNavBarHeight 44.0

/// 状态栏 + 导航栏 的高
#define kTopHeight    (kStatusBarHeight + kNavBarHeight)

/// 屏幕底部的安全高度
#define KBottomEmptyH   (IPHONE_X ? 34 : 0)

/// tabBar高
#define kTabBarHeight     49


#endif /* MZConstantConfig_h */

