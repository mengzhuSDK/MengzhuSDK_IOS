//
//  MZRollingPageControl.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/9/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZRollingPageControl : UIView
@property (nonatomic, strong) UIView  *bigDot;//当前指示点
@property (nonatomic, strong) UIColor *dotNormalColor;//未选中的点的默认颜色

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@end

NS_ASSUME_NONNULL_END
