//
//  MZBaseImageTools.h
//  MZCoreSDKLibrary
//
//  Created by LiWei on 2020/8/5.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ImageUrlCutTypeCustomSize,//初始图片
    ImageUrlCutTypeSmallSize,//小图片（头像）
    ImageUrlCutTypeMiddelSize,//中图片
    ImageUrlCutTypeBigSize//大图片（全屏的）
} ImageUrlCutType;

@interface MZBaseImageTools : NSObject

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
#pragma mark 给imageView设置网络图片
+(void)setWebImageWithImageView:(UIView *)imageView imageUrlStr:(NSString *)imageUrlStr defaltImage:(UIImage *)defaltImage;

@end

NS_ASSUME_NONNULL_END
