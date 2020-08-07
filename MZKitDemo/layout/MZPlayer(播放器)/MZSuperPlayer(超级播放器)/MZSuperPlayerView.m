//
//  MZSuperPlayerView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/8.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZSuperPlayerView.h"

#import "MZHistoryChatView.h"
#import "MZMessageToolView.h"

#import "MZGoodsListView.h"
#import "MZLiveAudienceHeaderView.h"
#import "MZAudienceView.h"
#import "MZTipGoodsView.h"

#import "MZPraiseButton.h"
#import "MZBagButton.h"
#import "MZBottomTalkBtn.h"

#import "MZSmallPlayerView.h"
#import "MZMultiMenu.h"
#import "MZActivityMenu.h"

#import "MZGoodsListPresenter.h"

#import "MZSuperPlayerView+UI.h"
#import "MZVoteView.h"

#define kViewFramePath      @"frame"

typedef void(^GoodsDataCallback)(MZGoodsListOuterModel *model);

@interface MZSuperPlayerView()<MZChatKitDelegate,MZMessageToolBarDelegate,MZGoodsRequestProtocol,MZHistoryChatViewProtocol,MZPlaybackRateDelegate,MZMediaPlayerViewDelegate,MZDLNAViewDelegate,MZMultiMenuDelegate,MZActivityMenuDelegate>
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

@property (nonatomic, strong) UIView *tipGoodsBackgroundView;//循环播放的view的背景View
@property (nonatomic, strong) MZTipGoodsView *circleTipGoodsView;//循环播放的弹出商品view
@property (nonatomic, strong) MZTipGoodsView *spreadTipGoodsView;//推广的循环播放的弹出商品view

@property (nonatomic, strong) MZHistoryChatView *chatView;//聊天view
@property (nonatomic, strong) MZBottomTalkBtn *bottomTalkBtn;//聊天框
@property (nonatomic, strong) MZMessageToolView *chatToolBar;//聊天工具栏
@property (nonatomic, strong) MZChatKitManager *chatKitManager;//聊天Kit

@property (nonatomic, strong) MZLiveAudienceHeaderView *liveAudienceHeaderView;//右上角观众view
@property (nonatomic, strong) NSMutableArray *onlineUsersArr;//记录的右上角展示的几个在线观众数据源
@property (nonatomic, assign) int onlineUsersTotalCount;//记录的总在线人数

@property (nonatomic, strong) UILabel *unusualTipView;//主播中途离开的提示
@property (nonatomic, strong) UILabel *realyEndView;//直播结束的提示

@property (nonatomic, assign) BOOL isPraise;//点赞过滤
@property (nonatomic, strong) MZPraiseButton *praiseButton;//点赞按钮
@property (nonatomic, strong) MZTimer *timer;//持续点赞定时器

@property (nonatomic, strong) UIButton *hideKeyBoardBtn;//隐藏键盘按钮
@property (nonatomic, strong) UIButton *shareBtn;//分享按钮
@property (nonatomic, strong) MZBagButton *shoppingBagButton;//商品袋按钮

@property (nonatomic, strong) MZMoviePlayerPlaybackRateView *rateView;//倍速选择播放的view
@property (nonatomic, assign) MZPlayBackRate selectedRate;//当前倍速索引

@property (nonatomic, strong) MZDLNAPlayingView *DLNAPlayingView;//投屏中展示的View
@property (nonatomic, strong) MZDLNAView *DLNAView;//选择投屏的View

@property (nonatomic, strong) UIButton *multiButton;//多菜单按钮
@property (nonatomic, strong) MZMultiMenu *multiMenu;//多功能菜单View

@property (nonatomic, strong) MZActivityMenu *activityMenu;//活动的自定义菜单

@property (nonatomic, assign) BOOL isChat;//聊天室是否可以聊天,默认可以
@property (nonatomic, assign) BOOL isRecordScreen;//是否开启防录屏，默认不开启
@property (nonatomic, assign) BOOL isCanBarrage;//是否可以发弹幕，默认可以
@property (nonatomic, assign) BOOL isShowBarrage;//是否显示弹幕，默认可以

