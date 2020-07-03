//
//  MZPraiseButton.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/8.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZPraiseButton.h"

@interface MZPraiseButton()
@property (nonatomic, assign) NSTimeInterval duration;
@end

@implementation MZPraiseButton

- (void)showPraiseAnimation {
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect frame = self.frame;
    //  初始frame，即设置了动画的起点
    imageView.frame = CGRectMake(frame.size.width - 40, frame.size.height - 65, 30, 30);
    //  初始化imageView透明度为0
    imageView.alpha = 0;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    //  用0.2秒的时间将imageView的透明度变成1.0，同时将其放大1.3倍，再缩放至1.1倍，这里参数根据需求设置
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1.0;
        imageView.frame = CGRectMake(frame.size.width - 40, frame.size.height - 150, 30, 30);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
        imageView.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [self addSubview:imageView];
    //  随机产生一个动画结束点的X值
    CGFloat finishX = frame.size.width - round(random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = frame.size.height - 400;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    //  动画执行时间
    self.duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (self.duration == INFINITY) self.duration = 2.412346;
    // 随机生成一个0~7的数，以便下面拼接图片名
    //    int imageName = round(random() % 8);//  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    //  设置动画时间
    [UIView setAnimationDuration:self.duration];
    //    NSArray *nameArr = @[@"bottom_紫",@"bottom_粉",@"bottom_黄",@"bottom_绿",@"bottom_蓝"];
    //  拼接图片名字
    imageView.image = [UIImage imageNamed:@"bottom_likeImage"];
    
    //  设置imageView的结束frame
    imageView.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:self.duration animations:^{
        imageView.alpha = 0;
    }];
    
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
    imageView = nil;
}

@end
