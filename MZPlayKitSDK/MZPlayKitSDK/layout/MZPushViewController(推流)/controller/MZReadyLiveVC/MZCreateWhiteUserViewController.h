//
//  MZCreateWhiteUserViewController.h
//  MZKitDemo
//
//  Created by 李风 on 2021/6/3.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZCreateWhiteUserViewController : UIViewController

- (instancetype)initWithWhiteId:(NSString *)whiteId result:(void(^)(void))result;

@end

NS_ASSUME_NONNULL_END
