//
//  MZReadyLiveViewController.m
//  MengZhu
//
//  Created by vhall on 16/11/29.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZReadyLiveViewController.h"
#import "MZLiveViewController.h"
#import "MZLiveFinishViewController.h"
#import "MZAlertController.h"
#import "MZSDKConfig.h"
#import "MZConditionListView.h"

typedef enum : int {
    MZWatchMode_Free = 1,
    MZWatchMode_WhiteList = 5,
    MZWatchMode_FCode = 6,
} MZWatchMode;

@interface MZReadyLiveViewController ()<UITextFieldDelegate,UITextFieldDelegate,MZConditionLabelSelectProtocol>
@property (nonatomic, strong) NSMutableDictionary *startLiveInfoDict;
@property (nonatomic,   copy) NSString *live_tkString;
@property (nonatomic,   copy) NSString *ticket_idString;
@property (nonatomic, strong) MZChannelManagerModel *model;

@property (nonatomic, strong) UIScrollView *bgScrollView;//背景滑动的ScrollView
@property (nonatomic, strong) UIView *topBgView;//信息填写的背景

@property (nonatomic, strong) UITextField *uniqueIdTextField;//用户ID
//@property (nonatomic, strong) UITextField *liveTKTextField;//live_tk
//@property (nonatomic, strong) UITextField *ticketIdTextField;//ticket_id
@property (nonatomic, strong) UITextField *countDownTextField;//倒计时
@property (nonatomic, strong) UITextField *categoryTextField;//直播分类选择
@property (nonatomic, assign) int selectCategoryId;//选中的分类ID

@property (nonatomic, strong) MZConditionLabel *beautyFaceLabel;//美颜label
@property (nonatomic, strong) MZConditionLabel *backgroundCameraLabel;//是否后置摄像头
@property (nonatomic, strong) MZConditionLabel *muteLabel;//静音label
@property (nonatomic, strong) MZConditionLabel *blockAllLabel;//禁言label
@property (nonatomic, strong) MZConditionLabel *autoRecordLabel;//是否生成回放label

@property (nonatomic, strong) UIButton *sessionPresetMediumButton;//标清
@property (nonatomic, strong) UIButton *sessionPresetHighButton;//高清
@property (nonatomic, strong) UIButton *sessionPresetVeryHighButton;//超清
@property (nonatomic, assign) MZCaptureSessionPreset selectSessionPreset;//选中的分辨率

@property (nonatomic, strong) UIButton *watchOfFreeButton;//免费观看按钮
@property (nonatomic, strong) UIButton *watchOfWhiteListButton;//白名单观看按钮
@property (nonatomic, strong) UIButton *watchOfFCodeButton;//F码观看按钮
@property (nonatomic, assign) MZWatchMode selectWatchMode;//选中的观看方式，默认是免费
@property (nonatomic, assign) int selectFCodeId;//选中的F码ID
@property (nonatomic, assign) int selectWhiteListIds;//选中的白名单ID列表

@property (nonatomic, strong) UIButton *pusherPortraitButton;//竖屏直播按钮
@property (nonatomic, strong) UIButton *pusherLandspaceButton;//横屏直播按钮
@property (nonatomic, strong) UIButton *pusherAudioButton;//音频直播按钮

@property (nonatomic, strong) UIButton *currentPusherButton;//当前点击的直播按钮
@end

@implementation MZReadyLiveViewController

- (void)dealloc {
    NSLog(@"推流配置界面释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"推流";
    self.model = [[MZChannelManagerModel alloc] init];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)backButtonClick {
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard {
    [self.uniqueIdTextField resignFirstResponder];
//    [self.liveTKTextField resignFirstResponder];
//    [self.ticketIdTextField resignFirstResponder];
    [self.countDownTextField resignFirstResponder];
}

- (void)selectOrUnSelect:(MZConditionLabel *)label {
    [self hideKeyboard];
}

- (void)setupUI {
    self.selectCategoryId = 0;
    self.selectFCodeId = 0;
    self.selectWhiteListIds = 0;
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;

    CGFloat scrollViewHeight = self.view.frame.size.height - navBarHeight - (IPHONE_X ? 39 : 10) - 49 - 20 - 44 - 10;
    CGFloat scrollViewContentHeight = 44*4 + 44*MZ_RATE*8 + 60*MZ_RATE*2;
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, scrollViewHeight)];
    self.bgScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView setContentSize:CGSizeMake(self.view.frame.size.width, scrollViewContentHeight)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.bgScrollView addGestureRecognizer:tap];
    
    UILabel *infoInputLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.view.frame.size.width, 44)];
    infoInputLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1];
    infoInputLabel.backgroundColor = [UIColor clearColor];
    infoInputLabel.text = @"信息填写";
    [self.bgScrollView addSubview:infoInputLabel];
    
    self.topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, infoInputLabel.frame.size.height+infoInputLabel.frame.origin.y, self.view.frame.size.width, 44*MZ_RATE*3)];
    self.topBgView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self.bgScrollView addSubview:self.topBgView];
    
    NSDictionary *attrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:14*MZ_RATE],NSForegroundColorAttributeName:[UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1]};
    
    NSMutableAttributedString *uniquePlaceStr = [[NSMutableAttributedString alloc] initWithString:@"填写第三方用户唯一ID，必填项，例:user888" attributes:attrDict];
