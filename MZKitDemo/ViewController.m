//
//  ViewController.m
//  MZLiveSDK
//
//  Created by 孙显灏 on 2018/10/17.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import "ViewController.h"
#import "MZVerticalPlayerViewController.h"
#import "PlayerViewController.h"
#import "MZM3U8DownLoadViewController.h"
#import "MZReadyLiveViewController.h"
#import "MZSuperPlayerViewController.h"
#import "MZSimpleHud.h"

/// 分配的appID和secretKey
#define MZSDK_AppID @""
#define MZSDK_SecretKey @""

@interface ViewController (){
    UIButton *pushBtn;
    UIButton *playerBtn;
    UIButton *playerViewBtn;
    UIButton *playerViewBtn2;
    UIButton *playerViewBtn3;
    UIButton *playerViewBtn4;
//    MZPlayerManager *manager;
    
}
//@property(nonatomic,strong)MZChatKitManager *chatManager;
@property (nonatomic ,strong) UITextView *ticket_IDTextView;
@property (nonatomic ,strong) UITextView *UIDTextView;
@property (nonatomic ,strong) UITextView *nameTextView;
@property (nonatomic ,strong) UITextView *avatarTextView;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationbar];
    [MZUserServer signOutCurrentUser] ;
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
    
    playerViewBtn=[[UIButton alloc]initWithFrame:CGRectMake(playerBtn.frame.origin.x, playerBtn.frame.origin.y+playerBtn.frame.size.height+400 - 40, self.view.bounds.size.width, 40)];
    [playerViewBtn setTitle:@"竖屏播放器" forState:UIControlStateNormal];
    [playerViewBtn setBackgroundColor:[UIColor blueColor]];
    [playerViewBtn addTarget:self action:@selector(onPlayerViewClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playerViewBtn];
    playerViewBtn2=[[UIButton alloc]initWithFrame:CGRectMake(playerViewBtn.frame.origin.x, playerViewBtn.frame.origin.y+playerViewBtn.frame.size.height+20, self.view.bounds.size.width, 40)];
    [playerViewBtn2 setTitle:@"超级播放器" forState:UIControlStateNormal];
    [playerViewBtn2 setBackgroundColor:[UIColor blueColor]];
    [playerViewBtn2 addTarget:self action:@selector(onSuperPlayerViewClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playerViewBtn2];
    playerViewBtn3=[[UIButton alloc]initWithFrame:CGRectMake(playerViewBtn.frame.origin.x, playerViewBtn2.frame.origin.y+playerViewBtn2.frame.size.height+20, self.view.bounds.size.width, 40)];
    [playerViewBtn3 setTitle:@"推流测试" forState:UIControlStateNormal];
    [playerViewBtn3 setBackgroundColor:[UIColor blueColor]];
    [playerViewBtn3 addTarget:self action:@selector(pusherClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playerViewBtn3];
    playerViewBtn4=[[UIButton alloc]initWithFrame:CGRectMake(playerViewBtn3.frame.origin.x, playerViewBtn3.frame.origin.y+playerViewBtn3.frame.size.height+20, self.view.bounds.size.width, 40)];
    [playerViewBtn4 setTitle:@"下载测试" forState:UIControlStateNormal];
    [playerViewBtn4 setBackgroundColor:[UIColor blueColor]];
    [playerViewBtn4 addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playerViewBtn4];
//  输入框
    
    UILabel *tipL1 = [[UILabel alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 90, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL1];
    tipL1.text = @"ticket_ID";
    
    self.ticket_IDTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 110, self.view.bounds.size.width, 30)];
    self.ticket_IDTextView.backgroundColor = [UIColor cyanColor];
    self.ticket_IDTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.ticket_IDTextView];
    self.ticket_IDTextView.text = @"10014099";//竖屏
//    self.ticket_IDTextView.text = @"10013331";//横屏
//    self.ticket_IDTextView.text = @"10014014";//竖屏

    UILabel *tipL2 = [[UILabel alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 140, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL2];
    tipL2.text = @"观众信息：UID";
    self.UIDTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 160, self.view.bounds.size.width, 30)];
    self.UIDTextView.backgroundColor = [UIColor cyanColor];
    self.UIDTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.UIDTextView];
    self.UIDTextView.text = @"1000109198213";
    
    UILabel *tipL3 = [[UILabel alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 190, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL3];
    tipL3.text = @"观众信息：NAME";
    self.nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 210, self.view.bounds.size.width, 30)];
    self.nameTextView.backgroundColor = [UIColor cyanColor];
    self.nameTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.nameTextView];
    self.nameTextView.text = @"大鸭梨";
    
    UILabel *tipL4 = [[UILabel alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 240, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL4];
    tipL4.text = @"观众信息：AVATAR";
    self.avatarTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 260, self.view.bounds.size.width, 50)];
    self.avatarTextView.backgroundColor = [UIColor cyanColor];
    self.avatarTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.avatarTextView];
    self.avatarTextView.text = @"https://cdn.duitang.com/uploads/item/201410/26/20141026191422_yEKyd.thumb.700_0.jpeg";
}


