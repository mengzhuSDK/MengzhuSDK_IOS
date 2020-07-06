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
#import "MZDLNAView.h"
#import "MZDLNAPlayingView.h"
#import "MZMoviePlayerPlaybackRateView.h"
#import "MZSmallPlayerView.h"
#import "MZAudienceView.h"
#import <MZPlayerSDK/MZPreventRecordScreenLabel.h>

#define kViewFramePath      @"frame"

typedef void(^GoodsDataCallback)(MZGoodsListOuterModel *model);

@interface MZVerticalPlayerView()<MZMessageToolBarDelegate,UITextViewDelegate,MZChatKitDelegate,MZGoodsRequestProtocol,MZHistoryChatViewProtocol,MZMultiMenuDelegate,MZMediaPlayerViewToolDelegate,MZMediaPlayerViewPlayDelegate,MZDLNAViewDelegate,MZPlaybackRateDelegate>

@property (nonatomic, strong) UIView *playerBackgroundView;//播放器上盖的一层View，用于承载各模块view

@property (nonatomic, strong) MZMoviePlayerModel *playInfo;//视频播放详情Model
@property (nonatomic, strong) MZHostModel *hostModel;//主播信息
@property (nonatomic, assign) long long popularityNum;//人气

@property (nonatomic, strong) MZLiveAudienceHeaderView *liveAudienceHeaderView;//右上角观众view
@property (nonatomic, strong) NSMutableArray *onlineUsersArr;//上线人数数据源

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

@property (nonatomic, strong) NSMutableArray *goodsListArr;//商品共用的数据源
@property (nonatomic, strong) MZGoodsListView *goodsListView;//商品View
@property (nonatomic, strong) MZTipGoodsView *circleTipGoodsView;//循环播放的弹出商品view
@property (nonatomic, strong) MZTipGoodsView *spreadTipGoodsView;//推广的弹出view
@property (nonatomic, assign) int goodsOffset;//商品偏移量
@property (nonatomic, assign) int totalNum;//商品总个数

@property (nonatomic, strong) MZChatKitManager *chatKitManager;//聊天句柄

@property (nonatomic, strong) MZMoviePlayerPlaybackRateView *rateView;//倍速选择播放的view
@property (nonatomic, assign) NSInteger selectedRate;//默认倍速索引
@property (nonatomic, strong) UIButton *playRateButton;//倍速播放按钮

@property (nonatomic, strong) UIButton *dlnaButton;//投屏按钮
@property (nonatomic, strong) MZDLNAPlayingView *DLNAPlayingView;//投屏中展示的View
@property (nonatomic, strong) MZDLNAView *DLNAView;//选择投屏的View

@property (nonatomic, strong) UIView *barrageBackgroundView;//承载弹幕的view，只有竖屏播放器才有，适配弹幕位置

@property (nonatomic, assign) BOOL isChat;//聊天室是否可以聊天,默认可以
@property (nonatomic, assign) BOOL isRecordScreen;//是否开启防录屏，默认不开启
@property (nonatomic, assign) BOOL isCanBarrage;//是否可以发弹幕，默认可以
@property (nonatomic, assign) BOOL isShowBarrage;//是否显示弹幕，默认可以

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
}

