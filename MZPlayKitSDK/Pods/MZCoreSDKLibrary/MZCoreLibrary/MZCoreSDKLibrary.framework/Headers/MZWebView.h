//
//  MZWebView.h
//  MZPlayKitSDK
//
//  Created by 李风 on 2020/7/16.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MZWebViewDelegate <NSObject>

@optional
- (void)loadStart;
- (void)loadFinish;
- (void)loadFail:(NSString * _Nonnull)error;

@end

@interface MZWebView : WKWebView

@property (nonatomic, strong) UIProgressView *progressView;//进度条

- (instancetype)initWithFrame:(CGRect)frame mzDelegate:(id _Nullable)mzDelegate isOpenSafari:(BOOL)isOpenSafari;

/// 重新加载
- (void)reloadView;

/// 加载地址
- (void)loadViewWithRequest:(NSMutableURLRequest * _Nonnull)request;

/// 添加跟h5约定好的 方法名字列表 和 回调方法
- (BOOL)addScriptMessageWithNameList:(NSArray <NSString *> *)nameList handle:(void(^)(NSString * _Nullable methodName))handle;

/// 删除链接中的空白字符和处理中文字符
- (NSString *)deleteBlankSpaceWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