//    NSMutableAttributedString *live_TKPlaceStr = [[NSMutableAttributedString alloc] initWithString:@"填写live_tk，debug模式会自动获取，无需填写" attributes:attrDict];
//    NSMutableAttributedString *ticket_IDPlaceStr = [[NSMutableAttributedString alloc] initWithString:@"填写ticketId，debug模式会自动获取，无需填写" attributes:attrDict];
    NSMutableAttributedString *countDownPlaceStr = [[NSMutableAttributedString alloc] initWithString:@"填写开始倒计时时长，默认为3秒" attributes:attrDict];
    NSMutableAttributedString *categoryPlaceStr = [[NSMutableAttributedString alloc] initWithString:@"选择直播分类" attributes:attrDict];

    UILabel *aRedStar = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 20, 44*MZ_RATE)];
    aRedStar.backgroundColor = [UIColor clearColor];
    aRedStar.textAlignment = NSTextAlignmentCenter;
    aRedStar.textColor = [UIColor redColor];
    aRedStar.text = @"*";
    [self.topBgView addSubview:aRedStar];
        
    self.uniqueIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width - 30, 44*MZ_RATE)];
    self.uniqueIdTextField.backgroundColor = [UIColor clearColor];
    self.uniqueIdTextField.keyboardType = UIKeyboardTypeDefault;
    self.uniqueIdTextField.textColor = [UIColor whiteColor];
    self.uniqueIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.topBgView addSubview:self.uniqueIdTextField];
    [self.uniqueIdTextField setAttributedPlaceholder:uniquePlaceStr];
    
