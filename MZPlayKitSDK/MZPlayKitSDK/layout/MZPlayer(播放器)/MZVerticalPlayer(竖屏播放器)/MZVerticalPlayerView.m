//
//  MZVerticalPlayerView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/6/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZVerticalPlayerView.h"
#import "MZPlayManagerHeaderView.h"
#import "MZLiveAudienceHeaderView.h"
#import "MZGoodsListView.h"
#import "MZHistoryChatView.h"
#import "MZBottomTalkBtn.h"
#import "MZMessageToolView.h"
#import "MZTipGoodsView.h"
#import "MZMultiMenu.h"
#import "MZPraiseButton.h"
#import "MZSmallPlayerView.h"
#import "MZAudienceView.h"
#import "MZGoodsListPresenter.h"
#import "MZVerticalPlayerView+UI.h"
#import "MZGiftView.h"

#import "MZVoteView.h"
#import "MZWatchHeaderMessageView.h"
#import "MZUserTipView.h"
#import "MZRedPackageViewController.h"

#define kViewFramePath      @"frame"

static NSString *signImageName = @"mz_qiandao_normal";//未签到图片
static NSString *signInImageName = @"mz_qiandao_select";//签到图片

typedef void(^GoodsDataCallback)(MZGoodsListOuterModel *model);

@interface MZVerticalPlayerView()<MZMessageToolBarDelegate,UITextViewDelegate,MZChatKitDelegate,MZGoodsRequestProtocol,MZHistoryChatViewProtocol,MZMultiMenuDelegate,MZMediaPlayerViewDelegate,MZDLNAViewDelegate,MZPlaybackRateDelegate,MZVideoOpenADViewProtocol>

@property (nonatomic, strong) UIView *playerBackgroundView;//播放器上盖的一层View，用于承载各模块view

@property (nonatomic, strong) MZMoviePlayerModel *playInfo;//视频播放详情Model
@property (nonatomic, strong) MZHostModel *hostModel;//主播信息
@property (nonatomic, assign) long long popularityNum;//人气

@property (nonatomic, strong) MZLiveAudienceHeaderView *liveAudienceHeaderView;//右上角观众view
@property (nonatomic, strong) NSMutableArray *onlineUsersArr;//记录的右上角展示的几个在线观众数据源
@property (nonatomic, assign) int onlineUsersTotalCount;//记录的总在线人数

@property (nonatomic, strong) MZHistoryChatView *chatView;//聊天view
@property (nonatomic, strong) UIButton *hideKeyBoardBtn;//聊天弹出后，点击隐藏键盘的button
@property (nonatomic, strong) MZMessageToolView *chatToolBar;//聊天工具输入栏

@property (nonatomic, strong) UILabel *unusualTipView;//主播离开的提示view
@property (nonatomic, strong) UILabel *realyEndView;//直播结束的提示

@property (nonatomic, strong) UIButton *closeLiveBtn;//关闭按钮
@property (nonatomic, strong) UIStackView *stackContainerView;//底部并列的菜单按钮
@property (nonatomic, strong) UIButton *shoppingBagButton;//商品袋
@property (nonatomic, strong) UILabel *goodsNumLabel;//商品袋里的商品个数
@property (nonatomic, strong) MZBottomTalkBtn *bottomTalkBtn;//点击后弹出键盘的button

@property (nonatomic, strong) UIButton *multiButton;//多菜单按钮
@property (nonatomic, strong) MZMultiMenu *multiMenu;//多功能菜单View

@property (nonatomic, assign) BOOL isPraise;//点赞过滤
@property (nonatomic, strong) MZPraiseButton *praiseButton;//点赞按钮
@property (nonatomic, strong) MZTimer *timer;//持续点赞定时器

@property (nonatomic, strong) UIButton *giftButton;//礼物按钮
@property (nonatomic, strong) MZGiftView *giftView;//礼物View

@property (nonatomic, strong) UIButton *redPackageButton;//红包按钮
@property (nonatomic, assign) BOOL isShowRedPackageButton;//是否显示红包按钮

@property (nonatomic, strong) NSMutableArray *goodsListArr;//商品共用的数据源
@property (nonatomic, strong) MZGoodsListView *goodsListView;//商品View
@property (nonatomic, strong) MZTipGoodsView *circleTipGoodsView;//循环播放的弹出商品view
@property (nonatomic, strong) MZTipGoodsView *spreadTipGoodsView;//推广的弹出view
@property (nonatomic, assign) int totalNum;//商品总个数

@property (nonatomic, strong) MZChatKitManager *chatKitManager;//聊天句柄

@property (nonatomic, strong) MZMoviePlayerPlaybackRateView *rateView;//倍速选择播放的view
@property (nonatomic, assign) NSInteger selectedRate;//默认倍速索引

@property (nonatomic, strong) MZDLNAPlayingView *DLNAPlayingView;//投屏中展示的View
@property (nonatomic, strong) MZDLNAView *DLNAView;//选择投屏的View

@property (nonatomic, strong) UIView *barrageBackgroundView;//承载弹幕的view，只有竖屏播放器才有，适配弹幕位置

@property (nonatomic, assign) BOOL isChat;//聊天室是否可以聊天,默认可以
@property (nonatomic, assign) BOOL isRecordScreen;//是否开启防录屏，默认不开启
@property (nonatomic, assign) BOOL isCanBarrage;//是否可以发弹幕，默认可以
@property (nonatomic, assign) BOOL isShowBarrage;//是否显示弹幕，默认可以

@property (nonatomic, assign) BOOL isShowDocuments;//是否显示文档
@property (nonatomic, assign) BOOL isShowVideoBeforeAD;//是否显示暖场图

@property (nonatomic, strong) MZAnimationView *audioAnimationView;//静音直播的动画展示
@property (nonatomic ,strong)MZOpenScreenView *openScreenView;//暖场图

@property (nonatomic, assign) BOOL isShowPraiseView;//是否显示点赞视图
@property (nonatomic, assign) BOOL isShowGiftView;//是否显示礼物视图
@property (nonatomic, assign) BOOL isShowTimesSpeedView;//是否显示倍速视图

@property (nonatomic, assign) NSTimeInterval videoPauseTimeInBackground;//视频进入后台时候的记录位置
@property (nonatomic, assign) BOOL isEnterBackground;//是否进入后台标示
@property (nonatomic, assign) BOOL isBackgroundPlay;//是否后台播放

/**
    这里的是右侧菜单列表处理，所有的开关统一说明，例如:
    isShowSignLocation 本地的是否显示签到
    isShowSign 控制台的是否显示签到
    如果本地是否显示为YES，那么就按照控制台的开关来处理，
    如果本地是否显示为NO，那么就忽略控制台的是否显示状态，强制不显示
 */
@property (nonatomic, assign) BOOL isShowSignLocation;//本地的是否显示签到
@property (nonatomic, assign) BOOL isShowSign;//控制台的是否显示签到
@property (nonatomic, assign) BOOL isSignIn;//是否已经签到
@property (nonatomic, strong) UIButton *signButton;//签到按钮
@property (nonatomic, strong) MZSignView *signView;//签到View

@property (nonatomic, assign) BOOL isShowVoteLocation;//本地的是否显示投票
@property (nonatomic, assign) BOOL isShowVote;//控制台是否显示投票
@property (nonatomic, strong) UIButton *voteButton;//投票按钮
@property (nonatomic, strong) MZVoteView *voteView;//投票View

@property (nonatomic, assign) BOOL isShowPrizeLocation;//本地的是否显示抽奖
@property (nonatomic, assign) BOOL isShowPrize;//控制台是否显示抽奖
@property (nonatomic ,strong) UIButton *prizeButton;//抽奖按钮
@property (nonatomic ,strong) MZFuctionWebView *prizeFuctionWebView;//抽奖View

@property (nonatomic, strong) MZUserTipView *tipView;

@end

@implementation MZVerticalPlayerView

- (void)dealloc {
    _delegate = nil;
    [self removeObserver:self forKeyPath:kViewFramePath];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MZSmallPlayerView hide];

    [_playerView.advertPlayerView stop];
    NSLog(@"竖屏播放器界面释放");
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.selectedRate = 1;
        self.videoPauseTimeInBackground = 0;

        self.isChat = YES;
        self.isRecordScreen = NO;
        self.isCanBarrage = YES;
        self.isShowBarrage = YES;
        self.isSignIn = NO;//默认未签到

        // 右侧菜单列表 - 所有本地控制的开关
        self.isShowSignLocation = YES;//本地默认展示签到
        self.isShowVoteLocation = YES;//本地默认展示投票
        self.isShowPrizeLocation = YES;//本地默认展示抽奖

        // 右侧菜单列表 - 控制台控制的开关
        self.isShowSign = NO;//控制台默认不展示签到
        self.isShowVote = NO;//控制台默认不展示投票
        self.isShowPrize = NO;//控制台默认不展示抽奖
        
        self.isShowDocuments = NO;//默认不展示文档
        self.isShowGiftView = YES;//默认展示礼物按钮
        self.isShowPraiseView = YES;//默认展示点赞按钮
        
        self.isShowRedPackageButton = YES;//本地默认展示抽奖

        [self customAddSubviews];
        [self addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)enterForeground:(NSNotification *)noti {
    self.isEnterBackground = NO;
    if (@available(iOS 14.0, *)) {
        if (self.playInfo.status == 2) {//回放
            if (!self.isBackgroundPlay) {
                self.videoPauseTimeInBackground = self.playerView.playerManager.currentPlaybackTime;
                [self playerVideoWithURLString:self.playInfo.video.url];
            }
        } else {//直播
            if (self.playerView.playerManager.isPlaying == NO) {
                [self.playerView startPlayer];
            }
        }
    }
}

