//
//  MZLiveViewController.m
//  MengZhu
//
//  Created by vhall on 16/6/12.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZLiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "MZWatchHeaderMessageView.h"

#import "MZMessageToolView.h"
#import "MZAudienceView.h"
#import "MZPresentView.h"

#import "MZLiveAlertView.h"
#import "MZLiveManagerHearderView.h"
#import "MZLiveAudienceHeaderView.h"
#import "MZUserTipView.h"
#import "MZBottomTalkBtn.h"

#import "MZChannelAlertView.h"

#import "MZHistoryChatView.h"

#import "AppDelegate.h"
#import "MZLiveFinishViewController.h"
#import "MZAlertController.h"

#import "MZLiveFinishViewController.h"
#import "MZSessionPresetView.h"
#import "MZBeautyFaceOptionView.h"

#define StreamName     @"86ff6b3712d6f8c6ccd14980fc6319e2"
#define Token          @"123456"
#define kViewFramePath      @"frame"
#define AlivcScreenWidth  [UIScreen mainScreen].bounds.size.width
#define AlivcScreenHeight  [UIScreen mainScreen].bounds.size.height
#define AlivcSizeWidth(W) (W*(AlivcScreenWidth)/320)
#define AlivcSizeHeight(H) (H*(AlivcScreenHeight)/568)

//#define IPHONEX (AlivcScreenWidth == 375.f && AlivcScreenHeight == 812.f)

typedef void(^FinishHandle)(MZLiveFinishModel *model);

typedef enum {
    MZLiveViewCloseBtnTag,
    MZLiveViewSwapCameraBtnTag,
    MZLiveViewFlashLightBtnTag,
    MZLiveViewSlienceBtnTag,
    MZLiveviewAudienceBtnTag,
    MZLiveViewChatBtnTag,
    MZLiveViewHideKeyBoardBtnTag,
    MZLiveViewPresentBtnTag,
    MZLiveViewPushBtnTag,
    MZLiveViewSkinButtonTag,
    MZLiveViewShareButtonTag,
    MZLiveViewBlockButtonTag,
    MZLiveViewMirrorTag,
    MZLiveViewBitRateTag,
    MZLiveViewMenuTag,
    MZLiveViewBeautyFaceTag,//美颜
    MZLiveViewSessionPresetTag,//分辨率
}MZLiveViewBtnTag;

typedef enum {
    MZLiveLaunchSuccess,
    MZLiveLaunchFail,
    MZLiveLaunching
}MZLiveState;

typedef enum {
    MZLiveSuperClear,
    MZLiveHighClear,
    MZLiveStandardClear
}MZLiveBitRate;//

CGFloat BtnW = 28;
CGFloat BtnSpace = 28 + 12;
//  发起直播界面
@interface MZLiveViewController ()<UITextFieldDelegate,MZMessageToolBarDelegate,MZHistoryChatViewProtocol,UITextViewDelegate,MZAVCaptureDelegate,MZChatKitDelegate>{

    UIView               * _preView;//预览view
    UIView               *_previewView;//预览影像
    MZLiveState            _liveState;
    UIButton        * _hideKeyBoardBtn;//隐藏键盘按钮
    MZHistoryChatView      * _chatView;//聊天页面
    UIView * _shadowBgView;//聊天阴影
    MZMessageToolView *_chatToolBar;
    double _liveDuration;
    NSTimer  * _timer;
    //倒计时
    NSTimer * _countDowntimer;//倒计时计时器
    
    UILabel  * _bitRateLabel;//实时码率
    UILabel  * _liveTimeLabel;//直播时长
    
    //聚焦参数
    CGFloat             _mLastScale;
    CGFloat             _currentScale;
    
    NSMutableArray * _getGiftDataArr;
    NSString * _moneyChangeTotalStr;

    NSString *_url;
    CGFloat _lastPinchDistance;
    //自己结束的
    BOOL    selfStopped;
    BOOL _isConnecting;
}

//直播SDK新变量
@property (nonatomic, strong) MZPushStreamManager *pushManager;
// 聊天kit
@property (nonatomic, strong) MZChatKitManager *chatKitManager;

//倒计时
@property (nonatomic, strong) UILabel  *downCountLabel;
@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic, assign) BOOL isCTCallStateDisconnected;

//礼物列表
@property (nonatomic, strong) MZPresentView * presentListView;

@property (nonatomic, strong) UIView *liveBottonContentView;//下部的控件view
@property (nonatomic, strong) UIView *bitTopView;
@property (nonatomic, assign) BOOL isFuctionHidden;
@property (nonatomic, strong) UIImageView *shareImageView;

//开始推流（这个参数是防止还没有开始推流，切换到后台或者其他操作走了appResignActive方法，然后回来后走appBecomeActive，这种情况不能走重连的方法）
@property (nonatomic, assign) BOOL isStartPush;

@property (nonatomic, strong) UIView *roteScreenBGView;

@property (nonatomic, strong) UIButton *closeLiveBtn;
@property (nonatomic, strong) MZBottomTalkBtn *bottomTalkBtn;

@property (nonatomic, strong) UIButton *cameraChangeBtn;//镜头反转按钮
@property (nonatomic, strong) UIButton *shareBtn;//分享按钮
@property (nonatomic, strong) UIButton *menuBtn;//菜单按钮

@property (nonatomic, strong) UIButton *muteBtn;// 静音按钮
@property (nonatomic, strong) UIButton *flashLightBtn;//闪光灯按钮
@property (nonatomic, strong) UIButton *mirrorBtn;//镜像按钮
@property (nonatomic, strong) UIButton *beautyFaceBtn;//美颜按钮
@property (nonatomic, strong) UIButton *blockAllButton;//全体禁言，解禁
@property (nonatomic, strong) UIButton *sessionPresetButton;//分辨率按钮

@property (nonatomic, strong) MZLiveAlertView *liveAlertView;//断流提示的view

@property (nonatomic, strong) UIVisualEffectView *blurEffectBgView;
@property (nonatomic, strong) UIView *effectBgView;
@property (nonatomic, strong) MZLiveUserModel *myLiveUserModel;

@property (nonatomic, strong) MZLiveManagerHearderView *liveManagerHearderView;//左上角主播按钮view
@property (nonatomic, assign) long long popularityNum;//主播人气

@property (nonatomic, strong) MZLiveAudienceHeaderView *liveAudienceHeaderView;//右上角观众view
@property (nonatomic, strong) NSMutableArray *onlineUsersArr;//在线观众

@property (nonatomic, strong) MZUserTipView *tipView;

@property (nonatomic,   copy) FinishHandle handle;

@property (nonatomic, strong) MZAnimationView *audioAnimationView;//静音直播的动画展示

@property (nonatomic, strong) MZFacialView *portraitFacialView;//竖屏表情键盘View
@property (nonatomic, strong) MZFacialView *landspaceFacialView;//横屏表情键盘View

@property (nonatomic, strong) MZBeautyFaceOptionView *beautyFaceOptionView;//美颜等级选择View

@property (nonatomic, strong) MZSessionPresetView *sessionPresetView;//分辨率选择View

@end