//    self.liveTKTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, self.uniqueIdTextField.bottom, self.view.bounds.size.width - 30, 44*MZ_RATE)];
//    self.liveTKTextField.backgroundColor = [UIColor clearColor];
//    self.liveTKTextField.keyboardType = UIKeyboardTypeDefault;
//    self.liveTKTextField.textColor = [UIColor whiteColor];
//    self.liveTKTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [self.topBgView addSubview:self.liveTKTextField];
//    [self.liveTKTextField setAttributedPlaceholder:live_TKPlaceStr];
//
//    self.ticketIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, self.liveTKTextField.bottom, self.view.bounds.size.width - 30, 44*MZ_RATE)];
//    self.ticketIdTextField.backgroundColor = [UIColor clearColor];
//    self.ticketIdTextField.keyboardType = UIKeyboardTypeDefault;
//    self.ticketIdTextField.textColor = [UIColor whiteColor];
//    self.ticketIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [self.topBgView addSubview:self.ticketIdTextField];
//    [self.ticketIdTextField setAttributedPlaceholder:ticket_IDPlaceStr];
    
    self.countDownTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, self.uniqueIdTextField.bottom, self.view.bounds.size.width - 30, 44*MZ_RATE)];
    self.countDownTextField.backgroundColor = [UIColor clearColor];
    self.countDownTextField.keyboardType = UIKeyboardTypeDefault;
    self.countDownTextField.textColor = [UIColor whiteColor];
    self.countDownTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.topBgView addSubview:self.countDownTextField];
    [self.countDownTextField setAttributedPlaceholder:countDownPlaceStr];
    
    self.categoryTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, self.countDownTextField.bottom, self.view.bounds.size.width - 30, 44*MZ_RATE)];
    self.categoryTextField.backgroundColor = [UIColor clearColor];
    self.categoryTextField.keyboardType = UIKeyboardTypeDefault;
    self.categoryTextField.textColor = [UIColor whiteColor];
    self.categoryTextField.keyboardType = UIKeyboardTypePhonePad;
    self.categoryTextField.delegate = self;
    [self.topBgView addSubview:self.categoryTextField];
    [self.categoryTextField setAttributedPlaceholder:categoryPlaceStr];
    
    UILabel *conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, self.topBgView.bottom, self.view.frame.size.width, 44)];
    conditionLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1];
    conditionLabel.backgroundColor = [UIColor clearColor];
    conditionLabel.text = @"条件筛选";
    [self.bgScrollView addSubview:conditionLabel];
    
    UIView *conditionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, conditionLabel.frame.size.height+conditionLabel.frame.origin.y, self.view.frame.size.width, 44*MZ_RATE*5)];
    conditionBgView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self.bgScrollView addSubview:conditionBgView];
    
    self.beautyFaceLabel = [[MZConditionLabel alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width - 30, 44*MZ_RATE)];
    self.beautyFaceLabel.text = @"开启美颜";
    self.beautyFaceLabel.delegate = self;
    self.beautyFaceLabel.textColor = [UIColor whiteColor];
    self.beautyFaceLabel.font = [UIFont systemFontOfSize:14];
    self.beautyFaceLabel.backgroundColor = [UIColor clearColor];
    [conditionBgView addSubview:self.beautyFaceLabel];
    self.beautyFaceLabel.isSelect = YES;
    
    self.backgroundCameraLabel = [[MZConditionLabel alloc] initWithFrame:CGRectMake(30, self.beautyFaceLabel.bottom, self.view.frame.size.width - 30, 44*MZ_RATE)];
    self.backgroundCameraLabel.delegate = self;
    self.backgroundCameraLabel.text = @"后置摄像头";
    self.backgroundCameraLabel.textColor = [UIColor whiteColor];
    self.backgroundCameraLabel.font = [UIFont systemFontOfSize:14];
    self.backgroundCameraLabel.backgroundColor = [UIColor clearColor];
    [conditionBgView addSubview:self.backgroundCameraLabel];
    
    self.muteLabel = [[MZConditionLabel alloc] initWithFrame:CGRectMake(30, self.backgroundCameraLabel.bottom, self.view.frame.size.width - 30, 44*MZ_RATE)];
    self.muteLabel.text = @"静音";
    self.muteLabel.delegate = self;
    self.muteLabel.textColor = [UIColor whiteColor];
    self.muteLabel.font = [UIFont systemFontOfSize:14];
    self.muteLabel.backgroundColor = [UIColor clearColor];
    [conditionBgView addSubview:self.muteLabel];
    
    self.blockAllLabel = [[MZConditionLabel alloc] initWithFrame:CGRectMake(30, self.muteLabel.bottom, self.view.frame.size.width - 30, 44*MZ_RATE)];
    self.blockAllLabel.delegate = self;
    self.blockAllLabel.text = @"全体禁言";
    self.blockAllLabel.textColor = [UIColor whiteColor];
    self.blockAllLabel.font = [UIFont systemFontOfSize:14];
    self.blockAllLabel.backgroundColor = [UIColor clearColor];
    [conditionBgView addSubview:self.blockAllLabel];
    
    self.autoRecordLabel = [[MZConditionLabel alloc] initWithFrame:CGRectMake(30, self.blockAllLabel.bottom, self.view.frame.size.width - 30, 44*MZ_RATE)];
    self.autoRecordLabel.delegate = self;
    self.autoRecordLabel.text = @"是否生成回放";
    self.autoRecordLabel.textColor = [UIColor whiteColor];
    self.autoRecordLabel.font = [UIFont systemFontOfSize:14];
    self.autoRecordLabel.backgroundColor = [UIColor clearColor];
    [conditionBgView addSubview:self.autoRecordLabel];
    self.autoRecordLabel.isSelect = YES;
    
    UILabel *sessionPresetLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, conditionBgView.bottom, self.view.frame.size.width, 44)];
    sessionPresetLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1];
    sessionPresetLabel.backgroundColor = [UIColor clearColor];
    sessionPresetLabel.text = @"清晰度选择";
    [self.bgScrollView addSubview:sessionPresetLabel];
    
    UIView *sessionPresetBgView = [[UIView alloc] initWithFrame:CGRectMake(0, sessionPresetLabel.frame.size.height+sessionPresetLabel.frame.origin.y, self.view.frame.size.width, 60*MZ_RATE)];
    sessionPresetBgView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self.bgScrollView addSubview:sessionPresetBgView];
    
    CGFloat itemWidth = (self.view.frame.size.width - 30*4)/3;
    
    self.sessionPresetMediumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sessionPresetMediumButton.frame = CGRectMake(30, 10*MZ_RATE, itemWidth, 40*MZ_RATE);
    [self.sessionPresetMediumButton setImage:[UIImage imageNamed:@"mz_config_biaoqing_normal"] forState:UIControlStateNormal];
    [self.sessionPresetMediumButton setImage:[UIImage imageNamed:@"mz_config_biaoqing_select"] forState:UIControlStateSelected];
    [self.sessionPresetMediumButton setTitle:@"  标清" forState:UIControlStateNormal];
    [self.sessionPresetMediumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sessionPresetMediumButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateSelected];
    [self.sessionPresetMediumButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.sessionPresetMediumButton addTarget:self action:@selector(sessionPresetClick:) forControlEvents:UIControlEventTouchUpInside];
    [sessionPresetBgView addSubview:self.sessionPresetMediumButton];
    self.sessionPresetMediumButton.layer.cornerRadius = 10.5;
    self.sessionPresetMediumButton.layer.masksToBounds = YES;
    
    self.sessionPresetHighButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sessionPresetHighButton.frame = CGRectMake(30+self.sessionPresetMediumButton.right, 10*MZ_RATE, itemWidth, 40*MZ_RATE);
    [self.sessionPresetHighButton setImage:[UIImage imageNamed:@"mz_config_gaoqing_normal"] forState:UIControlStateNormal];
    [self.sessionPresetHighButton setImage:[UIImage imageNamed:@"mz_config_gaoqing_select"] forState:UIControlStateSelected];
    [self.sessionPresetHighButton setTitle:@"  高清" forState:UIControlStateNormal];
    [self.sessionPresetHighButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sessionPresetHighButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateSelected];
    [self.sessionPresetHighButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.sessionPresetHighButton addTarget:self action:@selector(sessionPresetClick:) forControlEvents:UIControlEventTouchUpInside];
    [sessionPresetBgView addSubview:self.sessionPresetHighButton];
    self.sessionPresetHighButton.layer.cornerRadius = 10.5;
    self.sessionPresetHighButton.layer.masksToBounds = YES;
    
    self.sessionPresetVeryHighButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sessionPresetVeryHighButton.frame = CGRectMake(30+self.sessionPresetHighButton.right, 10*MZ_RATE, itemWidth, 40*MZ_RATE);
    [self.sessionPresetVeryHighButton setImage:[UIImage imageNamed:@"mz_config_chaoqing_normal"] forState:UIControlStateNormal];
    [self.sessionPresetVeryHighButton setImage:[UIImage imageNamed:@"mz_config_chaoqing_select"] forState:UIControlStateSelected];
    [self.sessionPresetVeryHighButton setTitle:@"  超清" forState:UIControlStateNormal];
    [self.sessionPresetVeryHighButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sessionPresetVeryHighButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateSelected];
    [self.sessionPresetVeryHighButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.sessionPresetVeryHighButton addTarget:self action:@selector(sessionPresetClick:) forControlEvents:UIControlEventTouchUpInside];
    [sessionPresetBgView addSubview:self.sessionPresetVeryHighButton];
    self.selectSessionPreset = MZCaptureSessionPreset720x1280;
    self.sessionPresetVeryHighButton.layer.cornerRadius = 10.5;
    self.sessionPresetVeryHighButton.layer.masksToBounds = YES;
    self.sessionPresetVeryHighButton.selected = YES;
    self.sessionPresetVeryHighButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
    self.sessionPresetVeryHighButton.layer.borderWidth = 1.0;
    
    UILabel *watchModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, sessionPresetBgView.bottom, self.view.frame.size.width, 44)];
    watchModeLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1];
    watchModeLabel.backgroundColor = [UIColor clearColor];
    watchModeLabel.text = @"观看方式";
    [self.bgScrollView addSubview:watchModeLabel];
       
    UIView *watchModeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, watchModeLabel.frame.size.height+watchModeLabel.frame.origin.y, self.view.frame.size.width, 60*MZ_RATE)];
    watchModeBgView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self.bgScrollView addSubview:watchModeBgView];
                  
    self.watchOfFreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.watchOfFreeButton.frame = CGRectMake(30, 10*MZ_RATE, itemWidth, 40*MZ_RATE);
    [self.watchOfFreeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.watchOfFreeButton setTitle:@"免费观看" forState:UIControlStateNormal];
    [self.watchOfFreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.watchOfFreeButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateSelected];
    [self.watchOfFreeButton addTarget:self action:@selector(watchModeClick:) forControlEvents:UIControlEventTouchUpInside];
    [watchModeBgView addSubview:self.watchOfFreeButton];
    self.watchOfFreeButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
    self.watchOfFreeButton.layer.borderWidth = 1.0;
    self.watchOfFreeButton.layer.cornerRadius = 10.5;
    self.watchOfFreeButton.layer.masksToBounds = YES;
    
    self.watchOfWhiteListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.watchOfWhiteListButton.frame = CGRectMake(30+self.watchOfFreeButton.right, 10*MZ_RATE, itemWidth, 40*MZ_RATE);
    [self.watchOfWhiteListButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.watchOfWhiteListButton setTitle:@"白名单观看" forState:UIControlStateNormal];
    [self.watchOfWhiteListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.watchOfWhiteListButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateSelected];
    [self.watchOfWhiteListButton addTarget:self action:@selector(watchModeClick:) forControlEvents:UIControlEventTouchUpInside];
    [watchModeBgView addSubview:self.watchOfWhiteListButton];
    self.watchOfWhiteListButton.layer.cornerRadius = 10.5;
    self.watchOfWhiteListButton.layer.masksToBounds = YES;
    
    self.watchOfFCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.watchOfFCodeButton.frame = CGRectMake(30+self.watchOfWhiteListButton.right, 10*MZ_RATE, itemWidth, 40*MZ_RATE);
    [self.watchOfFCodeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.watchOfFCodeButton setTitle:@"F码观看" forState:UIControlStateNormal];
    [self.watchOfFCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.watchOfFCodeButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateSelected];
    [self.watchOfFCodeButton addTarget:self action:@selector(watchModeClick:) forControlEvents:UIControlEventTouchUpInside];
    [watchModeBgView addSubview:self.watchOfFCodeButton];
    self.watchOfFCodeButton.layer.cornerRadius = 10.5;
    self.watchOfFCodeButton.layer.masksToBounds = YES;
    
    self.watchOfFreeButton.selected = YES;
    self.selectWatchMode = MZWatchMode_Free;

    CGFloat pushItemWidth = (self.view.frame.size.width - 46*2 - 20)/2;
    
    self.pusherAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pusherAudioButton.frame = CGRectMake(46, self.view.frame.size.height - (IPHONE_X ? 39 : 10) - 49, self.view.frame.size.width - 46*2, 49);
    self.pusherAudioButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
    self.pusherAudioButton.layer.borderWidth = 1.0;
    [self.pusherAudioButton setTitle:@"语音直播" forState:UIControlStateNormal];
    [self.pusherAudioButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
    [self.pusherAudioButton setBackgroundColor:[UIColor clearColor]];
    [self.pusherAudioButton addTarget:self action:@selector(pusherClick:) forControlEvents:UIControlEventTouchUpInside];
    self.pusherAudioButton.layer.cornerRadius = 25;
    self.pusherLandspaceButton.layer.masksToBounds = YES;
    [self.view addSubview:self.pusherAudioButton];
    
    self.pusherPortraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pusherPortraitButton.frame = CGRectMake(46, self.pusherAudioButton.top - 20 - 44, pushItemWidth, 44);
    [self.pusherPortraitButton setTitle:@"竖屏直播" forState:UIControlStateNormal];
    [self.pusherPortraitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.pusherPortraitButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1]];
    [self.pusherPortraitButton addTarget:self action:@selector(pusherClick:) forControlEvents:UIControlEventTouchUpInside];
    self.pusherPortraitButton.layer.cornerRadius = 22;
    self.pusherPortraitButton.layer.masksToBounds = YES;
    [self.view addSubview:self.pusherPortraitButton];
    
    self.pusherLandspaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pusherLandspaceButton.frame = CGRectMake(46+20+pushItemWidth, self.pusherAudioButton.top - 20 - 44, pushItemWidth, 44);
    [self.pusherLandspaceButton setTitle:@"横屏直播" forState:UIControlStateNormal];
    [self.pusherLandspaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.pusherLandspaceButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1]];
    [self.pusherLandspaceButton addTarget:self action:@selector(pusherClick:) forControlEvents:UIControlEventTouchUpInside];
    self.pusherLandspaceButton.layer.cornerRadius = 22;
    self.pusherLandspaceButton.layer.masksToBounds = YES;
    [self.view addSubview:self.pusherLandspaceButton];
    
    MZUser *user = [MZBaseUserServer currentUser];
    if (user) {
        self.uniqueIdTextField.text = user.uniqueID;
    }
}

