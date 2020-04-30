//
//  MZCameraHelperView.h
//  MengZhu
//
//  Created by vhall on 16/12/1.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MZCameraHelperView : UIImageView

/*!
    创建cameraView
 */
- (instancetype)initWithMZCameraHelperView:(CGRect)frame;

/*!
    启动camera
 */
- (void)startRuning;

/*!
    关闭camera
 */
- (void)stopRuning;

/*!
    获取整个相机的全照片
 */
-(void)captureImageBlock:(void (^)(UIImage * image))block;

/*!
    取出图片某一位置的截图
 */
- (UIImage *)clipImageInRect:(CGRect)rect image:(UIImage *)image;

/*!
    切换camera,默认为后摄像头
 */
- (void)swapCamera:(BOOL)isBack;

/*!
    获取当前是否为后置摄像头
 */
- (BOOL)getCurrentCameraIsBack;

/*!
    设置camera是否为自动对焦,默认为NO
 */
- (void)setCameraAutoFocus:(BOOL)isAuto;

/*!
    手动聚焦,point为需要聚焦的点击区域
 */
- (void)setCameraFocus:(CGPoint)point;

/*!
    设置camera的缩放比例
 */
- (void)setCameraScale:(CGFloat)scale;

/*!
    打开或关闭闪光灯
 */
- (void)setCameraFlashIsOpen:(BOOL)isOpen;


@end