@implementation MZLiveViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _preView.frame = self.view.bounds;
    
    CGFloat topSpace = 0;

    if (self.isLandscape) {//横屏状态下更改布局。
        float bottomSpace = IPHONE_X ? 5 : 0;
        float leftSpace = IPHONE_X ? 44 : 0;
        float landScapeRate = MZ_FULL_RATE;
        float itemSpace = 9*landScapeRate;
        
        self.effectBgView.frame = _preView.bounds;
        self.blurEffectBgView.frame = _preView.bounds;
        
        self.closeLiveBtn.frame = CGRectMake(_preView.frame.size.width - 44*landScapeRate - 8*landScapeRate,topSpace + 20*landScapeRate, 44*landScapeRate, 44*landScapeRate);
        _previewView.frame = _preView.bounds;
        
        _shadowBgView.frame = CGRectMake(0, _preView.frame.size.height - 150, _preView.frame.size.width/2.0, 150);
        
        _chatView.frame = CGRectMake(leftSpace, _preView.frame.size.height - bottomSpace - 44*landScapeRate - 200, _preView.frame.size.width/2.0, (IPHONE_X ? 140 : 170)*landScapeRate);

        _liveManagerHearderView.frame = CGRectMake(leftSpace+12*landScapeRate, topSpace+22*landScapeRate, 172*landScapeRate, 40*landScapeRate);
        
        _liveAudienceHeaderView.frame = CGRectMake(_preView.frame.size.width - 116*landScapeRate - 44*landScapeRate - 8*landScapeRate, _liveManagerHearderView.center.y - 14*landScapeRate, 116*landScapeRate, 28*landScapeRate);

        self.bitTopView.frame = CGRectMake(_liveAudienceHeaderView.frame.origin.x - 158, _liveAudienceHeaderView.frame.origin.y, 138, BtnW*landScapeRate);
        [self.bitTopView.layer setCornerRadius:BtnW*landScapeRate/2.0];

        _bitRateLabel.frame = CGRectMake(0 , 0, self.bitTopView.width/2.0, self.bitTopView.height);

        _liveTimeLabel.frame = CGRectMake(self.bitTopView.width / 2.0 , 0, self.bitTopView.width / 2.0 - 10, self.bitTopView.height);

        _downCountLabel.frame = CGRectMake(_preView.frame.size.width/2-80, _preView.frame.size.height/2-50, 160, 100);

        _presentListView.frame = self.view.bounds;
                        
        self.bottomTalkBtn.frame = CGRectMake(leftSpace+12*landScapeRate, _preView.frame.size.height - 44*landScapeRate - (bottomSpace + 12*landScapeRate), _preView.frame.size.width/2.0 - (leftSpace+12*landScapeRate+60*landScapeRate), 44*landScapeRate);
        
        self.cameraChangeBtn.frame = CGRectMake(_previewView.frame.size.width - 12*landScapeRate - 44*landScapeRate, self.bottomTalkBtn.top, 44*landScapeRate, 44*landScapeRate);
        
        self.shareBtn.frame = CGRectMake(self.cameraChangeBtn.frame.origin.x - 44*landScapeRate - 8, self.cameraChangeBtn.frame.origin.y, self.cameraChangeBtn.frame.size.width, self.cameraChangeBtn.frame.size.height);
    
        self.beautyFaceBtn.frame = CGRectMake(self.shareBtn.frame.origin.x - 44*landScapeRate - 8, self.cameraChangeBtn.frame.origin.y, self.cameraChangeBtn.frame.size.width, self.cameraChangeBtn.frame.size.height);

        self.mirrorBtn.frame = CGRectMake(self.beautyFaceBtn.frame.origin.x - 44*landScapeRate - 8, self.cameraChangeBtn.frame.origin.y, self.cameraChangeBtn.frame.size.width, self.cameraChangeBtn.frame.size.height);

        self.flashLightBtn.frame = CGRectMake(self.mirrorBtn.frame.origin.x - 44*landScapeRate - 8, self.cameraChangeBtn.frame.origin.y, self.cameraChangeBtn.frame.size.width, self.cameraChangeBtn.frame.size.height);

        self.muteBtn.frame = CGRectMake(self.flashLightBtn.frame.origin.x - 44*landScapeRate - 8, self.cameraChangeBtn.frame.origin.y, self.cameraChangeBtn.frame.size.width, self.cameraChangeBtn.frame.size.height);
        
        self.blockAllButton.frame = CGRectMake(self.muteBtn.frame.origin.x - 44*landScapeRate - 8, self.cameraChangeBtn.frame.origin.y, self.cameraChangeBtn.frame.size.width, self.cameraChangeBtn.frame.size.height);
        
        self.sessionPresetButton.frame = CGRectMake(self.blockAllButton.frame.origin.x - 44*landScapeRate - 8, self.cameraChangeBtn.frame.origin.y, self.cameraChangeBtn.frame.size.width, self.cameraChangeBtn.frame.size.height);

        self.tipView.frame = _preView.bounds;
        
        if(_chatToolBar==nil)
        {
            [self initHideKeyBoardBtn];
            _chatToolBar = [[MZMessageToolView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [MZMessageToolView defaultHeight],  self.view.frame.size.width, [MZMessageToolView defaultHeight]) type:MZMessageToolBarTypeAllBtn];
            _chatToolBar.maxLength = 100;
            _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
            _chatToolBar.delegate = self;
            _chatToolBar.msgTextView.delegate = self;
            _chatToolBar.hidden = YES;
            [self.view addSubview:_chatToolBar];
        }
    }
    
    UIView *oldHud = [[UIApplication sharedApplication].keyWindow viewWithTag:1101];
    if (oldHud) {
        oldHud.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width-100)/2.0, (UIScreen.mainScreen.bounds.size.height - 100)/2.0, 100, 100);
    }
}

- (instancetype)initWithFinishModel:(void(^)(MZLiveFinishModel *model))finishHandle {
    self = [super init];
    if (self) {
        self.handle = finishHandle;
        
        self.beautyFaceLevel = MZBeautyFaceLevel_None;
        self.isLandscape = NO;
        self.countDownNum = 3;
        self.videoSessionPreset = MZCaptureSessionPreset720x1280;
        self.isFrontCameraType = YES;
        self.isMirroringType = NO;
        self.isMuteType = NO;
        self.isTorchType = NO;
    }
    return self;
}

#pragma mark - View LifeCycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startFullScreen" object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO ; //取消侧滑
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    //清除直播推送的缓存lbxlbx
//    [self removePushItemCache];
    _liveState = MZLiveLaunching;

    [self startCountDownTimer];
    [self pushCapture];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _liveDuration = 0;
    _isConnecting = NO;

    self.onlineUsersArr = [NSMutableArray arrayWithCapacity:10];
    [self initView];

    __weak typeof(self)weakSelf = self;
    if (![MZBaseGlobalTools IsEnableNet]) {
        MZChannelAlertView * alert = [[MZChannelAlertView alloc]initWithClearBufferViewFrame:self.view.bounds title:@"无可用网络" btn:@"返回" btnBackgroundColor:MakeColorRGB(0xff5b29)];
        alert.block = ^(NSInteger tag){
            [weakSelf stopLive];
        };
    }
    
    
    self.chatKitManager = [[MZChatKitManager alloc]init];
    self.chatKitManager.delegate = self;

    [self.view addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self addKeyBoardNoti];
    _moneyChangeTotalStr = @"0.00";
    _getGiftDataArr = [[NSMutableArray alloc]init];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
    [self destoryPusher];

    _chatView = nil;
    _chatToolBar = nil;
    [self.view removeObserver:self forKeyPath:kViewFramePath];
    [self removeKeyBoardNoti];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Helper

- (void)initView
{
    if (!_preView) {
        _preView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, MZTotalScreenHeight)];
        _preView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_preView];

        [self creatTopView];
        [self creatChatView];
        [self creatBottomView];
    }
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_preView addGestureRecognizer:gesture];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [_preView addGestureRecognizer:pinch];
}

