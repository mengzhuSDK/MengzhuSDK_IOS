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
#import "MZUploadViewController.h"
#import "MZJoinMettingViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pusherButton;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, strong) UIButton *joinMeetingButton;

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
    
    _joinMeetingButton=[[UIButton alloc]initWithFrame:CGRectMake(48, self.view.frame.size.height - 90 - 48, self.view.bounds.size.width - 96, 48)];
    [_joinMeetingButton setTitle:@"加入会议测试" forState:UIControlStateNormal];
    [_joinMeetingButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
    [_joinMeetingButton setBackgroundColor:[UIColor clearColor]];
    [_joinMeetingButton addTarget:self action:@selector(joinMeetingClick) forControlEvents:UIControlEventTouchDown];
    [_joinMeetingButton.layer setCornerRadius:25];
    [_joinMeetingButton.layer setMasksToBounds:YES];
    [_joinMeetingButton.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor
     ];
    [_joinMeetingButton.layer setBorderWidth:1.0];
    [self.view addSubview:_joinMeetingButton];
    
    _uploadButton=[[UIButton alloc]initWithFrame:CGRectMake(_joinMeetingButton.frame.origin.x, _joinMeetingButton.frame.origin.y - 20 - 48, _joinMeetingButton.frame.size.width, _joinMeetingButton.frame.size.height)];
    [_uploadButton setTitle:@"上传测试" forState:UIControlStateNormal];
    [_uploadButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
    [_uploadButton setBackgroundColor:[UIColor clearColor]];
    [_uploadButton addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchDown];
    [_uploadButton.layer setCornerRadius:25];
    [_uploadButton.layer setMasksToBounds:YES];
    [_uploadButton.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor
     ];
    [_uploadButton.layer setBorderWidth:1.0];
    [self.view addSubview:_uploadButton];
    
    _downloadButton=[[UIButton alloc]initWithFrame:CGRectMake(_uploadButton.frame.origin.x, _uploadButton.frame.origin.y - 20 - 48, _uploadButton.frame.size.width, _uploadButton.frame.size.height)];
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

/// 进入上传界面
- (void)uploadClick {
    MZUploadViewController *uploadVC = [[MZUploadViewController alloc] init];
    [self.navigationController pushViewController:uploadVC animated:YES];
}

/// 进入加入会议界面
- (void)joinMeetingClick {
    MZJoinMettingViewController *joinMettingVC = [[MZJoinMettingViewController alloc] init];
    [self.navigationController pushViewController:joinMettingVC animated:YES];
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
