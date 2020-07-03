//
//  VHMyButton.m
//  VhallIphone
//
//  Created by vhall on 15/8/21.
//  Copyright (c) 2015年 www.mengzhu.com. All rights reserved.
//

#import "MZMyButton.h"
@interface MZMyButton()
{
    UILabel *_badgeLable;
}

@end
@implementation MZMyButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setBadgeValue:(NSInteger)badgeValue badgeColor:(UIColor *)badgeColor badgeValueColor:(UIColor *)badgeValueColor valueFont:(UIFont *)font
{
    
    CGFloat badgeW   = self.frame.size.height/3.0;
    if(!_badgeLable){
        _badgeLable = [[UILabel alloc]init];
        [self addSubview:_badgeLable];
    }
    
    _badgeLable.textAlignment = NSTextAlignmentCenter;
    _badgeLable.textColor = badgeValueColor ? :[UIColor whiteColor];
    _badgeLable.font = font ? font :[UIFont systemFontOfSize:12];
    _badgeLable.layer.cornerRadius = badgeW*0.5;
    _badgeLable.clipsToBounds = YES;
    _badgeLable.backgroundColor = badgeColor ? badgeColor : [UIColor redColor];
    
    _badgeLable.frame = CGRectMake(self.frame.size.width - badgeW, - 2*badgeW, badgeW, badgeW);
    
    if(badgeValue <= 0){
        _badgeLable.hidden = YES;
    }else if (badgeValue > 0 && badgeValue < 99){
        _badgeLable.hidden = NO;
        _badgeLable.text = [NSString stringWithFormat:@"%ld",badgeValue];
    }else {
        _badgeLable.hidden = NO;
        _badgeLable.text = @"99+";
    }
    
}

-(void)setBadgeValue:(NSInteger)badgeValue
{
    CGFloat badgeW   = self.titleLabel.frame.size.width/3.0;
    if(!_badgeLable){
        _badgeLable = [[UILabel alloc]init];
        [self.titleLabel addSubview:_badgeLable];
    }
    
    _badgeLable.textAlignment = NSTextAlignmentCenter;
    _badgeLable.textColor = [UIColor whiteColor];
    
    _badgeLable.font = [UIFont systemFontOfSize:8*MZ_RATE];
    _badgeLable.layer.cornerRadius = badgeW*0.5;
    _badgeLable.clipsToBounds = YES;
    _badgeLable.backgroundColor = [UIColor redColor];
    
    _badgeLable.frame = CGRectMake(self.frame.size.width - badgeW, - 2*badgeW, badgeW, badgeW);
    
    if(badgeValue <= 0){
        _badgeLable.hidden = YES;
    }else if (badgeValue > 0 && badgeValue < 99){
        _badgeLable.hidden = NO;
        _badgeLable.text = [NSString stringWithFormat:@"%ld",badgeValue];
    }else {
        _badgeLable.hidden = NO;
        _badgeLable.text = @"99+";
    }
}

@end