- (void)enterBackground:(NSNotification *)noti {
    self.isEnterBackground = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 聊天框
    CGRect toolBarFrame = _chatToolBar.frame;
    toolBarFrame.size.width = self.frame.size.width;
    _chatToolBar.frame = toolBarFrame;
    
    // 隐藏按钮的frame
    _hideKeyBoardBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    // 处理是否显示点赞按钮
    if (self.isShowPraiseView) {
        if (![self.stackContainerView.subviews containsObject:self.praiseButton]) {
            [self.stackContainerView addArrangedSubview:self.praiseButton];
        }
    } else {
        if ([self.stackContainerView.subviews containsObject:self.praiseButton]) {
            [self.stackContainerView removeArrangedSubview:self.praiseButton];
            [self.praiseButton removeFromSuperview];
        }
    }
    
    // 处理是否显示礼物按钮
    if (self.isShowGiftView) {
        if (![self.stackContainerView.subviews containsObject:self.giftButton]) {
            [self.stackContainerView insertArrangedSubview:self.giftButton atIndex:1];
        }
    } else {
        if ([self.stackContainerView.subviews containsObject:self.giftButton]) {
            [self.stackContainerView removeArrangedSubview:self.giftButton];
            [self.giftButton removeFromSuperview];
        }
    }
    
    // 处理是否显示红包按钮
    if (self.isShowRedPackageButton) {
        if (![self.stackContainerView.subviews containsObject:self.redPackageButton]) {
            [self.stackContainerView insertArrangedSubview:self.redPackageButton atIndex:2];
        }
    } else {
        if ([self.stackContainerView.subviews containsObject:self.redPackageButton]) {
            [self.stackContainerView removeArrangedSubview:self.redPackageButton];
            [self.redPackageButton removeFromSuperview];
        }
    }
}

- (void)customAddSubviews {
    self.playerBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.playerBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.playerBackgroundView];
    
    [self createTopView];
    [self createBottomButtons];
    [self setupChatView];
    [self addTimerForScroll]; //开启动画计时器
    
    // 添加静音播放的动画View
    [self.playerBackgroundView addSubview:self.audioAnimationView];
}

- (void)createTopView {
    self.isPraise = YES;
    WeaklySelf(weakself);
    CGFloat topSpace = IPHONE_X ? 20 : 0;
    self.liveManagerHeaderView = [[MZPlayManagerHeaderView alloc]initWithFrame:CGRectMake(12*MZ_RATE,topSpace + 22*MZ_RATE, 172*MZ_RATE, 40*MZ_RATE)];
    [self addSubview:self.liveManagerHeaderView];
    
    self.liveManagerHeaderView.clickBlock = ^{
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(avatarDidClick:)]) {
            [weakself.delegate avatarDidClick:weakself.hostModel];
        }
    };
    self.liveManagerHeaderView.attentionClickBlock = ^{
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(attentionButtonDidClick:)]) {
            [weakself.delegate attentionButtonDidClick:weakself.playInfo];
        }
    };
    self.liveAudienceHeaderView = [[MZLiveAudienceHeaderView alloc]initWithFrame:CGRectMake(self.liveManagerHeaderView.right + 22*MZ_RATE, self.liveManagerHeaderView.center.y - 14*MZ_RATE, 116*MZ_RATE, 28*MZ_RATE)];
    self.liveAudienceHeaderView.hidden = NO;
    [self addSubview:self.liveAudienceHeaderView];
    
    self.liveAudienceHeaderView.clickBlock = ^{
        [weakself creatAudienceWinView];
    };
    self.closeLiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(MZ_SW - 44*MZ_RATE - 8*MZ_RATE,topSpace + 20*MZ_RATE, 44*MZ_RATE, 44*MZ_RATE)];
    [self.closeLiveBtn addTarget:self action:@selector(closeButtonDidclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeLiveBtn setImage:ImageName(@"live_close") forState:UIControlStateNormal];
    [self addSubview:self.closeLiveBtn];
}

- (void)createBottomButtons {
    WeaklySelf(weakSelf);
    CGFloat bottomSpace = 12;
    if (IPHONE_X) {
        bottomSpace+=34;
    }
    UIStackView *stackContainerView = [[UIStackView alloc] initWithFrame:CGRectMake(171 * MZ_RATE, MZTotalScreenHeight-(36+bottomSpace)*MZ_RATE, 198*MZ_RATE, 36 *MZ_RATE)];
    self.stackContainerView = stackContainerView;
    
    stackContainerView.axis = UILayoutConstraintAxisHorizontal;
    stackContainerView.alignment = UIStackViewAlignmentFill;
    stackContainerView.spacing = 3 *MZ_RATE;
    stackContainerView.distribution = UIStackViewDistributionFillEqually;
    [self addSubview:stackContainerView];
    
    CGRect commonRect = CGRectMake(0, 0, 36 *MZ_RATE, 36*MZ_RATE);
    
    UIButton *xinshouButton = [[UIButton alloc] initWithFrame:commonRect];
    [xinshouButton setImage:ImageName(@"bottomButton_jubao") forState:UIControlStateNormal];
    [xinshouButton setImage:ImageName(@"bottomButton_jubao_click") forState:UIControlStateSelected];
    [stackContainerView addArrangedSubview:xinshouButton];
    [xinshouButton addTarget:self action:@selector(multiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.multiButton = xinshouButton;
    
    self.multiMenu = [[MZMultiMenu alloc] initWithFrame:CGRectMake(stackContainerView.frame.origin.x - 14*MZ_RATE, stackContainerView.frame.origin.y - 78*MZ_RATE - 10, 72*MZ_RATE, 78*MZ_RATE)];
    self.multiMenu.delegate = self;
    [self addSubview:self.multiMenu];
    [self.multiMenu setHidden:YES];
    
    [stackContainerView addArrangedSubview:self.giftButton];
    self.giftButton.frame = commonRect;
    
    [stackContainerView addArrangedSubview:self.redPackageButton];
    self.redPackageButton.frame = commonRect;
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:commonRect];
    [shareButton setImage:ImageName(@"bottomButton_share") forState:UIControlStateNormal];
    [stackContainerView addArrangedSubview:shareButton];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [stackContainerView addArrangedSubview:self.praiseButton];
    self.praiseButton.frame = commonRect;
    
    UIButton *shoppingBagButton = [[UIButton alloc] initWithFrame:CGRectMake(12, stackContainerView.top, 44*MZ_RATE, 44*MZ_RATE)];
    [self addSubview:shoppingBagButton];
    self.shoppingBagButton = shoppingBagButton;
    [shoppingBagButton setImage:ImageName(@"bottomButton_shoppingBag") forState:UIControlStateNormal];
    [shoppingBagButton addTarget:self action:@selector(shoppingBagButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21*MZ_RATE, 44*MZ_RATE, 17*MZ_RATE)];
    self.goodsNumLabel.font = [UIFont systemFontOfSize:12];
    self.goodsNumLabel.textAlignment = NSTextAlignmentCenter;
    self.goodsNumLabel.textColor = [UIColor whiteColor];
    self.goodsNumLabel.hidden=YES;
    [shoppingBagButton addSubview:self.goodsNumLabel];
    
    self.bottomTalkBtn = [[MZBottomTalkBtn alloc]initWithFrame:CGRectMake(shoppingBagButton.right + 5*MZ_RATE, shoppingBagButton.top, 90*MZ_RATE, 44*MZ_RATE)];
    [self addSubview:self.bottomTalkBtn];
    self.bottomTalkBtn.bottomClickBlock = ^{
        if(weakSelf.bottomTalkBtn.isBanned){
            [weakSelf show:@"你已被禁言"];
        }else{
            if (weakSelf.isChat) {
                [weakSelf showKeyboard];
            } else {
                [weakSelf show:@"管理员已开启禁言功能"];
            }
        }
    };
}

- (void)setupChatView {
    self.chatView = [[MZHistoryChatView alloc]initWithFrame:CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 130*MZ_RATE)];
    self.chatView.chatDelegate =self;
    [self addSubview:self.chatView];
    
    //将弹出菜单放到self的最顶部
    [self bringSubviewToFront:self.multiMenu];
}


#pragma mark - 本类方法
// 红包按钮点击
- (void)redPackageButtonDidClick:(UIButton *)sender {
    MZRedPackageViewController *redPackageVC = [[MZRedPackageViewController alloc] init];
    redPackageVC.modalPresentationStyle = UIModalPresentationFullScreen;
    redPackageVC.ticket_id = self.playInfo.ticket_id;
    redPackageVC.channel_id = self.playInfo.channel_id;
    [[self getCurrentVC] presentViewController:redPackageVC animated:YES completion:nil];
}

// 礼物按钮点击
- (void)giftButtonDidClick:(UIButton *)sender {
    [self.giftView show];
}

/// 添加点赞动画的计时器
- (void)addTimerForScroll {
    self.timer = [MZTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) repeats:YES];
}

/// 点赞动画持续执行
- (void)timerAction {
    [self.praiseButton showPraiseAnimation];
}

/// 关闭播放器按钮点击
- (void)closeButtonDidclick:(UIButton *)button {
    // 移除延迟弹窗的逻辑
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(signButtonClick) object:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonDidClick:)]) {
        [self.delegate closeButtonDidClick:self.playInfo];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(initChat) object:nil];
    [self playerShutDown];
}

/// 隐藏按钮点击
- (void)hideKeyBoardBtnDidClick:(UIButton *)sender {
    [self hideKeyboard];
}

/// 点赞按钮点击
- (void)likeButtonDidClick:(UIButton *)button {
    if(self.isPraise){
        [MZSDKBusinessManager reqPostPraise:self.playInfo.ticket_id channel_id:self.playInfo.channel_id praises:@"1" chat_uid:self.playInfo.chat_uid success:^(id responseObject) {
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^{
                self.isPraise=YES;
                NSLog(@"likeButtonDidClick %d",self.isPraise);
            });
        } failure:^(NSError *error) {
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^{
                self.isPraise=YES;
                NSLog(@"likeButtonDidClick %d",self.isPraise);
            });
        }];
        self.isPraise=NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(likeButtonDidClick:)]) {
        [self.delegate likeButtonDidClick:self.playInfo];
    }
    
    // 显示点赞动画
    [self.praiseButton showPraiseAnimation];
}

/// 底部多菜单点击事件
- (void)multiButtonClick {
    self.multiButton.selected = !self.multiButton.selected;
    if (self.multiButton.selected) {
        [self.multiMenu setHidden:NO];
    } else {
        [self.multiMenu setHidden:YES];
    }
}

/// 分享按钮点击
- (void)shareButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareButtonDidClick:)]) {
        [self.delegate shareButtonDidClick:self.playInfo];
    }
}

/// 商品袋按钮点击
- (void)shoppingBagButtonClick {
    _goodsListView = [[MZGoodsListView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, MZTotalScreenHeight)];
    _goodsListView.requestDelegate=self;
    [_goodsListView loadDataWithIsMore:NO];
    WeaklySelf(weakSelf);
    _goodsListView.goodsListViewCellClickBlock = ^(MZGoodsListModel * _Nonnull model) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(goodsItemDidClick:)]) {
            [weakSelf.delegate goodsItemDidClick:model];
        }
    };
    _goodsListView.outGoodsListView = ^{
        weakSelf.goodsListView = nil;
    };
    
    [self addSubview:_goodsListView];
}

