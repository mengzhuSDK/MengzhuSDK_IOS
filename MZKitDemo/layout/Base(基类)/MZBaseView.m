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
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake((view.width - 202*space)/2.0, view.height - 44*space, 202*space, 100*MZ_RATE)];
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
    CGFloat blackH = label.height + 22*space;
    [blackView roundChangeWithRadius:4*space];
    
    blackView.frame = CGRectMake((view.width - 202*space)/2.0, (view.height - blackH)/2.0, 202*space, blackH);
    label.frame = CGRectMake(8*space, 10*space, 186*space, label.height);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [blackView removeFromSuperview];
    });
}
@end