- (void)creatTopView
{

    WeaklySelf(weakSelf);
    self.effectBgView = [[UIView alloc]initWithFrame:_preView.bounds];
    [_preView addSubview:self.effectBgView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectBgView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.blurEffectBgView.frame = CGRectMake(0, 0, _preView.width, _preView.height);
    [self.effectBgView addSubview:self.blurEffectBgView];
    
    CGFloat topSpace = IPHONE_X ? 20 : 0;
    self.liveManagerHearderView = [[MZLiveManagerHearderView alloc]initWithFrame:CGRectMake(12*MZ_RATE,topSpace + 22*MZ_RATE, 172*MZ_RATE, 40*MZ_RATE)];
    self.liveManagerHearderView.clickBlock = ^{
        [weakSelf.view show:@"点击了自己的头像"];
    };
    
    self.liveManagerHearderView.attentionClickBlock = ^{
        [weakSelf.view show:@"点击关注按钮"];
    };

    [_preView addSubview:self.liveManagerHearderView];
    self.liveManagerHearderView.title = self.latestUser.nickname;
    self.liveManagerHearderView.numStr = @"0";
    self.liveManagerHearderView.imageUrl = self.latestUser.avatar;
    self.liveManagerHearderView.hidden = YES;
    
    self.liveAudienceHeaderView = [[MZLiveAudienceHeaderView alloc]initWithFrame:CGRectMake(_preView.frame.size.width - 116*MZ_RATE - 44*MZ_RATE - 8*MZ_RATE, self.liveManagerHearderView.center.y - 14*MZ_RATE, 116*MZ_RATE, 28*MZ_RATE)];
    self.liveAudienceHeaderView.hidden = YES;
    [_preView addSubview:self.liveAudienceHeaderView];
    self.liveAudienceHeaderView.clickBlock = ^{
        // 获取观众列表
        [weakSelf creatAudienceWinView];
    };
    
    /// 添加在线观众（自己）
    NSString *chat_uid = self.model.chat_conf.chat_uid;
    MZOnlineUserListModel *onlineUserModel = [[MZOnlineUserListModel alloc] init];
        
    onlineUserModel.uid = chat_uid;
    onlineUserModel.avatar = self.latestUser.avatar;
    onlineUserModel.nickname = self.latestUser.nickname;
    [self.onlineUsersArr addObject:onlineUserModel];
    self.liveAudienceHeaderView.userArr = self.onlineUsersArr;
    [self.liveAudienceHeaderView updateOnlineUserTotalCount:(int)self.onlineUsersArr.count];

    self.closeLiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(_preView.frame.size.width - 44*MZ_RATE - 8*MZ_RATE,topSpace + 20*MZ_RATE, 44*MZ_RATE, 44*MZ_RATE)];
    self.closeLiveBtn.tag = MZLiveViewCloseBtnTag;
    [self.closeLiveBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeLiveBtn setImage:ImageName(@"live_close") forState:UIControlStateNormal];
    [_preView addSubview:self.closeLiveBtn];
    
    //    网速提示的背景图
    self.bitTopView = [[UIView alloc]initWithFrame:CGRectMake(12*MZ_RATE, topSpace + (22+50)*MZ_RATE, 138, BtnW)];
    self.bitTopView.backgroundColor = MakeColor(0, 0, 0, 0.3);
    self.bitTopView.layer.masksToBounds = YES;
    self.bitTopView.layer.cornerRadius = self.bitTopView.height / 2.0;
    [_preView addSubview:self.bitTopView];
    self.bitTopView.hidden = YES;
    
    if (!_bitRateLabel) {
        _bitRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bitTopView.width/2.0+5, self.bitTopView.height)];
        _bitRateLabel.font = [UIFont systemFontOfSize:11];
        _bitRateLabel.textColor = [UIColor whiteColor];
        _bitRateLabel.textAlignment = NSTextAlignmentCenter;
        _bitRateLabel.text = @"0 Kb/s";
        [self.bitTopView addSubview:_bitRateLabel];
    }
    
    if (!_liveTimeLabel) {
        _liveTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bitTopView.width / 2.0+5, 0, self.bitTopView.width / 2.0 - 5, self.bitTopView.height)];
        _liveTimeLabel.font = [UIFont systemFontOfSize:11];
        _liveTimeLabel.textAlignment = NSTextAlignmentCenter;
        _liveTimeLabel.textColor = [UIColor whiteColor];
        _liveTimeLabel.text = @"00:00:00";
        [self.bitTopView addSubview:_liveTimeLabel];
    }
}

-(void)creatChatView
{
    _shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0, _preView.frame.size.height - _preView.frame.size.width, _preView.frame.size.width, _preView.frame.size.width)];
    [_preView addSubview:_shadowBgView];
    
//    [MZBaseGlobalTools setRadualChangeWithView:_shadowBgView startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1) startColor:MakeColorRGBA(0x000000, 0) endColor:MakeColorRGBA(0x000000, 0.6)];
    
    _chatView = [[MZHistoryChatView alloc]initWithFrame:CGRectMake(0, _preView.frame.size.height - 265*MZ_RATE - (IPHONE_X ? 34 : 0), _preView.frame.size.width, 200*MZ_RATE)];
    _chatView.chatDelegate =self;
    [_preView addSubview:_chatView];
}

- (void)historyChatViewUserHeaderClick:(MZLongPollDataModel *)pollingDate{
    if ([MZBaseGlobalTools isBlankString:pollingDate.userId] ||[pollingDate.userId isEqualToString:@"0"]){
        return;
    }
    [self getUserMessageWithPollingDate:pollingDate];
}

//屏幕底部控件
- (void)creatBottomView
{
    WeaklySelf(weakSelf);
    CGFloat bottomSpace = IPHONE_X ? 34*MZ_RATE : 0;
    
    self.bottomTalkBtn = [[MZBottomTalkBtn alloc]initWithFrame:CGRectMake(12*MZ_RATE, _preView.frame.size.height - 44*MZ_RATE - (bottomSpace + 12*MZ_RATE), _preView.frame.size.width/2.0-12*MZ_RATE, 44*MZ_RATE)];
    [_preView addSubview:self.bottomTalkBtn];
    self.bottomTalkBtn.hidden = YES;
    self.bottomTalkBtn.bottomClickBlock = ^{
        if (weakSelf.bottomTalkBtn.isBanned) {
            [weakSelf.view show:@"你已被禁言"];
        } else {
            [weakSelf showKeyboard];
        }
    };
    
    self.menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(_preView.frame.size.width - 12*MZ_RATE - 44*MZ_RATE , self.bottomTalkBtn.top, 44*MZ_RATE, 44*MZ_RATE)];
    self.menuBtn.tag = MZLiveViewMenuTag;
    [self.menuBtn setImage:ImageName(@"bottomButton_jubao") forState:UIControlStateNormal];
    [self.menuBtn setImage:ImageName(@"bottomButton_jubao_click") forState:UIControlStateSelected];
    [self.menuBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:self.menuBtn];
    self.menuBtn.hidden = YES;
    
    self.cameraChangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.menuBtn.frame.origin.x - 44*MZ_RATE - 12, self.menuBtn.frame.origin.y, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height)];
    self.cameraChangeBtn.tag = MZLiveViewSwapCameraBtnTag;
    [self.cameraChangeBtn setImage:ImageName(@"live_camera") forState:UIControlStateNormal];
    [self.cameraChangeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:self.cameraChangeBtn];
    self.cameraChangeBtn.hidden = YES;
    
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cameraChangeBtn.frame.origin.x - 44*MZ_RATE - 12, self.cameraChangeBtn.frame.origin.y, self.cameraChangeBtn.frame.size.width, self.cameraChangeBtn.frame.size.height)];
    self.shareBtn.tag = MZLiveViewShareButtonTag;
    [self.shareBtn setImage:ImageName(@"bottomButton_share") forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:self.shareBtn];
    self.shareBtn.hidden = YES;

    self.beautyFaceBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.menuBtn.frame.origin.x, self.menuBtn.frame.origin.y - 44*MZ_RATE - 12, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height)];
    self.beautyFaceBtn.tag = MZLiveViewBeautyFaceTag;
    [self.beautyFaceBtn setImage:ImageName(@"meiyan_normal") forState:UIControlStateNormal];
    [self.beautyFaceBtn setImage:ImageName(@"meiyan_select") forState:UIControlStateSelected];
    [self.beautyFaceBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:self.beautyFaceBtn];
    self.beautyFaceBtn.hidden = YES;
    self.beautyFaceBtn.alpha = 0;
    
    self.mirrorBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.beautyFaceBtn.frame.origin.x, self.beautyFaceBtn.frame.origin.y - 44*MZ_RATE - 12, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height)];
    self.mirrorBtn.tag = MZLiveViewMirrorTag;
    [self.mirrorBtn setImage:ImageName(@"jingxiang_normal") forState:UIControlStateNormal];
    [self.mirrorBtn setImage:ImageName(@"jingxiang_select") forState:UIControlStateSelected];
    [self.mirrorBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:self.mirrorBtn];
    self.mirrorBtn.hidden = YES;
    self.mirrorBtn.alpha = 0;
    
    self.flashLightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.mirrorBtn.frame.origin.x, self.mirrorBtn.frame.origin.y - 44*MZ_RATE - 12, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height)];
    self.flashLightBtn.tag = MZLiveViewFlashLightBtnTag;
    [self.flashLightBtn setImage:ImageName(@"shanguang_normal") forState:UIControlStateNormal];
    [self.flashLightBtn setImage:ImageName(@"shanguang_select") forState:UIControlStateSelected];
    [self.flashLightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:self.flashLightBtn];
    self.flashLightBtn.hidden = YES;
    self.flashLightBtn.alpha = 0;
    
    self.muteBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.flashLightBtn.frame.origin.x, self.flashLightBtn.frame.origin.y - 44*MZ_RATE - 12, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height)];
    self.muteBtn.tag = MZLiveViewSlienceBtnTag;
    [self.muteBtn setImage:ImageName(@"jingying_normal") forState:UIControlStateNormal];
    [self.muteBtn setImage:ImageName(@"jingying_select") forState:UIControlStateSelected];
    [self.muteBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:self.muteBtn];
    self.muteBtn.hidden = YES;
    self.muteBtn.alpha = 0;
    
    self.blockAllButton = [[UIButton alloc]initWithFrame:CGRectMake(self.muteBtn.frame.origin.x, self.muteBtn.frame.origin.y - 44*MZ_RATE - 12, self.menuBtn.frame.size.width, self.menuBtn.frame.size.height)];
    self.blockAllButton.tag = MZLiveViewBlockButtonTag;
    [self.blockAllButton setImage:ImageName(@"jingyan_normal") forState:UIControlStateNormal];
    [self.blockAllButton setImage:ImageName(@"jingyan_select") forState:UIControlStateSelected];
    [self.blockAllButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:self.blockAllButton];
    self.blockAllButton.hidden = YES;
    self.blockAllButton.alpha = 0;

    self.sessionPresetButton = [[UIButton alloc]initWithFrame:CGRectMake(self.blockAllButton.frame.origin.x, self.blockAllButton.frame.origin.y - 44*MZ_RATE - 12, self.blockAllButton.frame.size.width, self.blockAllButton.frame.size.height)];
    self.sessionPresetButton.tag = MZLiveViewSessionPresetTag;
    [self.sessionPresetButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_preView addSubview:self.sessionPresetButton];
    self.sessionPresetButton.hidden = YES;
    self.sessionPresetButton.alpha = 0;
    [self updateSessionPresetButton];

    
    [_preView addSubview:self.beautyFaceOptionView];
    [_preView addSubview:self.sessionPresetView];
    
    if (self.isOnlyAudio) {//只是音频直播，重置所有菜单的frame
        // 分享按钮
        self.shareBtn.frame = self.cameraChangeBtn.frame;
        // 前后摄像头按钮
        self.cameraChangeBtn.frame = CGRectZero;
        // 静音按钮
        self.muteBtn.frame = self.beautyFaceBtn.frame;
        // 禁言按钮
        self.blockAllButton.frame = self.mirrorBtn.frame;
        // 分辨率按钮
        self.sessionPresetButton.frame = CGRectZero;
        // 美颜按钮
        self.beautyFaceBtn.frame = CGRectZero;
        // 镜像按钮
        self.mirrorBtn.frame = CGRectZero;
        // 闪光灯按钮
        self.flashLightBtn.frame = CGRectZero;
    }
}

