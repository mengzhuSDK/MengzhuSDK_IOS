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

#define kViewFramePath      @"frame"

typedef void(^GoodsDataCallback)(MZGoodsListOuterModel *model);

@interface MZVerticalPlayerView()<MZMessageToolBarDelegate,UITextViewDelegate,MZChatKitDelegate,MZGoodsRequestProtocol,MZHistoryChatViewProtocol,MZMultiMenuDelegate,MZMediaPlayerViewDelegate,MZDLNAViewDelegate,MZPlaybackRateDelegate>

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

@property (nonatomic, assign) BOOL isShowVote;//是否显示投票
@property (nonatomic, assign) BOOL isShowSign;//是否显示签到
@property (nonatomic, assign) BOOL isShowDocuments;//是否显示文档

@property (nonatomic, strong) MZAnimationView *audioAnimationView;//静音直播的动画展示

@end

@implementation MZVerticalPlayerView

- (void)dealloc {
    self.delegate = nil;
    [self removeObserver:self forKeyPath:kViewFramePath];
    [MZSmallPlayerView hide];
    NSLog(@"竖屏播放器界面释放");
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.selectedRate = 1;

        self.isChat = YES;
        self.isRecordScreen = NO;
        self.isCanBarrage = YES;
        self.isShowBarrage = YES;
        
        self.isShowVote = NO;//默认不展示投票
        self.isShowSign = NO;//默认不展示签到
        self.isShowDocuments = NO;//默认不展示文档
        
        [self customAddSubviews];
        [self addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 聊天框
    CGRect toolBarFrame = _chatToolBar.frame;
    toolBarFrame.size.width = self.frame.size.width;
    _chatToolBar.frame = toolBarFrame;
    
    // 隐藏按钮的frame
    _hideKeyBoardBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
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
    UIStackView *stackContainerView = [[UIStackView alloc] initWithFrame:CGRectMake(191 * MZ_RATE, MZTotalScreenHeight-(44+bottomSpace)*MZ_RATE, 178*MZ_RATE, 44 *MZ_RATE)];
    self.stackContainerView = stackContainerView;
    
    stackContainerView.axis = UILayoutConstraintAxisHorizontal;
    stackContainerView.alignment = UIStackViewAlignmentFill;
    stackContainerView.spacing = 3 *MZ_RATE;
    stackContainerView.distribution = UIStackViewDistributionFillEqually;
    [self addSubview:stackContainerView];
    
    CGRect commonRect = CGRectMake(0, 0, 44 *MZ_RATE, 44*MZ_RATE);
    
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
    
    self.bottomTalkBtn = [[MZBottomTalkBtn alloc]initWithFrame:CGRectMake(shoppingBagButton.right + 14*MZ_RATE, shoppingBagButton.top, 120*MZ_RATE, 44*MZ_RATE)];
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
    
    //将弹出菜单放到muqianself的最顶部
    [self bringSubviewToFront:self.multiMenu];
}


#pragma mark - 本类方法
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonDidClick:)]) {
        [self.delegate closeButtonDidClick:self.playInfo];
    }
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
        MZGoodsListOuterModel *goodsListOuterModel = (MZGoodsListOuterModel *)responseObject;
        
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
    MZAudienceView *audienceView = [[MZAudienceView alloc] initWithFrame:self.bounds ticket_id:self.playInfo.ticket_id chat_idOfMe:self.playInfo.chat_uid selectUserHandle:^(MZOnlineUserListModel *userModel) {
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
    if (isShow) [MZPreventRecordScreenLabel showRandomLabelWithShowView:self.playerBackgroundView text:@"自定义的防录屏文字"];
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

                _chatToolBar = [[MZMessageToolView alloc] initWithFrame:CGRectMake(0, MZTotalScreenHeight - [MZMessageToolView defaultHeight],  MZ_SW, [MZMessageToolView defaultHeight]) type:MZMessageToolBarTypeAllBtn];
                _chatToolBar.maxLength = 100;
                _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
                _chatToolBar.delegate = self;
                _chatToolBar.isBarrage = self.isCanBarrage;
                _chatToolBar.hidden = YES;
                [self addSubview:_chatToolBar];
            }
        }
    }
}

