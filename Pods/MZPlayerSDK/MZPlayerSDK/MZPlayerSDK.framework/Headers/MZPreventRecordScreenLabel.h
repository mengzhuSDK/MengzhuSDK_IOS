//
//  MZPreventRecordScreenLabel.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/9.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZPreventRecordScreenLabel : UILabel

/// 显示防录屏label
+ (void)showRandomLabelWithShowView:(UIView *)showView text:(NSString *)text;

/// 隐藏防录屏label
+ (void)hideRandomLabel;


@end

NS_ASSUME_NONNULL_END
