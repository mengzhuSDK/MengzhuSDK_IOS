//
//  MZEditWhiteUserViewController.h
//  MZKitDemo
//
//  Created by 李风 on 2021/6/4.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZEditWhiteUserViewController : UIViewController

- (instancetype)initWithInfo:(NSDictionary *)info result:(void(^)(void))result;

@end

NS_ASSUME_NONNULL_END
