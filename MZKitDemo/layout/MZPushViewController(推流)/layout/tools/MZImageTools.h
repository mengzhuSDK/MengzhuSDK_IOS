//
//  MZImageTools.h
//  MengZhu
//
//  Created by vhall.com on 16/8/19.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ImageUrlCutTypeCustomSize,//初始图片
    ImageUrlCutTypeSmallSize,//小图片（头像）
    ImageUrlCutTypeMiddelSize,//中图片
    ImageUrlCutTypeBigSize//大图片（全屏的）
} ImageUrlCutType;

@interface MZImageTools : NSObject

+ (void)headBtnDidClickWithIsAfter:(BOOL)IsAfter controller:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)controller isCanEdit:(BOOL)isCanEdit;
/*
 *  压缩图片，10M以及以上，压缩至0.1，5~10M压缩至0.2，2~5M,压缩至0.4，1~2 压缩至0.8
 */
+ (NSData *)compressionImage:(UIImage *)image;
//将Http的图片链接变为https
+(NSString *)changeHttpUrlToHttpsWithUrl:(NSString *)url;

//拼接网络图片链接(其中的size，网络直接按宽高中最小的值得出等比例的图片ps：size必须为10的倍数才可以)
+(NSString *)shareImageWithImageUrl:(NSString *)imageUrl Size:(CGSize)size;
//拼接网络图片链接(其中的size，网络直接按宽高中最小的值得出等比例的图片ps：size必须为10的倍数才可以),小尺寸 240X240,中尺寸480X270,大尺寸 970X540
+(NSString *)shareImageWithImageUrl:(NSString *)imageUrl imageCutType:(ImageUrlCutType)imageCutType;

+(NSURL *)returnDefineImageSizeUrl:(NSString *)imageUrl Size:(CGSize)size;


@end