- (void)createTopView {
    self.isPraise = YES;
    WeaklySelf(weakself);
    CGFloat topSpace = IPHONE_X ? 20 : 0;
    self.liveManagerHeaderView = [[MZPlayManagerHeaderView alloc]initWithFrame:CGRectMake(12*MZ_RATE,topSpace + 22*MZ_RATE, 172*MZ_RATE, 40*MZ_RATE)];
    [self addSubview:self.liveManagerHeaderView];
    
    self.liveManagerHeaderView.clickBlock = ^{
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(avatarDidClick:)]) {
            [weakself.delegate avatarDidClick:weakself.playInfo];
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
    UIStackView *stackContainerView = [[UIStackView alloc] initWithFrame:CGRectMake(207 * MZ_RATE, MZTotalScreenHeight-(44+bottomSpace)*MZ_RATE, 156*MZ_RATE, 44 *MZ_RATE)];
    self.stackContainerView = stackContainerView;
    
    stackContainerView.axis = UILayoutConstraintAxisHorizontal;
    stackContainerView.alignment = UIStackViewAlignmentFill;
    stackContainerView.spacing = 12 *MZ_RATE;
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
            [weakSelf showTextView:weakSelf message:@"你已被禁言"];
        }else{
            if (weakSelf.isChat) {
                [weakSelf showKeyboard];
            } else {
                [weakSelf showTextView:weakSelf message:@"管理员已开启禁言功能"];
            }
        }
    };

    [self addSubview:self.dlnaButton];
    [self addSubview:self.playRateButton];
}

- (void)setupChatView {
    self.chatView = [[MZHistoryChatView alloc]initWithFrame:CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 130*MZ_RATE)];
    self.chatView.chatDelegate =self;
    [self addSubview:self.chatView];
    
    //将弹出菜单放到muqianself的最顶部
    [self bringSubviewToFront:self.multiMenu];
}


#pragma mark - 本类方法
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
        [self addSubview:self.circleTipGoodsView];
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

/// 加载商品列表
- (void)loadGoodsList:(int)offset limit:(int)limit callback:(GoodsDataCallback)callback {
    [MZSDKBusinessManager reqGoodsList:self.ticket_id offset:offset limit:limit success:^(id responseObject) {
        MZGoodsListOuterModel *goodsListOuterModel = (MZGoodsListOuterModel *)responseObject;
        if([goodsListOuterModel.list count]!=0&&self.goodsListArr&&[self.goodsListArr count]>0&&offset>self.goodsOffset){
            [self.goodsListArr addObjectsFromArray:goodsListOuterModel.list];
            self.goodsOffset=offset;
        }else {
            if(offset>self.goodsOffset){
                
            }else{
                self.goodsListArr  = goodsListOuterModel.list;
            }
        }
        self.totalNum = goodsListOuterModel.total;
        if(goodsListOuterModel.list.count % 50 > 0){
            [self.goodsListView.goodTabView.MZ_footer endRefreshingWithNoMoreData];
        }
        
        NSLog(@"-goodsListOuterModel %lu",[goodsListOuterModel.list count]);
        NSLog(@"+goodsListArr %lu",[self.goodsListArr count]);
        self.goodsNumLabel.text = [NSString stringWithFormat:@"%d",goodsListOuterModel.total];
        if(goodsListOuterModel.total==0){
            self.goodsNumLabel.hidden=YES;
        }else{
            self.goodsNumLabel.hidden=NO;
        }
        if(self.goodsListArr.count == 0){
            self.chatView.frame = CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 198*MZ_RATE);
        }else{
            self.chatView.frame = CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 130*MZ_RATE);
        }
        if(callback){
            callback(goodsListOuterModel);
        }
        
        [self tipGoodAnimationWithGoodsListArr:self.goodsListArr];
        
    } failure:^(NSError *error) {
        [self.goodsListView.goodTabView.MZ_header endRefreshing];
        [self.goodsListView.goodTabView.MZ_footer endRefreshing];
        NSLog(@"");
    }];
}

/// 请求加载商品列表
- (void)requestGoodsList:(GoodsDataResult)block offset:(int)offset {
    WeaklySelf(weakSelf);
    [self loadGoodsList:offset limit:50 callback:^(MZGoodsListOuterModel *model) {
        if(model.list.count == 0){
            if(offset == 0){
                [self.goodsListView.goodTabView.MZ_header endRefreshing];
                [self.goodsListView.goodTabView.MZ_footer endRefreshingWithNoMoreData];
            }else{
                [self.goodsListView.goodTabView.MZ_header endRefreshing];
                [self.goodsListView.goodTabView.MZ_footer endRefreshingWithNoMoreData];
            }
        }
        if(weakSelf.goodsListView&&weakSelf.goodsListView.dataArr){
            weakSelf.goodsListView.dataArr=weakSelf.goodsListArr;
        }
        if(weakSelf.goodsListArr.count % 50 > 0){
            [self.goodsListView.goodTabView.MZ_footer endRefreshingWithNoMoreData];
        }else{
            [self.goodsListView.goodTabView.MZ_footer endRefreshing];
        }
        [self.goodsListView.goodTabView.MZ_header endRefreshing];
        if(block){
            block(model);
        }
    }];
}

