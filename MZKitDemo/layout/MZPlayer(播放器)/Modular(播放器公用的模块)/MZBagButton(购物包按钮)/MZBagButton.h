//
//  MZBagButton.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/13.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZBagButton : UIButton

/// 更新商品总个数
- (void)updateNumber:(int)number;

/// 获取当前显示的商品总个数
- (int)getNumber;
@end

NS_ASSUME_NONNULL_END