@property (nonatomic, strong) MZAnimationView *audioAnimationView;//静音直播的动画展示

@property (nonatomic, assign) BOOL isShowSign;//是否显示签到
@property (nonatomic, assign) BOOL isSignIn;//是否已经签到
@property (nonatomic, strong) UIButton *signButton;//签到按钮
@property (nonatomic, strong) MZSignView *signView;//签到View

@property (nonatomic, assign) BOOL isShowVote;//是否显示投票
@property (nonatomic, strong) UIButton *voteButton;//投票按钮
@property (nonatomic, strong) MZVoteView *voteView;//投票View

@property (nonatomic, assign) BOOL isShowDocuments;//是否显示文档
@property (nonatomic, strong) MZDocumentView *documentView;//文档View

@end

@implementation MZSuperPlayerView

- (void)dealloc {
    [self.documentView destory];
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
                
        // 退出横屏按钮
        [self.playCloseButton setSelected:YES];
        self.playCloseButton.frame = CGRectMake(self.right - 12*self.relativeSafeRate - 40*self.relativeSafeRate, self.relativeSafeTop+15*self.relativeSafeRate, 40*self.relativeSafeRate, 40.0*self.relativeSafeRate);

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
        
        self.audioAnimationView.frame = CGRectMake(0, (self.playerBackgroundView.top + (self.playerBackgroundView.height - self.audioAnimationView.height)/2.0), self.audioAnimationView.width, self.audioAnimationView.height);
        
        if (_activityMenu) [_activityMenu recoveryMenuView];
        self.playerView.isFullScreen = NO;

        // 退出界面按钮
        [self.playCloseButton setSelected:NO];
        self.playCloseButton.frame = CGRectMake(self.right - 40*self.relativeSafeRate - 12*self.relativeSafeRate, self.relativeSafeTop+15*self.relativeSafeRate, 40*self.relativeSafeRate, 40.0*self.relativeSafeRate);

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
        
        self.isSignIn = NO;//默认没签到
        self.isShowSign = NO;//默认不展示签到
        self.isShowVote = NO;//默认不展示投票
        self.isShowDocuments = NO;//默认不展示文档

        [self makeView];
    }
    return self;
}

- (void)makeView {
    [self addSubview:self.playerBackgroundView];
    [self addSubview:self.chatView];
    [self addSubview:self.signButton];
    [self addSubview:self.voteButton];
    
    // 开启点赞定时器
    self.timer = [MZTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) repeats:YES];

    [self addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
    
    [self createTopView];
    [self createBottomButtons];
    
    // 添加自定义的活动菜单
    [self addSubview:self.activityMenu];

    // 添加静音播放动画
    [self addSubview:self.audioAnimationView];
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
    
    CGFloat spaceRate = 1; CGFloat safeTopHeight = IPHONE_X ? 44.0 : 20; CGFloat safeBottomHeight = IPHONE_X ? 34 : 0; CGFloat safeLeftHeight = 0;
    CGFloat endHeight = UIScreen.mainScreen.bounds.size.width < UIScreen.mainScreen.bounds.size.height ? UIScreen.mainScreen.bounds.size.height : UIScreen.mainScreen.bounds.size.width;
    CGFloat endWidth = UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height ? UIScreen.mainScreen.bounds.size.height : UIScreen.mainScreen.bounds.size.width;

    if (self.isLandSpace) {
        safeTopHeight = 0; safeBottomHeight = IPHONE_X ? 10: 5; safeLeftHeight = IPHONE_X ? 44.0 : 0;
        
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
        [self updateRightMenuButtonStatusWithIsLandSpace:YES windowWidth:endWidth];
    } else {
        // 互动菜单的bottom
        CGFloat tagMenuBottom = safeTopHeight + endWidth/16*9 + 44*spaceRate + 30*spaceRate + 40*spaceRate;
        
        self.chatView.frame = CGRectMake(0, tagMenuBottom, endWidth, endHeight - tagMenuBottom - safeBottomHeight - 18*spaceRate - tipGoodBackgroundViewHeight - shoppingButtonHeight);
        [self updateRightMenuButtonStatusWithIsLandSpace:NO windowWidth:endWidth];
    }

    if (isScroolBottom) [self.chatView scrollToBottom];
}

