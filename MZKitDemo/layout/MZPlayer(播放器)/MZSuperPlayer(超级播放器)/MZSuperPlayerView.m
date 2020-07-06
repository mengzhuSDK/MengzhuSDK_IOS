//
//  MZSuperPlayerView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/8.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZSuperPlayerView.h"
#import "MZSimpleHud.h"

#import "MZHistoryChatView.h"
#import "MZMessageToolView.h"

#import "MZGoodsListView.h"
#import "MZLiveAudienceHeaderView.h"
#import "MZAudienceView.h"
#import "MZTipGoodsView.h"

#import "MZPraiseButton.h"
#import "MZBagButton.h"
#import "MZBottomTalkBtn.h"

#import "MZDLNAView.h"
#import "MZDLNAPlayingView.h"
#import "MZMoviePlayerPlaybackRateView.h"
#import "MZSmallPlayerView.h"
#import "MZMultiMenu.h"
#import "MZActivityMenu.h"
#import <MZPlayerSDK/MZPreventRecordScreenLabel.h>

#define kViewFramePath      @"frame"

typedef void(^GoodsDataCallback)(MZGoodsListOuterModel *model);

@interface MZSuperPlayerView()<MZChatKitDelegate,MZMessageToolBarDelegate,MZGoodsRequestProtocol,MZHistoryChatViewProtocol,MZPlaybackRateDelegate,MZMediaPlayerViewPlayDelegate,MZMediaPlayerViewToolDelegate,MZDLNAViewDelegate,MZMultiMenuDelegate,MZActivityMenuDelegate>
@property (nonatomic, strong) UIButton *playCloseButton;//关闭按钮

@property (nonatomic, assign) BOOL isLandSpace;//横竖屏记录,默认竖屏

@property (nonatomic, assign) CGFloat relativeSafeTop;//顶部安全高度（适配横屏和竖屏）
@property (nonatomic, assign) CGFloat relativeSafeBottom;//底部安全高度（适配横屏和竖屏）
@property (nonatomic, assign) CGFloat relativeSafeLeft;//左部安全高度（适配横屏和竖屏）
@property (nonatomic, assign) CGFloat relativeSafeRate;//放大缩小比例（适配横屏和竖屏）

@property (nonatomic, strong) UIView *playerBackgroundView;//播放器的背景view

@property (nonatomic, strong) MZMoviePlayerModel *playInfo;//视频播放详情Model
@property (nonatomic, strong) MZHostModel *hostModel;//主播信息
@property (nonatomic, assign) long long popularityNum;//人气值

@property (nonatomic, strong) MZGoodsListView *goodsListView;//商品列表的view
@property (nonatomic, strong) NSMutableArray *goodsListArr;//商品列表数组
@property (nonatomic, assign) int goodsOffset;//商品请求偏移记录
@property (nonatomic, strong) UIView *tipGoodsBackgroundView;//循环播放的view的背景View
@property (nonatomic, strong) MZTipGoodsView *circleTipGoodsView;//循环播放的弹出商品view
@property (nonatomic, strong) MZTipGoodsView *spreadTipGoodsView;//推广的循环播放的弹出商品view

@property (nonatomic, strong) MZHistoryChatView *chatView;//聊天view
@property (nonatomic, strong) MZBottomTalkBtn *bottomTalkBtn;//聊天框
@property (nonatomic, strong) MZMessageToolView *chatToolBar;//聊天工具栏
@property (nonatomic, strong) MZChatKitManager *chatKitManager;//聊天Kit

@property (nonatomic, strong) MZLiveAudienceHeaderView *liveAudienceHeaderView;//右上角观众view
@property (nonatomic, strong) NSMutableArray *onlineUsersArr;//在线人数列表

@property (nonatomic, strong) UILabel *unusualTipView;//主播中途离开的提示
@property (nonatomic, strong) UILabel *realyEndView;//直播结束的提示

@property (nonatomic, assign) BOOL isPraise;//点赞过滤
@property (nonatomic, strong) MZPraiseButton *praiseButton;//点赞按钮
@property (nonatomic, strong) MZTimer *timer;//持续点赞定时器

@property (nonatomic, strong) UIButton *hideKeyBoardBtn;//隐藏键盘按钮
@property (nonatomic, strong) UIButton *shareBtn;//分享按钮
@property (nonatomic, strong) MZBagButton *shoppingBagButton;//商品袋按钮

@property (nonatomic, strong) MZMoviePlayerPlaybackRateView *rateView;//倍速选择播放的view
@property (nonatomic, assign) NSInteger selectedRate;//默认倍速索引
@property (nonatomic, strong) UIView *dlnaAndRateLayer;//倍速播放按钮和投屏按钮的背景layer
@property (nonatomic, strong) UIButton *playRateButton;//倍速播放按钮

@property (nonatomic, strong) UIButton *dlnaButton;//投屏按钮
@property (nonatomic, strong) MZDLNAPlayingView *DLNAPlayingView;//投屏中展示的View
@property (nonatomic, strong) MZDLNAView *DLNAView;//选择投屏的View

@property (nonatomic, strong) UIButton *multiButton;//多菜单按钮
@property (nonatomic, strong) MZMultiMenu *multiMenu;//多功能菜单View

@property (nonatomic, strong) MZActivityMenu *activityMenu;//活动的自定义菜单

@property (nonatomic, assign) BOOL isChat;//聊天室是否可以聊天,默认可以
@property (nonatomic, assign) BOOL isRecordScreen;//是否开启防录屏，默认不开启
@property (nonatomic, assign) BOOL isCanBarrage;//是否可以发弹幕，默认可以
@property (nonatomic, assign) BOOL isShowBarrage;//是否显示弹幕，默认可以

