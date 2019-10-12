//
//  VHMyButton.h
//  VhallIphone
//
//  Created by vhall on 15/8/21.
//  Copyright (c) 2015年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZMyButton : UIButton
@property(nonatomic,strong)id tagData;
- (void)setBadgeValue:(NSInteger)badgeValue badgeColor:(UIColor *)badgeColor badgeValueColor:(UIColor *)badgeValueColor valueFont:(UIFont *)font;
-(void)setBadgeValue:(NSInteger)badgeValue;
@end
