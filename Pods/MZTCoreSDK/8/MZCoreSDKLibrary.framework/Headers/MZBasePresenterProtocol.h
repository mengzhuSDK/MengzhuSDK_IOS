//
//  MZBasePresenterProtocol.h
//  MengZhu
//
//  Created by 孙显灏 on 2019/7/26.
//  Copyright © 2019 孙显灏. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol MZBasePresenterProtocol <NSObject>

@required
/**
 * 初始化presenter
 */
-(void)initPresenter:(UIViewController *)context;

/**
 * 启动主流程
 */
-(void)startFlow:(id )params,...;

/**
 * 执行主流程方法
 */
-(void)onFlow:(NSMutableArray *)params;

/**
 * 执行主流程数组参数类型
 */
-(void)startFlow_array:(NSMutableArray *)params;

@end
