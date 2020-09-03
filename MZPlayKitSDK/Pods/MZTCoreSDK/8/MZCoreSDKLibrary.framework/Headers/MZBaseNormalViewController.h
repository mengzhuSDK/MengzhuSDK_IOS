//
//  MZBaseNormalViewController.h
//  MZCoreSDKLibrary
//
//  Created by LiWei on 2020/7/30.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MZBaseNormalViewController : UIViewController

@property(nonatomic)BOOL isPersent;//标识controllert弹出方向 左右走还是上下走
@property (nonatomic ,strong)UIViewController *loginWillGoVC;
@property(nonatomic,assign)BOOL isStatusBarChange;
@property (nonatomic,assign) BOOL isWillGoLogin;



/**
 *  检测可用网络
 */
- (BOOL)isVisableNet;

//后台执行
-(void)doInBackground:(void(^)(void))block;
//主线程执行
-(void)doInMain:(void(^)(void))block;
//先在后台执行，完了以后在主线程回调
-(void)doAsync:(void(^)(void))block completion:(void(^)(void))completion;

-(void)showAlertViewWithMessage:(NSString *)message;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

-(void)adjustStatusBar;//状态栏变化的时候重新布局UI的方法


@end

NS_ASSUME_NONNULL_END