/// 更新主播信息
- (void)updateHostInfo:(MZHostModel *)hostModel {
    _hostModel = hostModel;
    
    self.liveManagerHeaderView.title = hostModel.nickname;
    self.liveManagerHeaderView.imageUrl = hostModel.avatar;
}

/// 销毁播放器
- (void)playerShutDown {
    [self.chatKitManager closeLongPoll];
    [self.chatKitManager closeSocketIO];
    self.chatKitManager.delegate = nil;
    
    [self.playerView.playerManager shutdown];
    [self.playerView.playerManager didShutdown];
}

/// 隐藏底部聊天等按钮
- (void)hideBottomMenu {
    [self.shoppingBagButton setHidden:YES];
    [self.stackContainerView setHidden:YES];
    [self.chatView setHidden:YES];
    [self.bottomTalkBtn setHidden:YES];
    
    [self.circleTipGoodsView setHidden:YES];
    [self.spreadTipGoodsView setHidden:YES];
    
    [self.multiButton setHidden:YES];
    self.multiButton.selected = NO;
    [self.multiMenu setHidden:YES];
}

/// 显示底部聊天等菜单
- (void)showBottomMenu {
    [self.shoppingBagButton setHidden:NO];
    [self.stackContainerView setHidden:NO];
    [self.chatView setHidden:NO];
    [self.bottomTalkBtn setHidden:NO];
    
    if (self.spreadTipGoodsView) {
        [self.spreadTipGoodsView setHidden:NO];
    } else if (self.circleTipGoodsView) {
        [self.circleTipGoodsView setHidden:NO];
    }
    
    [self.multiButton setHidden:NO];
    self.multiButton.selected = NO;
    [self.multiMenu setHidden:YES];
}

/// 显示循环展示的普通商品列表
- (void)tipGoodAnimationWithGoodsListArr:(NSMutableArray *)arr {
    WeaklySelf(weakSelf);
    if(!self.circleTipGoodsView){
        
        CGFloat y = self.chatView.frame.origin.y+self.chatView.frame.size.height + 3*MZ_RATE;
        if (self.chatView.frame.size.height >= 198*MZ_RATE) {//暂时没有商品的情况
            y = y - 60*MZ_RATE;
        }
        
        self.circleTipGoodsView = [[MZTipGoodsView alloc]initWithFrame:CGRectMake(18*MZ_RATE, y, 175*MZ_RATE, 60*MZ_RATE)];
        
        self.circleTipGoodsView.goodsClickBlock = ^(MZGoodsListModel * _Nonnull model) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(goodsItemDidClick:)]) {
                [weakSelf.delegate goodsItemDidClick:model];
            }
        };
        self.circleTipGoodsView.isCirclePlay = YES;
        self.circleTipGoodsView.alpha = 0;
        [self insertSubview:self.circleTipGoodsView belowSubview:self.multiMenu];
    }else{
        self.circleTipGoodsView.frame=CGRectMake(18*MZ_RATE, self.chatView.frame.origin.y+self.chatView.frame.size.height + 3*MZ_RATE, 175*MZ_RATE, 60*MZ_RATE);
        [self.chatView scrollToBottom];
    }
    self.circleTipGoodsView.goodsListModelArr = arr;
    if(!self.circleTipGoodsView.isOpen){
        [self.circleTipGoodsView beginAnimation];
    }else{
        if([arr count]==0){
            [self.circleTipGoodsView hiddenGoodViewWithModel:nil];
        }
    }
}

/// 加载推广商品，展示推广商品循环播放，隐藏默认商品循环播放
- (void)spreadTipGoodsViewDidShow {
    WeaklySelf(weakSelf);
    [self.spreadTipGoodsView beginAnimation];
    self.circleTipGoodsView.hidden = YES;
    self.spreadTipGoodsView.tipGoodsViewEndBlock = ^{
        weakSelf.circleTipGoodsView.hidden = NO;
        if([weakSelf.goodsListArr count]==0){
            weakSelf.chatView.frame = CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 198*MZ_RATE);
        }
    };
}

/// 请求加载商品列表
- (void)requestGoodsList:(GoodsDataResult)block offset:(int)offset {
    [MZSDKBusinessManager reqGoodsList:self.ticket_id offset:offset limit:50 success:^(id responseObject) {
        MZGoodsListOuterModel *goodsListOuterModel = [MZGoodsListOuterModel initModel:responseObject];
        
        if(offset>0){
            if (goodsListOuterModel.list.count) {
                [self.goodsListArr addObjectsFromArray:goodsListOuterModel.list];
            }
        }else {
            self.goodsListArr  = goodsListOuterModel.list;
            
            self.totalNum = goodsListOuterModel.total;
            self.goodsNumLabel.text = [NSString stringWithFormat:@"%d",goodsListOuterModel.total];
            self.goodsNumLabel.hidden = !goodsListOuterModel.total;
        }
        
        if(self.goodsListArr.count == 0){
            self.chatView.frame = CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 198*MZ_RATE);
        }else{
            self.chatView.frame = CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 130*MZ_RATE);
        }
        
        if(block){
            block(self.goodsListArr, self.totalNum);
        }
        
        [self tipGoodAnimationWithGoodsListArr:self.goodsListArr];
        
    } failure:^(NSError *error) {
        [self.goodsListView.goodTabView.mj_header endRefreshing];
        [self.goodsListView.goodTabView.mj_footer endRefreshing];
    }];
}

/// 观众列表展示
- (void)creatAudienceWinView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onlineListButtonDidClick:)]) {
        [self.delegate onlineListButtonDidClick:self.playInfo];
    }
    
    WeaklySelf(weakSelf);
    MZAudienceView *audienceView = [[MZAudienceView alloc] initWithFrame:self.bounds ticket_id:self.playInfo.ticket_id channel_id:self.playInfo.channel_id chat_idOfMe:self.playInfo.chat_uid isLiveHost:NO selectUserHandle:^(MZOnlineUserListModel *userModel) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onlineUserInfoDidClick:)]) {
            [weakSelf.delegate onlineUserInfoDidClick:userModel];
        }
    } closeHandle:^{
        NSLog(@"关闭了在线列表");
    }];
    [self addSubview:audienceView];
}

/// 添加/删除防录屏
- (void)preventRecordScreenLabelIsShow:(BOOL)isShow {
    NSString *text = self.hostModel.nickname;
    if (text.length <= 0) text = self.hostModel.uid;
    if (text.length <= 0) text = @"防录屏";
    
    if (isShow) [MZPreventRecordScreenLabel showRandomLabelWithShowView:self.playerBackgroundView text:text];
    else [MZPreventRecordScreenLabel hideRandomLabel];
}

/// 显示投屏选择view
- (void)showDLNASearthView {
    if ([MZBaseGlobalTools IsEnableWIFI]) {
        if(!self.DLNAView){
            self.DLNAView = [[MZDLNAView alloc]initWithFrame:CGRectMake(0, 0, MZScreenWidth, MZSafeScreenHeight)];
            self.DLNAView.delegate = self;
            self.DLNAView.DLNAString = self.playInfo.video.http_url ? self.playInfo.video.http_url : self.playInfo.video.url;
        }
        [self addSubview:self.DLNAView];
        
        [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
            self.DLNAView.fuctionView.frame = CGRectMake(0, MZSafeScreenHeight- 278*MZ_RATE, MZScreenWidth, 278*MZ_RATE);
        } completion:nil];
    } else {
        [self show:@"非Wifi情况下无法投屏"];
    }
}

/// 显示倍速选择view
- (void)playbackRateBtnClick {
    _rateView = [[MZMoviePlayerPlaybackRateView alloc] initRatePlayWithRate:_selectedRate];
    _rateView.delegate = self;
    [_rateView showInView:[UIApplication sharedApplication].delegate.window];
}

/// 小窗口播放
- (void)smallWindowToPlay {
    if (!self.playerView.superview) {
        NSLog(@"还没有添加播放窗口");
        return;
    }
    
    [self preventRecordScreenLabelIsShow:NO];
    
    WeaklySelf(weakSelf);
    __block CGRect frame = self.playerView.frame;
    [MZSmallPlayerView show:self.playerView finished:^{
        weakSelf.playerView.frame = frame;
        weakSelf.playerView.preview.frame = frame;
        [weakSelf.playerBackgroundView addSubview:weakSelf.playerView];
        if (weakSelf.isRecordScreen) {
            [weakSelf preventRecordScreenLabelIsShow:YES];
        }
    }];
}

#pragma mark - 更新主播相关信息/更新在线相关信息的方法
/// 更新左上角主播的人气/UV/视频类型的UI
- (void)updateUIWithPlayInfo {
    self.liveManagerHeaderView.live_status = self.playInfo.status;
    
    //    处理人气
    self.liveManagerHeaderView.numStr = [NSString stringWithFormat:@"%lld",self.popularityNum];
}

/// 更新右上角在线数据UI
- (void)updateUIWithOnlineUsers:(NSArray *)onlineUsers {
    if (!onlineUsers) {
        return;
    }
    self.onlineUsersArr = onlineUsers.mutableCopy;
    self.liveAudienceHeaderView.userArr = onlineUsers;
}

// 设置关注按钮状态
- (void)setAttentionState:(BOOL)isAttention {
    self.liveManagerHeaderView.width = isAttention ? 135*MZ_RATE : 172*MZ_RATE;
    self.liveManagerHeaderView.attentionBtn.hidden = isAttention;
}

/// 是否可以发送弹幕
- (void)setIsCanBarrage:(BOOL)isCanBarrage {
    _isCanBarrage = isCanBarrage;
    
    if (_chatToolBar) {
        _chatToolBar.isBarrage = _isCanBarrage;
    }
}

/// 展示/隐藏弹幕
- (void)barrageIsShow {
    if (self.isShowBarrage) {
        if (!self.barrageBackgroundView) {
            // 竖屏独有的弹幕frame
            CGFloat topSpace = IPHONE_X ? 20 : 0;
            
            self.barrageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, topSpace + 22*MZ_RATE + 44*MZ_RATE, self.playerView.playerManager.view.size.width, self.playerView.playerManager.view.size.height)];
            self.barrageBackgroundView.backgroundColor = [UIColor clearColor];
            [self.playerView.playerManager.view addSubview:self.barrageBackgroundView];
        }
        [MZBarrageManager startWithView:self.barrageBackgroundView];
