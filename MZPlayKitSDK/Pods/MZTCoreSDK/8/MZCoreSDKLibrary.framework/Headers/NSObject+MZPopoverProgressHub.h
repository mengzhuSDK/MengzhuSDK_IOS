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
//显示Progress （再当前控制器或当前view中心显示）
-(void)showProgressDialog;
// 隐藏
-(void)hideProgressDialog;
//指定view的
-(void)showProgressDialog:(UIView*)view;

-(void)hideProgressDialog:(UIView*)view;
//展示点击可以隐藏的ProgressDialog
-(void)showWeakProgressDialog:(UIView*)view;

//显示提示语
-(void)showTextView:(UIView*)view message:(NSString*)message;
-(void)showTextView:(UIView*)view message:(NSString*)message Delay:(int)delay;
-(void)showTextView:(UIView*)view message:(NSString*)message Delay:(int)delay doSomething:(void (^)(void))something;
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
