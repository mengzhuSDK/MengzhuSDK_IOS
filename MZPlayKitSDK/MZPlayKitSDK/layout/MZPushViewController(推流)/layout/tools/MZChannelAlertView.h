//
//  MZChannelAlertView.h
//  MengZhu
//
//  Created by vhall on 16/7/2.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZChannelAlertView : UIView
@property (nonatomic,copy) void(^block)(NSInteger type);//1 左边(不管底部是一个按钮还是两个按钮)   2 右边

//底部一个按钮
- (MZChannelAlertView *)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title btn:(NSString *)btnTitle;

-(instancetype)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title btn:(NSString *)btnTitle btnBackgroundColor:(UIColor *)color;

//底部俩个按钮x
- (MZChannelAlertView *)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn;

- (void)setMessageTextAlignment:(NSTextAlignment)textAlignment;
@end