// 选择清晰度
- (void)sessionPresetClick:(UIButton *)sender {
    if (sender == self.sessionPresetMediumButton) {
        self.selectSessionPreset = MZCaptureSessionPreset360x640;
        self.sessionPresetMediumButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
        self.sessionPresetMediumButton.layer.borderWidth = 1.0;
        self.sessionPresetHighButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.sessionPresetHighButton.layer.borderWidth = 0;
        self.sessionPresetVeryHighButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.sessionPresetVeryHighButton.layer.borderWidth = 0;
        self.sessionPresetMediumButton.selected = YES;
        self.sessionPresetHighButton.selected = NO;
        self.sessionPresetVeryHighButton.selected = NO;
    } else if (sender == self.sessionPresetHighButton)  {
        self.selectSessionPreset = MZCaptureSessionPreset540x960;
        self.sessionPresetMediumButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.sessionPresetMediumButton.layer.borderWidth = 0;
        self.sessionPresetHighButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
        self.sessionPresetHighButton.layer.borderWidth = 1.0;
        self.sessionPresetVeryHighButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.sessionPresetVeryHighButton.layer.borderWidth = 0;
        self.sessionPresetMediumButton.selected = NO;
        self.sessionPresetHighButton.selected = YES;
        self.sessionPresetVeryHighButton.selected = NO;
    } else if (sender == self.sessionPresetVeryHighButton) {
        self.selectSessionPreset = MZCaptureSessionPreset720x1280;
        self.sessionPresetMediumButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.sessionPresetMediumButton.layer.borderWidth = 0;
        self.sessionPresetHighButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.sessionPresetHighButton.layer.borderWidth = 0;
        self.sessionPresetVeryHighButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
        self.sessionPresetVeryHighButton.layer.borderWidth = 1.0;
        self.sessionPresetMediumButton.selected = NO;
        self.sessionPresetHighButton.selected = NO;
        self.sessionPresetVeryHighButton.selected = YES;
    }
}

