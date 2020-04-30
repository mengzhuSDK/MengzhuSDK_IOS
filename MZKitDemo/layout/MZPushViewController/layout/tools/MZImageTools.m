
//
//  MZImageTools.m
//  MengZhu
//
//  Created by vhall.com on 16/8/19.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZImageTools.h"
#import <AVFoundation/AVFoundation.h>
#import "MZActionSheetView.h"

@implementation MZImageTools


#pragma mark - 点击跳出选择图片的按钮
+ (void)headBtnDidClickWithIsAfter:(BOOL)IsAfter controller:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)controller isCanEdit:(BOOL)isCanEdit
{

    
    [MZActionSheetView dismissActionView];
    [MZActionSheetView initWithMZActionSheetView:^(NSInteger itemFlag,NSString * btnTitle) {
        if (itemFlag == 0) {
            [MZImageTools getPhoto:1 IsAfter:IsAfter controller:controller isCanEdit:isCanEdit];
        }
        if (itemFlag == 1) {
            [MZImageTools getPhoto:2 IsAfter:IsAfter controller:controller isCanEdit:isCanEdit];
        }
    } actionTilte:nil cancelBtnTitle:@"取消" buttonKeys:@"从手机相册选择",@"拍照",nil];
}

#pragma mark - 选择照片的方法
+ (void)getPhoto:(NSInteger)type IsAfter:(BOOL)IsAfter controller:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)controller isCanEdit:(BOOL)isCanEdit
{//相册权限检测
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.navigationBar.barStyle = UIBarStyleBlack;
    pickerController.navigationBar.barTintColor = MakeColor(20, 24, 38, 1);
    pickerController.navigationBar.tintColor = [UIColor whiteColor];
    [pickerController setAllowsEditing:isCanEdit];//设置允许编辑
    pickerController.navigationBar.backIndicatorImage = [[UIImage alloc] init];
    pickerController.navigationBar.backIndicatorTransitionMaskImage = [[UIImage alloc] init];
//    pickerController.editing = YES; 
    pickerController.navigationBar.translucent = NO;
    
    pickerController.delegate = controller;
    if(type == 1){//     如果相册可用
        if (![MZGlobalTools checkMediaDevice:@"ALAssetsLibrary"]){
            return;
        }
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }else if (type == 2){//如果摄像头可用
        if (![MZGlobalTools checkMediaDevice:AVMediaTypeVideo])
            return;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
            [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            if(IsAfter){//如果默认是后置
                if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
                    [pickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
                }
            }
            else{//如果默认是前置
                if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
                    [pickerController setCameraDevice:UIImagePickerControllerCameraDeviceFront];
                }
            }
        }
    }
    [controller presentViewController:pickerController animated:YES completion:nil];
}




+ (NSData *)compressionImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if (data.length > 1024*1024) {
        if (data.length > 10240*1024) {       ///< 10M以及以上
            data = UIImageJPEGRepresentation(image, 0.1); ///< 压缩之后1M~
        } else if (data.length > 5120*1024){  ///< 5M~10M
            data = UIImageJPEGRepresentation(image, 0.2); ///< 压缩之后1M~2M
        } else if (data.length > 2048*1024){  ///< 2M~5M
            data = UIImageJPEGRepresentation(image, 0.4); ///< 压缩之后0.8M~2M
        } else if (data.length > 1024*1024) { ///< 1M
            data = UIImageJPEGRepresentation(image, 0.8); ///< 压缩之后0.8M
        } else {
            ///< 1M以下不压缩
        }
    }
    return data;
}

+(NSString *)changeHttpUrlToHttpsWithUrl:(NSString *)url
{
    NSString *headerStr = [url substringToIndex:5];
    if(![headerStr isEqualToString:@"https"]){
        url = [url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
    }else{
        url = url;
    }
    return url;
}


+(NSString *)shareImageWithImageUrl:(NSString *)imageUrl Size:(CGSize)size
{
    if(size.width == 0 || size.height == 0){
        return imageUrl;
    }else{
        return [NSString stringWithFormat:@"%@?size=%dx%d",imageUrl,(int)size.width,(int)size.height];
    }
}


+(NSString *)shareImageWithImageUrl:(NSString *)imageUrl imageCutType:(ImageUrlCutType)imageCutType
{
    if(imageUrl.length > 0){
        switch (imageCutType) {
            case ImageUrlCutTypeCustomSize:
                return imageUrl;
                break;
            case ImageUrlCutTypeSmallSize:
                return [MZImageTools shareImageWithImageUrl:imageUrl Size:CGSizeMake(240*MZ_RATE, 240*MZ_RATE)];
                break;
            case ImageUrlCutTypeMiddelSize:
                return [MZImageTools shareImageWithImageUrl:imageUrl Size:CGSizeMake(480*MZ_RATE, 270*MZ_RATE)];
                break;
            case ImageUrlCutTypeBigSize:
                return [MZImageTools shareImageWithImageUrl:imageUrl Size:CGSizeMake(970*MZ_RATE, 54*MZ_RATE)];;
                break;
                
            default:
                break;
        }
    }else{
        return @"";
    }
    
}

+(NSURL *)returnDefineImageSizeUrl:(NSString *)imageUrl Size:(CGSize)size
{
    return [NSURL URLWithString:[MZImageTools shareImageWithImageUrl:imageUrl Size:size]];
}

@end
