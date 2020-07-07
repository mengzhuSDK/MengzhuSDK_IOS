//
//  MZSimpleHud.m
//  MZKitDemo
//
//  Created by 李风 on 2020/4/22.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZSimpleHud.h"

@implementation MZSimpleHud

+ (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *oldHud = [[UIApplication sharedApplication].keyWindow viewWithTag:1101];
        if (oldHud) [oldHud removeFromSuperview];
        
        MZSimpleHud *hud = [[MZSimpleHud alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width-100)/2.0, (UIScreen.mainScreen.bounds.size.height - 100)/2.0, 100, 100)];
        hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [hud.layer setCornerRadius:4];
        hud.tag = 1101;
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.frame = CGRectMake(30, 30, 40, 40);
        [hud addSubview:indicator];
        [indicator startAnimating];
    });
}

+ (void)hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *hud = [[UIApplication sharedApplication].keyWindow viewWithTag:1101];
        if (hud) {
            [UIView animateWithDuration:0.2 animations:^{
                hud.alpha = 0;
            } completion:^(BOOL finished) {
                [hud removeFromSuperview];
            }];
        }
    });
}



@end
