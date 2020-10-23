//
//  MZUploadVideoModel.h
//  MZUploadVideoSDK
//
//  Created by 李风 on 2020/10/12.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MZUploadVideoState_NoStart = 0,//未开始
    MZUploadVideoState_Uploading,//上传中
    MZUploadVideoState_Pause,//暂停
    MZUploadVideoState_Finish,//完成
    MZUploadVideoState_Fail,//失败
    MZUploadVideoState_Cancel,//取消
} MZUploadVideoState;

@interface MZUploadConfig : NSObject
@property (nonatomic, copy) NSString *bucket;//文件上传到的空间
@property (nonatomic, copy) NSString *accessKeyId;//上传的权限ID
@property (nonatomic, copy) NSString *accessKeySecret;//上传的权限密钥
@property (nonatomic, copy) NSString *stsToken;//文件上传的token
@property (nonatomic, copy) NSString *Expiration;//token到期时间
@end

@interface MZUploadVideoModel : NSObject
@property (nonatomic, strong) MZUploadConfig *config;//文件上传的配置，服务器返回

@property (nonatomic,   copy) NSString *directory;//上传视频的路径，服务器路径，服务器返回
@property (nonatomic,   copy) NSString *video_name;//上传视频名字，服务器生成，唯一，断点续传以此为准

@property (nonatomic,   copy) NSString *videoFullPath;//上传视频的本地完整路径
@property (nonatomic,   copy) NSString *videoObjectKey;//上传视频的唯一key，可以用来寻找本地文件的唯一相对路径
@property (nonatomic,   copy) NSString *file_name;//用户自定义的视频名字

@property (nonatomic, assign) int64_t file_size;//文件大小，任务开始之后有进度之后才有值
@property (nonatomic, assign) MZUploadVideoState state;//任务状态
@property (nonatomic, assign) CGFloat progress;//下载进度 range 0.0-1.0

@property (nonatomic, strong) id request;//该上传任务的请求

typedef void(^UpdateProgressBlock)(int64_t totalByteSent, int64_t totalBytesExpectedToSend, CGFloat progress);
@property (nonatomic,   copy) UpdateProgressBlock _Nullable progressBlock;//进度监听

typedef void(^UploadResultBlock)(id _Nullable response, NSError * _Nullable error);
@property (nonatomic,   copy) UploadResultBlock _Nullable resultBlock;//上传结果监听

@end

NS_ASSUME_NONNULL_END
