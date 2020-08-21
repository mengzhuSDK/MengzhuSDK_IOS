//
//  MZInputViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZInputViewController.h"
#import "MZReadyLiveViewController.h"
#import "MZSuperPlayerViewController.h"
#import "MZVerticalPlayerViewController.h"

/// 分配的appID和secretKey
#define MZSDK_AppID @"2019101019585068343"
#define MZSDK_SecretKey @"xEyRRg4QYWbk09hfRJHYHeKPv8nWZITlBiklc44MZCxbdk4E6cGVzrXve6iVaNBn"

@interface MZInputViewController ()
@property (nonatomic, assign) MZInputFrom from;

@property (nonatomic, strong) UITextView *ticket_IDTextView;
@property (nonatomic, strong) UITextView *uniqueIDTextView;
@property (nonatomic, strong) UITextView *nameTextView;
@property (nonatomic, strong) UITextView *avatarTextView;

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic ,strong) UISwitch *isDebugSwitch;//是否debug模式
@end

@implementation MZInputViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (instancetype)initWithFrom:(MZInputFrom)from {
    self = [super init];
    if (self) {
        self.from = from;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"活动ID和用户信息配置";
    [self.view addSubview:label];
    
    //  输入框
    UILabel *tipL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.size.height+label.frame.origin.y+30, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL1];
    tipL1.text = @"活动ID：ticket_ID（活动ID）";
    
    self.ticket_IDTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, tipL1.frame.size.height+tipL1.frame.origin.y, self.view.bounds.size.width, 30)];
    self.ticket_IDTextView.backgroundColor = [UIColor cyanColor];
    self.ticket_IDTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.ticket_IDTextView];
    self.ticket_IDTextView.text = @"10014121";//横屏
    self.ticket_IDTextView.text = @"10014334";//语音直播
    self.ticket_IDTextView.text = @"10014584";//竖屏
    self.ticket_IDTextView.text = @"10015111";//竖屏

    UILabel *tipL2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.ticket_IDTextView.frame.origin.y+self.ticket_IDTextView.frame.size.height, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL2];
    tipL2.text = @"观众信息：uniqueID(传递过来的唯一ID)";
    self.uniqueIDTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, tipL2.frame.size.height+tipL2.frame.origin.y, self.view.bounds.size.width, 30)];
    self.uniqueIDTextView.backgroundColor = [UIColor cyanColor];
    self.uniqueIDTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.uniqueIDTextView];
    self.uniqueIDTextView.text = @"A123456789B123";
    
    UILabel *tipL3 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.uniqueIDTextView.frame.size.height+self.uniqueIDTextView.frame.origin.y, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL3];
    tipL3.text = @"观众信息：NAME（用户昵称）";
    self.nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, tipL3.frame.size.height+tipL3.frame.origin.y, self.view.bounds.size.width, 30)];
    self.nameTextView.backgroundColor = [UIColor cyanColor];
    self.nameTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.nameTextView];
    self.nameTextView.text = @"大鸭梨";
    
    UILabel *tipL4 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameTextView.frame.size.height+self.nameTextView.frame.origin.y, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL4];
    tipL4.text = @"观众信息：AVATAR（用户头像URL）";
    self.avatarTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, tipL4.frame.size.height+tipL4.frame.origin.y, self.view.bounds.size.width, 50)];
    self.avatarTextView.backgroundColor = [UIColor cyanColor];
    self.avatarTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.avatarTextView];
    self.avatarTextView.text = @"https://cdn.duitang.com/uploads/item/201410/26/20141026191422_yEKyd.thumb.700_0.jpeg";
    
    self.isDebugSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, self.avatarTextView.frame.size.height+self.avatarTextView.frame.origin.y+20, 60, 44.0)];
    [self.view addSubview:self.isDebugSwitch];
    self.isDebugSwitch.backgroundColor = [UIColor whiteColor];
    [self.isDebugSwitch roundChangeWithRadius:31/2.0];
    [self.isDebugSwitch setOn:YES];

    UILabel *isDebugLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.isDebugSwitch.frame.origin.y, 180, self.isDebugSwitch.frame.size.height)];
    isDebugLabel.text = @"是否是debug模式";
    isDebugLabel.adjustsFontSizeToFitWidth = YES;
    isDebugLabel.backgroundColor = [UIColor whiteColor];
    isDebugLabel.textColor = [UIColor blackColor];
    [self.view addSubview:isDebugLabel];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(0, isDebugLabel.frame.size.height+isDebugLabel.frame.origin.y+120, self.view.frame.size.width, 44.0);
    [self.nextButton setBackgroundColor:[UIColor blueColor]];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    switch (self.from) {
        case MZInputFromLive:
            self.navigationItem.title = @"推流";
            [self.nextButton setTitle:@"进入推流详情配置" forState:UIControlStateNormal];
            self.ticket_IDTextView.hidden = YES;
            label.text = @"用户信息配置";
            tipL1.hidden = YES;
            break;
        case MZInputFromSuper:
            self.navigationItem.title = @"超级播放器";
            [self.nextButton setTitle:@"进入超级播放器" forState:UIControlStateNormal];
            break;
        case MZInputFromPortrait:
            self.navigationItem.title = @"竖屏播放器";
            [self.nextButton setTitle:@"进入竖屏播放器" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)nextButtonClick {
    switch (self.from) {
        case MZInputFromLive:
            [self pusherClick:self.nextButton];
            break;
        case MZInputFromSuper:
            [self onSuperPlayerViewClick:self.nextButton];
            break;
        case MZInputFromPortrait:
            [self onPlayerViewClick];
            break;
        default:
            break;
    }
}

/// 配置用户信息
- (void)serUserInfoSuccess:(void(^)(BOOL result, NSString *errorString))success {
    if (self.from != MZInputFromLive) {
        if (self.ticket_IDTextView.text.length <= 0) {
            success(NO, @"活动ID不能为空");
            return;
        }
    }
    
    if (self.uniqueIDTextView.text.length <= 0) {
        success(NO, @"用户ID不能为空");
        return;
    }
    
    MZUser *user = [[MZUser alloc] init];
    
#warning - 用户自己传过来的唯一ID
    user.uniqueID = self.uniqueIDTextView.text;
    user.nickName = self.nameTextView.text;
    user.avatar = self.avatarTextView.text;
    
#warning - 请输入分配给你们的appID和secretKey
    user.appID = MZSDK_AppID;//线上模拟环境(这里需要自己填一下)
    user.secretKey = MZSDK_SecretKey;
    
    if (user.appID.length <= 0 || user.secretKey.length <= 0) {
        success(NO, @"请配置appId或secretKey");
        return;
    }
    
    [MZBaseUserServer updateCurrentUser:user];
    
    success(YES, @"");
}


/// 进入竖屏播放器
-(void)onPlayerViewClick{
    [MZSDKBusinessManager setDebug:self.isDebugSwitch.isOn];
    
    [self serUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            MZVerticalPlayerViewController *liveVC = [[MZVerticalPlayerViewController alloc]init];
            liveVC.ticket_id = self.ticket_IDTextView.text;
            [self.navigationController pushViewController:liveVC  animated:YES];
        } else {
            [self.view show:errorString];
        }
    }];
}


/// 进入超级播放器（二分屏和横屏）
- (void)onSuperPlayerViewClick:(UIButton *)sender {
    [MZSDKBusinessManager setDebug:self.isDebugSwitch.isOn];
    
    [self serUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            MZSuperPlayerViewController *superPlayerVC = [[MZSuperPlayerViewController alloc] init];
            superPlayerVC.ticket_id = self.ticket_IDTextView.text;
            [self.navigationController pushViewController:superPlayerVC animated:YES];
        } else {
            [self.view show:errorString];
        }
    }];
}

/// 进入推流界面（直播界面）
-(void)pusherClick:(UIButton *)sender{
    [MZSDKBusinessManager setDebug:self.isDebugSwitch.isOn];
    
    [self serUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            MZReadyLiveViewController *vc = [[MZReadyLiveViewController alloc] init];
            vc.fromTicket_id = @"点击更改";
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.view show:errorString];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
