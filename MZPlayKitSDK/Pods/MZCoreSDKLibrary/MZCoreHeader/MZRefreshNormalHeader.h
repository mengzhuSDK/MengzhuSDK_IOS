//
//  MZRefreshNormalHeader.h
//  MZRefreshExample
//
//  Created by MZ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MZRefreshStateHeader.h"

@interface MZRefreshNormalHeader : MZRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