/// 观众列表展示
- (void)creatAudienceWinView {
    MZAudienceView * audienceView = [[MZAudienceView alloc] initWithFrame:self.bounds];
    
    [audienceView showWithView:self withJoinTotal:(int)self.onlineUsersArr.count];
    
    __weak typeof(self)weakSelf = self;
    [audienceView setUserList:self.onlineUsersArr withChannelId:self.playInfo.channel_id ticket_id:self.playInfo.ticket_id selectUserHandle:^(MZOnlineUserListModel *model) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onlineListButtonDidClick:)]) {
            [weakSelf.delegate onlineListButtonDidClick:model];
        }
    }];
}

/// 添加/删除防录屏
- (void)preventRecordScreenLabelIsShow:(BOOL)isShow {
    if (isShow) [MZPreventRecordScreenLabel showRandomLabelWithShowView:self.playerBackgroundView text:@"自定义的防录屏文字"];
    else [MZPreventRecordScreenLabel hideRandomLabel];
}

/// 显示投屏选择view
- (void)showDLNASearthView {
    WeaklySelf(weakSelf);
    if ([MZGlobalTools IsEnableWIFI]) {
        if(!self.DLNAView){
            self.DLNAView = [[MZDLNAView alloc]initWithFrame:CGRectMake(0, 0, MZScreenWidth, MZScreenHeight)];
            self.DLNAView.delegate = self;
            self.DLNAView.DLNAString = self.playInfo.video.http_url ? self.playInfo.video.http_url : self.playInfo.video.url;
            
            self.DLNAView.helpClickBlock = ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DLNAHelpClick)]) {
                    [weakSelf.delegate DLNAHelpClick];
                }
            };
        }
        [self addSubview:self.DLNAView];
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.DLNAView.fuctionView.frame = CGRectMake(0, MZScreenHeight- 278*MZ_RATE, MZScreenWidth, 278*MZ_RATE);
        } completion:nil];
    } else {
        [self showTextView:self message:@"非Wifi情况下无法投屏"];
    }
}

