//
//  MZBaseView.m
//  MZKitDemo
//
//  Created by LiWei on 2019/10/11.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZBaseView.h"

@implementation MZBaseView

//显示提示语
-(void)showTextView:(UIView*)view message:(NSString*)message
{
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake((view.width - 152*MZ_RATE)/2.0, view.height - 44*MZ_RATE, 152*MZ_RATE, 100*MZ_RATE)];
    blackView.backgroundColor = MakeColorRGBA(0x000000, 0.9);
    [view addSubview:blackView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8*MZ_RATE, 0, view.width - 16*MZ_RATE, CGFLOAT_MAX)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16*MZ_RATE];
    label.textColor = [UIColor whiteColor];
    label.text = message;
    [label sizeToFit];
    [blackView addSubview:label];
    CGFloat blackH = label.height + 22*MZ_RATE;
    blackView.frame = CGRectMake((view.width - 152*MZ_RATE)/2.0, (view.height - blackH)/2.0, 152*MZ_RATE, blackH);
    [blackView roundChangeWithRadius:4*MZ_RATE];
    label.frame = CGRectMake(8*MZ_RATE, 10*MZ_RATE, 136*MZ_RATE, label.height);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [blackView removeFromSuperview];
    });
}
@end
