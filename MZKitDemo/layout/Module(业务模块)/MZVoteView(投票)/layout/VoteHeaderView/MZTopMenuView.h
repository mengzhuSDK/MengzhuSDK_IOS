//
//  MZTopMenuView.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CloseHandler)(void);

@interface MZTopMenuView : UIView

@property (nonatomic, strong) UILabel *menuLabel;//标题
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮

@property (nonatomic, copy) CloseHandler closeHandler;//关闭的句柄

@end

NS_ASSUME_NONNULL_END