/// 选择观看方式
- (void)watchModeClick:(UIButton *)sender {
    if (sender == self.watchOfFreeButton) {
        self.watchOfFreeButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
        self.watchOfFreeButton.layer.borderWidth = 1.0;
        self.watchOfWhiteListButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.watchOfWhiteListButton.layer.borderWidth = 0;
        self.watchOfFCodeButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.watchOfFCodeButton.layer.borderWidth = 0;
        self.watchOfFreeButton.selected = YES;
        self.watchOfWhiteListButton.selected = NO;
        self.watchOfFCodeButton.selected = NO;
        
        self.selectWatchMode = MZWatchMode_Free;
        self.selectWhiteListIds = 0;
        self.selectFCodeId = 0;
    } else if (sender == self.watchOfWhiteListButton) {
        __weak typeof(self) weakSelf = self;
        [self setUserInfoSuccess:^(BOOL result, NSString *errorString) {
            if (result) {
                [MZConditionListView showList:MZReadyConditionListType_White result:^(BOOL isCancel, MZReadyConditionListType type, int selectId, NSString *selectString) {
                    if (isCancel) return;
                    weakSelf.watchOfWhiteListButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
                    weakSelf.watchOfWhiteListButton.layer.borderWidth = 1.0;
                    weakSelf.watchOfFreeButton.layer.borderColor = [UIColor clearColor].CGColor;
                    weakSelf.watchOfFreeButton.layer.borderWidth = 0;
                    weakSelf.watchOfFCodeButton.layer.borderColor = [UIColor clearColor].CGColor;
                    weakSelf.watchOfFCodeButton.layer.borderWidth = 0;
                    
                    weakSelf.watchOfWhiteListButton.selected = YES;
                    weakSelf.watchOfFreeButton.selected = NO;
                    weakSelf.watchOfFCodeButton.selected = NO;
                            
                    weakSelf.selectWatchMode = MZWatchMode_WhiteList;
                    weakSelf.selectFCodeId = 0;
                    weakSelf.selectWhiteListIds = selectId;
                }];
            } else {
                [weakSelf.view show:errorString];
            }
        }];

    } else if (sender == self.watchOfFCodeButton) {
        __weak typeof(self) weakSelf = self;
        [self setUserInfoSuccess:^(BOOL result, NSString *errorString) {
            if (result) {
                [MZConditionListView showList:MZReadyConditionListType_FCode result:^(BOOL isCancel, MZReadyConditionListType type, int selectId, NSString *selectString) {
                    if (isCancel) return;
                    weakSelf.watchOfFCodeButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
                    weakSelf.watchOfFCodeButton.layer.borderWidth = 1.0;
                    weakSelf.watchOfFreeButton.layer.borderColor = [UIColor clearColor].CGColor;
                    weakSelf.watchOfFreeButton.layer.borderWidth = 0;
                    weakSelf.watchOfWhiteListButton.layer.borderColor = [UIColor clearColor].CGColor;
                    weakSelf.watchOfWhiteListButton.layer.borderWidth = 0;
                    
                    weakSelf.watchOfFCodeButton.selected = YES;
                    weakSelf.watchOfFreeButton.selected = NO;
                    weakSelf.watchOfWhiteListButton.selected = NO;

                    weakSelf.selectWatchMode = MZWatchMode_FCode;
                    weakSelf.selectFCodeId = selectId;
                    weakSelf.selectWhiteListIds = 0;
                }];
            } else {
                [weakSelf.view show:errorString];
            }
        }];
    }
}

