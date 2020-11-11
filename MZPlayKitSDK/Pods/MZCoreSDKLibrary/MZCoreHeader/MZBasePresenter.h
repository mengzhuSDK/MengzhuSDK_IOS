//
//  MZBasePresenter.h
//  MengZhu
//
//  Created by 孙显灏 on 2019/7/26.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MZBasePresenterProtocol.h"
/**
 * 基础presenter回调协议  如需增加方法需要定义此协议
 */
@protocol MZBasePresenterListener
@optional

-(void)onResult:(int)type result:(id _Nullable)result,...;

-(void)onError:(NSInteger)type errorCode:(NSInteger)errorCode errorMsg:(NSString *_Nullable)errorMsg;

@end
//无网络回调
@protocol MZNetworkErrorRefreshDelegate <NSObject>

-(void)networkRefresh;

@end

@interface MZBasePresenter : NSObject<MZBasePresenterProtocol>
@property(nonatomic,weak) id<MZBasePresenterListener > _Nullable  delegate;
@property(nonatomic,weak) id<MZNetworkErrorRefreshDelegate> _Nullable refreshDelegate;//无网络刷新回调
@property(nonatomic,weak)UIViewController* _Nullable controller;
//获取flow参数数组
-(NSMutableArray * _Nonnull)getPresenterParams:(NSString * _Nonnull)params,...;

- (instancetype _Nonnull)init:(UIViewController * _Nonnull)context;

@end