/// 显示倍速选择view
- (void)playbackRateBtnClick {
    _rateView = [[MZMoviePlayerPlaybackRateView alloc] initRatePlayWithIndex:_selectedRate];
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
    self.liveManagerHeaderView.isLive = self.playInfo.status == 2 ? NO : YES;
    
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
/// 发送消息(这里我暂时写成弹幕消息接受的代理，回头要改一下消息工具的原代码)
- (void)didSendText:(NSString *)text userName:(NSString *)userName joinID:(NSString *)joinID isBarrage:(BOOL)isBarrage {
    if([MZUserServer currentUser].userId.length == 0){
        [self showTextView:self.superview message:@"您还未登录"];
        [self hideKeyboard];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerNotLogin)]) {
            [self.delegate playerNotLogin];
        }
        return;
    }
    if ([MZGlobalTools isBlankString:text]) {
        [self hideKeyboard];
        return;
    }
    NSString * host = [NSString stringWithFormat:@"%@?",self.playInfo.chat_config.pub_url];
    NSString * token = self.playInfo.msg_config.msg_token;
    MZLongPollDataModel*msgModel = [[MZLongPollDataModel alloc] init];
    msgModel.userId = [MZUserServer currentUser].userId;
    msgModel.userName = [MZUserServer currentUser].nickName;
    msgModel.userAvatar = [MZUserServer currentUser].avatar;
    msgModel.event = MsgTypeMeChat;
    MZActMsg *actMsg = [[MZActMsg alloc] init];
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
    
    [MZChatKitManager sendText:text host:host token:token userID:[MZUserServer currentUser].userId userNickName:[MZUserServer currentUser].nickName userAvatar:[MZUserServer currentUser].avatar isBarrage:isBarrage success:^(MZLongPollDataModel *msgModel) {
        
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

#pragma mark - 视频播放
/// 播放 直播/回放
- (void)playerVideoWithURLString:(NSString *)videoString {
    
    MZMediaPlayerView *view = (MZMediaPlayerView *)[self.playerBackgroundView viewWithTag:186];
    if (view) [view removeFromSuperview];
        
    self.playerView.tag = 186;
    
    int videoStatus = 1;//默认直播
    if (self.playInfo) {
        videoStatus = self.playInfo.status;
    }
    
    [self.playerView playWithURLString:videoString isLive:(videoStatus == 2 ? NO : YES) showView:self.playerBackgroundView delegate:self interfaceOrientation:MZMediaControlInterfaceOrientationMaskPortrait movieModel:MZMPMovieScalingModeFill];
    [self.playerBackgroundView sendSubviewToBack:self.playerView];

    [self.playerView startPlayer];
    [self.playerView.playerManager setPauseInBackground:NO];
        
    [self preventRecordScreenLabelIsShow:self.isRecordScreen];
    
    [self.unusualTipView setHidden:YES];
    
    // 设置竖屏全屏下的右侧向内偏移（新版播放控制栏才有效）
    if (videoStatus == 2) {
        [self.playerView portraitRightToInset:54*2];
    } else {
        [self.playerView portraitRightToInset:54];
    }
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
            [weakSelf showTextView:weakSelf message:@"sdk验证失败"];
        });
    }];
}

