//
//  MZDownLoadProgressView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/9/16.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZDownLoadProgressView : UIView

/**
 *  进度条背景颜色
 */
@property (nonatomic, strong) UIColor *bgProgressColor;

/**
 *  进度条渐变颜色数组，颜色个数>=2
 *  e.g. @[(id)MQRGBColor(252, 244, 77).CGColor,(id)MQRGBColor(252, 93, 59).CGColor]
 */
@property (nonatomic, strong) NSArray *colorArr;

/**
 *  进度
 */
@property (nonatomic, assign) CGFloat progress;


- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
