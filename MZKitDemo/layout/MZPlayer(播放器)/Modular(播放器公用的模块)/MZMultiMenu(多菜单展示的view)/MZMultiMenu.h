//
//  MZMultiMenu.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/13.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MultiMenuClick_showBarrage = 0,//展示弹幕按钮
    MultiMenuClick_hideBarrage,//隐藏弹幕按钮
    MultiMenuClick_report,//反馈按钮
} MultiMenuClick;

@protocol MZMultiMenuDelegate <NSObject>
- (void)multiMenuClick:(MultiMenuClick)menu;
@end

@interface MZMultiMenu : UIView
@property (nonatomic, weak) id<MZMultiMenuDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
