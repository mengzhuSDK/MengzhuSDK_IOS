//
//  VHSlider.h
//  VhallIphone
//
//  Created by vhall on 15/11/26.
//  Copyright © 2015年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZSlider : UISlider

typedef void (^sliderChangeBlock)(MZSlider *slider);

@property(nonatomic,copy)sliderChangeBlock changeBlock;
//- (void)addTarget:(id)target action:(SEL)action;
@end