/// 更新分辨率的按钮图片
- (void)updateSessionPresetButton {
    if (self.videoSessionPreset == MZCaptureSessionPreset360x640) {
        [self.sessionPresetButton setImage:ImageName(@"mz_biaoqing_icon_xuanzhong") forState:UIControlStateNormal];
    } else if (self.videoSessionPreset == MZCaptureSessionPreset540x960) {
        [self.sessionPresetButton setImage:ImageName(@"mz_gaoqing_icon_xuanzhong") forState:UIControlStateNormal];
    } else if (self.videoSessionPreset == MZCaptureSessionPreset720x1280) {
        [self.sessionPresetButton setImage:ImageName(@"mz_chaoqing_icon_xuanzhong") forState:UIControlStateNormal];
    }
}

- (void)showKeyBoard:(NSString *)userName JoinID:(NSString *)joinID{
    if ([joinID isEqualToString:self.model.chat_conf.chat_uid]) {
        [_preView show:@"这是我自己"];
        return;
    }
    
    [self performSelector:@selector(showKeyboard) withObject:nil];
    _chatToolBar.msgTextView.text = [NSString stringWithFormat:@"@%@ ",userName];
    _chatToolBar.userName = userName;
    _chatToolBar.joinID = joinID;
}

-(void)getUserMessageWithPollingDate:(MZLongPollDataModel *)pollingDate
{
    if ([pollingDate.data.uniqueID isEqualToString:[MZBaseUserServer currentUser].uniqueID]) {
        [self.view show:@"点击了自己的头像"];
        return;
    }
    
    // 这里需要你们自己去获取用户的详细信息，包括是否已经禁言，直播量，赞量等你们自己的数据，我这里只是简单模拟
    MZLiveUserModel *model = [[MZLiveUserModel alloc] init];
    model.uid = pollingDate.userId;
    model.nickname = pollingDate.userName;
    model.avatar = pollingDate.userAvatar;
    
    model.is_banned = NO;//模拟显示未禁言
    model.lives = @"2";
    model.attentions = @"1";
    model.likes = @"3";

    [self tipUserMessageViewWithUserModel:model];
}

-(void)tipUserMessageViewWithUserModel:(MZLiveUserModel *)user
{
    WeaklySelf(weakSelf);
    MZWatchHeaderMessageView *headerMessageView = [[MZWatchHeaderMessageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    headerMessageView.isMySelf = NO;
    if ([user.uid isEqualToString:self.model.chat_conf.chat_uid]) {
        headerMessageView.isMySelf = YES;
    }
    
    headerMessageView.otherUserInfoModel = user;
    [headerMessageView showWithView:self.view action:^(HeadViewActionType actionType) {
        if(actionType == HeadViewActionTypeBlock){
            weakSelf.tipView = [[MZUserTipView alloc]initWithFrame:CGRectMake(0, 0, weakSelf.view.width, weakSelf.view.height)];
            weakSelf.tipView.otherUser = user;
            __weak typeof(weakSelf.tipView)weakTipView = weakSelf.tipView;
            weakSelf.tipView.userTipBlock = ^(MZUserTipType type) {
                if(type == MZUserTipTypeCancel){
                    [weakTipView removeFromSuperview];
                }else if(type == MZUserTipTypeBanned){
                    [weakSelf banedOrUnBannedUserWithModel:user isBanned:YES];
                }else if(type == MZUserTipTypeUnBanned){
                    [weakSelf banedOrUnBannedUserWithModel:user isBanned:NO];
                }
            };
            [weakSelf.view addSubview:self.tipView];
        }
    }];
}

/// 禁言请求
-(void)banedOrUnBannedUserWithModel:(MZLiveUserModel *)user isBanned:(BOOL)isBanned
{
    [MZSDKSimpleHud show];
    [MZSDKBusinessManager bannedOrUnBannedUserWithTicketId:_model.ticket_id uid:user.uid isBanned:isBanned success:^(id response) {
        [MZSDKSimpleHud hide];
        [self.view show:isBanned ? @"禁言成功":@"解禁成功"];
        [self.tipView removeFromSuperview];
    } failure:^(NSError *error) {
        [MZSDKSimpleHud hide];
        [self.view show:error.domain];
    }];
}

- (void)adjustPresentBtn:(NSString *)title
{
    
}

-(void)reloadFuctionBtnUIWithIsHidden:(BOOL)isHidden
{
    self.liveBottonContentView.hidden = isHidden;
    //    _chatView.hidden = isHidden;
}

- (CGRect)getFullScreenFrame
{
    CGRect frame = self.view.bounds;
    return frame;
}

#pragma mark - Internal Helper
- (void)pushCapture{
    
    if (![MZBaseGlobalTools IsEnableNet]) {
        [self.view show:@"请检查网络状况"];
        return;
    }
    
    if (!_pushManager) {
        if (self.isOnlyAudio) {//只是语音直播
            // 根据音频质量自动设置码率和采样率
            _pushManager = [[MZPushStreamManager alloc] initWithAudioQuality:MZLiveAudioQuality_VeryHigh];
            
            // 自定义音频码率和采样率
            //         _pushManager = [[MZPushStreamManager alloc] initWithAudioQuality:MZLiveAudioQuality_High numberOfChannels:2 audioSampleRate:MZLiveAudioSampleRate_44100Hz audioBitrate:MZLiveAudioBitRate_96Kbps];
            
            if (!self.audioAnimationView.superview) {
                self.audioAnimationView.frame = CGRectMake(0, self.liveManagerHearderView.bottom + 30.0, _preView.frame.size.width, _preView.frame.size.width/16*9);
                [_preView insertSubview:self.audioAnimationView atIndex:0];
            }
            if (self.audioAnimationView.isAnimationPlaying == NO) {
                [self.audioAnimationView play];
            }
            
        } else {//视频直播
            // 根据视频分辨率自动设置最优的码率和帧率
            _pushManager = [[MZPushStreamManager alloc] initWithVideoSessionPreset:self.videoSessionPreset outputImageOrientation:(self.isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait)];
            
            // 自定义视频码率和帧率
            //        _pushManager = [[MZPushStreamManager alloc] initWithVideoSessionPreset:self.videoSessionPreset videoBitRate:800*1000 videoFrameRate:18 outputImageOrientation:(self.isLandscape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait)];
            
            // 在添加_pushManager.preview之前，可以进行相关配置

            // 设置美颜开关
            [_pushManager setBeautyFaceLevel:self.beautyFaceLevel];
            [self.beautyFaceBtn setSelected:(self.beautyFaceLevel == MZBeautyFaceLevel_None ? NO : YES)];
            
            // 设置（前置/后置）摄像头
            [_pushManager switchCameraIsFront:_isFrontCameraType];
            [self.cameraChangeBtn setSelected:_isFrontCameraType];
            
            // 设置镜像开关
            [_pushManager setMirroring:!_isMirroringType];
            [self.mirrorBtn setSelected:_isMirroringType];
            
            // 设置是否静音
            [_pushManager setMute:_isMuteType];
            [self.muteBtn setSelected:_isMuteType];
            
            // 设置闪光灯开关（后置摄像头才有用）
            if (_isFrontCameraType) {
                _isTorchType = NO;
            }
            [_pushManager setTorch:_isTorchType];
            [self.flashLightBtn setSelected:_isTorchType];
        }

        // 设置代理
        _pushManager.stateDelegate = self;
    }
    
    if (!_previewView) {
        _previewView = [[UIView alloc] init];
        _previewView.backgroundColor = [UIColor clearColor];
        _previewView.frame = [self getFullScreenFrame];
    }
    [_previewView setCenter:_preView.center];
    
    [_preView insertSubview:_previewView atIndex:0];
    [_previewView addSubview:_pushManager.preview];
}

/// 销毁推流相关的具柄
- (void)destoryPusher {
    _isConnecting = NO; // 连接关闭
    [self stopLiveTimer]; // 销毁直播计时器
    [self hideKeyboard]; // 收起键盘
    
    [self destoryChatKitManager];
    [self destroySession];
    
}

/// 销毁聊天具柄
- (void)destoryChatKitManager {
    [self.chatKitManager closeLongPoll];
    [self.chatKitManager closeSocketIO];
    self.chatKitManager.delegate = nil;
    self.chatKitManager = nil;
}

/// 销毁推流具柄
- (void)destroySession{
    [_pushManager stopCapture];
}

#pragma mark - User Interaction
//点击对焦
- (void)tapGesture:(UITapGestureRecognizer *)gesture{
     NSLog(@"发直播窗口底部view tap 手势点击：%@",gesture);
    CGPoint point = [gesture locationInView:self.view];
    CGPoint percentPoint = CGPointZero;
    percentPoint.x = point.x / CGRectGetWidth(self.view.bounds);
    percentPoint.y = point.y / CGRectGetHeight(self.view.bounds);
    self.isFuctionHidden = !self.isFuctionHidden;
    [self reloadFuctionBtnUIWithIsHidden:self.isFuctionHidden];
    //less
    if ([_chatToolBar.msgTextView isFirstResponder]) {
        [self hideKeyboard];
    }
}

//捏合手势缩放
- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    
    if (isiPhone && (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < __DBL_EPSILON__)){
        [self.view show:@"该设备不支持变焦"];
        return;
    }
    _currentScale += [gesture scale] - _mLastScale;
    _mLastScale    = [gesture scale];
    if (gesture.state == UIGestureRecognizerStateEnded){
        _mLastScale = 1.0;
    }
    if (_currentScale <= 1.0f){
        _currentScale = 1.0f;
    }else if(_currentScale >= 5.0f){
        _currentScale = 5.0f;
    }
    if (gesture.numberOfTouches != 2) {
        return;
    }
    CGPoint p1 = [gesture locationOfTouch:0 inView:self.view];
    CGPoint p2 = [gesture locationOfTouch:1 inView:self.view];
    CGFloat dx = (p2.x - p1.x);
    CGFloat dy = (p2.y - p1.y);
    CGFloat dist = sqrt(dx*dx + dy*dy);
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _lastPinchDistance = dist;
    }
    CGFloat change = dist - _lastPinchDistance;
    //less
}

