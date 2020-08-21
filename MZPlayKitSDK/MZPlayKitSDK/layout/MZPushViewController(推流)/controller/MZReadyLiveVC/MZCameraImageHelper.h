//
//  MZCameraImageHelper.h
//  MZallIphone
//  相机图像助手
//  Created by wxx on 15/9/7.
//  Copyright (c) 2015年 www.MZall.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MZCameraImageHelper : NSObject

- (void)resetSession;

/**
 开始运行
 **/
+ (void) startRunning;

/*
 停止运行
 **/
+ (void) stopRunning;

/*
 获取图片
 **/
+ (UIImage *) image;

/*
 获取静止的图片
 **/
+ (void)captureStillImage:(void (^)())block;

/*
 插入预览视图到主视图中
 **/
+ (void)embedPreviewInView: (UIView *)aView;

/*
 改变预览视图的方向
 **/
+ (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;

/*
 切换摄像头
 **/
+ (void)swapCameras:(BOOL)isBack;

//摄像头的状态
+ (BOOL)isBackCamera;
@end
