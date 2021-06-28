//
//  MZRedPackageViewController.h
//  MZKitDemo
//
//  Created by 李风 on 2021/6/18.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZRedPackageViewController : UIViewController
@property (nonatomic ,  copy) NSString *ticket_id;
@property (nonatomic ,  copy) NSString *channel_id;

@property (nonatomic ,strong) UITextField * moneyTextField;
@property (nonatomic ,strong,readonly) UITextField * luckyNoteTextField;  // 祝福语占位图  最多15个字
@end

NS_ASSUME_NONNULL_END
