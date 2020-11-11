//
//  NSObject+MZPopoverProgressHub.h
//  MengZhu
//
//  Created by LiWei on 2020/4/16.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MZPopoverProgressHub)
//显示Progress （在当前控制器或当前view中心显示）
-(void)showProgressDialog;
// 隐藏toast提示
-(void)hideProgressDialog;
//指定view的
-(void)showProgressDialog:(UIView*)view;
//隐藏某个view上提示
-(void)hideProgressDialog:(UIView*)view;
//展示点击可以隐藏的ProgressDialog
-(void)showWeakProgressDialog:(UIView*)view;


/// 在某个view上显示toast提示，停留时间默认1.5s
/// @param view 要显示的view
/// @param message 显示的文字
-(void)showTextView:(UIView*)view message:(NSString*)message;
/// 在某个view上显示toast提示，停留时间可以自定义
/// @param view 要显示的view
/// @param message 显示的文字
/// @param Delay 停留时间
-(void)showTextView:(UIView*)view message:(NSString*)message Delay:(int)delay;
/// 在某个view上显示toast提示，停留时间可以自定义
/// @param view 要显示的view
/// @param message 显示的文字
/// @param Delay 停留时间
/// @param doSomething 回调方法
-(void)showTextView:(UIView*)view message:(NSString*)message Delay:(int)delay doSomething:(void (^)(void))something;


/// 展示系统的alertview提示
/// @param title 展示标题
/// @param message 展示信息
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

/// 展示系统的alertview提示（可自定义确定按钮）
/// @param title 展示标题
/// @param message 展示信息
/// @param sureTitle  确定按钮的标题
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle;
@end

NS_ASSUME_NONNULL_END