@end

@implementation MZSuperPlayerView

- (void)dealloc {
    self.delegate = nil;
    [self removeObserver:self forKeyPath:kViewFramePath];
    [MZSmallPlayerView hide];
    NSLog(@"播放器界面释放");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isLandSpace) {
        NSLog(@"横屏");
        self.relativeSafeTop = 0;
        self.relativeSafeLeft = IPHONE_X ? 44.0 : 0;
        self.relativeSafeBottom = IPHONE_X ? 10: 5;
        self.relativeSafeRate = MZ_FULL_RATE;
        
        // 播放view
        self.playerBackgroundView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        self.playerView.frame = self.playerBackgroundView.bounds;
        self.playerView.preview.frame = self.playerView.bounds;
        
        if (_activityMenu) [_activityMenu hideAllMenu];
        self.playerView.isFullScreen = YES;
        [self.dlnaAndRateLayer setHidden:YES];//阴影
                
        // 退出按钮
        [self.playCloseButton setSelected:YES];
        self.playCloseButton.frame = CGRectMake(self.right - 12*self.relativeSafeRate - 40*self.relativeSafeRate, self.relativeSafeTop+15*self.relativeSafeRate, 40*self.relativeSafeRate, 40.0*self.relativeSafeRate);

        CGFloat button_safeBottom = 0;
        if (IPHONE_X) button_safeBottom = 15;
        
        // 倍速播放按钮
        self.playRateButton.frame = CGRectMake(self.right - 6*self.relativeSafeRate - [MZMessageToolView defaultHeight], self.height - [MZMessageToolView defaultHeight] - button_safeBottom, [MZMessageToolView defaultHeight], [MZMessageToolView defaultHeight]);
        
        // 投屏按钮
        self.dlnaButton.frame = CGRectMake(self.playRateButton.frame.origin.x - 2*self.relativeSafeRate - [MZMessageToolView defaultHeight], self.playRateButton.frame.origin.y, [MZMessageToolView defaultHeight], [MZMessageToolView defaultHeight]);
        
        // 主播暂时离开提示
        if (self.unusualTipView) {
            self.unusualTipView.text = @"主播暂时离开，稍等一下马上回来";
        }
        
    } else {
        NSLog(@"竖屏");
        self.relativeSafeTop = IPHONE_X ? 44.0 : 20;
        self.relativeSafeLeft = 0;
        self.relativeSafeBottom = IPHONE_X ? 34: 0;
        self.relativeSafeRate = MZ_RATE;
        
        // 播放view
        self.playerBackgroundView.frame = CGRectMake(0, self.relativeSafeTop + 30 * self.relativeSafeRate + 40*self.relativeSafeRate, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width/16*9);
        self.playerView.frame = self.playerBackgroundView.bounds;
        self.playerView.preview.frame = self.playerView.bounds;
        
        if (_activityMenu) [_activityMenu recoveryMenuView];
        self.playerView.isFullScreen = NO;

        // 退出按钮
        [self.playCloseButton setSelected:NO];
        self.playCloseButton.frame = CGRectMake(self.right - 40*self.relativeSafeRate - 12*self.relativeSafeRate, self.relativeSafeTop+15*self.relativeSafeRate, 40*self.relativeSafeRate, 40.0*self.relativeSafeRate);
        
        if (self.playInfo.status == 1 || self.playInfo.status == 3) {
            // 投屏按钮
            self.dlnaButton.frame = CGRectMake(self.right - 6*self.relativeSafeRate - [MZMessageToolView defaultHeight], self.playerBackgroundView.frame.origin.y + 4*self.relativeSafeRate, [MZMessageToolView defaultHeight], [MZMessageToolView defaultHeight]);
        } else {
            // 倍速按钮
            self.playRateButton.frame = CGRectMake(self.right - 6*self.relativeSafeRate - [MZMessageToolView defaultHeight], self.playerBackgroundView.frame.origin.y + 4*self.relativeSafeRate, [MZMessageToolView defaultHeight], [MZMessageToolView defaultHeight]);
            
            // 投屏按钮
            self.dlnaButton.frame = CGRectMake(self.playRateButton.frame.origin.x - 2*self.relativeSafeRate - [MZMessageToolView defaultHeight], self.playRateButton.frame.origin.y, [MZMessageToolView defaultHeight], [MZMessageToolView defaultHeight]);
        }

        // 主播暂时离开提示
        if (self.unusualTipView) {
            self.unusualTipView.text = @"主播暂时离开，\n稍等一下马上回来";
        }
    }
    
    // 商品袋
    self.shoppingBagButton.frame = CGRectMake(self.relativeSafeLeft+12, self.frame.size.height - self.relativeSafeBottom-(44*self.relativeSafeRate), 44*self.relativeSafeRate, 44*self.relativeSafeRate);
    // 聊天框
    self.bottomTalkBtn.frame = CGRectMake(self.shoppingBagButton.frame.size.width + self.shoppingBagButton.frame.origin.x + 14*self.relativeSafeRate, self.shoppingBagButton.frame.origin.y, 120*self.relativeSafeRate, 44*self.relativeSafeRate);
    // 分享按钮
    self.praiseButton.frame = CGRectMake(self.right - 12*self.relativeSafeRate - 44*self.relativeSafeRate, self.shoppingBagButton.frame.origin.y, 44*self.relativeSafeRate, 44*self.relativeSafeRate);
    // 点赞按钮
    self.shareBtn.frame = CGRectMake(self.praiseButton.left - 12 - 44*self.relativeSafeRate, self.shoppingBagButton.frame.origin.y, 44*self.relativeSafeRate, 44*self.relativeSafeRate);
    // 多菜单按钮
    self.multiButton.frame = CGRectMake(self.shareBtn.left - 12 - 44*self.relativeSafeRate, self.shoppingBagButton.frame.origin.y, 44*self.relativeSafeRate, 44*self.relativeSafeRate);
    // 多菜单View
    self.multiMenu.frame = CGRectMake(self.multiButton.frame.origin.x - 14*self.relativeSafeRate, self.multiButton.frame.origin.y - 78*self.relativeSafeRate - 10, 72*self.relativeSafeRate, 78*self.relativeSafeRate);
    // 主播头像信息
    self.liveManagerHeaderView.frame = CGRectMake(self.relativeSafeLeft+12*self.relativeSafeRate, self.relativeSafeTop+15*self.relativeSafeRate, 172*self.relativeSafeRate, 40*self.relativeSafeRate);
    // 在线列表信息
    self.liveAudienceHeaderView.frame = CGRectMake(self.right - 12*self.relativeSafeRate - 116*self.relativeSafeRate - 30*self.relativeSafeRate, self.relativeSafeTop+15*self.relativeSafeRate+6*self.relativeSafeRate, 116*self.relativeSafeRate, 28*self.relativeSafeRate);
    // 聊天框
    CGRect toolBarFrame = _chatToolBar.frame;
    toolBarFrame.size.width = self.frame.size.width;
    _chatToolBar.frame = toolBarFrame;
    
    // 隐藏按钮的frame
    _hideKeyBoardBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    // 直播结束的label
    self.realyEndView.frame = self.playerBackgroundView.frame;
    self.realyEndView.font = [UIFont systemFontOfSize:20*self.relativeSafeRate];

    // 直播中途离开提示
    self.unusualTipView.frame = self.playerBackgroundView.frame;
    self.unusualTipView.font = [UIFont systemFontOfSize:20*self.relativeSafeRate];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedRate = 1;
        self.isLandSpace = NO;
        self.isChat = YES;
        self.isRecordScreen = NO;
        self.isCanBarrage = YES;
        self.isShowBarrage = YES;
        [self makeView];
    }
    return self;
}