/// 根据是否显示字段，来更新界面的菜单按钮的展示
- (void)updateRightMenuButtonStatusWithIsLandSpace:(BOOL)isLandSpace windowWidth:(CGFloat)windowWidth {
    if (isLandSpace) {
        self.signButton.hidden = isLandSpace;
        self.voteButton.hidden = isLandSpace;
    } else {
        if (self.isShowSign) {
            self.signButton.hidden = NO;
            self.signButton.frame = CGRectMake(windowWidth - 44*self.relativeSafeRate - 20*self.relativeSafeRate, self.chatView.top, 44*self.relativeSafeRate, 44*self.relativeSafeRate);
            if (self.isShowVote) {
                self.voteButton.hidden = NO;
                self.voteButton.frame = CGRectMake(windowWidth - 44*self.relativeSafeRate - 20*self.relativeSafeRate, self.signButton.bottom + 12*self.relativeSafeRate, 44*self.relativeSafeRate, 44*self.relativeSafeRate);
            } else {
                self.voteButton.hidden = YES;
            }
        } else {
            self.signButton.hidden = YES;
            if (self.isShowVote) {
                self.voteButton.hidden = NO;
                self.voteButton.frame = CGRectMake(windowWidth - 44*self.relativeSafeRate - 20*self.relativeSafeRate, self.chatView.top, 44*self.relativeSafeRate, 44*self.relativeSafeRate);
            } else {
                self.voteButton.hidden = YES;
            }
        }
    }
}