- (void)clickBtn:(UIButton *)button{
    if (button.tag == MZLiveViewSessionPresetTag) {//点击分辨率
        [self.sessionPresetView showWithDirection:self.isLandscape ? MZSessionPresetShowDirection_Up : MZSessionPresetShowDirection_Left from:self.sessionPresetButton normalSessionPreset:self.videoSessionPreset];
        [self.beautyFaceOptionView hide];
        return;
    }
    [self.sessionPresetView hide];
    
    if (button.tag == MZLiveViewBeautyFaceTag) {//点击美颜
        [self.beautyFaceOptionView showWithDirection:self.isLandscape ? MZBeautyFaceShowDirection_Up : MZBeautyFaceShowDirection_Left from:self.beautyFaceBtn normalBeautyLevel:self.beautyFaceLevel];
        return;
    }
    [self.beautyFaceOptionView hide];

    switch (button.tag) {
        case MZLiveViewCloseBtnTag:{//正常结束按钮
            if(self.isStartPush){
                MZLiveAlertView *liveAlertV = [[MZLiveAlertView alloc]init];
                [liveAlertV showInWithView:self.view title:@"是否结束直播" leftBtn:@"结束直播" rightBtn:@"继续直播" clickBlock:^(MZLiveAlerBtnClickType clickType) {
                    if(clickType == MZLiveAlerLeftClick){
                        selfStopped = YES;
                        [self getStopLiveData];
                    }
                }];
            }else{
//                [self stopLive];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //        [self rotateScreen:NO];
                    _pushManager.preview = nil;
                    [self stopLiveTimer];
                    [self stopCountDownTimer];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }
            break;
            
        case MZLiveViewSkinButtonTag:{

        }
            break;
        case MZLiveViewSwapCameraBtnTag:{//摄像头
            _isFrontCameraType = !_isFrontCameraType;
            [_pushManager switchCameraIsFront:_isFrontCameraType];
            if (_isFrontCameraType) {
                self.flashLightBtn.selected = NO;
                _isTorchType = NO;
            }
        }
            break;
        case MZLiveViewFlashLightBtnTag:{//闪光灯
            if (_isFrontCameraType) {
                [self.view show:@"前置摄像头不支持"];
                return;
            }
            
            button.selected = !button.selected;
            _isTorchType = button.selected;
            [_pushManager setTorch:_isTorchType];
        }
            break;
            
        case MZLiveViewSlienceBtnTag:{//静音
            button.selected = !button.selected;
            _isMuteType = button.selected;
            [_pushManager setMute:_isMuteType];
        }
            break;
            
        case MZLiveviewAudienceBtnTag:{

        }
            break;
            
        case MZLiveViewChatBtnTag:{//聊天
            [self showKeyboard];
        }
            break;
            
        case MZLiveViewHideKeyBoardBtnTag:{
            [self hideKeyboard];
        }
            break;
        case MZLiveViewPresentBtnTag:{//礼物

        }
            break;
        case MZLiveViewShareButtonTag://分享
        {
            NSLog(@"分享的model = %@",self.model);
            [self.view show:@"点击了分享"];
        }
            break;
        case MZLiveViewBlockButtonTag://禁言及解禁
        {
            [self blockAllOrAlowChat];
        }
            break;
            
        case MZLiveViewBitRateTag:{//码率

        }
            break;
            
        case MZLiveViewMirrorTag:{//镜像
            if (_isFrontCameraType == NO) {
                [self.view show:@"后置摄像头不支持镜像"];
                return;
            }
            button.selected = !button.selected;
            _isMirroringType = button.selected;
            [_pushManager setMirroring:!_isMirroringType];
        }
            break;
        case MZLiveViewMenuTag:{//菜单
            button.selected = !button.selected;
            [UIView animateWithDuration:0.33 animations:^{
                self.flashLightBtn.alpha = button.selected;
                self.muteBtn.alpha = button.selected;
                self.mirrorBtn.alpha = button.selected;
                self.beautyFaceBtn.alpha = button.selected;
                self.blockAllButton.alpha = button.selected;
                self.sessionPresetButton.alpha = button.selected;
            }];
        }
            break;
        default:
            break;
    }
}

#warning 全体禁言
//全体禁言
- (void)blockAllOrAlowChat {
    [MZSDKSimpleHud show];
    NSLog(@"show 3");

    [MZSDKBusinessManager blockAllOrAlowChatWithChannelId:_model.channelId ticketId:_model.ticket_id isChat:self.blockAllButton.selected success:^(id responseObject) {
        [MZSDKSimpleHud hide];
        if(self.blockAllButton.selected){
            [self.view show:@"已关闭全体禁言"];
            self.blockAllButton.selected = NO;
        }else{
            [self.view show:@"已开启全体禁言"];
            self.blockAllButton.selected = YES;
        }
    } failure:^(NSError *error) {
        [MZSDKSimpleHud hide];
        [self.view show:error.domain];
    }];
}


#pragma mark - Some Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        [_chatToolBar sendButtonTouchUpInside];
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 0){
        _chatToolBar.msgTextView.centerPlaceHolderLable.hidden = YES;
    }else{
        _chatToolBar.msgTextView.centerPlaceHolderLable.hidden = NO;
    }
}