- (void)makeView {
    [self addSubview:self.playerBackgroundView];
    [self addSubview:self.chatView];
    
    // 开启点赞定时器
    self.timer = [MZTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) repeats:YES];

    [self addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
    
    [self createTopView];
    [self createBottomButtons];
    
    // 添加自定义的活动菜单
    [self addSubview:self.activityMenu];
    
    // 添加自定义菜单
    [self addActivityMenu:@"文档" getMenuView:^(UIView * _Nonnull menuView) {
        menuView.backgroundColor = [UIColor blackColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:menuView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"文档内容";
        label.textColor = [UIColor whiteColor];
        [menuView addSubview:label];
        
    }];
    
    // 模拟延迟添加自定义菜单
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addActivityMenu:@"自定义菜单1" getMenuView:^(UIView * _Nonnull menuView) {
            menuView.backgroundColor = [UIColor blackColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:menuView.bounds];
            label.backgroundColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"自定义菜单1";
            label.textColor = [UIColor whiteColor];
            [menuView addSubview:label];
            
        }];
    });

    // 播放菜单上面的背景阴影
    [self addSubview:self.dlnaAndRateLayer];
    // 倍速按钮
    [self addSubview:self.playRateButton];
    // 投屏按钮
    [self addSubview:self.dlnaButton];
    
}

- (void)createTopView {
    WeaklySelf(weakself);
    self.liveManagerHeaderView = [[MZPlayManagerHeaderView alloc] initWithFrame:CGRectZero];
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
    
    self.liveAudienceHeaderView = [[MZLiveAudienceHeaderView alloc]initWithFrame:CGRectZero];
    self.liveAudienceHeaderView.hidden = NO;
    [self addSubview:self.liveAudienceHeaderView];
    
    self.liveAudienceHeaderView.clickBlock = ^{
        [weakself creatAudienceWinView];
    };
    
    [self addSubview:self.playCloseButton];
}

- (void)createBottomButtons {
    [self addSubview:self.shareBtn];
    
    [self addSubview:self.praiseButton];
    
    [self addSubview:self.shoppingBagButton];
    
    [self addSubview:self.bottomTalkBtn];
    
    [self addSubview:self.multiButton];
    [self addSubview:self.multiMenu];
    
    [self addSubview:self.tipGoodsBackgroundView];
}