//        [MZBarrageManager setSpriteHeaderIsHidden:YES];
    } else {
        [MZBarrageManager destory];
    }
}

#pragma mark - 聊天
/// 发送消息
- (void)didSendText:(NSString *)text userName:(NSString *)userName joinID:(NSString *)joinID isBarrage:(BOOL)isBarrage {
    if (self.playInfo.chat_uid.length <= 0 || [MZBaseUserServer currentUser].uniqueID.length <= 0) {
        [self.superview show:@"您还未登录"];
        [self hideKeyboard];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerNotLogin)]) {
            [self.delegate playerNotLogin];
        }
        return;
    }
    if ([MZBaseGlobalTools isBlankString:text]) {
        [self hideKeyboard];
        return;
    }
    NSString * host = [NSString stringWithFormat:@"%@?",self.playInfo.chat_config.pub_url];
    NSString * token = self.playInfo.msg_config.msg_token;
    MZLongPollDataModel*msgModel = [[MZLongPollDataModel alloc] init];
    msgModel.userId = self.playInfo.chat_uid;
    msgModel.userName = [MZBaseUserServer currentUser].nickName;
    msgModel.userAvatar = [MZBaseUserServer currentUser].avatar;
    msgModel.event = MsgTypeMeChat;
    MZActMsg *actMsg = [[MZActMsg alloc] init];
    actMsg.uniqueID = [MZBaseUserServer currentUser].uniqueID;
    actMsg.msgText = text;
    actMsg.barrage = isBarrage;
    msgModel.data = actMsg;
    [self.chatView addChatData:msgModel];
    
    if (self.isShowBarrage && isBarrage) {
        [MZBarrageManager sendBarrageWithMessage:msgModel.data.msgText userName:msgModel.userName avatar:msgModel.userAvatar isMe:YES result:^(BOOL isSuccess, NSError * _Nonnull error) {
            if (isSuccess) {
                NSLog(@"弹幕发送成功");
            } else {
                NSLog(@"弹幕发送失败， error = %@",error.localizedDescription);
            }
        }];
    }
    
    [MZChatKitManager sendText:text host:host token:token userID:self.playInfo.chat_uid userNickName:[MZBaseUserServer currentUser].nickName userAvatar:[MZBaseUserServer currentUser].avatar isBarrage:isBarrage success:^(MZLongPollDataModel *msgModel) {
        
        NSLog(@"发送成功");
    } failure:^(NSError *error) {
        
        NSLog(@"发送失败");
    }];
    
    [self hideKeyboard];
}

/// 聊天历史纪录里点击用户头像
- (void)historyChatViewUserHeaderClick:(MZLongPollDataModel *)msgModel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatUserHeaderDidClick:)]) {
        [self.delegate chatUserHeaderDidClick:msgModel];
    }
    // 这里不让展示用户头像信息，因为观看者没有权限
    return;
    
    [MZSDKSimpleHud hide];
    [MZSDKBusinessManager getUserBlockStateWithTicketId:self.ticket_id uid:msgModel.userId success:^(id response) {
        [MZSDKSimpleHud hide];
        int state = [[NSString stringWithFormat:@"%@",response[@"state"]] intValue];
        
        MZLiveUserModel *model = [[MZLiveUserModel alloc] init];
        model.uid = msgModel.userId;
        model.nickname = msgModel.userName;
        model.avatar = msgModel.userAvatar;
        model.is_kickOut = NO;//固定设置未踢出
        model.is_banned = state == 1 ? NO : YES;
        
        [self tipUserMessageViewWithUserModel:model];

    } failure:^(NSError *error) {
        [MZSDKSimpleHud hide];
        [self show:error.domain];
    }];
}

// 红包点击
- (void)redPackageClick:(MZLongPollDataModel *)msgModel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(redPackageClick:)]) {
        [self.delegate redPackageClick:msgModel];
    }
}

-(void)tipUserMessageViewWithUserModel:(MZLiveUserModel *)user
{
    WeaklySelf(weakSelf);
    MZWatchHeaderMessageView *headerMessageView = [[MZWatchHeaderMessageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    headerMessageView.isMySelf = NO;
    if ([user.uid isEqualToString:self.playInfo.chat_uid]) {
        headerMessageView.isMySelf = YES;
        [self show:@"点击了自己头像"];
        return;
    }
    
    headerMessageView.otherUserInfoModel = user;
    [headerMessageView showWithView:self action:^(HeadViewActionType actionType) {
        if(actionType == HeadViewActionTypeBlock || actionType == HeadViewActionTypeKick){
            weakSelf.tipView = [[MZUserTipView alloc]initWithFrame:CGRectMake(0, 0, weakSelf.width, weakSelf.height)];
            weakSelf.tipView.isKickOut = actionType == HeadViewActionTypeKick ? YES : NO;
            weakSelf.tipView.otherUser = user;
            __weak typeof(weakSelf.tipView)weakTipView = weakSelf.tipView;
            weakSelf.tipView.userTipBlock = ^(MZUserTipType type) {
                if(type == MZUserTipTypeCancel){
                    [weakTipView removeFromSuperview];
                }else if(type == MZUserTipTypeBanned){
                    [weakSelf banedOrUnBannedUserWithModel:user isBanned:YES];
                }else if(type == MZUserTipTypeUnBanned){
                    [weakSelf banedOrUnBannedUserWithModel:user isBanned:NO];
                }else if(type == MZUserTipTypeKickOut){
                    [weakSelf kickOutOrUnKickOutUserWithModel:user isKickOut:YES];
                }else if(type == MZUserTipTypeUnKickOut){
                    [weakSelf kickOutOrUnKickOutUserWithModel:user isKickOut:NO];
                }
            };
            [weakSelf addSubview:self.tipView];
        }
    }];
}

/// 踢出请求 - 这里后续改成踢出接口
-(void)kickOutOrUnKickOutUserWithModel:(MZLiveUserModel *)user isKickOut:(BOOL)isKickOut
{
    [MZSDKSimpleHud show];
    [MZSDKBusinessManager kickoutUserWithTicketId:self.playInfo.ticket_id channelId:self.playInfo.channel_id uid:user.uid isKickout:isKickOut success:^(id response) {
        [MZSDKSimpleHud hide];
        [self show:isKickOut ? @"踢出成功":@"解除踢出成功"];
        [self.tipView removeFromSuperview];
    } failure:^(NSError *error) {
        [MZSDKSimpleHud hide];
        [self show:error.domain];
    }];
}

/// 禁言请求
-(void)banedOrUnBannedUserWithModel:(MZLiveUserModel *)user isBanned:(BOOL)isBanned
{
    [MZSDKSimpleHud show];
    [MZSDKBusinessManager bannedOrUnBannedUserWithTicketId:self.playInfo.ticket_id uid:user.uid isBanned:isBanned success:^(id response) {
        [MZSDKSimpleHud hide];
        [self show:isBanned ? @"禁言成功":@"解禁成功"];
        [self.tipView removeFromSuperview];
    } failure:^(NSError *error) {
        [MZSDKSimpleHud hide];
        [self show:error.domain];
    }];
}

/// 展示键盘
- (void)showKeyboard {
    _hideKeyBoardBtn.hidden = NO;
    self.chatToolBar.hidden = NO;
    [self.chatToolBar.msgTextView becomeFirstResponder];
    [self addSubview:_chatToolBar];
}

/// 隐藏键盘
- (void)hideKeyboard {
    WeaklySelf(weakSelf);
    [_chatToolBar endEditing:YES];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        weakSelf.chatToolBar.hidden = YES;
        weakSelf.hideKeyBoardBtn.hidden = YES;
    });
}

#pragma mark - ObserveValueForKeyPath
/// 监听self的frame的更改，所以要在父类中更改该view的frame
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:kViewFramePath]){
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey]CGRectValue];
        if (frame.size.width < frame.size.height) {
            if (_chatToolBar == nil) {
                [self addSubview:self.hideKeyBoardBtn];
                
                _chatToolBar = [[MZMessageToolView alloc] initWithFrame:CGRectMake(0, MZTotalScreenHeight - [MZMessageToolView defaultHeight],  MZ_SW, [MZMessageToolView defaultHeight]) type:MZMessageToolBarTypeAllBtn isShowHostButton:YES];
                _chatToolBar.maxLength = 100;
                _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
                _chatToolBar.delegate = self;
                _chatToolBar.isBarrage = self.isCanBarrage;
                _chatToolBar.hidden = YES;
                [self addSubview:_chatToolBar];
                
                // 监听 只看主播 按钮的状态
                WeaklySelf(weakSelf);
                [_chatToolBar listenOnlyHostState:^(BOOL isOnlyHostMessage) {
                    [weakSelf.chatView updateOnlyHostState:isOnlyHostMessage];
                }];
            }
        }
    }
}

#pragma mark - 播放相关功能和逻辑
/// 通过活动ID请求视频播放详情
- (void)playVideoWithLiveIDString:(NSString *)ticket_id {
    self.ticket_id = ticket_id;
    //    获取播放信息
    [MZSDKBusinessManager reqPlayInfo:ticket_id success:^(MZMoviePlayerModel *responseObject) {
        
        NSLog(@"%@",responseObject);
        self.playInfo = responseObject;
        if(responseObject.isShowVideoBeforeAD){
            self.openScreenView = [[MZOpenScreenView alloc]initializationADViewWithTicketID:responseObject.ticket_id delegate:self];
            [KeyWindow addSubview:self.openScreenView];

//            self.openScreenView = [[MZOpenScreenView alloc]initializationADViewWithImageUrlArray:@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607326730404&di=b01bad44f9e64381e0be926971402f8b&imgtype=0&src=http%3A%2F%2Fdiy.qqjay.com%2Fu%2Ffiles%2F2012%2F0217%2Fb693a3b6d232ffe861da22287c888729.jpg"] showTime:5 delegate:self];
//            [KeyWindow addSubview:self.openScreenView];
            MZOpenScreenDataModel *model = [self.openScreenView getOpenScreenADData];
            NSLog(@"%@",model);
        }else{
            [self initPlayer];
        }
        //    获取主播信息
        [MZSDKBusinessManager reqHostInfo:ticket_id success:^(MZHostModel *responseObject) {
            // 更新主播信息
            self.hostModel = responseObject;
            [self updateHostInfo:self.hostModel];
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateHostUserInfo:)]) {
                [self.delegate updateHostUserInfo:self.hostModel];
            }
            self.chatView.hostModel = self.hostModel;
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self show:error.domain];
        }];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self show:error.domain];
    }] ;
}

