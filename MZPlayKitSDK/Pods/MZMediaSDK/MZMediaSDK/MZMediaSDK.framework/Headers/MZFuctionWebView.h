//
//  MZFuctionWebView.h
//  MZMediaSDK
//
//  Created by LiWei on 2020/9/14.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{//以后有功能再拓展
    MZFuctionWebPrizeType = 1 ,  //抽奖
    MZFuctionWebOtherType
} MZFuctionWebType;

typedef enum{//以后有功能再拓展
    MZFuctionMethodTypeClose = 1,//关闭
    MZFuctionMethodTypeLoadStart,//签到页面开始加载
    MZFuctionMethodTypeLoadFinish,//签到页面加载完成
    MZFuctionMethodTypeLoadFail,//签到页面加载失败
    MZFuctionMethodClickType1,//功能回调（自己加的事件回调）
    MZFuctionMethodClickType2,//功能回调
    MZFuctionMethodTypeOther,//其他
} MZFuctionMethodWebType;

typedef void(^SDKTopMenuViewCloseHandler)(void);

@interface MZSDKTopMenuView : UIView
@property (nonatomic, strong) UILabel *menuLabel;//标题
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮

@property (nonatomic, copy) SDKTopMenuViewCloseHandler closeHandler;//关闭的句柄
@end

@interface MZFuctionWebView : UIView

@property (nonatomic, strong) MZSDKTopMenuView *topMenuView;//顶部标题栏
@property (nonatomic, strong) MZWebView *fuctionWebView;//webView
@property (nonatomic, strong) UIView *bgView;//弹出背景View

/// 初始化功能view
/// @param fuctionWebType 功能类型
/// @param url 网址url
- (instancetype)initWithFuctionWebType:(MZFuctionWebType)fuctionWebType url:(NSString *)url closeHandle:(void(^)(MZFuctionMethodWebType methodType, NSString *message))handle;


/// 网页添加监听方法
/// @param ScriptArr 方法名字数组
/// @param callBackBlock 监听到的回调
- (void)addScriptMessageWithScriptArr:(NSArray *)ScriptArr callBackBlock:(void(^)(NSString * _Nullable methodName))callBackBlock;

/// 展示半窗view
/// @param URLString 链接
- (void)showWebView:(NSString *)URLString;

@end

NS_ASSUME_NONNULL_END
