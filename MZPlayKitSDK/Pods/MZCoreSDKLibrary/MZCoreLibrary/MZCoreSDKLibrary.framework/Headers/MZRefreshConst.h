
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
#define MZWeakSelf __weak typeof(self) weakSelf = self;

// 日志输出
#ifdef DEBUG
#define MZRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define MZRefreshLog(...)
#endif

// 过期提醒
#define MZRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define MZRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define MZRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define MZRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define MZRefreshLabelTextColor MZRefreshColor(90, 90, 90)

// 字体大小
#define MZRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 常量
UIKIT_EXTERN const CGFloat MZRefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat MZRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat MZRefreshFooterHeight;
UIKIT_EXTERN const CGFloat MZRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat MZRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const MZRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const MZRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const MZRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const MZRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const MZRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const MZRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const MZRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const MZRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const MZRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const MZRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const MZRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const MZRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const MZRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const MZRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const MZRefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString *const MZRefreshHeaderLastTimeText;
UIKIT_EXTERN NSString *const MZRefreshHeaderDateTodayText;
UIKIT_EXTERN NSString *const MZRefreshHeaderNoneLastDateText;

// 状态检查
#define MZRefreshCheckState \
MZRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];

// 异步主线程执行，不强持有Self
#define MZRefreshDispatchAsyncOnMainQueue(x) \
__weak typeof(self) weakSelf = self; \
dispatch_async(dispatch_get_main_queue(), ^{ \
typeof(weakSelf) self = weakSelf; \
{x} \
});