- (void)initChat {
    if (self.chatKitManager) {
        [self.chatKitManager closeLongPoll];
        [self.chatKitManager closeSocketIO];
        self.chatKitManager.delegate = nil;
        self.chatKitManager = nil;
    }
    self.chatKitManager = [[MZChatKitManager alloc] init];
    self.chatKitManager.delegate = self;
    
    [self.chatKitManager startTimelyChar:self.playInfo.ticket_id receive_url:self.playInfo.chat_config.receive_url srv:self.playInfo.msg_config.msg_online_srv token:self.playInfo.msg_config.msg_token];
}

-(void)initPlayer{
    // 设置 历史记录是否隐藏
    self.chatView.isHideChatHistory = self.playInfo.isHideChatHistory;
    
    self.chatView.activity = self.playInfo;
    
    /// 设置封面
    if (self.playInfo.cover.length) {
        [self.playerView showPreviewImage:self.playInfo.cover];
    }
    
    //            @property (nonatomic, assign) int user_status;// 用户状态 1:正常 2:被踢出 3:禁言
    self.bottomTalkBtn.isBanned = self.playInfo.user_status == 1 ? NO : YES;
    if (self.playInfo.user_status == 2) {//被踢出
        [[UIApplication sharedApplication].keyWindow show:@"您已被踢出"];
        [[self getCurrentVC].navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.playInfo.user_status == 1) {//正常
        [self show:@"状态：正常"];
    } else if (self.playInfo.user_status == 2) {//被踢出
        [self show:@"状态：被踢出"];
    } else if (self.playInfo.user_status == 3) {//禁言
        [self show:@"状态：禁言"];
    }
    
    self.isCanBarrage = self.playInfo.isBarrage;
    self.isChat = self.playInfo.isChat;
    self.isRecordScreen = self.playInfo.isRecord_screen;
    
    // 加载商品总个数
    [MZGoodsListPresenter getGoodsListCountWithTicket_id:self.ticket_id finished:^(MZGoodsListOuterModel * _Nullable goodsListOuterModel) {
        self.totalNum = goodsListOuterModel.total;
        self.goodsNumLabel.text = [NSString stringWithFormat:@"%d",goodsListOuterModel.total];
        
        self.goodsNumLabel.hidden = !goodsListOuterModel.total;
        
        if(goodsListOuterModel.list.count == 0){
            self.chatView.frame = CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 198*MZ_RATE);
        }else{
            self.chatView.frame = CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 130*MZ_RATE);
        }
        [self tipGoodAnimationWithGoodsListArr:goodsListOuterModel.list];
    }];
    
    // 播放视频
    [self playerVideoWithURLString:self.playInfo.video.url];
    
    // 设置人气缓存
    self.popularityNum = [self.playInfo.popular longLongValue];
    // 更新主播UI
    [self updateUIWithPlayInfo];
    
    // 非语音直播
    if (self.playInfo.live_type != 1) {
        if ([self.audioAnimationView isAnimationPlaying]) {
            [self.audioAnimationView stop];
        }
        [self.audioAnimationView removeFromSuperview];
        self.audioAnimationView = nil;
    }
    
    // 加载聊天SDK
    [self performSelector:@selector(initChat) withObject:nil afterDelay:1];
    
    // 获取前50位观众信息
    [MZAudienceView getOnlineUsersWithTicket_id:self.ticket_id chat_idOfMe:self.playInfo.chat_uid finished:^(NSArray<MZOnlineUserListModel *> *onlineUsers) {
        [self updateUIWithOnlineUsers:onlineUsers];
        
        __block BOOL isHaveMe = NO;
        [onlineUsers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MZOnlineUserListModel *onlineUser = (MZOnlineUserListModel *)obj;
            if ([onlineUser.uid isEqualToString:self.playInfo.chat_uid]) {
                isHaveMe = YES;
                *stop = YES;
            }
        }];
        
        if (onlineUsers.count < 50) {//在线人数低于50人的处理
            self.onlineUsersTotalCount = isHaveMe ? (int)onlineUsers.count : (int)onlineUsers.count + 1;
        } else {//在线人数高于50人的处理
            self.onlineUsersTotalCount = [self.playInfo.webinar_onlines intValue] + 1;
        }
        [self.liveAudienceHeaderView updateOnlineUserTotalCount:self.onlineUsersTotalCount];
    } failed:^(NSString *errorString) {
        NSLog(@"获取前50名观众信息出错");
    }];
    
    // 添加公告
    if (self.playInfo.notice.notice_content.length) {
        [self.chatView addNotice:self.playInfo.notice.notice_content];
    } else {
        [self.chatView addNotice:@"依法对直播内容进行24小时巡查，禁止传播暴力血腥、低俗色情、招嫖诈骗、非法政治活动等违法信息，坚决维护社会文明健康环境"];
    }
    
    // 请求活动配置信息
    [MZSDKBusinessManager getWebinarToolsList:self.playInfo.ticket_id success:^(id response) {
        NSDictionary *data = response[@"data"];
        NSArray *tools = data[@"tools"];
        if (tools.count) {//这个数组里是活动的所有配置开关项，这里我们就只摘出来 点赞开关/礼物开关/倍速开关 的配置
            //是否显示点赞按钮配置/是否显示礼物按钮配置/是否显示倍速按钮配置
            NSString *open_like = @"open_like"; NSString *pay_gift = @"pay_gift"; NSString *times_speed = @"times_speed"; NSString *bonus = @"bonus";
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tools == %@ or tools == %@ or tools == %@ or tools == %@",open_like,pay_gift,times_speed,bonus];
            NSArray *predicateArray = [tools filteredArrayUsingPredicate:predicate];
            for (NSDictionary *dict in predicateArray) {
                if ([[dict objectForKey:@"tools"] isEqualToString:open_like]) {
                    self.isShowPraiseView = [[dict objectForKey:@"is_open"] boolValue];
                } else if ([[dict objectForKey:@"tools"] isEqualToString:pay_gift]) {
                    self.isShowGiftView = [[dict objectForKey:@"is_open"] boolValue];
                } else if ([[dict objectForKey:@"tools"] isEqualToString:times_speed]) {
                    self.isShowTimesSpeedView = [[dict objectForKey:@"is_open"] boolValue];
                } else if ([[dict objectForKey:@"tools"] isEqualToString:bonus]) {
                    self.isShowRedPackageButton = [[dict objectForKey:@"is_open"] boolValue];
                }
            }
            [self setNeedsLayout];
            if (self.playInfo.status != 2) {//非回放状态下强制隐藏倍速按钮
                self.isShowTimesSpeedView = NO;
            }
            [self.playerView setPlayRateButtonIsHidden:!self.isShowTimesSpeedView];
        }
    } failure:^(NSError *error) {
        NSLog(@"请求配置出错");
    }];
    
    // 配置右侧菜单列表
    self.isShowPrize = self.playInfo.isShowPrize;
    self.isShowSign = self.playInfo.isShowSign;
    self.isShowVote = self.playInfo.isShowVote;
    
    if (!_signButton && !_voteButton && !_prizeButton) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (self.superview == NO) {
                sleep(1);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIView *marketingMenusView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 64*MZ_RATE, 120*MZ_RATE, 44*MZ_RATE, 350*MZ_RATE)];
                marketingMenusView.backgroundColor = [UIColor clearColor];
                [self addSubview:marketingMenusView];
                
                [marketingMenusView addSubview:self.signButton];
                [marketingMenusView addSubview:self.voteButton];
                [marketingMenusView addSubview:self.prizeButton];
                
                [self.signButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(marketingMenusView);
                    make.left.equalTo(@0);
                    make.width.equalTo(@(44*MZ_RATE));
                    make.height.equalTo(@(54*MZ_RATE));
                }];
                
                [self.voteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.signButton.mas_bottom);
                    make.left.width.equalTo(self.signButton);
                    make.height.equalTo(@(54*MZ_RATE));
                }];
                
                [self.prizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.voteButton.mas_bottom);
                    make.left.width.equalTo(self.voteButton);
                    make.height.equalTo(@(54*MZ_RATE));
                }];
                
                [self updateMarketingMenusView];
                
            });
        });
    }
    
    // 设置 签到
    self.isSignIn = self.playInfo.signInfo.is_sign;
    [self updateSignButtonStatus];
        
    if (self.playInfo.signInfo.is_sign == NO && self.playInfo.signInfo.is_force) {//如果未签到 && 是强制签到        //获取是否已经进入过强制签到的活动
        NSString *signFirstKey = [NSString stringWithFormat:@"%@%@%d",self.playInfo.unique_id,self.playInfo.ticket_id,self.playInfo.signInfo.sign_id];
        int isFirst = [[[NSUserDefaults standardUserDefaults] objectForKey:signFirstKey] intValue];
        if (isFirst == 1) {//这是第二次以后的进入强制签到的直播间,直接弹出强制签到
            [self signButtonClick];
        } else { //第一次进入强制签到的活动，延迟展示
            [self performSelector:@selector(signButtonClick) withObject:nil afterDelay:(self.playInfo.signInfo.delay_time*60)];
        }
    }
    
    [self updateMarketingMenusView];
}

/// 播放 直播/回放
- (void)playerVideoWithURLString:(NSString *)videoString {
    
    MZMediaPlayerView *view = (MZMediaPlayerView *)[self.playerBackgroundView viewWithTag:186];
    if (view) [view removeFromSuperview];
    
    self.playerView.tag = 186;
    
    int videoStatus = 1;//默认直播
    if (self.playInfo) {
        videoStatus = self.playInfo.status;
    }
    
    [self.playerView playWithURLString:videoString isLive:(videoStatus == 2 ? NO : YES) showView:self.playerBackgroundView delegate:self interfaceOrientation:MZMediaControlInterfaceOrientationMaskPortrait movieModel:MZMPMovieScalingModeAspectFill];
    [self.playerBackgroundView sendSubviewToBack:self.playerView];
    
    [self.playerView startPlayer];
    
    // 设置是否后台播放
    self.isBackgroundPlay = YES;
    [self.playerView.playerManager setPauseInBackground:!self.isBackgroundPlay];
    
    [self preventRecordScreenLabelIsShow:self.isRecordScreen];
    
    [self.unusualTipView setHidden:YES];
    
    if (videoStatus == 2) {//回放显示投屏和倍速
        [self.playerView setPlayRateButtonIsHidden:NO];
        [self.playerView setDLNAButtonIsHidden:NO];
    } else {// 直播只显示投屏，隐藏倍速
        [self.playerView setPlayRateButtonIsHidden:YES];
        [self.playerView setDLNAButtonIsHidden:(videoStatus == 0 ? YES : NO)];//未开播隐藏，开播显示
        if (self.playInfo.status == 3) {//断流状态
            if (!self.unusualTipView) {
                self.unusualTipView = [[self creatUnusualTipView] roundChangeWithRadius:4];
                self.unusualTipView.frame = self.playerBackgroundView.frame;
                [self addSubview:self.unusualTipView];
            }
            [self.unusualTipView setHidden:NO];
        }
    }
    
    // 设置控制栏常驻
    [self.playerView updateToolToHideAtDistantFuture];
    // 设置控制栏响应手势事件
    [self.playerView updateReponseTouchEvent:YES];
    
}