#pragma mark - 功能模块
/// 单独设置聊天界面的frame和广告frame
- (void)updateChatFrameAndTipGoodBackgroundView:(BOOL)isScroolBottom {
    // 广告的高度
    CGFloat tipGoodBackgroundViewHeight = self.tipGoodsBackgroundView.frame.size.height;
    if (self.goodsListArr.count <= 0) {
        tipGoodBackgroundViewHeight = 0;
        self.tipGoodsBackgroundView.hidden = YES;
    } else {
        self.tipGoodsBackgroundView.hidden = NO;
    }
    
    CGFloat spaceRate = 1;
    CGFloat safeTopHeight = IPHONE_X ? 44.0 : 20;
    CGFloat safeBottomHeight = IPHONE_X ? 34 : 0;
    CGFloat safeLeftHeight = 0;
    CGFloat endHeight = UIScreen.mainScreen.bounds.size.width < UIScreen.mainScreen.bounds.size.height ? UIScreen.mainScreen.bounds.size.height : UIScreen.mainScreen.bounds.size.width;
    CGFloat endWidth = UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height ? UIScreen.mainScreen.bounds.size.height : UIScreen.mainScreen.bounds.size.width;

    if (self.isLandSpace) {
        safeTopHeight = 0;
        safeBottomHeight = IPHONE_X ? 10: 5;
        safeLeftHeight = IPHONE_X ? 44.0 : 0;
        
        endHeight = UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height ? UIScreen.mainScreen.bounds.size.height : UIScreen.mainScreen.bounds.size.width;
        endWidth = UIScreen.mainScreen.bounds.size.width < UIScreen.mainScreen.bounds.size.height ? UIScreen.mainScreen.bounds.size.height : UIScreen.mainScreen.bounds.size.width;

        spaceRate = (endWidth/667) > 1.15 ? 1.15 : (endWidth/667);
        self.tipGoodsBackgroundView.frame = CGRectMake(safeLeftHeight+18*spaceRate, endHeight-safeBottomHeight-44*spaceRate-8*spaceRate - 60*spaceRate, self.tipGoodsBackgroundView.frame.size.width, self.tipGoodsBackgroundView.frame.size.height);
    } else {
        spaceRate = endWidth/375.0;
        self.tipGoodsBackgroundView.frame = CGRectMake(18*spaceRate, endHeight-safeBottomHeight-44*spaceRate-15*spaceRate - 60*spaceRate, self.tipGoodsBackgroundView.frame.size.width, self.tipGoodsBackgroundView.frame.size.height);
    }
    
    // 头像的bottom
    CGFloat liveManagerHeaderViewBottom = safeTopHeight+15*spaceRate+40*spaceRate;
    // 底部商品的按钮的高度
    CGFloat shoppingButtonHeight = 44*spaceRate;
    
    if (self.isLandSpace) {
        self.chatView.frame = CGRectMake(safeLeftHeight, liveManagerHeaderViewBottom + 44*spaceRate + 44*spaceRate, endWidth/2.0, endHeight - liveManagerHeaderViewBottom - 44*spaceRate - safeBottomHeight - 15*spaceRate - shoppingButtonHeight - tipGoodBackgroundViewHeight - 44*spaceRate);
    } else {
        // 互动菜单的bottom
        CGFloat tagMenuBottom = safeTopHeight + endWidth/16*9 + 44*spaceRate + 30*spaceRate + 40*spaceRate;
        
        self.chatView.frame = CGRectMake(0, tagMenuBottom + 44.0*spaceRate, endWidth, endHeight - tagMenuBottom - safeBottomHeight - 18*spaceRate - tipGoodBackgroundViewHeight - shoppingButtonHeight - 44.0*spaceRate);
    }
    if (isScroolBottom) {
        [self.chatView scrollToBottom];
    }
}

/// 点赞定时器
- (void)timerAction {
    [self.praiseButton showPraiseAnimation];
}

/// 播放 - 根据活动ID获取活动数据
- (void)playVideoWithLiveIDString:(NSString *)ticket_id {
    self.ticket_id = ticket_id;
    [self getPlayInfo];
}

/// 播放 - 执行播放操作
- (void)playWithVideoURLString:(NSString *)videoURLString {
    MZMediaPlayerView *view = (MZMediaPlayerView *)[self.playerBackgroundView viewWithTag:186];
    if (view) [view removeFromSuperview];
        
    self.playerView.tag = 186;
    [self.playerView playWithURLString:videoURLString isLive:(self.playInfo.status == 2 ? NO : YES) showView:self.playerBackgroundView delegate:self interfaceOrientation:MZMediaControlInterfaceOrientationMaskAll_new movieModel:MZMPMovieScalingModeAspectFit];
    
    [self.playerView startPlayer];
    [self.playerView.playerManager setPauseInBackground:NO];
        
    [self preventRecordScreenLabelIsShow:self.isRecordScreen];
    
    [self.unusualTipView setHidden:YES];
    
    // 设置横屏下的右侧向内偏移（新版播放控制栏才有效）
    if (self.playInfo.status == 2) {
        [self.playerView landSpaceRightToInset:40*2];
    } else {
        [self.playerView landSpaceRightToInset:40];
    }
}

/// 返回按钮点击
- (void)playCloseButtonClick {
    if (self.playCloseButton.selected) {
        if (self.isLandSpace) {
            [MZSmallPlayerView hide];//横屏下隐藏小屏幕播放
        }
        [self.playerView fullScreen];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonDidClick:)]) {
            [self.delegate closeButtonDidClick:self.playInfo];
        }
        [self playerShutDown];
    }
}

/// 销毁播放器
- (void)playerShutDown {
    [self.chatKitManager closeLongPoll];
    [self.chatKitManager closeSocketIO];
    self.chatKitManager.delegate = nil;
    
    [self.playerView.playerManager shutdown];
    [self.playerView.playerManager didShutdown];
}

/// 更新人气界面
- (void)updateUIWithPlayInfo {
    self.liveManagerHeaderView.isLive = self.playInfo.status == 2 ? NO : YES;
    // 人气值
    self.liveManagerHeaderView.numStr = [NSString stringWithFormat:@"%lld",self.popularityNum];
}

/// 更新在线人头和数字
- (void)updateUIWithOnlineUsers:(NSArray *)onlineUsers {
    if (!onlineUsers) {
        return;
    }
    self.onlineUsersArr = onlineUsers.mutableCopy;
    self.liveAudienceHeaderView.userArr = onlineUsers;
}