/// 点赞定时器
- (void)timerAction {
    [self.praiseButton showPraiseAnimation];
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

/// 更新人气界面
- (void)updateUIWithPlayInfo {
    self.liveManagerHeaderView.live_status = self.playInfo.status;
    // 人气值
    self.liveManagerHeaderView.numStr = [NSString stringWithFormat:@"%lld",self.popularityNum];
}

/// 更新在线人头和数字
- (void)updateUIWithOnlineUsers:(NSArray *)onlineUsers {
    if (!onlineUsers) return;
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
    _goodsListView.outGoodsListView = ^{
        weakSelf.goodsListView = nil;
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

/// 倍速播放点击
- (void)playbackRateBtnClick {
    if (self.isLandSpace) {
        _rateView = [[MZMoviePlayerPlaybackRateView alloc] initLandscapeRatePlayWithRate:_selectedRate];
    }else{
        _rateView = [[MZMoviePlayerPlaybackRateView alloc] initRatePlayWithRate:_selectedRate];
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
        if ([MZGlobalTools IsEnableWIFI]) {
            if(!self.DLNAView){
                self.DLNAView = [[MZDLNAView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, MZSafeScreenHeight)];
                self.DLNAView.delegate = self;
                self.DLNAView.DLNAString = self.playInfo.video.http_url ? self.playInfo.video.http_url : self.playInfo.video.url;
            }
            [self addSubview:self.DLNAView];
            
            [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
                self.DLNAView.fuctionView.frame = CGRectMake(0, MZSafeScreenHeight- 278*MZ_RATE, MZ_SW, 278*MZ_RATE);
            } completion:nil];
        } else {
            [self show:@"非Wifi情况下无法投屏"];
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
}

/// 投票按钮点击
- (void)voteButtonClick:(UIButton *)sender {
    [self.voteView showWithChannelId:self.playInfo.channel_id ticketId:self.playInfo.ticket_id];
}

/// 置空投票按钮
- (void)hideVoteView {
    self.voteView = nil;
}

/// 点赞按钮点击
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


#pragma mark - 播放相关功能和逻辑
/// 获取活动相关信息和配置
- (void)getPlayInfo {
    [MZSDKSimpleHud show];
    [[MZSDKInitManager sharedManager]initSDK:^(id responseObject) {
        //    获取播放信息
        [MZSDKBusinessManager reqPlayInfo:self.ticket_id success:^(MZMoviePlayerModel *responseObject) {
            [MZSDKSimpleHud hide];

            NSLog(@"%@",responseObject);
            self.playInfo = responseObject;
            
            // 设置 历史记录是否隐藏
            self.chatView.isHideChatHistory = self.playInfo.isHideChatHistory;
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
            // 加载商品总个数
            [MZGoodsListPresenter getGoodsListCountWithTicket_id:self.ticket_id finished:^(MZGoodsListOuterModel * _Nullable goodsListOuterModel) {
                self.goodsListArr = goodsListOuterModel.list;
                [self.shoppingBagButton updateNumber:goodsListOuterModel.total];
                [self tipGoodAnimationWithGoodsListArr:self.goodsListArr];
            }];
            
            // 播放直播/回放
            [self playWithVideoURLString:responseObject.video.url];
            // 设置人气缓存
            self.popularityNum = [self.playInfo.popular intValue];
            // 更新播放相关UI
            [self updateUIWithPlayInfo];
            
            // 更新签到按钮状态（签到/已签到）
            [self updateSignButtonStatus];
            
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
            
            // 设置 签到
            self.isShowSign = self.playInfo.isShowSign;
            self.isSignIn = self.playInfo.signInfo.is_sign;
            self.signButton.hidden = !self.playInfo.isShowSign;
            if (!self.signButton.isHidden) {
                [self updateSignButtonStatus];
            }
            // 继续设置签到的弹出逻辑
            if (self.playInfo.signInfo.is_sign == NO && self.playInfo.signInfo.is_force && self.playInfo.signInfo.force_type == 1) {//如果未签到 && 是强制签到 && 不可跳过
                //获取是否已经进入过强制签到的活动
                NSString *signFirstKey = [NSString stringWithFormat:@"%@%@%d",self.playInfo.unique_id,self.playInfo.ticket_id,self.playInfo.signInfo.sign_id];
                int isFirst = [[[NSUserDefaults standardUserDefaults] objectForKey:signFirstKey] intValue];
                if (isFirst == 1) {//这是第二次以后的进入强制签到的直播间,直接弹出强制签到
                    [self signButtonClick];
                } else { //第一次进入强制签到的活动，记录缓存
                    [self performSelector:@selector(signButtonClick) withObject:nil afterDelay:(self.playInfo.signInfo.delay_time*60)];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:signFirstKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            
            // 移除所有的自定义菜单
            [self.activityMenu removeAllMenu];
            
            // 设置 文档
            self.isShowDocuments = self.playInfo.isShowDocument;
            if (self.isShowDocuments) {
                // 添加自定义文档菜单
                WeaklySelf(weakSelf);
                [self addActivityMenu:@"文档" getMenuView:^(UIView * _Nonnull menuView) {
                    // 添加文档View
                    weakSelf.documentView = [[MZDocumentView alloc] initWithFrame:menuView.bounds live_status:weakSelf.playInfo.status channelID:weakSelf.playInfo.channel_id ticketID:weakSelf.playInfo.ticket_id];
                    [menuView addSubview:weakSelf.documentView];
                }];
            }
            
            // 设置 投票
            self.isShowVote = self.playInfo.isShowVote;
            self.voteButton.hidden = !self.isShowVote;
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MZSDKSimpleHud hide];
        }] ;
    
        // 获取主播信息
        [MZSDKBusinessManager reqHostInfo:self.ticket_id success:^(MZHostModel *responseObject) {
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
        [MZSDKSimpleHud hide];
    }];
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

    // 设置倍速按钮是否显示
    [self.playerView setPlayRateButtonIsHidden:(self.playInfo.status == 2 ? NO : YES)];
    // 设置投屏按钮是否显示
    [self.playerView setDLNAButtonIsHidden:(self.playInfo.status == 2 ? NO : YES)];
    // 设置全屏按钮是否显示
    [self.playerView setFullScreenButtonIsHidden:(self.playInfo.live_type == 1 ? YES : NO)];
    
    if (self.playInfo.status == 3) {//断流状态
        if (!self.unusualTipView) {
            self.unusualTipView = [[self creatUnusualTipView] roundChangeWithRadius:4];
            self.unusualTipView.frame = self.playerBackgroundView.frame;
            [self addSubview:self.unusualTipView];
        }
        [self.unusualTipView setHidden:NO];
        if (self.isLandSpace) {
            self.unusualTipView.text = @"主播暂时离开，稍等一下马上回来";
        } else {
            self.unusualTipView.text = @"主播暂时离开，\n稍等一下马上回来";
        }
    }

    // 设置控制栏响应手势事件
    [self.playerView updateReponseTouchEvent:YES];
}

/// 销毁播放器
- (void)playerShutDown {
    [self.chatKitManager closeLongPoll];
    [self.chatKitManager closeSocketIO];
    self.chatKitManager.delegate = nil;
    
    [self.playerView.playerManager shutdown];
    [self.playerView.playerManager didShutdown];
}

#pragma mark - 发送消息
/// 发送消息(这里我暂时写成弹幕消息接受的代理，回头要改一下消息工具的原代码)
- (void)didSendText:(NSString *)text userName:(NSString *)userName joinID:(NSString *)joinID isBarrage:(BOOL)isBarrage {
    if([MZUserServer currentUser].uniqueID.length <= 0 || self.playInfo.chat_uid.length <= 0){
        [self.superview show:@"您还未登录"];
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
    msgModel.userId = self.playInfo.chat_uid;
    msgModel.userName = [MZUserServer currentUser].nickName;
    msgModel.userAvatar = [MZUserServer currentUser].avatar;
    msgModel.event = MsgTypeMeChat;
    MZActMsg *actMsg = [[MZActMsg alloc] init];
    actMsg.msgText = text;
    actMsg.uniqueID = [MZUserServer currentUser].uniqueID;
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
    
    [MZChatKitManager sendText:text host:host token:token userID:self.playInfo.chat_uid userNickName:[MZUserServer currentUser].nickName userAvatar:[MZUserServer currentUser].avatar isBarrage:isBarrage success:^(MZLongPollDataModel *msgModel) {
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
    [MZSDKBusinessManager reqGoodsList:self.ticket_id offset:offset limit:50 success:^(id responseObject) {
        MZGoodsListOuterModel *goodsListOuterModel = (MZGoodsListOuterModel *)responseObject;
        int oldTotal = [self.shoppingBagButton getNumber];
        if (offset > 0) {
            if (goodsListOuterModel.list.count) {
                [self.goodsListArr addObjectsFromArray:goodsListOuterModel.list];
            }
        } else {
            self.goodsListArr  = goodsListOuterModel.list;
            [self.shoppingBagButton updateNumber:goodsListOuterModel.total];
            oldTotal = goodsListOuterModel.total;
        }
        if (block) {
            block(self.goodsListArr, oldTotal);
        }
        [self tipGoodAnimationWithGoodsListArr:self.goodsListArr];
    } failure:^(NSError *error) {
        [self.goodsListView.goodTabView.mj_header endRefreshing];
        [self.goodsListView.goodTabView.mj_footer endRefreshing];
    }];
}

#pragma mark - MZChatKitDelegate
/// 直播时参会人数发生变化
- (void)activityOnlineNumberdidchange:(NSString * )onlineNo {

}

/// 直播时礼物数发生变化
- (void)activityOnlineNumGiftchange:(NSString *)onlineGiftMoney {
    
}

/// 直播时收到一条新消息
- (void)activityGetNewMsg:(MZLongPollDataModel * )msg {
    switch (msg.event) {
        case MsgTypeOnline: {//上线一个用户
            [_chatView addChatData:msg];
            
            // 配置人气
            self.popularityNum ++;
            self.liveManagerHeaderView.numStr = [NSString stringWithFormat:@"%lld",self.popularityNum];
            
            //机器人不统计在线人
            if ([msg.data.is_hidden intValue] == 1) return;
            //如果是自己的上线通知，不处理
            if ([msg.userId isEqualToString:self.playInfo.chat_uid]) return;
            
            if (msg.userId.longLongValue <= 5000000000) {
                MZOnlineUserListModel *user = [[MZOnlineUserListModel alloc] init];
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
            if ([msg.userId isEqualToString:self.playInfo.chat_uid]) return;
            
            // 配置在线总人数
            self.onlineUsersTotalCount--;
            [self.liveAudienceHeaderView updateOnlineUserTotalCount:self.onlineUsersTotalCount];
            
            NSMutableArray *temArr = self.onlineUsersArr.mutableCopy;
            if (temArr.count > 0 && msg.userId.longLongValue <= 5000000000) {
                for (MZOnlineUserListModel *user in temArr) {
                    if([user.uid isEqualToString:msg.userId]){
                        [self.onlineUsersArr removeObject:user];
                        self.liveAudienceHeaderView.userArr = self.onlineUsersArr;
                        break;
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
        case MsgTypeMeChat: case MsgTypeOtherChat: {//聊天消息
            if ([self.playInfo.chat_uid isEqualToString:msg.userId]) {
                msg.event = MsgTypeMeChat;
                return;
            } else {
                [_chatView addChatData:msg];
                if (self.isShowBarrage && self.isCanBarrage) {
                    [MZBarrageManager sendBarrageWithMessage:msg.data.msgText userName:msg.userName avatar:msg.userAvatar isMe:NO result:^(BOOL isSuccess, NSError * _Nonnull error) {
                        if (isSuccess) NSLog(@"弹幕发送成功");
                    }];
                }
            }
            break;
        }
        case MsgTypeGoodsUrl: {//推广商品
            MZGoodsListModel *goodsListModel = [MZGoodsListModel creatModelFromMsg:msg];
            if (goodsListModel) {
                [self updateChatFrameAndTipGoodBackgroundView:NO];
            }
            if (!self.spreadTipGoodsView) {
                self.spreadTipGoodsView = [self creatSpreadTipGoodsView];
                self.spreadTipGoodsView.frame = self.tipGoodsBackgroundView.bounds;
                [self.tipGoodsBackgroundView addSubview:self.spreadTipGoodsView];
                [self.spreadTipGoodsView.goodsListModelArr addObject:goodsListModel];
                [self spreadTipGoodsViewDidShow];
            } else {
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
            if (self.isLandSpace) {
                self.unusualTipView.text = @"主播暂时离开，稍等一下马上回来";
            } else {
                self.unusualTipView.text = @"主播暂时离开，\n稍等一下马上回来";
            }
            [self.unusualTipView setHidden:NO];
            break;
        }
        case MsgTypeLiveReallyEnd: {//直播结束
            if (!self.realyEndView) {
                self.realyEndView = [[self creatRealyEndView] roundChangeWithRadius:4];
                self.realyEndView.frame = self.playerBackgroundView.frame;
                [self addSubview:self.realyEndView];
            }
            [self playerShutDown];
            [self.unusualTipView setHidden:YES];
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
        case MsgTypeWebinarFunctionMsg: {//活动过程中，配置更改
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
                    [self updateRightMenuButtonStatusWithIsLandSpace:self.isLandSpace windowWidth:UIScreen.mainScreen.bounds.size.width];
                } else if ([model.type isEqualToString:@"sign"]) {//是否显示签到
#warning - 签到关闭是实时的，开启的话只有重新进入视频才可以
                    
                    self.isShowSign = model.is_open;
                    if (self.isShowSign) {
                        self.isShowSign = NO;
                    }
                    [self updateRightMenuButtonStatusWithIsLandSpace:self.isLandSpace windowWidth:UIScreen.mainScreen.bounds.size.width];
                } else if ([model.type isEqualToString:@"documents"]) {//是否显示文档
#warning - 文档不是实时的，开启/关闭的话只有重新进入视频才可以
                    self.isShowDocuments = model.is_open;
                }
            }
            break;
        }
        case MsgTypeLiveStart: {//开始直播
            [self playWithVideoURLString:self.playInfo.video.url];
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
            NSLog(@"切换文档地址 - 文档名字 = %@，文档地址 = %@",msg.data.file_Name,msg.data.url);
            [self.documentView changeDoucmentPage:msg.data.url documentName:msg.data.file_Name];
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
    if (self.playInfo.status == 2 && self.isLandSpace) {//是回放格式并且是横屏走这个逻辑
        if (isShow) {
            [self hideBottomMenu];
        } else {
            [self showBottomMenu];
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
        [self.chatView onlineButtonIsCoverAtChatView:NO];
    } else {
        [self showBottomMenu];
        [self.chatView onlineButtonIsCoverAtChatView:YES];
    }
    
    [self updateChatFrameAndTipGoodBackgroundView:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:fullscreen:)]) {
        [self.delegate playerView:player fullscreen:fullscreen];
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
/// 已经准备好，可以进行播放了
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
                        
                        // 纯语音直播
                        if (weakSelf.playInfo.live_type == 1) {
                            weakSelf.audioAnimationView.hidden = NO;
                        }
                    } else if (type == MZDLNAControlTypeChange) {
                        [weakSelf showDLNASearthView];
                    }
                });
            };
            [self insertSubview:self.DLNAPlayingView aboveSubview:self.playerBackgroundView];
        }
        // 纯语音直播
        if (self.playInfo.live_type == 1) {
            self.audioAnimationView.hidden = YES;
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
- (MZMediaPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[MZMediaPlayerView alloc] init];
        _playerView.mediaPlayerViewDelegate = self;
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
        
        _chatView = [[MZHistoryChatView alloc]initWithFrame:CGRectMake(0, tagMenuBottom, self.width, self.height - tagMenuBottom - safeBottomHeight - 18*MZ_RATE - 60*MZ_RATE - 44*MZ_RATE) cellType:MZChatCellType_New];
        _chatView.chatDelegate = self;
        [_chatView onlineButtonIsCoverAtChatView:YES];
    }
    return _chatView;
}

- (MZBottomTalkBtn *)bottomTalkBtn {
    if (!_bottomTalkBtn) {
        WeaklySelf(weakSelf);
        _bottomTalkBtn = [[MZBottomTalkBtn alloc] initWithFrame:CGRectZero];
        _bottomTalkBtn.bottomClickBlock = ^{
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
    return _bottomTalkBtn;
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

- (MZAnimationView *)audioAnimationView {
    if (!_audioAnimationView) {
        _audioAnimationView = [MZAnimationView animationNamed:MZ_Audio_AnimationJsonName];
        _audioAnimationView.loopAnimation = YES;
        _audioAnimationView.userInteractionEnabled = NO;
        _audioAnimationView.frame = CGRectMake(0, 0, self.frame.size.width, 422*(self.frame.size.width/750));
        _audioAnimationView.hidden = YES;
    }
    return _audioAnimationView;
}

static NSString *signImageName = @"mz_qiandao_normal";//未签到图片
static NSString *signInImageName = @"mz_qiandao_select";//签到图片

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

- (MZSignView *)signView {
    if (!_signView) {
        WeaklySelf(weakSelf);
        _signView = [[MZSignView alloc] initWithSignInfo:self.playInfo.signInfo closeHandle:^(MZSignMethodType methodType, NSString * _Nonnull message) {
            switch (methodType) {
                case MZSignMethodTypeClose: {
                    NSLog(@"点击了关闭按钮");
                    weakSelf.signView = nil;
                    if (self.playInfo.signInfo.is_force && self.playInfo.signInfo.force_type == 1) {//强制签到 && 不可跳过
                        [weakSelf playCloseButtonClick];
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