/// 播放本地视频(暂时不使用，只是用于测试)
- (void)playVideoWithLocalMVURLString:(NSString *)mvURLString {
    [self playerVideoWithURLString:mvURLString];
}

/// 更新整体右侧菜单列表的是否展示UI
- (void)updateMarketingMenusView {
    if (self.isShowSignLocation == NO || self.isShowSign == NO) {//强制隐藏签到按钮 或者 控制台隐藏签到按钮
        [self.signButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } else {//展示签到按钮
        [self.signButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(54*MZ_RATE));
        }];
    }
    
    if (self.isShowVoteLocation == NO || self.isShowVote == NO) {//强制隐藏投票按钮 或者 控制台隐藏投票按钮
        [self.voteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } else {//展示投票按钮
        [self.voteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(54*MZ_RATE));
        }];
    }
    
    if (self.isShowPrizeLocation == NO || self.isShowPrize == NO) {//强制隐藏抽奖按钮 或者 控制台隐藏抽奖按钮
        [self.prizeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } else {//展示抽奖按钮
        [self.prizeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(54*MZ_RATE));
        }];
    }
}

/// 置空投票按钮
- (void)hideVoteView {
    self.voteView = nil;
}

/// 更新签到按钮的状态
- (void)updateSignButtonStatus {
    if (self.isSignIn) {
        [self.signButton setImage:[UIImage imageNamed:signInImageName] forState:UIControlStateNormal];
    } else {
        [self.signButton setImage:[UIImage imageNamed:signImageName] forState:UIControlStateNormal];
    }
}

/// 签到按钮点击
- (void)signButtonClick {
    // 移除延迟弹窗的逻辑
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(signButtonClick) object:nil];
    // 显示签到页面
    [self.signView showSignView:self.playInfo.signInfo.access_url];
    // 记录展示过签到界面了
    NSString *signFirstKey = [NSString stringWithFormat:@"%@%@%d",self.playInfo.unique_id,self.playInfo.ticket_id,self.playInfo.signInfo.sign_id];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:signFirstKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 投票按钮点击
- (void)voteButtonClick:(UIButton *)sender {
    [self.voteView showWithChannelId:self.playInfo.channel_id ticketId:self.playInfo.ticket_id];
}

/// 抽奖按钮点击
- (void)prizeButtonClick{
    WeaklySelf(weakSelf);
    // 移除延迟弹窗的逻辑
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(prizeButtonClick) object:nil];
    // 显示抽奖页面
    [self.prizeFuctionWebView showWebView:self.playInfo.prizeInfo.access_url];
    [self.prizeFuctionWebView addScriptMessageWithScriptArr:@[@"goModifyAddress",@"finishActivity"] callBackBlock:^(NSString * _Nullable methodName) {
        if([methodName isEqualToString:@"goModifyAddress"]){
            [weakSelf.prizeFuctionWebView showWebView:weakSelf.playInfo.prizeInfo.prize_modify_address];
            
        }else if ([methodName isEqualToString:@"finishActivity"]){
            [weakSelf.prizeFuctionWebView showWebView:weakSelf.playInfo.prizeInfo.access_url];
        }
    }];
}

#pragma mark MZVideoOpenADViewProtocol

// 点击图片的回调
/// @param link 图片对应的连接
- (void)videoOpenADViewTapImageLink:(NSString *)link {
    if(link.length == 0){
        
    }else{
        //[self.openScreenView closeTheOpenADViewNOCallBack];
        //这里跳相应的链接。若返回播放器，需要再次调用initPlayer才能播放
    }

}
- (void)ADScrollViewLoadImagesSuccess {//图片全部加载完成
    
}

- (void)ADScrollViewLoadImagesFailure {//图片全部加载失败
    
}
//点击关闭
- (void)videoOpenADViewClose {
    [self initPlayer];
}
//返回数据回调
- (void)ADOpenScreenDataIsReadyWithSuccessData:(id)data modelData:(MZOpenScreenDataModel *)modelData error:(NSError *)error{
    NSLog(@"%@ %@ %@",data,modelData,error);
}

#pragma mark - MZDLNAViewDelegate
/// 投屏成功开始播放
- (void)dlnaStartPlay {
    WeaklySelf(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playerView hideMediaControl];
        [self.playerView pausePlayer];
        if (!self.DLNAPlayingView) {
            self.DLNAPlayingView = [[MZDLNAPlayingView alloc] initWithFrame:self.playerBackgroundView.frame];
            self.DLNAPlayingView.playingTitleLabel.text = @"投屏";
            self.DLNAPlayingView.controlBlock = ^(MZDLNAControlType type) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (type == MZDLNAControlTypeExit) {
                        [weakSelf.DLNAPlayingView setHidden:YES];
                        
                        [weakSelf.DLNAView stopDLNA];
                        [weakSelf.playerView startPlayer];
                    } else if (type == MZDLNAControlTypeChange) {
                        [weakSelf showDLNASearthView];
                    }
                });
            };
            [self insertSubview:self.DLNAPlayingView aboveSubview:self.playerBackgroundView];
            [self.playerBackgroundView bringSubviewToFront:self.chatView];
        }
        [self.DLNAPlayingView setHidden:NO];
    });
}

/// 点击了投屏帮助按钮
- (void)helpButtonDidClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DLNAHelpClick)]) {
        [self.delegate DLNAHelpClick];
    }
}

/// 点击空白或者取消投屏调用的方法
- (void)dlnaViewExit {
    self.DLNAView = nil;
}

#pragma mark - MZPlaybackRateDelegate
/// 倍速选择回调 播放倍速的值 e.g. 0.75/1/1.25/1.5/2
- (void)playbackRateChangedWithIndex:(MZPlayBackRate)rate rateValue:(CGFloat)rateValue {    
    if (_selectedRate != rate) {
        _selectedRate = rate;
        
        self.playerView.playerManager.playbackRate = rateValue;
        
        [self.playerView setPlayBackRateButtonImage:[UIImage imageNamed:[NSString stringWithFormat:@"MZPlayerSDK.bundle/mz_playRate_%@",@[@"075",@"1",@"125",@"15",@"2"][_selectedRate]]]];
        
        // 统计play事件(切换倍速)
        if (self.playerView.playerManager.isPlaying) {
            [self sendPlayEvent];
        }
        
        [self sendChangeSpeedEvent];
    }
}

/// 退出倍速选择界面
- (void)playbackRateViewExit {
    self.rateView = nil;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length > 0){
        _chatToolBar.msgTextView.centerPlaceHolderLable.hidden = YES;
    }else{
        _chatToolBar.msgTextView.centerPlaceHolderLable.hidden = NO;
    }
}

#pragma mark - MZMultiMenuDelegate
/// 多菜单点击回调
- (void)multiMenuClick:(MultiMenuClick)menu {
    [self multiButtonClick];
    switch (menu) {
        case MultiMenuClick_report: {//反馈
            if (self.delegate && [self.delegate respondsToSelector:@selector(reportButtonDidClick:)]) {
                [self.delegate reportButtonDidClick:self.playInfo];
            }
            break;
        }
        case MultiMenuClick_showBarrage: {//显示弹幕
            self.isShowBarrage = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(barrageShow:)]) {
                [self.delegate barrageShow:self.playInfo];
            }
            break;
        }
        case MultiMenuClick_hideBarrage: {//隐藏弹幕
            self.isShowBarrage = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(barrageHide:)]) {
                [self.delegate barrageHide:self.playInfo];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - MZChatKitDelegate
/*!
 直播时参会人数发生变化
 */
- (void)activityOnlineNumberdidchange:(NSString * )onlineNo {
    
}

/// 直播时礼物数发生变化
- (void)activityOnlineNumGiftchange:(NSString *)onlineGiftMoney {
    
}

/// 收到一条全局礼物消息
- (void)activityGetGiftMsg:(MZLongPollDataModel *)msg {
    [_chatView addChatData:msg];
}

/// 收到被踢出信息
-(void)activityGetKickoutMsg:(MZLongPollDataModel *)msg {
    NSLog(@"用户id为%@的用户被踢出",msg.data.tickOutUserID);
    if ([self.playInfo.chat_uid isEqualToString:msg.data.tickOutUserID]) {
        self.bottomTalkBtn.isBanned = YES;
        [[UIApplication sharedApplication].keyWindow show:@"您已被踢出"];
        [[self getCurrentVC].navigationController popViewControllerAnimated:YES];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(newMsgForKickoutOneUser:)]) {
        [_delegate newMsgForKickoutOneUser:msg];
    }
}

/// 红包系统，收到一条红包创建消息
-(void)activityGetCreateNewRedPackage:(MZLongPollDataModel *)msg {
    NSLog(@"收到一条红包消息：%@ - %@ - %@ - %@ - %@ - %@",msg.data.slogan, msg.data.amount, msg.data.nickname, msg.data.unique_id, msg.data.bonus_id, msg.data.buyerAvatar);
    [_chatView addChatData:msg];
}