/// 推广商品展示
- (void)spreadTipGoodsViewDidShow {
    WeaklySelf(weakSelf);
    [self.spreadTipGoodsView beginAnimation];
    self.circleTipGoodsView.hidden = YES;
    self.spreadTipGoodsView.tipGoodsViewEndBlock = ^{
        weakSelf.circleTipGoodsView.hidden = NO;
        if([weakSelf.goodsListArr count] == 0) {
            [weakSelf updateChatFrameAndTipGoodBackgroundView:NO];
        }
    };
}

/// 更新主播信息
- (void)updateHostInfo:(MZHostModel *)hostModel {
    _hostModel = hostModel;
    
    self.liveManagerHeaderView.title = hostModel.nickname;
    self.liveManagerHeaderView.imageUrl = hostModel.avatar;
}

/// 购物袋点击
- (void)shoppingBagButtonClick {    
    _goodsListView = [[MZGoodsListView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
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

/// 分享按钮点击
- (void)shareButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareButtonDidClick:)]) {
        [self.delegate shareButtonDidClick:self.playInfo];
    }
}

/// 隐藏键盘按钮点击
- (void)hideKeyBoardBtnDidClick:(UIButton *)sender {
    [self hideKeyboard];
}

/// 商品自动动画展示
- (void)tipGoodAnimationWithGoodsListArr:(NSMutableArray *)arr {
    WeaklySelf(weakSelf);
    [self.tipGoodsBackgroundView setHidden:NO];
    
    if(!self.circleTipGoodsView){
        self.circleTipGoodsView = [[MZTipGoodsView alloc] initWithFrame:self.tipGoodsBackgroundView.bounds];

        self.circleTipGoodsView.goodsClickBlock = ^(MZGoodsListModel * _Nonnull model) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(goodsItemDidClick:)]) {
                [weakSelf.delegate goodsItemDidClick:model];
            }
        };
        self.circleTipGoodsView.isCirclePlay = YES;
        self.circleTipGoodsView.alpha = 0;
        
        [self.tipGoodsBackgroundView addSubview:self.circleTipGoodsView];
    }
    [self updateChatFrameAndTipGoodBackgroundView:YES];
    
    self.circleTipGoodsView.goodsListModelArr = arr;
    
    if (!self.circleTipGoodsView.isOpen) {
        [self.circleTipGoodsView beginAnimation];
    } else {
        if ([arr count] == 0) {
            [self.circleTipGoodsView hiddenGoodViewWithModel:nil];
        }
    }
}

/// 观众列表展示
- (void)creatAudienceWinView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onlineListButtonDidClick:)]) {
        [self.delegate onlineListButtonDidClick:self.onlineUsersArr];
    }
    
    MZAudienceView * audienceView = [[MZAudienceView alloc] initWithFrame:self.bounds];
    
    [audienceView showWithView:self withJoinTotal:(int)self.onlineUsersArr.count];
    
    __weak typeof(self)weakSelf = self;
    [audienceView setUserList:self.onlineUsersArr withChannelId:self.playInfo.channel_id ticket_id:self.playInfo.ticket_id selectUserHandle:^(MZOnlineUserListModel *model) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onlineUserInfoDidClick:)]) {
            [weakSelf.delegate onlineUserInfoDidClick:model];
        }
    }];
}

/// 添加/删除防录屏
- (void)preventRecordScreenLabelIsShow:(BOOL)isShow {
    if (isShow) [MZPreventRecordScreenLabel showRandomLabelWithShowView:self.playerBackgroundView text:@"自定义的防录屏文字"];
    else [MZPreventRecordScreenLabel hideRandomLabel];
}

/// 倍速播放点击
- (void)playbackRateBtnClick {
    if (self.isLandSpace) {
        _rateView = [[MZMoviePlayerPlaybackRateView alloc] initLandscapeRatePlayWithIndex:_selectedRate];
    }else{
        _rateView = [[MZMoviePlayerPlaybackRateView alloc] initRatePlayWithIndex:_selectedRate];
    }
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
    if (self.isLandSpace) {
        [self isPlayToolsShow:NO];
    }
    
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
        [MZBarrageManager startWithView:self.playerView.playerManager.view];
    } else {
        [MZBarrageManager destory];
    }
}

/// 展示投屏选择界面
- (void)showDLNASearthView {
    [self toPortraitResult:^{
        WeaklySelf(weakSelf);
        
        if ([MZGlobalTools IsEnableWIFI]) {
            if(!self.DLNAView){
                self.DLNAView = [[MZDLNAView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, MZScreenHeight)];
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
                weakSelf.DLNAView.fuctionView.frame = CGRectMake(0, MZScreenHeight- 278*MZ_RATE, MZ_SW, 278*MZ_RATE);
            } completion:nil];
        } else {
            [self showTextView:self message:@"非Wifi情况下无法投屏"];
        }
    }];
}

/// 底部菜单
- (void)multiButtonClick {
    self.multiButton.selected = !self.multiButton.selected;

    if (self.multiButton.selected) {
        [self.multiMenu setHidden:NO];
    } else {
        [self.multiMenu setHidden:YES];
    }
}

/// 横屏下点击某些按钮需要转换成竖屏的回调方法
- (void)toPortraitResult:(void(^)(void))result {
    if (self.isLandSpace == NO) {
        result();
        return;
    }
    [self.playerView fullScreen];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        result();
    });
}

