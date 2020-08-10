//
//  MZInputViewController.h
//  MZKitDemo
//
//  Created by 李风 on 2020/8/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MZInputFromPortrait = 0,//竖屏播放器
    MZInputFromSuper,//超级播放器
    MZInputFromLive,//推流测试
} MZInputFrom;

@interface MZInputViewController : UIViewController

- (instancetype)initWithFrom:(MZInputFrom)from;

@end

NS_ASSUME_NONNULL_END
