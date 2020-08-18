//
//  MZDLNAView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MZDLNAViewDelegate <NSObject>
@optional
/// 开始投屏
- (void)dlnaStartPlay;

/// 点击了投屏帮助按钮
- (void)helpButtonDidClick;

/// 点击空白或者取消投屏调用的方法
- (void)dlnaViewExit;
@end

@interface MZDLNAView : UIView

@property (nonatomic,   weak) id <MZDLNAViewDelegate>delegate;//代理

@property (nonatomic, strong) UIButton *helpButton;//投屏帮助按钮，默认隐藏 [helpButton setHidden:YES];

@property (nonatomic,   copy) NSString *DLNAString;//投屏的视频地址

@property (nonatomic, strong) UIView *fuctionView;//展示的设备列表背景View
@property (nonatomic, strong) UITableView *searchTableView;//搜索设备的tableView
@property (nonatomic, strong) UIButton *refreshButton;//刷新设备的按钮
@property (nonatomic, strong) UILabel *searchStatusLabel;//搜索设备的状态指示Label
@property (nonatomic, strong) UIButton *cancelButton;//取消按钮

@property (nonatomic, strong) UIView *topView;//顶部菜单栏
@property (nonatomic, strong) UIView *topLineView;//顶部的线
@property (nonatomic, strong) UIView *bottomLineView;//底部的线

/// 停止投屏（开始投屏后，停止投屏调用）
- (void)stopDLNA;

@end

NS_ASSUME_NONNULL_END