/// 添加自定义的活动菜单
- (void)addActivityMenu:(NSString *)menu getMenuView:(void(^)(UIView * menuView))getMenuView {
    CGFloat relativeSafeTop = IPHONE_X ? 44.0 : 20;
    
    CGFloat y = relativeSafeTop+30*MZ_RATE+40*MZ_RATE+UIScreen.mainScreen.bounds.size.width/16*9 + 44*MZ_RATE;
    CGFloat height = UIScreen.mainScreen.bounds.size.height - (relativeSafeTop+30*MZ_RATE+40*MZ_RATE+UIScreen.mainScreen.bounds.size.width/16*9 + 44*MZ_RATE);
    
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, y, UIScreen.mainScreen.bounds.size.width, height)];
    [self addSubview:menuView];
    
    [self.activityMenu addMenu:menu menuView:menuView];
    
    getMenuView(menuView);
}

#pragma mark - 业务请求
/// 获取播放详情
- (void)getPlayInfo {
    [MZSimpleHud show];
    [[MZSDKInitManager sharedManager]initSDK:^(id responseObject) {
        //    获取播放信息
        [MZSDKBusinessManager reqPlayInfo:self.ticket_id success:^(MZMoviePlayerModel *responseObject) {
            [MZSimpleHud hide];

            NSLog(@"%@",responseObject);
            self.playInfo = responseObject;
            self.chatView.activity = self.playInfo;
            
            /// 设置封面
            if (self.playInfo.cover.length) {
                [self.playerView showPreviewImage:self.playInfo.cover];
            }

            self.bottomTalkBtn.isBanned = self.playInfo.user_status == 1 ? NO : YES;
            
            self.isCanBarrage = self.playInfo.isBarrage;
            self.isChat = self.playInfo.isChat;
            self.isRecordScreen = self.playInfo.isRecord_screen;
            [self.activityMenu setHidden:NO];
            
            // 更新商品和聊天界面的frame
            [self tipGoodAnimationWithGoodsListArr:self.goodsListArr];
            // 获取商品列表
            [self loadGoodsList:0 limit:50 callback:nil];
            // 播放直播/回放
            [self playWithVideoURLString:responseObject.video.url];
            // 设置人气缓存
            self.popularityNum = [self.playInfo.popular intValue];
            // 更新播放相关UI
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
            [MZSDKBusinessManager reqGetUserList:self.ticket_id offset:0 limit:0 success:^(NSArray* responseObject) {
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
                
                [self updateUIWithOnlineUsers:tempArr];
            } failure:^(NSError *error) {
                NSLog(@"error %@",error);
            }];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MZSimpleHud hide];
        }] ;
    
        //    获取主播信息
        [MZSDKBusinessManager reqHostInfo:self.ticket_id success:^(MZHostModel *responseObject) {
            // 更新主播信息
            self.hostModel = responseObject;
            [self updateHostInfo:self.hostModel];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    } failure:^(NSError *error) {
        [self showTextView:self message:@"sdk验证失败"];
        [MZSimpleHud hide];
    }];
}

/// 获取商品列表
- (void)loadGoodsList:(int) offset limit:(int)limit callback:(GoodsDataCallback)callback {
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
        if(goodsListOuterModel.list.count % 50 > 0){
            [self.goodsListView.goodTabView.MZ_footer endRefreshingWithNoMoreData];
        }

        NSLog(@"-goodsListOuterModel %lu",[goodsListOuterModel.list count]);
        NSLog(@"+goodsListArr %lu",[self.goodsListArr count]);
        [self.shoppingBagButton updateNumber:goodsListOuterModel.total];

        if(callback){
            callback(goodsListOuterModel);
        }
        [self tipGoodAnimationWithGoodsListArr:self.goodsListArr];
        
    } failure:^(NSError *error) {
        [self.goodsListView.goodTabView.MZ_header endRefreshing];
        [self.goodsListView.goodTabView.MZ_footer endRefreshing];
    }];
}

/// 请求点赞
- (void)praiseButtonDidClick:(UIButton *)button {
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

/// 显示键盘
- (void)showKeyboard {
    self.hideKeyBoardBtn.hidden = NO;
    _chatToolBar.hidden = NO;
    [_chatToolBar.msgTextView becomeFirstResponder];
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

/// 隐藏底部聊天等按钮
- (void)hideBottomMenu {
    [self.shoppingBagButton setHidden:YES];
    [self.bottomTalkBtn setHidden:YES];
    [self.praiseButton setHidden:YES];
    [self.shareBtn setHidden:YES];
    
    [self.multiButton setHidden:YES];
    self.multiButton.selected = NO;
    [self.multiMenu setHidden:YES];
}

/// 显示底部聊天等菜单
- (void)showBottomMenu {
    [self.shoppingBagButton setHidden:NO];
    [self.bottomTalkBtn setHidden:NO];
    [self.praiseButton setHidden:NO];
    [self.shareBtn setHidden:NO];
    
    [self.multiButton setHidden:NO];
    self.multiButton.selected = NO;
    [self.multiMenu setHidden:YES];
}

#pragma mark - 懒加载
- (MZMediaPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[MZMediaPlayerView alloc] init];
        _playerView.playDelegate = self;
        _playerView.toolDelegate = self;
    }
    return _playerView;
}

- (UIView *)playerBackgroundView {
    if (!_playerBackgroundView) {
        _playerBackgroundView = [[UIView alloc] init];
        _playerBackgroundView.backgroundColor = [UIColor clearColor];
    }
    return _playerBackgroundView;
}

