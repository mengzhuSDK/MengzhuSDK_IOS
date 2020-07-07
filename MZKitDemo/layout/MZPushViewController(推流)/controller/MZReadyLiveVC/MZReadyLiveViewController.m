//
//  MZReadyLiveViewController.m
//  MengZhu
//
//  Created by vhall on 16/11/29.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZReadyLiveViewController.h"
#import "MZCameraImageHelper.h"
#import <AVFoundation/AVFoundation.h>

#import "MZLiveViewController.h"

#import "MZImageTools.h"

#import "MZReadyLiveHeaderView.h"
#import "MZCameraViewController.h"

#import "MZImagePickerViewController.h"

#import "UIViewController+MZShowMessage.h"

#import "MZSimpleHud.h"
#import "MZLiveFinishViewController.h"
#import "MZLiveSelectBiteRateView.h"

typedef enum {
    MZReadyLiveViewCloseTag,
    MZReadyLiveViewChangeCameraTag,
    MZReadyLiveViewAddImageTag,
    MZReadyLiveViewStartLiveTag,
    MZReadyLiveViewRuleTag,
    MZReadyMoreBtn,
    MZReadyVoiceLiveViewStartLiveTag
}MZReadyLiveViewTag;

@interface MZReadyLiveViewController ()<UITextFieldDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic ,strong)NSMutableDictionary * startLiveInfoDict;
@property (nonatomic ,strong)MZChannelManagerModel * model;

@property (nonatomic ,strong)UIVisualEffectView *blurEffectBgView;//背景

@property (nonatomic ,strong) UISwitch *meiyanSwith;//美颜
@property (nonatomic ,strong) UISwitch *landscapeSwitch;//横竖屏
@property (nonatomic ,strong) UISwitch *muteSwith;//静音
@property (nonatomic ,strong) UISwitch *frontCameraSwitch;//前后摄像头
@property (nonatomic ,strong) UILabel *coundDownLabel;//倒计时label
@property (nonatomic ,strong) UILabel *biteRateLabe;//清晰度选择

@property (nonatomic, assign) int countDownNumber;//选择的倒计时数字
@property (nonatomic, assign) int videoSessionPreset;//视频分辨率

@property (nonatomic, strong) UILabel *live_tk_label;//live_tk的Label
@property (nonatomic, strong) UILabel *ticket_id_label;//ticket_id的Label

@property (nonatomic ,strong)NSString *live_tk;//直播活动live_tk
@property (nonatomic ,strong)NSString *ticket_id;//直播活动ticket_id

@property (nonatomic ,strong) UIButton *startLiveButton;//直播按钮

@property (nonatomic,strong) MZLiveSelectBiteRateView *biteRateView;//选择清晰度的view

@end

