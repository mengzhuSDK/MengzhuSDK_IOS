//
//  UIViewController+MZShowMessage.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/4/21.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MZShowMessage)

//显示提示语
-(void)showTextView:(UIView*)view message:(NSString*)message;

@end

NS_ASSUME_NONNULL_END