#pragma mark - API

- (void)getStopLiveData
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    __block UIVisualEffectView *blurEffectBlackView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurEffectBlackView.frame = CGRectMake(-500, -500, 3000, 3000);
    
    if (self.isLandscape) {
        [self.view addSubview:blurEffectBlackView];
    }
    
    [MZSDKSimpleHud show];
    
    [MZSDKBusinessManager stopLive:_model.channelId ticketId:_model.ticket_id success:^(MZLiveFinishModel *model) {

        [self destoryPusher];
        [MZSDKSimpleHud hideAfterDelay:0];

        [self dismissViewControllerAnimated:NO completion:^{
            if (self.handle) self.handle(model);
            [blurEffectBlackView removeFromSuperview];
        }];

    } failure:^(NSError * error) {
        [self destoryPusher];
        [MZSDKSimpleHud hideAfterDelay:0];

        [self dismissViewControllerAnimated:YES completion:^{
            [blurEffectBlackView removeFromSuperview];
        }];
        
    }];
}

#pragma mark - Notification Handler
- (void)appResignActive{
    if (!self.isStartPush) {//还没有开始推流
        return;
    }
    [self destoryPusher];
    
    // 监听电话
    if (_callCenter) {
        _callCenter = nil;
    }
    
    WeaklySelf(weakSelf);
    
    _callCenter = [[CTCallCenter alloc] init];
    _isCTCallStateDisconnected = NO;
    _callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            weakSelf.isCTCallStateDisconnected = YES;
        }
        else if([call.callState isEqualToString:CTCallStateConnected]){
            weakSelf.callCenter = nil;
        }
    };
}
//   断网弹窗关闭后  会回调
- (void)appBecomeActive
{
    if (!self.isStartPush) {//还没有开始推流
        return;
    }
    
    if (![MZBaseGlobalTools isConnectionAvailable]) {
        [self.view show:@"请检查网络连接"];
        return;
    }
    [self pushCapture];

    if (self.liveParama) {
        if (_isConnecting) {
//            [self.view show:@"正在连接中，无法推流"];
            return;
        }

        _liveState = MZLiveLaunching;
        _url = self.liveParama[@"push_url"];
        
        if (!self.chatKitManager) {
            self.chatKitManager = [[MZChatKitManager alloc] init];
            self.chatKitManager.delegate = self;
        }
        [self.chatKitManager startTimelyChar:self.model.ticket_id receive_url:self.model.chat_conf.receive_url srv:self.model.msg_conf.msg_srv token:self.model.msg_conf.msg_token];


        [self startLiveTimer];
        _isConnecting = YES;
        self.view.userInteractionEnabled = YES;
    }else{
        [self.view show:@"无推流配置"];
    }
    [_pushManager startCaptureWithRtmpUrl:_url];
}

- (void)addKeyBoardNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)removeKeyBoardNoti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification  object:nil];
}

/**
 链接失败
 */
-(void)pushConnectErrorHint
{
    [self showCutOffTipView];
}

-(void)showCutOffTipView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //阻止iOS设备锁屏
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
        [MZSDKSimpleHud hide];
        if (!self.liveAlertView) {
            self.liveAlertView = [[MZLiveAlertView alloc]init];
            NSString *startTip = @"您的直播推流失败，请点击“重试”进行尝试新的推流！";
            NSString *centerTip = @"您的直播出现意外“断流”，请点击“重试”按钮恢复直播推流！";
            WeaklySelf(weakSelf);
            [self.liveAlertView showInWithView:self.view title:self.isStartPush ? centerTip :startTip leftBtn:@"结束" rightBtn:@"重试" clickBlock:^(MZLiveAlerBtnClickType clickType) {
                weakSelf.liveAlertView = nil;
                if(clickType == MZLiveAlerLeftClick){
                    [weakSelf stopLive];
                }else{
                    [weakSelf outToConnect];
                    [MZSDKSimpleHud show];
                }
            }];
        }
    });
}

/// 断流后重连
- (void)outToConnect {
    [_pushManager startCaptureWithRtmpUrl:_url];
}

- (void)videoBitrateCurrentBandwidth:(CGFloat)currentBandwidth {
    if (currentBandwidth > 100) {
        _bitRateLabel.textColor = [UIColor colorWithRed:80/255.0 green:227/255.0 blue:194/255.0 alpha:1];
    }else{
        _bitRateLabel.textColor = [UIColor redColor];
    }
    _bitRateLabel.text = [NSString stringWithFormat:@"%.1f Kb/s",currentBandwidth/1000.0 * 8];
}

-(void) avCapture:(mz_rtmp_state) fromState toState:(mz_rtmp_state) toState {
    switch (toState) {
        case mz_rtmp_state_idle: {
            NSLog(@"初始状态");
            break;
        }
        case mz_rtmp_state_connecting: {
            NSLog(@"连接中");
            break;
        }
        case mz_rtmp_state_opened: {
            self.isStartPush = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MZSDKSimpleHud hide];
                self.closeLiveBtn.userInteractionEnabled = YES;
            });
            NSLog(@"MZLiveViewController alivc connect success!");
            break;
        }
        case mz_rtmp_state_connected: {
            NSLog(@"连接成功");
            break;
        }
        case mz_rtmp_state_closed: {
            NSLog(@"已关闭");
            break;
        }
        case mz_rtmp_state_error_write: {
            NSLog(@"写入错误");
            break;
        }
        case mz_rtmp_state_error_open: {
            NSLog(@"连接错误");
            dispatch_async(dispatch_get_main_queue(), ^{
                [MZSDKSimpleHud hide];
                self.closeLiveBtn.userInteractionEnabled = YES;
                [self pushConnectErrorHint];
            });
            break;
        }
        case mz_rtmp_state_error_net: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view show:@"网速太差，建议等待"];
            });
            break;
        }
    }
}

#pragma mark 不允许直播
- (void)forbidLive{
    __weak typeof(self) weakSelf = self;
    MZChannelAlertView * alertView = [[MZChannelAlertView alloc] initWithClearBufferViewFrame:CGRectMake((self.view.width - self.view.width) / 2.0 ,(self.view.height - self.view.height) / 2.0, self.view.width, self.view.height) title:@"该频道已在其它设备直播中，不可同时发起直播！" btn:@"我知道了" btnBackgroundColor:MakeColorRGB(0xff5b29)];
    
    [_preView addSubview:alertView];
    alertView.block = ^(NSInteger tag){
        [weakSelf stopLive];
    };

}

-(NSURL *)customUrlWithStr:(NSString *)str
{
//    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; //这个方法是解决链接中含有中文字符的情况（有特殊字符还是不能正常显示），下面的方法是可以的
   str = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return [NSURL URLWithString:str];
}

#pragma mark - CameraEngineDelegate

-(void)firstCaptureImage:(UIImage *)image{
    NSLog(@"第一张图片");
}

#pragma mark 发起/停止直播
- (void)startLive{
    if (self.liveParama) {
        if(_isConnecting){
            [MZSDKSimpleHud hide];
            self.closeLiveBtn.userInteractionEnabled = YES;
            return;
        }
        if(_timer == nil){
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
        }
        self.view.userInteractionEnabled = YES;
        
        _liveState = MZLiveLaunching;
        _url = self.liveParama[@"push_url"];
        
        if (!self.chatKitManager) {
            self.chatKitManager = [[MZChatKitManager alloc] init];
            self.chatKitManager.delegate = self;
        }
        [self.chatKitManager startTimelyChar:self.model.ticket_id receive_url:self.model.chat_conf.receive_url srv:self.model.msg_conf.msg_srv token:self.model.msg_conf.msg_token];

        [_pushManager startCaptureWithRtmpUrl:_url];
        
        [self startLiveTimer];
        _isConnecting = YES;
    } else {
        [self.view show:@"无推流配置,无法直播"];
    }
    
}

- (void)stopLive{
    [self destoryPusher];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}

#pragma mark - 直播时长timer
- (void)startLiveTimer{
    [self stopLiveTimer];
    if(_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
    }
}