/// 展示分类列表
- (void)showCategoryList {
    NSLog(@"展示分类列表");
    __weak typeof(self) weakSelf = self;
    [self setUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            [MZConditionListView showList:MZReadyConditionListType_Categroy result:^(BOOL isCancel, MZReadyConditionListType type, int selectId, NSString *selectString) {
                if (isCancel) return;
                weakSelf.selectCategoryId = selectId;
                weakSelf.categoryTextField.text = selectString;
            }];
        } else {
            weakSelf.categoryTextField.text = @"";
            weakSelf.selectCategoryId = 0;
            [weakSelf.view show:errorString];
        }
    }];
}

/// 配置用户信息
- (void)setUserInfoSuccess:(void(^)(BOOL result, NSString *errorString))success {
    if (self.uniqueIdTextField.text.length <= 0) {
        success(NO, @"用户ID不能为空");
        return;
    }
    
    MZUser *user = [MZBaseUserServer currentUser];
    if (!user) {
        user = [[MZUser alloc] init];
    }
    
    if (user.avatar.length <= 0) {
        user.avatar = @"https://cdn.duitang.com/uploads/item/201410/26/20141026191422_yEKyd.thumb.700_0.jpeg";
    }
    
    if (user.nickName.length <= 0) {
        user.nickName = @"大鸭梨";
    }
    
    if (user.phone.length <= 0) {
        user.phone = @"19912344321";
    }
        
#warning - 用户自己传过来的唯一ID
    user.uniqueID = self.uniqueIdTextField.text;

    [MZBaseUserServer updateCurrentUser:user];

    success(YES, @"");
}