@implementation MZReadyLiveViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[MZChannelManagerModel alloc] init];
    
    UIImageView* _bgCameraView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, MZScreenHeight)];
    [self.view addSubview:_bgCameraView];
    [MZCameraImageHelper embedPreviewInView:_bgCameraView];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startFullScreen" object:nil];
    self.navigationController.navigationBar.hidden = YES;
    [MZCameraImageHelper startRunning];
    [MZCameraImageHelper swapCameras:NO];
    
    self.live_tk_label.text = @"点击更改";
    self.live_tk = self.live_tk_label.text;
    
    self.ticket_id_label.text = @"点击更改";
    self.ticket_id = self.ticket_id_label.text;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MZCameraImageHelper stopRunning];
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)backButtonClick {
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectBgView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.blurEffectBgView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:self.blurEffectBgView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 44, 64, 40);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, 84)];
    tipLabel.text = @"请输入自己服务器获取的live_tk和ticket_id信息\n如果不输入则默认使用我们的测试信息";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.numberOfLines = 2;
    [self.view addSubview:tipLabel];
    
    UILabel *liveTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, tipLabel.frame.origin.y + tipLabel.frame.size.height, 70, 44.0)];
    liveTipLabel.text = @"live_tk:";
    liveTipLabel.font = [UIFont systemFontOfSize:15];
    liveTipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:liveTipLabel];
    
    self.live_tk_label = [[UILabel alloc] initWithFrame:CGRectMake(90, liveTipLabel.frame.origin.y, self.view.frame.size.width - 120, 44.0)];
    self.live_tk_label.userInteractionEnabled = YES;
    self.live_tk_label.text = @"点击更改";
    self.live_tk_label.adjustsFontSizeToFitWidth = YES;
    self.live_tk_label.textAlignment = NSTextAlignmentRight;
    self.live_tk_label.textColor = [UIColor whiteColor];
    [self.view addSubview:self.live_tk_label];
    self.live_tk = self.live_tk_label.text;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [self.live_tk_label addGestureRecognizer:tap2];
    
    UILabel *ticketTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, liveTipLabel.frame.origin.y+liveTipLabel.frame.size.height, 70, 44.0)];
    ticketTipLabel.text = @"ticket_id:";
    ticketTipLabel.font = [UIFont systemFontOfSize:15];
    ticketTipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:ticketTipLabel];
    
    self.ticket_id_label = [[UILabel alloc] initWithFrame:CGRectMake(90, ticketTipLabel.frame.origin.y, self.view.frame.size.width - 120, 44.0)];
    self.ticket_id_label.userInteractionEnabled = YES;
    self.ticket_id_label.text = @"点击更改";
    self.ticket_id_label.adjustsFontSizeToFitWidth = YES;
    self.ticket_id_label.textAlignment = NSTextAlignmentRight;
    self.ticket_id_label.textColor = [UIColor whiteColor];
    [self.view addSubview:self.ticket_id_label];
    self.ticket_id = self.ticket_id_label.text;
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [self.ticket_id_label addGestureRecognizer:tap3];
    
    UILabel *meiyanLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ticketTipLabel.frame.origin.y+ticketTipLabel.frame.size.height, 70, 44.0)];
    meiyanLabel.text = @"美颜";
    meiyanLabel.font = [UIFont systemFontOfSize:15];
    meiyanLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:meiyanLabel];
    
    UISwitch *meiyanSwith = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, meiyanLabel.frame.origin.y, 60, 44.0)];
    [self.view addSubview:meiyanSwith];
    meiyanSwith.backgroundColor = [UIColor whiteColor];
    [meiyanSwith roundChangeWithRadius:31/2.0];
    self.meiyanSwith = meiyanSwith;
    [self.meiyanSwith setOn:NO];
    
    UILabel *landscapeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, meiyanLabel.frame.origin.y+meiyanLabel.frame.size.height, 110, 44.0)];
    landscapeLabel.text = @"是否横屏直播";
    landscapeLabel.font = [UIFont systemFontOfSize:15];
    landscapeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:landscapeLabel];
    
    UISwitch *landscapeSwith = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, landscapeLabel.frame.origin.y, 60, 44.0)];
    [self.view addSubview:landscapeSwith];
    landscapeSwith.backgroundColor = [UIColor whiteColor];
    [landscapeSwith roundChangeWithRadius:31/2.0];
    self.landscapeSwitch = landscapeSwith;
    [self.landscapeSwitch setOn:NO];
    
    UILabel *muteLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, landscapeLabel.frame.origin.y+landscapeLabel.frame.size.height, 110, 44.0)];
    muteLabel.text = @"是否静音";
    muteLabel.font = [UIFont systemFontOfSize:15];
    muteLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:muteLabel];
    
    UISwitch *muteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, muteLabel.frame.origin.y, 60, 44.0)];
    [self.view addSubview:muteSwitch];
    muteSwitch.backgroundColor = [UIColor whiteColor];
    [muteSwitch roundChangeWithRadius:31/2.0];
    self.muteSwith = muteSwitch;
    [self.muteSwith setOn:NO];
    
    UILabel *frontCameraLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, muteLabel.frame.origin.y+muteLabel.frame.size.height, 110, 44.0)];
    frontCameraLabel.text = @"是否前置摄像头";
    frontCameraLabel.font = [UIFont systemFontOfSize:15];
    frontCameraLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:frontCameraLabel];
    
    UISwitch *frontCameraSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, frontCameraLabel.frame.origin.y, 60, 44.0)];
    [self.view addSubview:frontCameraSwitch];
    frontCameraSwitch.backgroundColor = [UIColor whiteColor];
    [frontCameraSwitch roundChangeWithRadius:31/2.0];
    self.frontCameraSwitch = frontCameraSwitch;
    [self.frontCameraSwitch setOn:YES];
    
    UILabel *countDownTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, frontCameraLabel.frame.origin.y+frontCameraLabel.frame.size.height, 180, 44.0)];
    countDownTipLabel.text = @"开始倒计时(默认为3秒)";
    countDownTipLabel.font = [UIFont systemFontOfSize:15];
    countDownTipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:countDownTipLabel];
    self.countDownNumber = 3;

    UILabel *countDownLabel = [[UILabel alloc]init];
    countDownLabel.text = @"点击更改";
    countDownLabel.userInteractionEnabled = YES;
    countDownLabel.font = [UIFont systemFontOfSize:16];
    countDownLabel.textColor = [UIColor whiteColor];
    countDownLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:countDownLabel];
    countDownLabel.frame = CGRectMake(self.view.frame.size.width - 120, countDownTipLabel.frame.origin.y, 90, 44.0);
    self.coundDownLabel = countDownLabel;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [self.coundDownLabel addGestureRecognizer:tap];
    
    UILabel *biteRateTipLabel = [[UILabel alloc]init];
    biteRateTipLabel.text = @"清晰度选择(默认为超清)";
    biteRateTipLabel.font = [UIFont systemFontOfSize:15];
    biteRateTipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:biteRateTipLabel];
    biteRateTipLabel.frame = CGRectMake(20, countDownTipLabel.frame.origin.y+countDownTipLabel.frame.size.height, 180, 44.0);
    self.videoSessionPreset = 2;
    
    UILabel *biteRateLabel = [[UILabel alloc]init];
    biteRateLabel.text = @"点击更改";
    biteRateLabel.userInteractionEnabled = YES;
    biteRateLabel.font = [UIFont systemFontOfSize:16];
    biteRateLabel.textColor = [UIColor whiteColor];
    biteRateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:biteRateLabel];
    biteRateLabel.frame = CGRectMake(self.view.frame.size.width - 120, biteRateTipLabel.frame.origin.y, 90, 44.0);
    self.biteRateLabe = biteRateLabel;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    [self.biteRateLabe addGestureRecognizer:tap1];
    
    UIButton *startLiveButton = [[UIButton alloc] init];
    self.startLiveButton = startLiveButton;
    [self.view addSubview:startLiveButton];
    [startLiveButton addTarget:self action:@selector(liveButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    startLiveButton.enabled = YES;
    [startLiveButton setImage:[UIImage imageNamed:@"live_button_enable"] forState:UIControlStateNormal];

    CGFloat bottomSpace = 5;
    if (IPHONE_X) {
        bottomSpace+=34;
    }
    
    startLiveButton.frame = CGRectMake(12, self.view.frame.size.height - bottomSpace - 64*MZ_RATE, self.view.frame.size.width - 24, 64*MZ_RATE); 
}

- (void)labelClick:(UITapGestureRecognizer *)tap {
    if (tap.view == self.coundDownLabel) {
        // 自定义倒计时
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入直播开始倒计时" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(alertController)weakAlert = alertController;
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypePhonePad;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *inputTextField = weakAlert.textFields.firstObject;
            if ([inputTextField.text intValue] > 0) {
                self.countDownNumber = [inputTextField.text intValue];
                self.coundDownLabel.text = [NSString stringWithFormat:@"%d",self.countDownNumber];
            } else {
                [self showTextView:self.view message:@"请输入大于0的数字"];
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];

    } else if (tap.view == self.biteRateLabe) {
        // 选择清晰度
        [self showBiteRateView];
    } else if (tap.view == self.live_tk_label) {
        // 输入live_tk
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入live_tk" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(alertController)weakAlert = alertController;
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            // 关闭首字母大写
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            // 关闭自动联想
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *inputTextField = weakAlert.textFields.firstObject;
            if (inputTextField.text.length) {
                self.live_tk_label.text = inputTextField.text;
                self.live_tk = self.live_tk_label.text;
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (tap.view == self.ticket_id_label) {
        // 输入ticket_id
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入ticket_id" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(alertController)weakAlert = alertController;
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            // 关闭首字母大写
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            // 关闭自动联想
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *inputTextField = weakAlert.textFields.firstObject;
            if (inputTextField.text.length) {
                self.ticket_id_label.text = inputTextField.text;
                self.ticket_id = self.ticket_id_label.text;
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// 选择清晰度
- (void)showBiteRateView {
    WeaklySelf(weakSelf);
    _biteRateView = [[MZLiveSelectBiteRateView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) BiteRateArray:@[@"标清 360P",@"高清 540P",@"超清 720P"] SelectIndex:self.videoSessionPreset];
    _biteRateView.biteRateBlock = ^(NSInteger index) {
        weakSelf.videoSessionPreset = (int)index;
        weakSelf.biteRateLabe.text = @[@"标清 360P",@"高清 540P",@"超清 720P"][index];
    };
    [self.view addSubview:self.biteRateView];
}

#pragma mark - 开启直播
-(void)liveButtonDidClick:(UIButton *)button{
     NSLog(@"%s",__func__);
    self.startLiveButton.userInteractionEnabled = NO;
    
    // 如果已经从你们服务器获取了 live_tk 和 ticket_id,那么就直接开始直播
    if (self.live_tk.length > 4 && self.ticket_id.length > 4) {
        [self getLiveData];
    } else {
        // 从测试服务器使用测试数据获取
        [self createNewLiveActivity];
    }
}

-(void)createNewLiveActivity
{
    [MZSimpleHud show];
    WeaklySelf(weakSelf);

#warning 这里是我自己模拟的创建活动,为了获取 live_tk 和 ticket_id ,数据是写死的。（你用的时候自己从自己服务器获取 live_tk 和 ticket_id,不需要使用这个接口）
    // 直播封面地址（测试数据）
    NSString *live_coverURLString = @"http://s1.t.zmengzhu.com/upload/img/6e/77/6e77552721067fbc87ee0b00664556d1.png";
    // 直播名字（测试数据）
    NSString *live_name = @"直播测试";

    [MZNewLiveActivityTest test_createNewLiveWithLiveCover:live_coverURLString liveName:live_name success:^(id _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"live_tk-----------  %@",[response valueForKey:@"live_tk"]);
            self.live_tk = [response valueForKey:@"live_tk"];
            self.ticket_id = [response valueForKey:@"ticket_id"];
            [self getLiveData];
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"error = %@",error.localizedDescription);
            [weakSelf showTextView:self.view message:error.domain];
            self.startLiveButton.userInteractionEnabled = YES;
            [MZSimpleHud hide];
        });
    }];
}

-(void)getLiveData
{
    WeaklySelf(weakSelf);
    NSString *codeName = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                   (CFStringRef)[MZUserServer currentUser].nickName,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8));
    NSString *codeAvatar = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                   (CFStringRef)[MZUserServer currentUser].avatar,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8));
    
    [MZSDKBusinessManager startLiveWithUsername:codeName userAvatar:codeAvatar userId:[MZUserServer currentUser].userId ticketId:self.ticket_id live_tk:self.live_tk success:^(id response) {
        weakSelf.startLiveInfoDict = ((NSDictionary *)response).mutableCopy;
        weakSelf.model.ticket_id = weakSelf.startLiveInfoDict[@"ticket_id"];
        weakSelf.model.msg_conf = [MZMoviePlayerMsg_conf mz_objectWithKeyValues:weakSelf.startLiveInfoDict[@"msg_conf"]];
        weakSelf.model.chat_conf = [MZMoviePlayerChat_conf mz_objectWithKeyValues:weakSelf.startLiveInfoDict[@"chat_conf"]];
        weakSelf.model.push_url = weakSelf.startLiveInfoDict[@"push_url"];
        
        weakSelf.model.channelId = weakSelf.startLiveInfoDict[@"channel_id"];
        weakSelf.model.channelName = weakSelf.startLiveInfoDict[@"stream_name"];
        weakSelf.model.webinar_id = weakSelf.startLiveInfoDict[@"webinar_id"];
        
        
        NSLog(@"push_url = %@",weakSelf.model.push_url);
        MZLiveUserModel *LiveUser = [[MZLiveUserModel alloc] init];
        LiveUser.nickname = [MZUserServer currentUser].nickName;
        LiveUser.uid = [MZUserServer currentUser].userId;
        LiveUser.avatar = [MZUserServer currentUser].avatar;
        [MZSimpleHud hide];
        
        [self pushToLive:LiveUser];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
        [weakSelf showTextView:weakSelf.view message:error.domain];
        self.startLiveButton.userInteractionEnabled = YES;
        [MZSimpleHud hide];
    }];
}