- (void)stopLiveTimer{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timerHandler:(NSTimer *)timer {
    _liveDuration = _liveDuration + 1.0;
    long seconds = (long)_liveDuration % 60;
    long minutes = ((long)_liveDuration / 60) % 60;
    long hours = (long)_liveDuration / 3600;
    _liveTimeLabel.text = [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld", hours, minutes, seconds];
}

#pragma mark 直播倒计时timer
-(void)countDownAction
{
    self.view.userInteractionEnabled = YES;
    self.liveManagerHearderView.userInteractionEnabled = NO;
    self.liveAudienceHeaderView.userInteractionEnabled = NO;
    _chatView.userInteractionEnabled = NO;
    self.cameraChangeBtn.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf=self;
    [_preView addSubview:self.downCountLabel];
    
    if (_countDownNum >= 0) {
        self.downCountLabel.text = [NSString stringWithFormat:@"%d",_countDownNum];
    }

    if (_countDownNum == -1) {

        [self stopCountDownTimer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.downCountLabel removeFromSuperview];
            [MZSDKSimpleHud show];
            NSLog(@"show 2");

            self.effectBgView.hidden = YES;
            self.liveAudienceHeaderView.hidden = NO;
            self.liveManagerHearderView.hidden = NO;
            self.bottomTalkBtn.hidden = NO;
            self.cameraChangeBtn.hidden = NO;
            if (self.audioAnimationView.superview) {
                [self.audioAnimationView setHidden:NO];
            }
            
            if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
                self.menuBtn.hidden = YES;
                
                self.beautyFaceBtn.alpha = 1;
                self.mirrorBtn.alpha = 1;
                self.flashLightBtn.alpha = 1;
                self.muteBtn.alpha = 1;
                self.blockAllButton.alpha = 1;
                self.sessionPresetButton.alpha = 1;
                
                [self.view setNeedsLayout];
            } else {
                self.menuBtn.hidden = NO;
            }
            
            self.shareBtn.hidden = NO;
            self.muteBtn.hidden = NO;
            self.blockAllButton.hidden = NO;
            self.sessionPresetButton.hidden = NO;
            self.flashLightBtn.hidden = NO;
            self.mirrorBtn.hidden = NO;
            self.beautyFaceBtn.hidden = NO;
            self.bitTopView.hidden = NO;
            self.liveManagerHearderView.userInteractionEnabled = YES;
            self.liveAudienceHeaderView.userInteractionEnabled = YES;
            _chatView.userInteractionEnabled = YES;
            self.closeLiveBtn.userInteractionEnabled = NO;
            self.cameraChangeBtn.userInteractionEnabled = YES;
            
            [self startLive];
        });
    }
    _countDownNum --;
}

- (void)startCountDownTimer{
    _countDowntimer = nil;
    if (_countDownNum <= 0) {
        _countDownNum = 4;
    }
    if (!_countDowntimer) {
        _countDowntimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    }
}
- (void)stopCountDownTimer{
    if(_countDowntimer)
    {
        [_countDowntimer invalidate];
        _countDowntimer = nil;
        _countDownNum = 0;
        self.view.userInteractionEnabled = YES;
    }
}

#pragma mark - 视频直播异常打断
- (void)applicationDidEnterBackground{
    NSLog(@"进入后台，停止直播");

    [self hideKeyboard];
    [self appResignActive];
}

//- (void)stopLive:(NSString*)str{
//    if (_liveState == MZLiveLaunching) {
//        return;
//    }
//    [self stopLiveTimer];
//    [self stopCountDownTimer];
//    WeaklySelf(weakSelf);
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"视频直播异常停止" message:@"确定后将继续发起直播" preferredStyle:UIAlertControllerStyleActionSheet];
//
//    [alertController addAction:[UIAlertAction actionWithTitle:@"结束" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [MZSDKBusinessManager stopLive:nil ticketId:_model.ticket_id success:^(MZLiveFinishModel *model) {
//            [weakSelf stopLive];
//        } failure:^(NSError * error) {
//            [weakSelf stopLive];
//        }];
//    }]];
//
//    [alertController addAction:[UIAlertAction actionWithTitle:@"继续直播" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf startLive];
//    }]];
//
//    [self presentViewController:alertController animated:true completion:nil];
//}



#pragma mark 聊天
- (void)showKeyboard{
    _hideKeyBoardBtn.hidden = NO;
    _chatToolBar.hidden = NO;
    [_chatToolBar.msgTextView becomeFirstResponder];
    [self.view addSubview:_chatToolBar];
}

- (void)hideKeyboard{
    [_chatToolBar endEditing:YES];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        _chatToolBar.hidden = YES;
        _hideKeyBoardBtn.hidden = YES;
    });
}

-(void)viewCutLevel:(BOOL)isCut{
    _chatView.hidden=NO;
}
#pragma mark - MZMessageToolBarDelegate
- (void)didChangeFrameToHeight:(CGFloat)toHeight{
}

- (void)didSendText:(NSString *)text userName:(NSString *)userName joinID:(NSString *)joinID
{
    if([MZBaseUserServer currentUser].uniqueID.length <= 0 || self.model.chat_conf.chat_uid.length <= 0){
        [self.navigationController.view show:@"您还未登录"];
        [self hideKeyboard];
        return;
    }
    if ([MZBaseGlobalTools isBlankString:text]) {
        [self hideKeyboard];
        return;
    }
//
    NSString * host = [NSString stringWithFormat:@"%@?",self.model.chat_conf.pub_url];
    NSString * token = self.model.msg_conf.msg_token;
    MZLongPollDataModel*msgModel = [[MZLongPollDataModel alloc]init];
    msgModel.userId = self.model.chat_conf.chat_uid;
    msgModel.userName = [MZBaseUserServer currentUser].nickName;
    msgModel.userAvatar = [MZBaseUserServer currentUser].avatar;
    msgModel.event = MsgTypeMeChat;
    MZActMsg *actMsg = [[MZActMsg alloc]init];
    actMsg.msgText = text;
    actMsg.uniqueID = [MZBaseUserServer currentUser].uniqueID;
    msgModel.data = actMsg;
    [_chatView addChatData:msgModel];
    
    
    [MZChatKitManager sendText:text host:host token:token userID:self.model.chat_conf.chat_uid userNickName:[MZBaseUserServer currentUser].nickName userAvatar:[MZBaseUserServer currentUser].avatar isBarrage:NO success:^(MZLongPollDataModel *msgModel) {
        
        NSLog(@"发送成功");
    } failure:^(NSError *error) {

        NSLog(@"发送失败");
    }];
    
    [self hideKeyboard];
}

- (void)cancelTextView{
    [self hideKeyboard];
}

#pragma mark --观众列表
- (void)creatAudienceWinView {
    WeaklySelf(weakSelf);
    MZAudienceView *audienceView = [[MZAudienceView alloc] initWithFrame:self.view.bounds ticket_id:self.model.ticket_id chat_idOfMe:self.model.chat_conf.chat_uid  selectUserHandle:^(MZOnlineUserListModel *userModel) {
        [weakSelf.view show:@"点击了某一个观众"];
    } closeHandle:^{
        NSLog(@"关闭了在线列表");
    }];
    [self.view addSubview:audienceView];
    
}

#pragma mark 礼物列表弹窗
- (void)creatPresentView{
    MZPresentView * presentListView = [[MZPresentView alloc]initWithFrame:self.view.bounds];
    [presentListView showWithView:self.view withJoinTotal:_moneyChangeTotalStr];

    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (NSInteger i = _getGiftDataArr.count - 1; i >= 0; i--) {
        [array  addObject:_getGiftDataArr[i]];
    }
    [presentListView setGiftList:array];
    [self.view addSubview:presentListView];
}

#pragma mark 消息回调
- (void)activityOnlineNumberdidchange:(NSString *)onlineNo{
//    [self adjustAudienceBtn:onlineNo];
}

- (void)activityOnlineNumGiftchange:(NSString *)onlineGiftMoney{
}

/// 收到一条全局礼物消息
- (void)activityGetGiftMsg:(MZLongPollDataModel *)msg {
    [_chatView addChatData:msg];
}

/// 收到被踢出信息
-(void)activityGetKickoutMsg:(MZLongPollDataModel *)msg {
    NSLog(@"用户id为%@的用户被踢出",msg.data.tickOutUserID);
}