- (UIButton *)playCloseButton {
    if (!_playCloseButton) {
        _playCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playCloseButton setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
        [_playCloseButton setImage:[UIImage imageNamed:@"mz_close_select"] forState:UIControlStateSelected];
        [_playCloseButton addTarget:self action:@selector(playCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playCloseButton;
}

- (NSMutableArray *)onlineUsersArr {
    if (!_onlineUsersArr) {
        _onlineUsersArr = @[].mutableCopy;
    }
    return _onlineUsersArr;
}

- (NSMutableArray *)goodsListArr {
    if (!_goodsListArr) {
        _goodsListArr = @[].mutableCopy;
    }
    return _goodsListArr;
}

- (MZPraiseButton *)praiseButton {
    if (!_praiseButton) {
        _isPraise = YES;
        _praiseButton = [MZPraiseButton buttonWithType:UIButtonTypeCustom];
        [_praiseButton setImage:ImageName(@"bottomButton_like") forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(praiseButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseButton;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:ImageName(@"bottomButton_share") forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)shoppingBagButton {
    if (!_shoppingBagButton) {
        _shoppingBagButton = [[MZBagButton alloc] init];
        [_shoppingBagButton addTarget:self action:@selector(shoppingBagButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shoppingBagButton;
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

- (MZHistoryChatView *)chatView {
    if (!_chatView) {
        CGFloat safeTopHeight = IPHONE_X ? 44.0 : 20;
        CGFloat safeBottomHeight = IPHONE_X ? 34.0 : 0;
        CGFloat tagMenuBottom = safeTopHeight + self.width/16*9 + 44*MZ_RATE;
        
        _chatView = [[MZHistoryChatView alloc]initWithFrame:CGRectMake(0, tagMenuBottom + 44*MZ_RATE, self.width, self.height - tagMenuBottom - safeBottomHeight - 18*MZ_RATE - 60*MZ_RATE - 44*MZ_RATE - 44*MZ_RATE) cellType:MZChatCellType_New];
        _chatView.chatDelegate = self;
    }
    return _chatView;
}

- (MZBottomTalkBtn *)bottomTalkBtn {
    if (!_bottomTalkBtn) {
        WeaklySelf(weakSelf);
        _bottomTalkBtn = [[MZBottomTalkBtn alloc] initWithFrame:CGRectZero];
        _bottomTalkBtn.bottomClickBlock = ^{
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
    }
    return _bottomTalkBtn;
}

- (UIView *)dlnaAndRateLayer {
    if (!_dlnaAndRateLayer) {
         CGFloat relativeSafeTop = IPHONE_X ? 44.0 : 20;
        _dlnaAndRateLayer = [[UIView alloc] initWithFrame:CGRectMake(0, relativeSafeTop + 30*MZ_RATE + 40*MZ_RATE, self.width, [MZMessageToolView defaultHeight])];
        _dlnaAndRateLayer.backgroundColor = [UIColor clearColor];
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0.5, 0);
        layer.endPoint = CGPointMake(0.5, 1);
        layer.locations = @[@(0), @(1.0f)];
        layer.frame = _dlnaAndRateLayer.bounds;
        layer.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6].CGColor, (__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0].CGColor];
        [_dlnaAndRateLayer.layer insertSublayer:layer atIndex:0];
        [_dlnaAndRateLayer setHidden:YES];
    }
    return _dlnaAndRateLayer;
}

- (UIButton *)playRateButton {
    if (!_playRateButton) {
        _playRateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playRateButton setImage:[UIImage imageNamed:@"mz_playRate_1"] forState:UIControlStateNormal];
        [_playRateButton addTarget:self action:@selector(playbackRateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_playRateButton setHidden:YES];
    }
    return _playRateButton;
}

- (UIButton *)dlnaButton {
    if (!_dlnaButton) {
        _dlnaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dlnaButton setImage:[UIImage imageNamed:@"mz_dlna"] forState:UIControlStateNormal];
        [_dlnaButton addTarget:self action:@selector(showDLNASearthView) forControlEvents:UIControlEventTouchUpInside];
        [_dlnaButton setHidden:YES];
    }
    return _dlnaButton;
}

- (UIButton *)multiButton {
    if (!_multiButton) {
        _multiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_multiButton setImage:[UIImage imageNamed:@"bottomButton_jubao"] forState:UIControlStateNormal];
        [_multiButton setImage:[UIImage imageNamed:@"bottomButton_jubao_click"] forState:UIControlStateSelected];
        [_multiButton addTarget:self action:@selector(multiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _multiButton;
}

- (MZMultiMenu *)multiMenu {
    if (!_multiMenu) {
        _multiMenu = [[MZMultiMenu alloc] init];
        _multiMenu.delegate = self;
    }
    return _multiMenu;
}

- (UIView *)tipGoodsBackgroundView {
    if (!_tipGoodsBackgroundView) {
        CGFloat safeBottomHeight = IPHONE_X ? 34.0 : 0;

        _tipGoodsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(18*MZ_RATE, self.frame.size.height-safeBottomHeight-44*MZ_RATE-15*MZ_RATE - 60*MZ_RATE, 175*MZ_RATE, 60*MZ_RATE)];
        _tipGoodsBackgroundView.backgroundColor = [UIColor clearColor];
        [_tipGoodsBackgroundView setHidden:YES];
    }
    return _tipGoodsBackgroundView;
}

- (MZActivityMenu *)activityMenu {
    if (!_activityMenu) {
        CGFloat relativeSafeTop = IPHONE_X ? 44.0 : 20;
        _activityMenu = [[MZActivityMenu alloc] initWithFrame:CGRectMake(0, relativeSafeTop+30*MZ_RATE+40*MZ_RATE+UIScreen.mainScreen.bounds.size.width/16*9, self.frame.size.width, 44*MZ_RATE)];
        _activityMenu.delegate = self;
        [_activityMenu setHidden:YES];
    }
    return _activityMenu;
}

#pragma mark - 发送消息
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
    MZLongPollDataModel*msgModel = [[MZLongPollDataModel alloc]init];
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

/// 聊天头像点击
- (void)historyChatViewUserHeaderClick:(MZLongPollDataModel *)msgModel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatUserHeaderDidClick:)]) {
        [self.delegate chatUserHeaderDidClick:msgModel];
    }
}

#pragma mark - ObserveValueForKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:kViewFramePath]){
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey]CGRectValue];
        if (frame.size.width < frame.size.height) {
            if (_chatToolBar == nil) {
                [self addSubview:self.hideKeyBoardBtn];

                _chatToolBar = [[MZMessageToolView alloc] initWithFrame:CGRectMake(0, MZTotalScreenHeight - [MZMessageToolView defaultHeight],  MZ_SW, [MZMessageToolView defaultHeight]) type:MZMessageToolBarTypeAllBtn];
                _chatToolBar.maxLength = 100;
                _chatToolBar.isBarrage = self.isCanBarrage;
                _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
                _chatToolBar.delegate = self;
                _chatToolBar.hidden = YES;
                [self addSubview:_chatToolBar];
            }
        }
    }
}