/// 直播时收到一条新消息
- (void)activityGetNewMsg:(MZLongPollDataModel * )msg {
    switch (msg.event) {
        case MsgTypeOnline: {//上线一个用户
            [_chatView addChatData:msg];
            
            // 配置人气
            self.popularityNum ++;
            self.liveManagerHeaderView.numStr = [NSString stringWithFormat:@"%lld",self.popularityNum];
            
            if ([msg.data.is_hidden intValue] == 1) {//机器人不统计在线人数
                return;
            }
            
            if ([msg.userId isEqualToString:self.playInfo.chat_uid]) {//如果是自己的上线通知，不处理
                return;
            }
            
            if (msg.userId.longLongValue <= 5000000000) {
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
                
                // 配置在线总人数
                if (onlineArrayIsHas == NO) {
                    self.onlineUsersTotalCount++;
                }
            }
            
            // 配置在线3位人员资料
            self.liveAudienceHeaderView.userArr = self.onlineUsersArr;

            [self.liveAudienceHeaderView updateOnlineUserTotalCount:self.onlineUsersTotalCount];
            
            break;
        }
        case MsgTypeOffline: {//下线一个用户
            // 如果是自己下线的通知，不处理
            if ([msg.userId isEqualToString:self.playInfo.chat_uid]) {
                return;
            }
            
            // 配置在线总人数
            self.onlineUsersTotalCount--;
            [self.liveAudienceHeaderView updateOnlineUserTotalCount:self.onlineUsersTotalCount];
            
            NSMutableArray *temArr = self.onlineUsersArr.mutableCopy;
            if(temArr.count > 0){
                if(msg.userId.longLongValue <= 5000000000){
                    for (MZOnlineUserListModel *user in temArr) {
                        if([user.uid isEqualToString:msg.userId]){
                            [self.onlineUsersArr removeObject:user];
                            self.liveAudienceHeaderView.userArr = self.onlineUsersArr;
                            break;
                        }
                    }
                }
            }
            
            if (self.onlineUsersTotalCount < 3) {//当总在线人数小于3之后。
                if (self.onlineUsersTotalCount != self.onlineUsersArr.count) {
                    //如果总在线个数和在线用户头像展示的个数不相同，需要更新数据源
                    [MZAudienceView getOnlineUsersWithTicket_id:self.ticket_id chat_idOfMe:self.playInfo.chat_uid finished:^(NSArray<MZOnlineUserListModel *> *onlineUsers) {
                        [self updateUIWithOnlineUsers:onlineUsers];
                    } failed:^(NSString *errorString) {
                        NSLog(@"获取前50名观众信息出错");
                    }];
                }
            } else {//总在线人数大于3
                if (self.onlineUsersArr.count < 3) {
                    //在线用户头像个数小于3，需要更新数据源
                    [MZAudienceView getOnlineUsersWithTicket_id:self.ticket_id chat_idOfMe:self.playInfo.chat_uid finished:^(NSArray<MZOnlineUserListModel *> *onlineUsers) {
                        [self updateUIWithOnlineUsers:onlineUsers];
                    } failed:^(NSString *errorString) {
                        NSLog(@"获取前50名观众信息出错");
                    }];
                }
            }
            
            [_chatView addChatData:msg];
            break;
        }
        case MsgTypeMeChat: case MsgTypeOtherChat:{//聊天消息
            if ([self.playInfo.chat_uid isEqualToString:msg.userId]) {
                msg.event = MsgTypeMeChat;
                return;
            } else {
                [_chatView addChatData:msg];
                if (self.isShowBarrage && self.isCanBarrage) {
                    if (self.chatToolBar.isOnlyHostMessage == NO || [self.chatView.chatApiManager.filterUserIds containsObject:msg.userId] || [self.chatView.chatApiManager.filterUserIds containsObject:msg.data.uniqueID]) {
                        [MZBarrageManager sendBarrageWithMessage:msg.data.msgText userName:msg.userName avatar:msg.userAvatar isMe:NO result:^(BOOL isSuccess, NSError * _Nonnull error) {
                            if (isSuccess) {
                                NSLog(@"弹幕发送成功");
                            } else {
                                NSLog(@"弹幕发送失败， error = %@",error.localizedDescription);
                            }
                        }];
                    }
                }
            }
            break;
        }
        case MsgTypeGoodsUrl: {//推广商品
            MZGoodsListModel *goodsListModel = [MZGoodsListModel creatModelFromMsg:msg];
            if(goodsListModel){
                self.chatView.frame = CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 130*MZ_RATE);
            }
            if(!self.spreadTipGoodsView){
                self.spreadTipGoodsView = [self creatSpreadTipGoodsView];
                self.spreadTipGoodsView.frame = CGRectMake(18*MZ_RATE, self.chatView.frame.origin.y+self.chatView.frame.size.height + 3*MZ_RATE, 175*MZ_RATE, 60*MZ_RATE);
                [self addSubview:self.spreadTipGoodsView];
                [self.spreadTipGoodsView.goodsListModelArr addObject:goodsListModel];
                [self spreadTipGoodsViewDidShow];
            }else{
                self.spreadTipGoodsView.frame=CGRectMake(18*MZ_RATE, self.chatView.frame.origin.y+self.chatView.frame.size.height + 3*MZ_RATE, 175*MZ_RATE, 60*MZ_RATE);
                [self.spreadTipGoodsView.goodsListModelArr addObject:goodsListModel];
                if(self.spreadTipGoodsView.isEnd){
                    [self spreadTipGoodsViewDidShow];
                }
            }
            break;
        }
        case MsgTypeLiveOver: {//主播暂时离开
            if (!self.unusualTipView) {
                self.unusualTipView = [[self creatUnusualTipView] roundChangeWithRadius:4];
                self.unusualTipView.frame = self.playerBackgroundView.frame;
                [self addSubview:self.unusualTipView];
            }
            self.unusualTipView.center = self.center;
            [self.unusualTipView setHidden:NO];
            break;
        }
        case MsgTypeLiveReallyEnd: {//直播结束
            if (!self.realyEndView) {
                self.realyEndView = [[self creatRealyEndView] roundChangeWithRadius:4];
                self.realyEndView.frame = self.playerBackgroundView.frame;
                [self addSubview:self.realyEndView];
                
                CGFloat topSpace = IPHONE_X ? 20 : 0;
                
                UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                closeButton.frame = CGRectMake(MZ_SW - 44*MZ_RATE - 8*MZ_RATE, topSpace + 20*MZ_RATE, 44*MZ_RATE, 44*MZ_RATE);
                [closeButton addTarget:self action:@selector(closeButtonDidclick:) forControlEvents:UIControlEventTouchUpInside];
                [closeButton setImage:ImageName(@"live_close") forState:UIControlStateNormal];
                [self.realyEndView addSubview:closeButton];
            }
            [self playerShutDown];
            [self.realyEndView setHidden:NO];
            break;
        }
        case MsgTypeDisableChat: {//禁言某一个用户
            if(self.playInfo.chat_uid.intValue  == msg.data.disableChatUserID.intValue){
                self.bottomTalkBtn.isBanned = YES;
                [self show:@"您已被禁言"];
            }
            break;
        }
        case MsgTypeAbleChat: {//解禁某一个用户的发言
            if(self.playInfo.chat_uid.intValue  == msg.data.ableChatUserID.intValue){
                self.bottomTalkBtn.isBanned = NO;
                [self show:@"您已解除禁言"];
            }
            break;
        }
        case MsgTypeWebinarFunctionMsg: {//活动配置更改
            for (MZSingleContentModel *model in msg.data.webinar_content) {
                if ([model.type isEqualToString:@"disable_chat"]) {//聊天室是否可以聊天
                    self.isChat = !model.is_open;
                } else if ([model.type isEqualToString:@"barrage"]) {//弹幕是否打开
                    self.isCanBarrage = model.is_open;
                } else if ([model.type isEqualToString:@"record_screen"]) {//防录屏是否开启
                    self.isRecordScreen = model.is_open;
                    [self preventRecordScreenLabelIsShow:self.isRecordScreen];
                } else if ([model.type isEqualToString:@"vote"]) {//是否显示投票
                    self.isShowVote = model.is_open;
                    [self updateMarketingMenusView];
                } else if ([model.type isEqualToString:@"sign"]) {//是否显示签到
#warning - 签到关闭是实时的，开启的话只有重新进入视频才可以
                    self.isShowSign = model.is_open;                    
                    if (self.isShowSign) {
                        self.isShowSign = NO;
                    }
                    [self updateMarketingMenusView];
                } else if ([model.type isEqualToString:@"documents"]) {//是否显示文档
                    self.isShowDocuments = model.is_open;
                }else if([model.type isEqualToString:@"prize"]){//是否显示抽奖
                    self.isShowPrize = model.is_open;
                    [self updateMarketingMenusView];
                }else if([model.type isEqualToString:@"full_screen"]){//是否显示暖场图
                    self.isShowVideoBeforeAD = model.is_open;
                } else if ([model.type isEqualToString:@"pay_gift"]) {//是否显示礼物视图
                    self.isShowGiftView = model.is_open;
                    [self setNeedsLayout];
                } else if ([model.type isEqualToString:@"open_like"]) {//是否显示点赞视图
                    self.isShowPraiseView = model.is_open;
                    [self setNeedsLayout];
                } else if ([model.type isEqualToString:@"times_speed"]) {//是否显示倍速视图
                    self.isShowTimesSpeedView = model.is_open;
                    if (self.playInfo.status != 2) {//非回放状态下强制隐藏倍速按钮
                        self.isShowTimesSpeedView = NO;
                    }
                    [self.playerView setPlayRateButtonIsHidden:!self.isShowTimesSpeedView];

                } else if ([model.type isEqualToString:@"bonus"]){
                    self.isShowRedPackageButton = model.is_open;
                    [self setNeedsLayout];
                } else {
                    NSLog(@"未解析的活动配置更改消息类型 = %@",model.type);
                }
            }
            break;
        }
        case MsgTypeLiveStart: {//开始直播
            [self playerVideoWithURLString:self.playInfo.video.url];
            break;
        }
        case MsgTypeChannelLiveStart: {//频道开启了新的直播
            //    "ticket_id" : 10000537 // 开始直播的ticket id
            if ([msg.data.ticket_id isEqualToString:self.playInfo.ticket_id]) {
                [self playVideoWithLiveIDString:msg.data.ticket_id];
            }
            break;
        }
        case MsgTypeDocSwitchPageMsg: {
            NSLog(@"切换文档地址 - 文档名字 = %@，文档地址 = %@，活动ID = %@",msg.data.file_Name,msg.data.url,msg.data.ticket_id);
            break;
        }
        case MsgTypeDocConfigStatusMsg: {
            NSLog(@"更改文档是否可以下载,这个没用");
            break;
        }
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(newMsgCallback:)]) {
        [self.delegate newMsgCallback:msg];
    }
}