#pragma mark - 播放相关功能和逻辑
/// 通过活动ID请求视频播放详情
- (void)playVideoWithLiveIDString:(NSString *)ticket_id {
    self.ticket_id = ticket_id;
    [[MZSDKInitManager sharedManager]initSDK:^(id responseObject) {
        //    获取播放信息
        [MZSDKBusinessManager reqPlayInfo:ticket_id success:^(MZMoviePlayerModel *responseObject) {
            //        http://vod.t.zmengzhu.com/record/base/hls-sd/a954304bb6482c3c00083250.m3u8
            NSLog(@"%@",responseObject);
            self.playInfo = responseObject;
            
            // 设置 历史记录是否隐藏
            self.chatView.isHideChatHistory = self.playInfo.isHideChatHistory;
            
            self.chatView.activity = self.playInfo;
                        
            /// 设置封面
            if (self.playInfo.cover.length) {
                [self.playerView showPreviewImage:self.playInfo.cover];
            }
            
//            @property (nonatomic, assign) int user_status;// 用户状态 1:正常 2:被踢出 3:禁言
            self.bottomTalkBtn.isBanned = self.playInfo.user_status == 1 ? NO : YES;
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
            [self playerVideoWithURLString:responseObject.video.url];
            
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
            if (self.chatKitManager) {
                [self.chatKitManager closeLongPoll];
                [self.chatKitManager closeSocketIO];
                self.chatKitManager.delegate = nil;
                self.chatKitManager = nil;
            }
            self.chatKitManager = [[MZChatKitManager alloc] init];
            self.chatKitManager.delegate = self;
            
            [self.chatKitManager startTimelyChar:self.playInfo.ticket_id receive_url:self.playInfo.chat_config.receive_url srv:self.playInfo.msg_config.msg_online_srv token:self.playInfo.msg_config.msg_token];
            
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
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }] ;
        
        //    获取主播信息
        [MZSDKBusinessManager reqHostInfo:ticket_id success:^(MZHostModel *responseObject) {
            // 更新主播信息
            self.hostModel = responseObject;
            [self updateHostInfo:self.hostModel];
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateHostUserInfo:)]) {
                [self.delegate updateHostUserInfo:self.hostModel];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    } failure:^(NSError *error) {
        [self show:@"sdk验证失败"];
    }];
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
    
    [self.playerView playWithURLString:videoString isLive:(videoStatus == 2 ? NO : YES) showView:self.playerBackgroundView delegate:self interfaceOrientation:MZMediaControlInterfaceOrientationMaskPortrait movieModel:MZMPMovieScalingModeAspectFit];
    [self.playerBackgroundView sendSubviewToBack:self.playerView];

    [self.playerView startPlayer];
    [self.playerView.playerManager setPauseInBackground:NO];
        
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
    WeaklySelf(weakSelf);
    [[MZSDKInitManager sharedManager] initSDK:^(id responseObject) {
        NSLog(@"sdk验证成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf playerVideoWithURLString:mvURLString];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf playerVideoWithURLString:mvURLString];
            [self show:@"sdk验证失败"];
        });
    }];
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
        [self show:@"您已被踢出"];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(newMsgForKickoutOneUser:)]) {
        [_delegate newMsgForKickoutOneUser:msg];
    }
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
            }
            
            // 配置在线3位人员资料
            self.liveAudienceHeaderView.userArr = self.onlineUsersArr;
            // 配置在线总人数
            self.onlineUsersTotalCount++;
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
                    [MZBarrageManager sendBarrageWithMessage:msg.data.msgText userName:msg.userName avatar:msg.userAvatar isMe:NO result:^(BOOL isSuccess, NSError * _Nonnull error) {
                        if (isSuccess) {
                            NSLog(@"弹幕发送成功");
                        } else {
                            NSLog(@"弹幕发送失败， error = %@",error.localizedDescription);
                        }
                    }];
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
            }
            break;
        }
        case MsgTypeAbleChat: {//解禁某一个用户的发言
            if(self.playInfo.chat_uid.intValue  == msg.data.ableChatUserID.intValue){
                self.bottomTalkBtn.isBanned = NO;
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
                 } else if ([model.type isEqualToString:@"sign"]) {//是否显示签到
#warning - 签到关闭是实时的，开启的话只有重新进入视频才可以
                     self.isShowVote = model.is_open;
                 } else if ([model.type isEqualToString:@"documents"]) {//是否显示文档
                     self.isShowDocuments = model.is_open;
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
        case MsgTypeKickout: {//踢出用户
            // "user_id": "1111", // 用户ID
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
/// 播放中状态回调
- (void)moviePlayBackStateDidChange:(MZMPMoviePlaybackState)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayBackStateDidChange:)]) {
        [self.delegate moviePlayBackStateDidChange:type];
    }
    if (type == MZMPMoviePlaybackStateInterrupted) {
        [self show:@"当前网络状态不佳"];
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

@end