- (void)pusherClick:(UIButton *)sender {
    if ([self isSimulator]) {
        return;
    }
    self.currentPusherButton = sender;
    [self liveButtonDidClick:sender];
}

#pragma mark - 开启直播
- (void)liveButtonDidClick:(UIButton *)button {
    NSLog(@"%s",__func__);

    WeaklySelf(weakSelf);
    [self setUserInfoSuccess:^(BOOL result, NSString *errorString) {
        if (result) {
            button.userInteractionEnabled = NO;
            
            // 如果已经从你们服务器获取了 live_tk 和 ticket_id,那么就直接调用getLiveData开始直播
//            if (weakSelf.liveTKTextField.text.length > 4 && weakSelf.ticketIdTextField.text.length > 4) {
//                [weakSelf getLiveData];
//            } else {
                // 从测试服务器使用测试数据获取
                [weakSelf createNewLiveActivity];
//            }
        } else {
            [weakSelf.view show:errorString];
        }
    }];
}

- (void)createNewLiveActivity {
    [MZSDKSimpleHud show];
    
    // 直播封面地址（测试数据）
    NSString *live_coverURLString = @"http://s1.t.zmengzhu.com/upload/img/6e/77/6e77552721067fbc87ee0b00664556d1.png";
    // 直播名字（测试数据）
    NSString *live_name = @"直播测试";
    // 直播简介（测试数据）
    NSString *liveIntroduction = @"直接活动简介";
    
    // 直播所属频道ID，测试的时候请使用对应自己APPID的频道ID，可以向对接人员索取。
    NSString *channel_id = MZSDK_ChannelId;
    
    int live_style = 1;//默认竖屏
    if (self.currentPusherButton == self.pusherLandspaceButton) {//横屏
        live_style = 0;
    }
    
    int live_type = 0;//默认视频直播
    if (self.currentPusherButton == self.pusherAudioButton) {//音频直播
        live_type = 1;
    }
    
    NSString *pay_notice = @"";
    if (self.selectWatchMode == MZWatchMode_FCode) {
        pay_notice = @"视频设置了F码，请输入F码观看";
    } else if (self.selectWatchMode == MZWatchMode_WhiteList) {
        pay_notice = @"视频设置了白名单观看";
    }
    
#pragma mark - 创建直播活动接口 - 此接口建议只是测试使用，该接口返回需要的数据请从自己服务端获取
    [MZSDKBusinessManager createNewLiveWithChannel_id:channel_id liveCover:live_coverURLString liveName:live_name liveIntroduction:liveIntroduction live_style:live_style live_type:live_type auto_record:self.autoRecordLabel.isSelect view_mode:self.selectWatchMode white_id:self.selectWhiteListIds fcode_id:self.selectFCodeId pay_notice:pay_notice category_id:self.selectCategoryId success:^(id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"live_tk-----------  %@",[response valueForKey:@"live_tk"]);
            self.live_tkString = [NSString stringWithFormat:@"%@",[response valueForKey:@"live_tk"]];
            self.ticket_idString = [NSString stringWithFormat:@"%@",[response valueForKey:@"ticket_id"]];
            [self getLiveData];
        });
    } failure:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"error = %@",error.localizedDescription);
            [MZAlertController showWithTitle:@"错误" message:error.domain cancelTitle:@"" sureTitle:@"确定" preferredStyle:UIAlertControllerStyleAlert handle:^(MZResultCode code) {
            }];
            self.currentPusherButton.userInteractionEnabled = YES;
            [MZSDKSimpleHud hide];
        });
    }];
}