#pragma mark - 获取播放信息
/// 通过活动ID请求视频播放详情
- (void)playVideoWithLiveIDString:(NSString *)ticket_id {
    self.ticket_id = ticket_id;
    WeaklySelf(weakSelf);
    [[MZSDKInitManager sharedManager]initSDK:^(id responseObject) {
        //    获取播放信息
        [MZSDKBusinessManager reqPlayInfo:ticket_id success:^(MZMoviePlayerModel *responseObject) {
            //        http://vod.t.zmengzhu.com/record/base/hls-sd/a954304bb6482c3c00083250.m3u8
            NSLog(@"%@",responseObject);
            self.playInfo = responseObject;
            self.chatView.activity = self.playInfo;
            
            /// 设置封面
            if (self.playInfo.cover.length) {
                [self.playerView showPreviewImage:self.playInfo.cover];
            }

            // 判断是否被禁言
            self.bottomTalkBtn.isBanned = self.playInfo.user_status == 1? NO : YES;
            
            self.isCanBarrage = self.playInfo.isBarrage;
            self.isChat = self.playInfo.isChat;
            self.isRecordScreen = self.playInfo.isRecord_screen;
            
            // 加载商品列表
            [self loadGoodsList:0 limit:50 callback:nil];
            
            // 播放视频
            [self playerVideoWithURLString:responseObject.video.url];
            
            // 设置人气缓存
            self.popularityNum = [self.playInfo.popular longLongValue];
            // 更新主播UI
            [self updateUIWithPlayInfo];
            
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
            
            //    获取在线人数
            [MZSDKBusinessManager reqGetUserList:ticket_id offset:0 limit:0 success:^(NSArray* responseObject) {
                NSMutableArray *tempArr = responseObject.mutableCopy;
                
                BOOL isHasMe = NO;
                for (MZOnlineUserListModel* model in responseObject) {
                    if(model.uid.longLongValue > 5000000000){//uid大于五十亿是游客
                        [tempArr removeObject:model];
                    }
                    if ([model.uid isEqualToString:self.playInfo.chat_uid]) {
                        isHasMe = YES;
                    }
                }
                
                if (isHasMe == NO) {
                    MZOnlineUserListModel *meModel = [[MZOnlineUserListModel alloc] init];
                    
                    MZUser *user = [MZUserServer currentUser];
                    
                    meModel.nickname = user.nickName;
                    meModel.avatar = user.avatar;
                    meModel.uid = self.playInfo.chat_uid;
                    
                    [tempArr addObject:meModel];
                }
                
                // 更新在线人数UI
                [self updateUIWithOnlineUsers:tempArr];
            } failure:^(NSError *error) {
                NSLog(@"error %@",error);
            }];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }] ;
        

        
        //    获取主播信息
        [MZSDKBusinessManager reqHostInfo:ticket_id success:^(MZHostModel *responseObject) {
            // 更新主播信息
            self.hostModel = responseObject;
            [self updateHostInfo:self.hostModel];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    } failure:^(NSError *error) {
        [weakSelf showTextView:weakSelf message:@"sdk验证失败"];
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
            self.DLNAPlayingView.title = @"投屏";
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

#pragma mark - MZPlaybackRateDelegate
/// 倍速选择回调
- (void)playbackRateChangedWithIndex:(NSInteger)index {
    [self.rateView dismiss];
    self.rateView = nil;
    
    if (_selectedRate != index) {
        _selectedRate = index;
        
        NSArray *rateArray = @[@"0.75",@"1",@"1.25",@"1.5",@"2"];
        
        if (_selectedRate >= rateArray.count || _selectedRate < 0) {
            _selectedRate = 1;
        }
        
        self.playerView.playerManager.playbackRate = [rateArray[_selectedRate] floatValue];
        
        [self.playRateButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mz_playRate_%@",@[@"075",@"1",@"125",@"15",@"2"][_selectedRate]]] forState:UIControlStateNormal];
    }
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

/*!
 直播时收到一条新消息
 */
- (void)activityGetNewMsg:(MZLongPollDataModel * )msg {
    switch (msg.event) {
        case MsgTypeOnline: {//上线一个用户
            [_chatView addChatData:msg];
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
            
            // 配置在线
            self.liveAudienceHeaderView.userArr = self.onlineUsersArr;
            
            // 配置人气
            self.popularityNum ++;
            self.liveManagerHeaderView.numStr = [NSString stringWithFormat:@"%lld",self.popularityNum];
            break;
        }
        case MsgTypeOffline: {//下线一个用户
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
            MZGoodsListModel *goodsListModel = [[MZGoodsListModel alloc]init];
            goodsListModel.id = msg.data.goods_id;
            goodsListModel.name = msg.data.name;
            goodsListModel.type = msg.data.goods_type;
            goodsListModel.price = msg.data.price;
            goodsListModel.pic = msg.data.pic;
            goodsListModel.buy_url = msg.data.url;
            if(goodsListModel){
                self.chatView.frame = CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 130*MZ_RATE);
            }
            if(!self.spreadTipGoodsView){
                self.spreadTipGoodsView = [[MZTipGoodsView alloc]initWithFrame:CGRectMake(18*MZ_RATE, self.chatView.frame.origin.y+self.chatView.frame.size.height + 3*MZ_RATE, 175*MZ_RATE, 60*MZ_RATE)];
                self.spreadTipGoodsView.alpha = 0;
                self.spreadTipGoodsView.goodsListModelArr = [NSMutableArray array];
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
                self.unusualTipView = [[[UILabel alloc]initWithFrame:self.playerBackgroundView.frame] roundChangeWithRadius:4];
                self.unusualTipView.backgroundColor = MakeColorRGBA(0x000000, 0.6);
                self.unusualTipView.textAlignment = NSTextAlignmentCenter;
                self.unusualTipView.textColor = MakeColorRGB(0xffffff);
                self.unusualTipView.font = [UIFont systemFontOfSize:20*MZ_RATE];
                self.unusualTipView.text = @"主播暂时离开，\n稍等一下马上回来";
                self.unusualTipView.numberOfLines = 2;
                [self addSubview:self.unusualTipView];
            }
            self.unusualTipView.center = self.center;
            break;
        }
        case MsgTypeLiveReallyEnd: {//直播结束
            if (!self.realyEndView) {
                self.realyEndView = [[[UILabel alloc]initWithFrame:self.playerBackgroundView.frame] roundChangeWithRadius:4];
                self.realyEndView.backgroundColor = MakeColorRGBA(0x000000, 0.6);
                self.realyEndView.textAlignment = NSTextAlignmentCenter;
                self.realyEndView.textColor = MakeColorRGB(0xffffff);
                self.realyEndView.font = [UIFont systemFontOfSize:20*MZ_RATE];
                self.realyEndView.text = @"直播已结束";
                self.realyEndView.numberOfLines = 1;
                self.realyEndView.userInteractionEnabled = YES;
                [self addSubview:self.realyEndView];
                [self.realyEndView setHidden:YES];
                
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
                if ([model.type isEqualToString:@"disable_chat"]) {
                    self.isChat = !model.is_open;
                } else if ([model.type isEqualToString:@"barrage"]) {
                    self.isCanBarrage = model.is_open;
                } else if ([model.type isEqualToString:@"record_screen"]) {
                    self.isRecordScreen = model.is_open;
                    [self preventRecordScreenLabelIsShow:self.isRecordScreen];
                }
            }
            break;
        }
        case MsgTypeLiveStart: {//开始直播
            [self playerVideoWithURLString:self.playInfo.video.url];
            break;
        }
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(newMsgCallback:)]) {
        [self.delegate newMsgCallback:msg];
    }
}

#pragma mark - MZMediaPlayerViewToolDelegate
/// 播放按钮点击
- (void)playerPlayClick:(BOOL)isPlay {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayClick:)]) {
        [self.delegate playerPlayClick:isPlay];
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
        self.dlnaButton.hidden = !isShow;
        self.playRateButton.hidden = !isShow;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(isPlayToolsShow:)]) {
            [self.delegate isPlayToolsShow:isShow];
        }
    }
}

