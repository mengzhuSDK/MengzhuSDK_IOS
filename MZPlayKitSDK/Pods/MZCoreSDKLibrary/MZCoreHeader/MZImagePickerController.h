//
//  MZImagePickerController.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/9/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ImagePickerResultCode) {
    ImagePickerResultCodeSuccessed = 1,//已选择
    ImagePickerResultCodeCancel,//取消
    ImagePickerResultCodeError,//出错
};

@interface MZImagePickerController : NSObject

/** 显示 拍照/从相册选择 的alert 不压缩*/
- (void)showImagePickerAlert:(void(^)(ImagePickerResultCode code, UIImage *_Nullable image))block;

@end

NS_ASSUME_NONNULL_END
