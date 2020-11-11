//
//  MZBaseLayoutProtocol.h
//  MengZhu
//
//  Created by 孙显灏 on 2019/7/29.
//  Copyright © 2019 孙显灏. All rights reserved.
//
#import "MZBaseModel.h"
@protocol MZBaseLayoutProtocol <NSObject>

@required
-(void)initView;//初始化布局
-(void)initListener;//初始化监听
-(void)loadData:(MZBaseModel *)model;//加载数据
-(void)loadData:(id)obj model:(MZBaseModel *)model;//加载数据
@end
