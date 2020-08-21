//
//  MZCameraViewController.h
//  MengZhu
//
//  Created by vhall on 16/12/2.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^imageBlock)(UIImage * clipImage,UIImage * allSizeImage);
@interface MZCameraViewController : UIViewController

@property (nonatomic,assign) BOOL isFontCamera; //设置是否为前置摄像头,默认后置
@property (nonatomic,assign) BOOL isAllSizeImage; //当设置为YES，block返回（nil,allSizeImage);当为NO,block返回（clipImage,allSizeImage)

@property (nonatomic,assign) CGFloat ratio;//宽高比（宽已整个屏幕的宽）

@property (nonatomic,copy) imageBlock block;
@end