- (void)onSuperPlayerViewClick:(UIButton *)sender {
    [MZSDKBusinessManager setDebug:YES];
    MZUser *user=[[MZUser alloc]init];
    
    user.userId = self.UIDTextView.text;
    user.nickName = self.nameTextView.text;
    user.avatar = self.avatarTextView.text;
    
    /// 用户自己传过来的唯一ID
    user.uniqueID = @"A123456B";

#warning 请输入分配给你们的appID和secretKey
    user.appID = MZSDK_AppID;//线上模拟环境(这里需要自己填一下)
    user.secretKey = MZSDK_SecretKey;
    
    [MZUserServer updateCurrentUser:user];
    
    
//    [[MZSDKInitManager sharedManager]initSDK:^(id responseObject) {

        MZSuperPlayerViewController *superPlayerVC = [[MZSuperPlayerViewController alloc] init];
    superPlayerVC.ticket_id = self.ticket_IDTextView.text;
        [self.navigationController pushViewController:superPlayerVC animated:YES];
//        PlayerViewController *playerVC = [[PlayerViewController alloc] init];
//        [self.navigationController pushViewController:playerVC animated:YES];

//    } failure:^(NSError *error) {
//
//    }];
}

-(void)pusherClick:(UIButton *)sender{
    
    [MZSDKBusinessManager setDebug:YES];
    
    MZUser *user=[[MZUser alloc]init];
    
#warning 这里是我模拟的用户信息，使用的时候，请使用你们自己服务器的用户信息
    user.userId = self.UIDTextView.text;
    user.nickName = self.nameTextView.text;
    user.avatar = self.avatarTextView.text;
    
    /// 用户自己传过来的唯一ID
    user.uniqueID = @"A123456B";
    
#warning 请输入分配给你们的appID和secretKey
    user.appID = MZSDK_AppID;//线上模拟环境(这里需要自己填一下)
    user.secretKey = MZSDK_SecretKey;
    
    [MZUserServer updateCurrentUser:user];
    
    MZReadyLiveViewController *vc = [[MZReadyLiveViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)onPlayerViewClick{
    if (self.ticket_IDTextView.text.length == 0) {
        
        return;
    }
    [MZSDKBusinessManager setDebug:YES];
    
    MZUser *user=[[MZUser alloc]init];
    user.userId = self.UIDTextView.text;
    user.nickName = self.nameTextView.text;
    user.avatar = self.avatarTextView.text;
    
    /// 用户自己传过来的唯一ID
    user.uniqueID = @"A123456B";
    
#warning 请输入分配给你们的appID和secretKey
    user.appID = MZSDK_AppID;//线上模拟环境(这里需要自己填一下)
    user.secretKey = MZSDK_SecretKey;
    
    [MZUserServer updateCurrentUser:user];
    
    MZVerticalPlayerViewController *liveVC = [[MZVerticalPlayerViewController alloc]init];
    liveVC.ticket_id = self.ticket_IDTextView.text;
    [self.navigationController pushViewController:liveVC  animated:YES];
}

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