#pragma mark - MZMediaPlayerViewDelegate
/// 播放按钮点击
- (void)playerPlayClick:(BOOL)isPlay {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayClick:)]) {
        [self.delegate playerPlayClick:isPlay];
    }
    
    // 统计播放暂停的事件
    if (isPlay) {
        [self sendPlayEvent];
    } else {
        [self sendEndEvent];
    }
}
/// 快进退 进度回调
- (void)playerSeekProgress:(NSTimeInterval)progress {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerSeekProgress:)]) {
        [self.delegate playerSeekProgress:progress];
    }
}
/// 快进退 手势回调
- (void)playerSeekLocation:(float)location {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerSeekLocation:)]) {
        [self.delegate playerSeekLocation:location];
    }
}
/// 声音大小手势回调
- (void)playerVoiceSize:(float)size {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerVoiceSize:)]) {
        [self.delegate playerVoiceSize:size];
    }
}
/// 亮度手势回调
- (void)playerLuminance:(float)luminance {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerLuminance:)]) {
        [self.delegate playerLuminance:luminance];
    }
}

/// 是否显示下方工具栏
- (void)isPlayToolsShow:(BOOL)isShow {
    if (self.playInfo.status == 2) {//是回放格式走这个逻辑
        if (isShow) {
            [self hideBottomMenu];
        } else {
            [self showBottomMenu];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(isPlayToolsShow:)]) {
            [self.delegate isPlayToolsShow:isShow];
        }
    }
}
/// 倍速按钮点击
- (void)playRateButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playRateButtonClick:)]) {
        [self.delegate playRateButtonClick:sender];
    }
    [self playbackRateBtnClick];
}
/// 投屏按钮点击
- (void)dlnaButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dlnaButtonClick:)]) {
        [self.delegate dlnaButtonClick:sender];
    }
    [self showDLNASearthView];
}

/// 开始播放状态回调
- (void)loadStateDidChange:(MZMPMovieLoadState)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadStateDidChange:)]) {
        [self.delegate loadStateDidChange:type];
    }
}
- (void)connectToPlay {
    if (self.playInfo.status == 2) {
        [self.playerView.playerManager play];
    } else if (self.playInfo.status == 1 || self.playInfo.status == 3) {
        if (self.playInfo.video.url && self.playInfo.video.url.length) {
            [self playerVideoWithURLString:self.playInfo.video.url];
        }
    }
}
/// 播放中状态回调
- (void)moviePlayBackStateDidChange:(MZMPMoviePlaybackState)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayBackStateDidChange:)]) {
        [self.delegate moviePlayBackStateDidChange:type];
    }
    if (type == MZMPMoviePlaybackStateInterrupted) {
        [self show:@"当前网络状态不佳"];
    }
    if (@available(iOS 14.0, *)) {
        if (type == MZMPMoviePlaybackStatePaused) {
            if (self.isEnterBackground && self.playInfo.status == 2) {//进入后台并且是回放
                if (self.isBackgroundPlay) {
                    [self.playerView startPlayer];
                }
            }
        }
    }
}
/// 播放结束状态 包含异常停止
- (void)moviePlayBackDidFinish:(MZMPMovieFinishReason)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayBackDidFinish:)]) {
        [self.delegate moviePlayBackDidFinish:type];
    }
    // 统计end事件
    [self sendEndEvent];
}
/// 准备播放完成
- (void)mediaIsPreparedToPlayDidChange {
    [self barrageIsShow];
    if (self.playInfo.live_type == 1) {//语音直播的话， 播放语音动画
        self.audioAnimationView.hidden = NO;
        if (![self.audioAnimationView isAnimationPlaying]) {
            [self.audioAnimationView play];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaIsPreparedToPlayDidChange)]) {
        [self.delegate mediaIsPreparedToPlayDidChange];
    }
    
}
/// 播放失败
- (void)playerViewFailePlay:(MZMediaPlayerView *)player {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerViewFailePlay:)]) {
        [self.delegate playerViewFailePlay:player];
    }
}

#pragma mark - 统计事件
/// play统计事件
- (void)sendPlayEvent {
    CGFloat speed = 1.0;//直播默认1.0倍速
    if (self.playInfo.status == 2) {//如果是回放，取播放器的倍速
        speed = self.playerView.playerManager.playbackRate;
    }
    [self.chatKitManager sendStatisticsOfPlayEventWithTicket_id:self.ticket_id speed:speed];
}

/// end统计事件
- (void)sendEndEvent {
    [self.chatKitManager sendStatisticsOfEndEventWithTicket_id:self.ticket_id];
}

/// changeSpeed统计事件
- (void)sendChangeSpeedEvent {
    CGFloat speed = 1.0;//直播默认1.0倍速
    if (self.playInfo.status == 2) {//如果是回放，取播放器的倍速
        speed = self.playerView.playerManager.playbackRate;
    }
    [self.chatKitManager sendStatisticsOfChangeSpeedWithTicket_id:self.ticket_id speed:speed];
}

#pragma mark - 懒加载
- (MZPraiseButton *)praiseButton {
    if (!_praiseButton) {
        _isPraise = YES;
        _praiseButton = [MZPraiseButton buttonWithType:UIButtonTypeCustom];
        [_praiseButton setImage:ImageName(@"bottomButton_like") forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(likeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseButton;
}

- (UIButton *)giftButton {
    if (!_giftButton) {
        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftButton setImage:ImageName(@"mz_gift_icon") forState:UIControlStateNormal];
        [_giftButton addTarget:self action:@selector(giftButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftButton;
}

- (UIButton *)redPackageButton {
    if (!_redPackageButton) {
        _redPackageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_redPackageButton setImage:ImageName(@"men_icon_red") forState:UIControlStateNormal];
        [_redPackageButton addTarget:self action:@selector(redPackageButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redPackageButton;
}


- (MZMediaPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[MZMediaPlayerView alloc] init];
        _playerView.mediaPlayerViewDelegate = self;
        [_playerView showPreviewImage:@"https://inews.gtimg.com/newsapp_ls/0/9563866905_294195/0"];
    }
    return _playerView;
}

- (MZGiftView *)giftView {
    if (!_giftView) {
        WeaklySelf(weakSelf);
        _giftView = [[MZGiftView alloc] initWithTicketId:self.ticket_id selectHandler:^(NSString * _Nonnull giftId, int quantity) {
            NSLog(@"模拟礼物去支付，选中的礼物ID = %@，礼物个数= %d",giftId,quantity);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"礼物支付成功,去发送礼物赠送成功的消息");
                [weakSelf.giftView pushGiftMessageWithGiftId:giftId quantity:quantity];
            });
        }];
    }
    return _giftView;
}

- (UIButton *)hideKeyBoardBtn {
    if (!_hideKeyBoardBtn) {
        _hideKeyBoardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MZ_SW, MZTotalScreenHeight)];
        _hideKeyBoardBtn.backgroundColor = [UIColor clearColor];
        [_hideKeyBoardBtn addTarget:self action:@selector(hideKeyBoardBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _hideKeyBoardBtn.hidden = YES;
    }
    return _hideKeyBoardBtn;
}

- (MZAnimationView *)audioAnimationView {
    if (!_audioAnimationView) {
        _audioAnimationView = [MZAnimationView animationNamed:MZ_Audio_AnimationJsonName];
        _audioAnimationView.loopAnimation = YES;
        _audioAnimationView.frame = CGRectMake(0, self.liveManagerHeaderView.bottom + 30.0, self.frame.size.width, 422*(self.frame.size.width/750));
        _audioAnimationView.userInteractionEnabled = NO;
        _audioAnimationView.hidden = YES;
    }
    return _audioAnimationView;
}

- (UIButton *)signButton {
    if (!_signButton) {
        _signButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signButton setImage:[UIImage imageNamed:signImageName] forState:UIControlStateNormal];
        [_signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signButton;
}

- (UIButton *)voteButton {
    if (!_voteButton) {
        _voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voteButton setImage:[UIImage imageNamed:@"mz_toupiao_normal"] forState:UIControlStateNormal];
        [_voteButton addTarget:self action:@selector(voteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voteButton;
}

- (UIButton *)prizeButton{
    if (!_prizeButton) {
        _prizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_prizeButton setImage:[UIImage imageNamed:@"mz_choujiang_menu"] forState:UIControlStateNormal];
        [_prizeButton addTarget:self action:@selector(prizeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prizeButton;
}

- (MZSignView *)signView {
    if (!_signView) {
        WeaklySelf(weakSelf);
        _signView = [[MZSignView alloc] initWithSignInfo:self.playInfo.signInfo closeHandle:^(MZSignMethodType methodType, NSString * _Nonnull message) {
            switch (methodType) {
                case MZSignMethodTypeClose: {
                    NSLog(@"点击了关闭按钮");
                    weakSelf.signView = nil;
                    if (self.playInfo.signInfo.is_force && self.playInfo.signInfo.force_type == 1) {//强制签到 && 不可跳过
                        [weakSelf closeButtonDidclick:nil];
                    }
                    break;
                }
                case MZSignMethodTypeSignIn: {
                    NSLog(@"签到成功");
                    weakSelf.isSignIn = YES;
                    [weakSelf updateSignButtonStatus];
                    weakSelf.signView = nil;
                    break;
                }
                case MZSignMethodTypeLoadStart: {
                    break;
                }
                case MZSignMethodTypeLoadFinish: {
                    break;
                }
                case MZSignMethodTypeLoadFail: {
                    [self show:message];
                    break;
                }
                default:
                    break;
            }
        }];
    }
    return _signView;
}

-(MZFuctionWebView *)prizeFuctionWebView{
    WeaklySelf(weakSelf);
    if(!_prizeFuctionWebView){
        _prizeFuctionWebView = [[MZFuctionWebView alloc]initWithFuctionWebType:MZFuctionWebPrizeType url:@"www.baidu.com" closeHandle:^(MZFuctionMethodWebType methodType, NSString * _Nonnull message) {
            if([message isEqualToString:@"close"]){
                [weakSelf.prizeFuctionWebView removeFromSuperview];
                weakSelf.prizeFuctionWebView = nil;
            }
            
        }];
    }
    return _prizeFuctionWebView;
}

- (MZVoteView *)voteView {
    if (!_voteView) {
        WeaklySelf(weakSelf);
        _voteView = [[MZVoteView alloc] initWithCloseHander:^{
            [weakSelf hideVoteView];
        }];
    }
    return _voteView;
}

@end
