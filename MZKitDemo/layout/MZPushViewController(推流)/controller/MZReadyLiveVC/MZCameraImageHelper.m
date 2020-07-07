//
//  MZCameraImageHelper.m
//  MZallIphone
//
//  Created by MZall on 15/9/7.
//  Copyright (c) 2015年 www.MZall.com. All rights reserved.
//

#import "MZCameraImageHelper.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

@interface MZCameraImageHelper() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, assign)            BOOL isBackCamera;

@property (strong, nonatomic) AVCaptureSession *session;                    // 捕获会话
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;     // 捕获输出
@property (strong, nonatomic) UIImage *image;                               // 图片
@property (assign, nonatomic) UIImageOrientation imageOrientation;          // 图片方向
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;          // 预览视图

@end


@implementation MZCameraImageHelper

static MZCameraImageHelper *sharedInstance = nil;

/*
 初始化
 **/
- (void) initialize
{
    NSError *error = nil;
    // 1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    [self resetSession];
    // 2.找到一个合适的采集设备
    _isBackCamera = YES;
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if(device == nil)
    {
        _isBackCamera = NO;
        device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    }
    // 3.创建一个输入设备,并将它添加到会话
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!captureInput){
        NSLog(@"Error: %@", error);
        return;
    }
    [self.session addInput:captureInput];
    
    // 4.创建一个输出设备,并将它添加到会话
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    
//    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
    self.captureOutput.outputSettings = outputSettings;
    
    [self.session addOutput:self.captureOutput];
}

- (void)resetSession
{
    //  设置采集大小
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    else if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPreset640x480;
    }
    else {
        self.session.sessionPreset = AVCaptureSessionPreset640x480;
    }
}

/*
 初始化
 **/
- (id)init
{
    if (self = [super init]){
        [self initialize];
    }
    return self;
}

/*
 插入预览视图到视图中
 **/
- (void)embedPreviewInView: (UIView *) aView {
    if (!self.session){
        return;
    }
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    self.preview.frame = aView.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer: self.preview];
}

/*
 捕获图片
 **/
-(void)captureimage:(void (^)())block{
    // 5.获取连接
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    // 6.获取图片
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, nil);
        if (exifAttachments) {
            // Do something with the attachments.
        }
        // 获取图片数据
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *t_image = [[UIImage alloc] initWithData:imageData];
        self.image = t_image;
//        self.image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.5 orientation:UIImageOrientationRight];
        if(block)
            block();
    }];
}

/*
 改变预览方向
 **/
- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [CATransaction begin];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.imageOrientation = UIImageOrientationRight;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;

    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.imageOrientation = UIImageOrientationLeft;
        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    [CATransaction commit];
}

#pragma mark   切换摄像头
- (void)swapCameras:(BOOL)isBack{
//    if(_isBackCamera == isBack) return;
    _isBackCamera = isBack;
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs )
    {
        [_session beginConfiguration];
        [_session removeInput:input];
        [_session commitConfiguration];
    }

    AVCaptureDevice *newCamera = nil;
    if (!isBack)
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
    else
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
    NSError *nserror = nil;
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&nserror];
    if (nserror) {
        //        NSLog(@"Failed to get video device input: %@", nserror);
        return;
    }
    [_session beginConfiguration];
    [_session addInput:input];
    [_session commitConfiguration];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

#pragma mark Class Interface
/*
 private
 实例化 CameraImageHelper
 **/
+ (MZCameraImageHelper *) sharedInstance{
    if(!sharedInstance){
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

/*
 开始运行
 **/
+ (void) startRunning{
    [[self sharedInstance] resetSession];
    [[[self sharedInstance] session] startRunning];
}

/*
 停止运行
 **/
+ (void) stopRunning{
    [[[self sharedInstance] session] stopRunning];
    AVAuthorizationStatus avAuthorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(avAuthorizationStatus == AVAuthorizationStatusAuthorized){//在摄像头可用情况下，默认切换到前置摄像头
        [self swapCameras:NO];
    }
}

/*
 获取图片
 **/
+ (UIImage *) image{
    return [[self sharedInstance] image];
}

/*
 获取静止的图片
 **/
+(void)captureStillImage:(void (^)())block{
    [[self sharedInstance] captureimage:block];
}

/*
 插入预览视图到主视图中
 **/
+ (void)embedPreviewInView: (UIView *) aView{
    [[self sharedInstance] embedPreviewInView:aView];
}

/*
 改变预览视图的方向
 **/
+ (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [[self sharedInstance] changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation];
}

/*
切换摄像头
 **/
+ (void)swapCameras:(BOOL)isBack{
    [[self sharedInstance] swapCameras:isBack];
}

+ (BOOL)isBackCamera
{
    return  [[self sharedInstance] isBackCamera];
}

@end