- (void)getLiveData {
    MZUser *user = [MZBaseUserServer currentUser];

    [MZSDKBusinessManager startLiveWithUsername:user.nickName userAvatar:user.avatar uniqueId:user.uniqueID ticketId:self.ticket_idString live_tk:self.live_tkString success:^(id response) {
        self.startLiveInfoDict = ((NSDictionary *)response).mutableCopy;
        self.model.ticket_id = self.startLiveInfoDict[@"ticket_id"];
        self.model.msg_conf = [MZMoviePlayerMsg_conf mj_objectWithKeyValues:self.startLiveInfoDict[@"msg_conf"]];
        self.model.chat_conf = [MZMoviePlayerChat_conf mj_objectWithKeyValues:self.startLiveInfoDict[@"chat_conf"]];
        self.model.push_url = self.startLiveInfoDict[@"push_url"];
        
        self.model.channelId = self.startLiveInfoDict[@"channel_id"];
        self.model.channelName = self.startLiveInfoDict[@"stream_name"];
        self.model.webinar_id = self.startLiveInfoDict[@"webinar_id"];
        
        NSLog(@"push_url = %@",self.model.push_url);
        MZLiveUserModel *LiveUser = [[MZLiveUserModel alloc] init];
        LiveUser.nickname = [MZBaseUserServer currentUser].nickName;
        LiveUser.uid = self.model.chat_conf.chat_uid;
        LiveUser.avatar = [MZBaseUserServer currentUser].avatar;
        
        [MZSDKSimpleHud hideAfterDelay:0];
        
        [self pushToLive:LiveUser];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
        [self.view show:error.domain];
        self.currentPusherButton.userInteractionEnabled = YES;
        [MZSDKSimpleHud hide];
    }];
}

- (void)pushToLive:(MZLiveUserModel *)user {

    //相机、麦克风权限检测
    if (![MZBaseGlobalTools checkMediaDevice:AVMediaTypeAudio]) {
        self.currentPusherButton.userInteractionEnabled = YES;
        return;
    }
    if (![MZBaseGlobalTools checkMediaDevice:AVMediaTypeVideo]) {
        self.currentPusherButton.userInteractionEnabled = YES;
        return;
    }
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
        live.isFrontCameraType = !self.backgroundCameraLabel.isSelect;
        
        // 设置镜像开关，默认关闭
        live.isMirroringType = NO;
        
        // 设置是否静音，默认非静音
        live.isMuteType = self.muteLabel.isSelect;
        
        // 设置闪光灯开关（后置摄像头才有用），默认不使用
        live.isTorchType = NO;
        
        // 设置美颜等级
        live.beautyFaceLevel = (self.beautyFaceLabel.isSelect ? MZBeautyFaceLevel_Medium : MZBeautyFaceLevel_None);
        
        // 设置（横/竖）屏直播，默认竖屏
        if (self.currentPusherButton == self.pusherLandspaceButton)  {
            live.isLandscape = YES;
        } else {
            live.isLandscape = NO;
        }
        
        // 设置开始倒计时描述，默认3秒
        live.countDownNum = [self.countDownTextField.text intValue] > 0 ? [self.countDownTextField.text intValue] : 3;
        
        // 设置清晰度，默认高清
        live.videoSessionPreset = self.selectSessionPreset;
        
        // 是否全体禁言
        live.isBlockAllChat = self.blockAllLabel.isSelect;
        
        // 设置是否只是语音直播
        if (self.currentPusherButton == self.pusherAudioButton)  {
            live.isOnlyAudio = YES;
        }
        
        self.currentPusherButton.userInteractionEnabled = YES;
        live.modalPresentationStyle = UIModalPresentationFullScreen;
        
        self.live_tkString = @"";
        self.ticket_idString = @"";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"此创建活动功能API接口权限所属于服务端，提供此功能为了便于demo演示。如接入时考虑数据安全等因素建议通过服务访问API并将live_tk、ticket_id传入SDK进行推流。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"开始直播" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                  UIView *loadingOneView = nil;
                  UIView *loadingTwoView = nil;
                  if (live.isLandscape) {
                      loadingOneView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, -200, 5000, 5000)];
                      loadingOneView.backgroundColor = [UIColor blackColor];
                      [live.view addSubview:loadingOneView];
                      
                      loadingTwoView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, -200, 5000, 5000)];
                      loadingTwoView.backgroundColor = [UIColor blackColor];
                      [[UIApplication sharedApplication].keyWindow addSubview:loadingTwoView];
                  }
                  [self presentViewController:live animated:(live.isLandscape ? NO : YES) completion:^{
                      NSLog(@"跳转完成");
                      [loadingTwoView removeFromSuperview];
                      [loadingOneView removeFromSuperview];
                  }];
              }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.categoryTextField) {
        [self showCategoryList];
        return NO;
    }
    return YES;
}

// 是否是模拟器
- (BOOL)isSimulator  {
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        [self.view show:@"推流不支持模拟器"];
        return YES;
    }
    return NO;
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//一开始的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