#pragma mark - MZGoodsRequestProtocol
- (void)requestGoodsList:(GoodsDataResult)block offset:(int)offset{
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

#pragma mark - MZChatKitDelegate
/// 直播时参会人数发生变化
- (void)activityOnlineNumberdidchange:(NSString * )onlineNo {
    NSLog(@"aaa onlineNo = %@",onlineNo);
}

/// 直播时礼物数发生变化
- (void)activityOnlineNumGiftchange:(NSString *)onlineGiftMoney {
    
}

/// 直播时收到一条新消息
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
        case MsgTypeMeChat: case MsgTypeOtherChat: {//聊天消息
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
                [self updateChatFrameAndTipGoodBackgroundView:NO];
            }
            if(!self.spreadTipGoodsView){
                self.spreadTipGoodsView = [[MZTipGoodsView alloc] initWithFrame:self.tipGoodsBackgroundView.bounds];
                self.spreadTipGoodsView.alpha = 0;
                self.spreadTipGoodsView.goodsListModelArr = [NSMutableArray array];
                [self.tipGoodsBackgroundView addSubview:self.spreadTipGoodsView];
                [self.spreadTipGoodsView.goodsListModelArr addObject:goodsListModel];
                [self spreadTipGoodsViewDidShow];
            }else{
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
            [self.unusualTipView setHidden:NO];
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
                [self addSubview:self.realyEndView];
                [self.realyEndView setHidden:YES];
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
            [self playWithVideoURLString:self.playInfo.video.url];
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
    if (self.playInfo.status == 2 && self.isLandSpace) {//是回放格式并且是横屏走这个逻辑
        if (isShow) {
            [self hideBottomMenu];
        } else {
            [self showBottomMenu];
        }
    }
    
    [self.dlnaButton setHidden:!isShow];

    if (self.isLandSpace) {
        [self.dlnaAndRateLayer setHidden:YES];
        [self.playRateButton setHidden:!isShow];
    } else {
        [self.dlnaAndRateLayer setHidden:!isShow];
        if (self.playInfo.status == 2) {
            [self.playRateButton setHidden:!isShow];
        } else {
            [self.playRateButton setHidden:YES];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(isPlayToolsShow:)]) {
        [self.delegate isPlayToolsShow:isShow];
    }
}
/// 全屏/非全屏切换
- (void)playerView:(MZMediaPlayerView *)player fullscreen:(BOOL)fullscreen {
    self.isLandSpace = fullscreen;
    
    if (self.isLandSpace) {
        [self.playerView hideMediaControl];
    } else {
        [self showBottomMenu];
        [self.dlnaAndRateLayer setHidden:self.dlnaButton.hidden];
    }
    
    [self updateChatFrameAndTipGoodBackgroundView:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:fullscreen:)]) {
        [self.delegate playerView:player fullscreen:fullscreen];
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
/// 已经准备好，可以进行播放了
- (void)mediaIsPreparedToPlayDidChange {
    [self barrageIsShow];
    [self.dlnaButton setHidden:NO];

    if (self.playInfo.status == 2) {
        [self.playRateButton setHidden:NO];
    }
    
    if (!self.isLandSpace) [self.dlnaAndRateLayer setHidden:NO];
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
        }
        [self.DLNAPlayingView setHidden:NO];
    });
}

#pragma mark - MZMultiMenuDelegate
/// 多菜单点击回调
- (void)multiMenuClick:(MultiMenuClick)menu {
    [self multiButtonClick];
    switch (menu) {
        case MultiMenuClick_report: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(reportButtonDidClick:)]) {
                [self.delegate reportButtonDidClick:self.playInfo];
            }
            break;
        }
        case MultiMenuClick_showBarrage: {
            self.isShowBarrage = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(showBarrageDidClick:)]) {
                [self.delegate showBarrageDidClick:YES];
            }
            break;
        }
        case MultiMenuClick_hideBarrage: {
            self.isShowBarrage = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(showBarrageDidClick:)]) {
                [self.delegate showBarrageDidClick:NO];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - MZActivityMenuDelegate
/// 活动菜单点击回调
- (void)activityMenuClickWithIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityMenuClickWithIndex:)]) {
        [self.delegate activityMenuClickWithIndex:index];
    }
}

@end