#pragma mark - MZMediaPlayerViewPlayDelegate
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
        [self showTextView:self message:@"当前网络状态不佳"];
    }
}
/// 播放结束状态 包含异常停止
- (void)moviePlayBackDidFinish:(MZMPMovieFinishReason)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayBackDidFinish:)]) {
        [self.delegate moviePlayBackDidFinish:type];
    }
}
/// 准备播放完成
- (void)mediaIsPreparedToPlayDidChange {
    [self barrageIsShow];

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

- (MZMediaPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[MZMediaPlayerView alloc] init];
        _playerView.playDelegate = self;
        _playerView.toolDelegate = self;
        [_playerView showPreviewImage:@"https://inews.gtimg.com/newsapp_ls/0/9563866905_294195/0"];
    }
    return _playerView;
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


- (UIButton *)playRateButton {
    if (!_playRateButton) {
        _playRateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playRateButton setImage:[UIImage imageNamed:@"mz_playRate_1"] forState:UIControlStateNormal];
        [_playRateButton addTarget:self action:@selector(playbackRateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_playRateButton setHidden:YES];
        _playRateButton.frame = CGRectMake(self.width - 44.0, self.height - (IPHONE_X ? 34.0 : 0) - 44.0, 44.0, 44.0);
    }
    return _playRateButton;
}

- (UIButton *)dlnaButton {
    if (!_dlnaButton) {
        _dlnaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dlnaButton setImage:[UIImage imageNamed:@"mz_dlna"] forState:UIControlStateNormal];
        [_dlnaButton addTarget:self action:@selector(showDLNASearthView) forControlEvents:UIControlEventTouchUpInside];
        [_dlnaButton setHidden:YES];
        _dlnaButton.frame = CGRectMake(self.width - 44.0 - 44.0, self.height - (IPHONE_X ? 34.0 : 0) - 44.0, 44.0, 44.0);
    }
    return _dlnaButton;
}

@end
