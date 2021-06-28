//
//  MZRedPackageAlert.h
//  MZKitDemo
//
//  Created by 李风 on 2021/6/22.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZRedPackageAlert : UIView

+ (void)showWithBonus_id:(NSString *)bonus_id slogan:(NSString *)slogan nickname:(NSString *)nickname avatar:(NSString *)avatar isGoReceiveList:(void(^)(BOOL isGoReceiveList))handler;

@end

NS_ASSUME_NONNULL_END
