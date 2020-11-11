//
//  MZBadgeButton.h
//  MZUILibrary
//
//  Created by 李风 on 2020/7/22.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZBadgeButton : UIButton

@property(nonatomic,strong)id tagData;

@property (nonatomic, strong) UILabel *badgeLabel;

- (void)setBadgeValue:(NSInteger)badgeValue badgeColor:(UIColor *)badgeColor badgeValueColor:(UIColor *)badgeValueColor valueFont:(UIFont *)font;

- (void)setBadgeValue:(NSInteger)badgeValue;

@end

NS_ASSUME_NONNULL_END