- (void)pushToLive:(MZLiveUserModel *)user{
    //相机、麦克风权限检测
    if (![MZGlobalTools checkMediaDevice:AVMediaTypeAudio])
        return;
    if (![MZGlobalTools checkMediaDevice:AVMediaTypeVideo])
        return;
    dispatch_async(dispatch_get_main_queue(), ^{
        WeaklySelf(weakSelf);
        MZLiveViewController * live = [[MZLiveViewController alloc]initWithFinishModel:^(MZLiveFinishModel *model) {

            MZLiveFinishViewController * finishVC = [[MZLiveFinishViewController alloc]init];
            finishVC.model = model;
            [weakSelf presentViewController:finishVC animated:YES completion:nil];

        }];
        
        // 设置数据源
        live.model = self.model;
        live.liveParama = self.startLiveInfoDict;
        live.latestUser = user;

        // 设置（前置/后置）摄像头，默认前置
        live.isFrontCameraType = self.frontCameraSwitch.isOn;
        
        // 设置镜像开关，默认关闭
        live.isMirroringType = NO;
        
        // 设置是否静音，默认非静音
        live.isMuteType = self.muteSwith.isOn;
        
        // 设置闪光灯开关（后置摄像头才有用），默认不使用
        live.isTorchType = NO;
        
        // 设置是否开启美颜，默认关闭
        live.isBeautyFace = self.meiyanSwith.isOn;
        
        // 设置（横/竖）屏直播，默认竖屏
        live.isLandscape = self.landscapeSwitch.isOn;

        // 设置开始倒计时描述，默认3秒
        live.countDownNum = self.countDownNumber;
        
        // 设置清晰度，默认高清
        live.videoSessionPreset = self.videoSessionPreset;
        
        self.startLiveButton.userInteractionEnabled = YES;
        live.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:live animated:YES completion:nil];
    });
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
