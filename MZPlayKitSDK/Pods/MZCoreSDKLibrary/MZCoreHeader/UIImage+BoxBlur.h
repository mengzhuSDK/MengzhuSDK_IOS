//
//  UIImage+BoxBlur.h
//  LiveBlurView
//
//  Created by Alex Usbergo on 7/3/13.
//  Copyright (c) 2013 Alex Usbergo. All rights reserved.
//
// algorithm from: http://indieambitions.com/idevblogaday/perform-blur-vimage-accelerate-framework-tutorial/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+IndieAmbitions+%28Indie+Ambitions%29


#import <UIKit/UIKit.h>

@interface UIImage (BoxBlur)

/* blur the current image with a box blur algoritm */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur;
- (UIImage *)blurryImageWithBlurLevel:(CGFloat)blur;
-(UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius;
//压缩在150K左右方便上传加载
-(UIImage *)compressedImage;

//按16:9裁剪
-(UIImage *)clipSizeImage;

@end
