//
//  MZCameraHelperView.m
//  MengZhu
//
//  Created by vhall on 16/12/1.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZCameraHelperView.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>

static const char *kMZCameraHelperQueueName = "MZCameraHelperQueueName";
#define kImageScale 2.5

@interface MZCameraHelperView()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL _isBackCamera;
}
@property (nonatomic) AVCaptureDevice *captureDevice;
@property (nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation MZCameraHelperView

- (instancetype)initWithMZCameraHelperView:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self startReading:frame];
    }

    return self;
}

- (void)startRuning
{
    [self.layer insertSublayer:_videoPreviewLayer atIndex:0];
    [_captureSession startRunning];
}

- (void)stopRuning
{
    // 停止会话
    [_captureSession stopRunning];
}

- (void)startReading:(CGRect)frame
{
    // 获取 AVCaptureDevice 实例
    NSError * error;
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    captureMetadataOutput.rectOfInterest = CGRectMake(frame.origin.y/MZ_SH,frame.origin.x/MZ_SW, frame.size.height/MZ_SH, frame.size.width/MZ_SW);
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    captureMetadataOutput.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kMZCameraHelperQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:CGRectMake(0, 0, self.width, self.height)];

    // 4.创建一个输出设备,并将它添加到会话
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
    self.captureOutput.outputSettings = outputSettings;
    
    [_captureSession addOutput:self.captureOutput];

}

- (void)setCameraScale:(CGFloat)scale
{
    NSError *error = nil;
    [self.captureDevice lockForConfiguration:&error];
    if (!error) {
        self.captureDevice.videoZoomFactor = scale;
    }
    [self.captureDevice unlockForConfiguration];
}

- (void)setCameraAutoFocus:(BOOL)isAuto
{
    [self.captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
}

- (void)setCameraFocus:(CGPoint)point
{
    if ([self getCurrentCameraIsBack] && (self.captureDevice.focusMode != AVCaptureFocusModeAutoFocus)) {
        NSError *error = nil;
        [self.captureDevice lockForConfiguration:&error];
        if (!error) {
            [self.captureDevice setFocusPointOfInterest:point];
        }
        [self.captureDevice unlockForConfiguration];
    }
}

-(void)captureImageBlock:(void (^)(UIImage * image))block{
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
        if(block)
        {
            block([self dealWithImage:t_image]);
        }
    }];
}

- (UIImage *)dealWithImage:(UIImage *)editedImage
{
    CGRect rect = CGRectMake(0, 0, editedImage.size.height, editedImage.size.width);
    
    return [self image:rect image:editedImage];
}

- (UIImage *)clipImageInRect:(CGRect)rect image:(UIImage *)image
{
    CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(rect.origin.x, rect.origin.y * kImageScale*0.98 , rect.size.width * kImageScale, rect.size.height * kImageScale * 0.90));
    UIGraphicsBeginImageContextWithOptions(rect.size, 0, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), imgRef);
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();
    return newImg;
}

- (UIImage *)image:(CGRect)rect image:(UIImage *)editImge
{
    CGImageRef imageRef=editImge.CGImage;
    CGImageRef imagePartRef=CGImageCreateWithImageInRect(imageRef,rect);
    UIImage* cropImage = [[UIImage alloc]initWithCGImage:imagePartRef scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(imagePartRef);
    cropImage = [MZBaseGlobalTools imageByScalingAndCroppingForSourceImage:cropImage targetSize:CGSizeMake(self.width * kImageScale,self.height * kImageScale)];
    return cropImage;
}


- (void)swapCamera:(BOOL)isBack;
{
    _isBackCamera = isBack;
    NSArray *inputs = self.captureSession.inputs;
    for ( AVCaptureDeviceInput *input in inputs )
    {
        [_captureSession beginConfiguration];
        [_captureSession removeInput:input];
        [_captureSession commitConfiguration];
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
    [_captureSession beginConfiguration];
    [_captureSession addInput:input];
    [_captureSession commitConfiguration];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

- (void)setCameraFlashIsOpen:(BOOL)isOpen
{
    if (_isBackCamera) {
        NSError *error = nil;
        [self.captureDevice lockForConfiguration:&error];
        if (!error) {
            [self.captureDevice setTorchMode:(isOpen ? AVCaptureTorchModeOn : AVCaptureTorchModeOff)];
        }
        [self.captureDevice unlockForConfiguration];
    }
}

- (BOOL)getCurrentCameraIsBack
{
    return _isBackCamera;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
