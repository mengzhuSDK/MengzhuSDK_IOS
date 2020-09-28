//
//  ViewController.m
//  MZLiveSDK
//
//  Created by 孙显灏 on 2018/10/17.
//  Copyright © 2018年 孙显灏. All rights reserved.
//
#import "ViewController.h"
#import "MZM3U8DownLoadViewController.h"
#import "MZInputViewController.h"
#import "MZReadyLiveViewController.h"
#import "MZSDKConfig.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pusherButton;
@property (nonatomic, strong) UIButton *downloadButton;

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationbar];
}

- (void)setNavigationbar{
//    self.navigationItem.title = @"SDKdemo";
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
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mz_home_logo"]];
    logoIV.frame = CGRectMake((self.view.frame.size.width - 100*MZ_RATE)/2.0, 110, 100*MZ_RATE, 146*MZ_RATE);
    [self.view addSubview:logoIV];
    
    _downloadButton=[[UIButton alloc]initWithFrame:CGRectMake(48, self.view.frame.size.height - 90 - 48, self.view.bounds.size.width - 96, 48)];
    [_downloadButton setTitle:@"下载测试" forState:UIControlStateNormal];
    [_downloadButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
    [_downloadButton setBackgroundColor:[UIColor clearColor]];
    [_downloadButton addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchDown];
    [_downloadButton.layer setCornerRadius:25];
    [_downloadButton.layer setMasksToBounds:YES];
    [_downloadButton.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor
     ];
    [_downloadButton.layer setBorderWidth:1.0];
    [self.view addSubview:_downloadButton];
    
    _pusherButton=[[UIButton alloc]initWithFrame:CGRectMake(_downloadButton.frame.origin.x, _downloadButton.frame.origin.y - 20 - 48, _downloadButton.frame.size.width, _downloadButton.frame.size.height)];
    [_pusherButton setTitle:@"推流测试" forState:UIControlStateNormal];
    [_pusherButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
    [_pusherButton setBackgroundColor:[UIColor clearColor]];
    [_pusherButton addTarget:self action:@selector(intoInpuInfoVC:) forControlEvents:UIControlEventTouchDown];
    [_pusherButton.layer setCornerRadius:25];
    [_pusherButton.layer setMasksToBounds:YES];
    [_pusherButton.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor
     ];
    [_pusherButton.layer setBorderWidth:1.0];
    [self.view addSubview:_pusherButton];
    
    _playButton=[[UIButton alloc]initWithFrame:CGRectMake(_downloadButton.frame.origin.x, _pusherButton.frame.origin.y - 20 - 48, _downloadButton.frame.size.width, _downloadButton.frame.size.height)];
    [_playButton setTitle:@"直播/回放" forState:UIControlStateNormal];
    [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1]];
    [_playButton addTarget:self action:@selector(intoInpuInfoVC:) forControlEvents:UIControlEventTouchDown];
    [_playButton.layer setCornerRadius:25];
    [_playButton.layer setMasksToBounds:YES];
    [self.view addSubview:_playButton];
}

- (void)intoInpuInfoVC:(UIButton *)sender  {
    [MZSDKBusinessManager setDebug:MZ_is_debug];
    if (sender == _pusherButton) {
        MZReadyLiveViewController *vc = [[MZReadyLiveViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MZInputViewController *vc = [[MZInputViewController alloc] init];
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
