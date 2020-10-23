
 //  Created by vhallrd01 on 13-12-25.
 //  Copyright (c) 2013年 vhallrd01. All rights reserved.
 

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;
@property (nonatomic ,strong)UILabel *badgeLable;
/// 变成圆角
-(instancetype)roundChangeWithRadius:(CGFloat)radius;

/// 给当前view添加指定角度的圆角，默认4个角
- (void)mz_setCornerRadius:(CGFloat)radius;
/// 给当前view添加指定角度的圆角，自定义哪几个角
- (void)mz_setCornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)corners;
/// 给当前view添加高度一半的圆角，默认4个角
- (void)mz_setCornerRadiusOfHalfHeight;
/// 给当前view添加高度一半的圆角，自定义哪几个角
- (void)mz_setCornerRadiusOfHalfHeightWithRectCorner:(UIRectCorner)corners;

/// 设置边框
-(instancetype)borderWithColor:(UIColor *)color :(CGFloat)borderWidth;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;
@end
