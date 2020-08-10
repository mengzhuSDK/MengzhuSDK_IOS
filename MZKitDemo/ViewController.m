//
//  ViewController.m
//  MZLiveSDK
//
//  Created by 孙显灏 on 2018/10/17.
//  Copyright © 2018年 孙显灏. All rights reserved.
//
#import "ViewController.h"
#import "PlayerViewController.h"
#import "MZM3U8DownLoadViewController.h"
#import "MZInputViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *portraitButton;
@property (nonatomic, strong) UIButton *superButton;
@property (nonatomic, strong) UIButton *pusherButton;
@property (nonatomic, strong) UIButton *downloadButton;

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationbar];
}

- (void)setNavigationbar{
    self.navigationItem.title = @"SDKdemo";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customAddSubviews];  
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)customAddSubviews{
    
    _portraitButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 40)];
    [_portraitButton setTitle:@"竖屏播放器" forState:UIControlStateNormal];
    [_portraitButton setBackgroundColor:[UIColor blueColor]];
    [_portraitButton addTarget:self action:@selector(intoInpuInfoVC:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_portraitButton];
    _superButton=[[UIButton alloc]initWithFrame:CGRectMake(_portraitButton.frame.origin.x, _portraitButton.frame.origin.y+_portraitButton.frame.size.height+20, self.view.bounds.size.width, 40)];
    [_superButton setTitle:@"超级播放器" forState:UIControlStateNormal];
    [_superButton setBackgroundColor:[UIColor blueColor]];
    [_superButton addTarget:self action:@selector(intoInpuInfoVC:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_superButton];
    _pusherButton=[[UIButton alloc]initWithFrame:CGRectMake(_superButton.frame.origin.x, _superButton.frame.origin.y+_superButton.frame.size.height+20, self.view.bounds.size.width, 40)];
    [_pusherButton setTitle:@"推流测试" forState:UIControlStateNormal];
    [_pusherButton setBackgroundColor:[UIColor blueColor]];
    [_pusherButton addTarget:self action:@selector(intoInpuInfoVC:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_pusherButton];
    _downloadButton=[[UIButton alloc]initWithFrame:CGRectMake(_pusherButton.frame.origin.x, _pusherButton.frame.origin.y+_pusherButton.frame.size.height+20, self.view.bounds.size.width, 40)];
    [_downloadButton setTitle:@"下载测试" forState:UIControlStateNormal];
    [_downloadButton setBackgroundColor:[UIColor blueColor]];
    [_downloadButton addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_downloadButton];
}

- (void)intoInpuInfoVC:(UIButton *)sender  {
    if (sender == _portraitButton) {
        MZInputViewController *vc = [[MZInputViewController alloc] initWithFrom:MZInputFromPortrait];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender == _superButton) {
        MZInputViewController *vc = [[MZInputViewController alloc] initWithFrom:MZInputFromSuper];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender == _pusherButton) {
        MZInputViewController *vc = [[MZInputViewController alloc] initWithFrom:MZInputFromLive];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/// 进入下载器
- (void)downloadClick {
    MZM3U8DownLoadViewController *downloadVC = [[MZM3U8DownLoadViewController alloc] init];
    downloadVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:downloadVC animated:YES];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


@end
