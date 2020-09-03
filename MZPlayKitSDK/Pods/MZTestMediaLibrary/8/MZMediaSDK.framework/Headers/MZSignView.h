//
//  MZSignView.h
//  MZPlayerSDK
//
//  Created by 李风 on 2020/7/14.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZMoviePlayerModel.h"
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MZSignMethodTypeClose = 0,//关闭
    MZSignMethodTypeSignIn,//签到完成
    MZSignMethodTypeLoadStart,//签到页面开始加载
    MZSignMethodTypeLoadFinish,//签到页面加载完成
    MZSignMethodTypeLoadFail,//签到页面加载失败
} MZSignMethodType;

@interface MZSignView : UIView

@property (nonatomic, strong) UIView *headerView;//顶部的标题栏
@property (nonatomic, strong) UILabel *menuLabel;//标题
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮
@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) MZWebView *signWebView;//signWebView

/// 初始化签到View（自动计算frame）
- (instancetype)initWithSignInfo:(MZSignInfo *)info closeHandle:(void(^)(MZSignMethodType methodType, NSString *message))handle;

/// 显示
- (void)showSignView:(NSString *)URLString;

/// 隐藏
- (void)hideSignView;

@end

NS_ASSUME_NONNULL_END
