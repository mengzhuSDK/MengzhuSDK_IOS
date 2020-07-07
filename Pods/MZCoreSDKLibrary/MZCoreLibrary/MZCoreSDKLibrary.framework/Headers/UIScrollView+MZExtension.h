//  代码地址: https://github.com/CoderMZLee/MZRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+Extension.h
//  MZRefreshExample
//
//  Created by MZ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MZExtension)
@property (readonly, nonatomic) UIEdgeInsets MZ_inset;

@property (assign, nonatomic) CGFloat MZ_insetT;
@property (assign, nonatomic) CGFloat MZ_insetB;
@property (assign, nonatomic) CGFloat MZ_insetL;
@property (assign, nonatomic) CGFloat MZ_insetR;

@property (assign, nonatomic) CGFloat MZ_offsetX;
@property (assign, nonatomic) CGFloat MZ_offsetY;

@property (assign, nonatomic) CGFloat MZ_contentW;
@property (assign, nonatomic) CGFloat MZ_contentH;
@end
