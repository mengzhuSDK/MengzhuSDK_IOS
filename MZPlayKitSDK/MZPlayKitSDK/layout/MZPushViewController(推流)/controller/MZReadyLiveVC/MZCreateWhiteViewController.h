//
//  MZCreateWhiteViewController.h
//  MZKitDemo
//
//  Created by 李风 on 2021/6/3.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MZCreateWhiteViewController : UIViewController

- (instancetype)initWithIsCreated:(void(^)(BOOL isCreated))isCreated;

@end

NS_ASSUME_NONNULL_END