/// 直播时收到一条新消息
-(void)activityGetNewMsg:(MZLongPollDataModel * )msg
{
    if(msg.event == MsgTypeOnline){
        [_chatView addChatData:msg];
        
        // 统计人气
        self.popularityNum ++;
        self.liveManagerHearderView.numStr = [NSString stringWithFormat:@"%lld",self.popularityNum];
        
        if ([msg.data.is_hidden intValue] == 1) {//机器人不统计在线人数
            return;
        }
        if(msg.userId.longLongValue <= 5000000000){
            MZOnlineUserListModel *user = [[MZOnlineUserListModel alloc]init];
            user.uid = msg.userId;
            user.avatar = msg.userAvatar;
            user.nickname = msg.userName;

            __block BOOL onlineArrayIsHas = NO;
            [self.onlineUsersArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MZOnlineUserListModel *model = (MZOnlineUserListModel *)obj;
                if ([model.uid isEqualToString:user.uid]) {
                    onlineArrayIsHas = YES;
                    *stop = YES;
                }
            }];
            if (!onlineArrayIsHas) {
                [self.onlineUsersArr addObject:user];
            }
        }
        NSLog(@"上线了上线了");
        self.liveAudienceHeaderView.userArr = self.onlineUsersArr;
        [self.liveAudienceHeaderView updateOnlineUserTotalCount:(int)self.onlineUsersArr.count];

    }else if(msg.event == MsgTypeOffline){
//        有人下线
        
        NSLog(@"下线了下线了");
        
        // 如果是自己下线的通知，不处理
        if ([msg.userId isEqualToString:self.model.chat_conf.chat_uid]) {
            return;
        }
        
        NSMutableArray *temArr = self.onlineUsersArr.mutableCopy;
        if(temArr.count > 0){
            if(msg.userId.longLongValue <= 5000000000){
                for (MZOnlineUserListModel *user in temArr) {
                    if([user.uid isEqualToString:msg.userId]){
                        [self.onlineUsersArr removeObject:user];
                        self.liveAudienceHeaderView.userArr = self.onlineUsersArr;
                        [self.liveAudienceHeaderView updateOnlineUserTotalCount:(int)self.onlineUsersArr.count];
                        break;
                    }
                }
            }
        }
        [_chatView addChatData:msg];
    }else if(msg.event == MsgTypeOtherChat || msg.event == MsgTypeMeChat){
        if([self.model.chat_conf.chat_uid isEqualToString:msg.userId]){
            msg.event = MsgTypeMeChat;
            return;
        }else{
            [_chatView addChatData:msg];
        }
        
    }else if (msg.event == MsgTypeGoodsUrl){//推广商品

    }else if (msg.event == MsgTypeLiveOver){//中途结束
    }else if (msg.event == MsgTypeLiveReallyEnd){//直播真正的结束

    }else if (msg.event == MsgTypeDisableChat){
        if(self.model.chat_conf.chat_uid.intValue  == msg.data.disableChatUserID.intValue){
            self.bottomTalkBtn.isBanned = YES;
        }
    }else if (msg.event == MsgTypeAbleChat){
        if(self.model.chat_conf.chat_uid.intValue  == msg.data.ableChatUserID.intValue){
            self.bottomTalkBtn.isBanned = NO;
        }
    }else if (msg.event == MsgTypeGetGift) {
         MZPresentListModel * model = [[MZPresentListModel alloc]init];
         model.name = msg.data.giftName;
         model.icon = msg.data.giftIcon;
         model.id = msg.data.giftID;
         model.num = msg.data.continuous;
         model.price = msg.data.giftPrice;
         [_getGiftDataArr addObject:model];
    }else if (msg.event == MsgTypeGetReward) {
         MZPresentListModel * model = [[MZPresentListModel alloc]init];
         model.name = msg.data.giftName;
         model.price = msg.data.rewardMoney;
         [_getGiftDataArr addObject:model];
    }else if (msg.event == MsgTypeChannelLiveStart) {//直播间有其他的直播开始
        //    "ticket_id" : 10000537 // 开始直播的ticket id

    }else if (msg.event == MsgTypeKickout) {//踢出用户
        // "user_id": "1111", // 用户ID
    }
}

#pragma mark - 设备旋转
// 支持设备自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.isLandscape) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

//一开始的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.isLandscape) {
        return UIInterfaceOrientationLandscapeRight;
    }
    return UIInterfaceOrientationPortrait;
}

#pragma mark - ObserveValueForKeyPath
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:kViewFramePath]){
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey]CGRectValue];
        if(frame.size.width < frame.size.height)
        {
            if(_chatToolBar==nil)
            {
                [self initHideKeyBoardBtn];
                _chatToolBar = [[MZMessageToolView alloc] initWithFrame:CGRectMake(0, MZTotalScreenHeight - [MZMessageToolView defaultHeight],  MZ_SW, [MZMessageToolView defaultHeight]) type:MZMessageToolBarTypeAllBtn];
                _chatToolBar.maxLength = 100;
                _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
                _chatToolBar.delegate = self;
                _chatToolBar.msgTextView.delegate = self;
                _chatToolBar.hidden = YES;
                [self.view addSubview:_chatToolBar];
            }
        } else if (frame.size.width > frame.size.height) {

        }
    }
}

-(void)receiveOtherLoginMessage
{
    [self destroySession];
}


//账号在其他e页面登录，点击提示弹窗的方法
-(void)sureOtherLoginMessage
{
//    [self rotateScreen:NO];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 懒加载
- (UILabel *)downCountLabel {
    if (!_downCountLabel) {
        _downCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_preView.frame.size.width/2.0-125, _preView.frame.size.height/2.0-125, 250, 250)];
        _downCountLabel.textColor = [UIColor whiteColor];
        _downCountLabel.textAlignment = NSTextAlignmentCenter;
        _downCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:101];
        
        /** 都是等宽不晃动的字体
         label.font = [UIFont fontWithName:@"Helvetica Neue" size:101];//普通
         label.font = [UIFont fontWithName:@"Helvetica-Bold" size:101];//加粗
         label.font = [UIFont fontWithName:@"Helvetica-Oblique" size:101];//加斜
         label.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:101];//又粗又斜
         */
        _downCountLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _downCountLabel;
}

- (void)initHideKeyBoardBtn{
    if (!_hideKeyBoardBtn) {
        _hideKeyBoardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _hideKeyBoardBtn.backgroundColor = [UIColor clearColor];
        _hideKeyBoardBtn.tag = MZLiveViewHideKeyBoardBtnTag;
        [_hideKeyBoardBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _hideKeyBoardBtn.hidden = YES;
        [self.view addSubview:_hideKeyBoardBtn];
    }
}

- (MZAnimationView *)audioAnimationView {
    if (!_audioAnimationView) {
        _audioAnimationView = [MZAnimationView animationNamed:MZ_Audio_AnimationJsonName];
        _audioAnimationView.loopAnimation = YES;
        _audioAnimationView.frame = CGRectMake(0, self.liveManagerHearderView.bottom + 30.0, _preView.frame.size.width, _preView.frame.size.width/16*9);
        [_audioAnimationView setHidden:YES];
        _audioAnimationView.userInteractionEnabled = NO;
    }
    return _audioAnimationView;
}

- (MZBeautyFaceOptionView *)beautyFaceOptionView {
    if (!_beautyFaceOptionView) {
        WeaklySelf(weakSelf);
        _beautyFaceOptionView = [[MZBeautyFaceOptionView alloc] init];
        _beautyFaceOptionView.result = ^(BOOL isCancel, MZBeautyFaceLevel beautyLevel) {
            if (!isCancel) {
                weakSelf.beautyFaceLevel = beautyLevel;
                [weakSelf.beautyFaceBtn setSelected:(beautyLevel == MZBeautyFaceLevel_None ? NO : YES)];
                [weakSelf.pushManager setBeautyFaceLevel:beautyLevel];
            }
        };
    }
    return _beautyFaceOptionView;
}

- (MZSessionPresetView *)sessionPresetView {
    if (!_sessionPresetView) {
        WeaklySelf(weakSelf);
        _sessionPresetView = [[MZSessionPresetView alloc] init];
        _sessionPresetView.result = ^(BOOL isCancel, MZCaptureSessionPreset sessionPreset) {
            if (!isCancel) {
                weakSelf.videoSessionPreset = sessionPreset;
                [weakSelf updateSessionPresetButton];
                [weakSelf.pushManager setCaptureSessionPreset:sessionPreset];
            }
        };
    }
    return _sessionPresetView;
}

- (void)removePushItemCache{
//    [[EGOCache  globalCache] removeCacheForKey:MZLive_PushPresentCache];
//    [[EGOCache  globalCache] removeCacheForKey:MZLive_PushProductCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) keyboardWasShown:(NSNotification *) notif{
//    _chatToolBar.frame = CGRectMake(_chatToolBar.origin.x, MZTotalScreenHeight  - _chatToolBar.frame.size.height, _chatToolBar.width, _chatToolBar.height);
}

- (void)clickBtn{
    [self stopLive];
}

-(void)dealloc{
    NSLog(@"%@",[[self class] description]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
