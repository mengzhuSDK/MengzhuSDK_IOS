//
//  UIViewController+MZShowMessage.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/4/21.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "UIViewController+MZShowMessage.h"

@implementation UIViewController (MZShowMessage)

//显示提示语
-(void)showTextView:(UIView*)view message:(NSString*)message
{
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = 375 / self.view.height;
    }
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake((view.width - 152*space)/2.0, view.height - 44*space, 152*space, 100*space)];
    blackView.backgroundColor = MakeColorRGBA(0x000000, 0.9);
    [view addSubview:blackView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8*space, 0, view.width - 16*space, CGFLOAT_MAX)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16*space];
    label.textColor = [UIColor whiteColor];
    label.text = message;
    [label sizeToFit];
    [blackView addSubview:label];
    CGFloat blackH = label.height + 14*space;
    [blackView roundChangeWithRadius:4*space];
    
    blackView.frame = CGRectMake((view.width - 192*space)/2.0, (view.height - blackH)/2.0, 192*space, blackH);
    label.frame = CGRectMake(8*space, 7*space, 176*space, label.height);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [blackView removeFromSuperview];
    });
}

@end
