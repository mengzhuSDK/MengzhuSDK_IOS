//
//  MZInputViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZInputViewController.h"
#import "MZSuperPlayerViewController.h"
#import "MZVerticalPlayerViewController.h"
#import "MZSDKConfig.h"

@interface MZInputViewController ()

@property (nonatomic, strong) UITextField *ticket_IDTextField;//活动ID
@property (nonatomic, strong) UITextField *uniqueIDTextField;//用户ID
@property (nonatomic, strong) UITextField *nameTextField;//用户名字
@property (nonatomic, strong) UITextField *avatarTextField;//用户头像
@property (nonatomic, strong) UITextField *phoneTextField;//用户手机号

@property (nonatomic, strong) UIButton *portraitButton;
@property (nonatomic, strong) UIButton *landspaceButton;

@end

@implementation MZInputViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"播放";
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, navBarHeight, self.view.frame.size.width, 44)];
    label.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"信息填写";
    [self.view addSubview:label];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, label.frame.size.height+label.frame.origin.y, self.view.frame.size.width, 44*MZ_RATE*5)];
    bgView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self.view addSubview:bgView];
    
    NSDictionary *attrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:14*MZ_RATE],NSForegroundColorAttributeName:[UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1]};
    
    NSString *egTicketId = @"10017889";
    NSString *egUniqueId = @"debugUser888";
    if (MZ_is_debug == 0) {//正式环境
        egTicketId = @"10165373";
        egUniqueId = @"releaseUser999";
    }
    
    NSMutableAttributedString *ticket_IDPlaceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"填写ticket_id，必填项，例:%@",egTicketId] attributes:attrDict];
    NSMutableAttributedString *uniquePlaceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"填写用户唯一ID，必填项，例:%@",egUniqueId] attributes:attrDict];
    NSMutableAttributedString *nicknamePlaceStr = [[NSMutableAttributedString alloc] initWithString:@"填写用户昵称，空则使用默认名字" attributes:attrDict];
    NSMutableAttributedString *avatarPlaceStr = [[NSMutableAttributedString alloc] initWithString:@"填写用户头像地址，空则使用默认头像" attributes:attrDict];
    NSMutableAttributedString *phonePlaceStr = [[NSMutableAttributedString alloc] initWithString:@"填写用户手机号，空则使用默认手机号" attributes:attrDict];
    
    UILabel *aRedStar = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 20, 44*MZ_RATE)];
    aRedStar.backgroundColor = [UIColor clearColor];
    aRedStar.textAlignment = NSTextAlignmentCenter;
    aRedStar.textColor = [UIColor redColor];
    aRedStar.text = @"*";
    [bgView addSubview:aRedStar];

    self.ticket_IDTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width - 30, 44*MZ_RATE)];
    self.ticket_IDTextField.backgroundColor = [UIColor clearColor];
    self.ticket_IDTextField.keyboardType = UIKeyboardTypeDefault;
    self.ticket_IDTextField.textColor = [UIColor whiteColor];
    [self.ticket_IDTextField setAttributedPlaceholder:ticket_IDPlaceStr];
    self.ticket_IDTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [bgView addSubview:self.ticket_IDTextField];
    
    UILabel *bRedStar = [[UILabel alloc] initWithFrame:CGRectMake(10, self.ticket_IDTextField.frame.size.height+self.ticket_IDTextField.frame.origin.y, 20, 44*MZ_RATE)];
    bRedStar.backgroundColor = [UIColor clearColor];
    bRedStar.textAlignment = NSTextAlignmentCenter;
    bRedStar.textColor = [UIColor redColor];
    bRedStar.text = @"*";
    [bgView addSubview:bRedStar];
    
    self.uniqueIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, self.ticket_IDTextField.frame.size.height+self.ticket_IDTextField.frame.origin.y, self.view.bounds.size.width - 30, 44*MZ_RATE)];
    self.uniqueIDTextField.backgroundColor = [UIColor clearColor];
    self.uniqueIDTextField.keyboardType = UIKeyboardTypeDefault;
    self.uniqueIDTextField.textColor = [UIColor whiteColor];
    self.uniqueIDTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [bgView addSubview:self.uniqueIDTextField];
    [self.uniqueIDTextField setAttributedPlaceholder:uniquePlaceStr];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, self.uniqueIDTextField.frame.size.height+self.uniqueIDTextField.frame.origin.y, self.view.bounds.size.width - 30, 44*MZ_RATE)];
    self.nameTextField.backgroundColor = [UIColor clearColor];
    self.nameTextField.keyboardType = UIKeyboardTypeDefault;
    self.nameTextField.textColor = [UIColor whiteColor];
    [self.nameTextField setAttributedPlaceholder:nicknamePlaceStr];
    self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [bgView addSubview:self.nameTextField];
    
    self.avatarTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, self.nameTextField.frame.size.height+self.nameTextField.frame.origin.y, self.view.bounds.size.width - 30, 44*MZ_RATE)];
    self.avatarTextField.backgroundColor = [UIColor clearColor];
    self.avatarTextField.keyboardType = UIKeyboardTypeDefault;
    self.avatarTextField.textColor = [UIColor whiteColor];
    [self.avatarTextField setAttributedPlaceholder:avatarPlaceStr];
    self.avatarTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [bgView addSubview:self.avatarTextField];
    
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, self.avatarTextField.frame.size.height+self.avatarTextField.frame.origin.y, self.view.bounds.size.width - 30, 44*MZ_RATE)];
    self.phoneTextField.backgroundColor = [UIColor clearColor];
    self.phoneTextField.keyboardType = UIKeyboardTypeDefault;
    self.phoneTextField.textColor = [UIColor whiteColor];
    [self.phoneTextField setAttributedPlaceholder:phonePlaceStr];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [bgView addSubview:self.phoneTextField];
    
    self.portraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.portraitButton.frame = CGRectMake(48*MZ_RATE, bgView.frame.size.height+bgView.frame.origin.y+200, self.view.frame.size.width-96*MZ_RATE, 44*MZ_RATE);
    [self.portraitButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:36/255.0 blue:91/255.0 alpha:1]];
    [self.portraitButton setTitle:@"竖屏播放" forState:UIControlStateNormal];
    [self.portraitButton.layer setCornerRadius:22*MZ_RATE];
    [self.portraitButton.layer setMasksToBounds:YES];
    [self.view addSubview:self.portraitButton];
    [self.portraitButton addTarget:self action:@selector(onPlayerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.landspaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.landspaceButton.frame = CGRectMake(48*MZ_RATE, self.portraitButton.frame.size.height+self.portraitButton.frame.origin.y+20*MZ_RATE, self.view.frame.size.width-96*MZ_RATE, 44*MZ_RATE);
    [self.landspaceButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:36/255.0 blue:91/255.0 alpha:1]];
    [self.landspaceButton setTitle:@"二分屏播放" forState:UIControlStateNormal];
    [self.landspaceButton.layer setCornerRadius:22*MZ_RATE];
    [self.landspaceButton.layer setMasksToBounds:YES];
    [self.view addSubview:self.landspaceButton];
    [self.landspaceButton addTarget:self action:@selector(onSuperPlayerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    MZUser *user = [MZBaseUserServer currentUser];
    if (user) {
        self.uniqueIDTextField.text = user.uniqueID;
        self.nameTextField.text = user.nickName;
        self.avatarTextField.text = user.avatar;
        self.phoneTextField.text = user.phone;
    }
}

/// 配置用户信息
- (void)setUserInfoSuccess:(void(^)(BOOL result, NSString *errorString))success {
    if (self.ticket_IDTextField.text.length <= 0) {
        success(NO, @"活动ID不能为空");
        return;
    }
    
    if (self.uniqueIDTextField.text.length <= 0) {
        success(NO, @"用户ID不能为空");
        return;
    }
    
    MZUser *user = [MZBaseUserServer currentUser];
    if (!user) {
        user = [[MZUser alloc] init];
    }
    
#warning - 用户自己传过来的唯一ID
    user.uniqueID = self.uniqueIDTextField.text;
    
    if (self.nameTextField.text.length)  {
        user.nickName = self.nameTextField.text;
    } else {
        if (user.nickName.length <= 0) {
            user.nickName = @"盟主user888";
        }
    }
    
    if (self.avatarTextField.text.length) {
        user.avatar = self.avatarTextField.text;
    } else {
        if (user.avatar.length <= 0) {
            user.avatar = @"http://s1.t.zmengzhu.com/upload/img/c0/63/c0638527f2fd32e1b086bae5ec61c8bf.png";
        }
    }
    
    if (self.phoneTextField.text.length) {
        user.phone = self.phoneTextField.text;
    } else {
        if (user.phone.length <= 0) {
            user.phone = @"19912344321";
        }
    }

//    user.user_ext = @{@"level":@"99",@"vip":@"99"}.mj_JSONString;
    [MZBaseUserServer updateCurrentUser:user];
    
    if (self.nameTextField.text.length <= 0) {
        self.nameTextField.text = user.nickName;
    }
    
    if (self.avatarTextField.text.length <= 0) {
        self.avatarTextField.text = user.avatar;
    }
    
    if (self.phoneTextField.text.length <= 0) {
        self.phoneTextField.text = user.phone;
    }
    
    success(YES, @"");
}

/// 进入竖屏播放器
- (void)onPlayerViewClick:(UIButton *)sender {
    WeaklySelf(weakSelf);
    [self setUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            MZVerticalPlayerViewController *liveVC = [[MZVerticalPlayerViewController alloc]init];
            liveVC.ticket_id = weakSelf.ticket_IDTextField.text;
            [weakSelf.navigationController pushViewController:liveVC  animated:YES];
        } else {
            [weakSelf.view show:errorString];
        }
    }];
}

/// 进入超级播放器（二分屏和横屏）
- (void)onSuperPlayerViewClick:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self setUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            MZSuperPlayerViewController *superPlayerVC = [[MZSuperPlayerViewController alloc] init];
            superPlayerVC.ticket_id = weakSelf.ticket_IDTextField.text;
            [weakSelf.navigationController pushViewController:superPlayerVC animated:YES];
        } else {
            [weakSelf.view show:errorString];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
