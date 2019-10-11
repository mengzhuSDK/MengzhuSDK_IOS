

#import "MZPlayerControlView.h"
#import "MZLiveManagerHearderView.h"
#import "MZLiveAudienceHeaderView.h"
#import "MZPopView.h"
#import "YYTimer.h"
#import "MZGoodsListView.h"
#import "MZChatView.h"
#import "MZHistoryChatView.h"
#import "MZBottomTalkBtn.h"
#import "MZMessageToolView.h"
#import "MZTipGoodsView.h"

#define kViewFramePath      @"frame"

@interface MZPlayerControlView()<MZChatViewDelegate,MZMessageToolBarDelegate,UITextViewDelegate>
@property (nonatomic ,strong)UIView *playerContentView;//播放器上盖的一层View
@property (nonatomic ,strong)MZLiveManagerHearderView *liveManagerHearderView;//左上角主播按钮view
@property (nonatomic ,strong)MZLiveAudienceHeaderView *liveAudienceHeaderView;//右上角观众view
@property (nonatomic ,strong)  UIView               * preView;//预览view
@property (nonatomic ,strong)UIButton *closeLiveBtn;
@property (nonatomic ,assign) BOOL isCanShowVerticalScreen;//只有在停止播放的时候才能显示竖屏、
//@property (nonatomic ,strong) LivePusher * liveSession;
@property (nonatomic ,strong) UIButton *jvbaoButton;
@property (nonatomic ,strong) UIButton *likeButton;
@property (nonatomic ,strong) UIStackView *stackContainerView;
@property (nonatomic,assign) NSTimeInterval duration;
@property (nonatomic ,strong) YYTimer *timer;
@property (nonatomic ,strong)MZHistoryChatView *chatView;
@property (nonatomic ,strong)MZPlayerManager *manager;
//@property (nonatomic ,strong)MZMoviePlayerModel *moviePlayerDetailModel;//视频播放详情Model
@property (nonatomic ,strong)MZBottomTalkBtn *bottomTalkBtn;
@property (nonatomic ,strong)UIButton *hideKeyBoardBtn;
@property (nonatomic ,strong)MZMessageToolView *chatToolBar;
@property (nonatomic ,strong) MZMoviePlayerModel *playInfo;////视频播放详情Model
@property (nonatomic ,strong) UIButton *tipButon_jvbao;
@end
@implementation MZPlayerControlView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self customAddSubviews];
        [self addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
- (void)customAddSubviews{
    self.playerContentView = [[UIView alloc]initWithFrame:self.bounds];
    self.playerContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.playerContentView];
    [self loadGoodsList];
    [self createTopView];
    [self createBottomButtons];
    [self setupChatView];
    [self addTimerForScroll];//    开启动画计时器
}
-(void)createTopView{
    WeaklySelf(weakself);
    CGFloat topSpace = IPHONE_X ? 20 : 0;
    self.liveManagerHearderView = [[MZLiveManagerHearderView alloc]initWithFrame:CGRectMake(12*MZ_RATE,topSpace + 22*MZ_RATE, 172*MZ_RATE, 40*MZ_RATE)];
    [self.playerContentView addSubview:self.liveManagerHearderView];
    
    self.liveManagerHearderView.clickBlock = ^{
        [weakself.playerDelegate avatarDidClick:weakself.playInfo];
    };
    self.liveManagerHearderView.attentionClickBlock = ^{
        [weakself.playerDelegate attentionButtonDidClick:weakself.playInfo];
    };
    self.liveAudienceHeaderView = [[MZLiveAudienceHeaderView alloc]initWithFrame:CGRectMake(self.liveManagerHearderView.right + 22*MZ_RATE, self.liveManagerHearderView.center.y - 14*MZ_RATE, 116*MZ_RATE, 28*MZ_RATE)];
    self.liveAudienceHeaderView.hidden = NO;
    [self.playerContentView addSubview:self.liveAudienceHeaderView];
    
    self.liveAudienceHeaderView.clickBlock = ^{
        [weakself.playerDelegate onlineListButtonDidClick:weakself.playInfo];
    };
    self.closeLiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(MZ_SW - 44*MZ_RATE - 8*MZ_RATE,topSpace + 20*MZ_RATE, 44*MZ_RATE, 44*MZ_RATE)];
    //    self.closeLiveBtn.tag = MZLiveViewCloseBtnTag;
    [self.closeLiveBtn addTarget:self action:@selector(closeButtonDidclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeLiveBtn setImage:ImageName(@"live_close") forState:UIControlStateNormal];
    [self.playerContentView addSubview:self.closeLiveBtn];
}
-(void)createBottomButtons{
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
    [xinshouButton addTarget:self action:@selector(firstButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tipButon_jvbao = xinshouButton;
    UIButton *shareButton = [[UIButton alloc] initWithFrame:commonRect];
    [shareButton setImage:ImageName(@"bottomButton_share") forState:UIControlStateNormal];
    [stackContainerView addArrangedSubview:shareButton];
    [shareButton addTarget:self action:@selector(secondButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *likeButton = [[UIButton alloc] initWithFrame:commonRect];
    self.likeButton = likeButton;
    [likeButton setImage:ImageName(@"bottomButton_like") forState:UIControlStateNormal];
    [stackContainerView addArrangedSubview:likeButton];
    [likeButton addTarget:self action:@selector(likeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *shoppingBagButton = [[UIButton alloc] initWithFrame:CGRectMake(12, stackContainerView.top, 44*MZ_RATE, 44*MZ_RATE)];
    [self addSubview:shoppingBagButton];
    [shoppingBagButton setImage:ImageName(@"bottomButton_shoppingBag") forState:UIControlStateNormal];
    [shoppingBagButton addTarget:self action:@selector(shoppingBagButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21*MZ_RATE, 44*MZ_RATE, 17*MZ_RATE)];
    goodsNumLabel.font = [UIFont systemFontOfSize:12];
    goodsNumLabel.textAlignment = NSTextAlignmentCenter;
    goodsNumLabel.textColor = [UIColor whiteColor];
    [shoppingBagButton addSubview:goodsNumLabel];
    goodsNumLabel.text = @"12";
    
    self.bottomTalkBtn = [[MZBottomTalkBtn alloc]initWithFrame:CGRectMake(shoppingBagButton.right + 14*MZ_RATE, shoppingBagButton.top, 120*MZ_RATE, 44*MZ_RATE)];
    [self addSubview:self.bottomTalkBtn];
    self.bottomTalkBtn.bottomClickBlock = ^{
                [weakSelf showKeyboard];
    };
}
-(void)setupChatView
{
    self.chatView = [[MZHistoryChatView alloc]initWithFrame:CGRectMake(0, kDHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), kDWidth, 130*MZ_RATE)];
//    self.chatView.delegate =self;
    [self.playerContentView addSubview:self.chatView];
    //这里设置的固定的活动ID
    MZMoviePlayerModel *model = [[MZMoviePlayerModel alloc]init];
    model.ticket_id = MZ_DefailtTicket_id;
    self.chatView.activity = model;
}
-(void)tipGoodAnimationWithGoodsListArr:(NSMutableArray *)arr
{
    MZTipGoodsView *tipGoodsView = [[MZTipGoodsView alloc]initWithFrame:CGRectMake(18*MZ_RATE, self.chatView.bottom + 3*MZ_RATE, 185*MZ_RATE, 60*MZ_RATE)];
    tipGoodsView.alpha = 0;
    [self addSubview:tipGoodsView];
    tipGoodsView.goodsListModelArr = arr;
    [tipGoodsView beginAnimation];
}

-(void)loadGoodsList
{
    [MZSDKBusinessManager reqGoodsList:MZ_DefailtTicket_id offset:1 limit:50 success:^(id responseObject) {
        MZGoodsListOuterModel *goodsListOuterModel = (MZGoodsListOuterModel *)responseObject;
        [self tipGoodAnimationWithGoodsListArr:goodsListOuterModel.list];
        
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}


- (void)addTimerForScroll{
    //    添加动画
    self.timer = [YYTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) repeats:YES];
}
-(void)timerAction{
    [self praiseAnimationWithBtn:self.likeButton];
}
- (void)initHideKeyBoardBtn{
    if (!_hideKeyBoardBtn) {
        _hideKeyBoardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, MZTotalScreenHeight)];
        _hideKeyBoardBtn.backgroundColor = [UIColor clearColor];
        [_hideKeyBoardBtn addTarget:self action:@selector(hideKeyBoardBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _hideKeyBoardBtn.hidden = YES;
        [self addSubview:_hideKeyBoardBtn];
    }
}
#pragma mark 聊天
- (void)showKeyboard{
    _hideKeyBoardBtn.hidden = NO;
    self.chatToolBar.hidden = NO;
    [self.chatToolBar.msgTextView becomeFirstResponder];
    [self addSubview:_chatToolBar];
}

- (void)hideKeyboard{
    WeaklySelf(weakSelf);
    [_chatToolBar endEditing:YES];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        weakSelf.chatToolBar.hidden = YES;
        weakSelf.hideKeyBoardBtn.hidden = YES;
    });
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
                _chatToolBar = [[MZMessageToolView alloc] initWithFrame:CGRectMake(0, MZTotalScreenHeight - [MZMessageToolView defaultHeight],  MZ_SW, [MZMessageToolView defaultHeight]) type:MZMessageToolBarTypeOnlyTextView];
                _chatToolBar.maxLength = 100;
                _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
                _chatToolBar.delegate = self;
                _chatToolBar.msgTextView.delegate = self;
                _chatToolBar.hidden = YES;
                [self addSubview:_chatToolBar];
            }
        }
    }
}

-(MZMessageToolView *)chatToolBar
{
    if(!_chatToolBar){
        _chatToolBar = [[MZMessageToolView alloc] initWithFrame:CGRectMake(0, MZTotalScreenHeight - [MZMessageToolView defaultHeight] , MZ_SW, [MZMessageToolView defaultHeight]) type:MZMessageToolBarTypeOnlyTextView];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.maxLength = 100;
        _chatToolBar.delegate = self;
        _chatToolBar.hidden = YES;
    }
    return _chatToolBar;
}

- (void)didSendText:(NSString *)text userName:(NSString *)userName joinID:(NSString *)joinID
{
    if(![MZUserServer currentUser]){
//        [self showTextView:self.navigationController.view message:@"您还未登录"];
        return;
    }
    if ([MZGlobalTools isBlankString:text]) {
//        [self showTextView:self.view message:@"聊天信息不能为空"];
        [self hideKeyboard];
    }
    NSString * host = [NSString stringWithFormat:@"%@?",self.playInfo.chat_config.pub_url];
    NSString * token = self.playInfo.msg_config.msg_token;
    MZLongPollDataModel*msgModel = [[MZLongPollDataModel alloc]init];
    msgModel.userId = [MZUserServer currentUser].userId;
    msgModel.userName = [MZUserServer currentUser].nickName;
    msgModel.userAvatar = [MZUserServer currentUser].avatar;
    msgModel.event = MsgTypeMeChat;
    MZActMsg *actMsg = [[MZActMsg alloc]init];
    actMsg.msgText = text;
    msgModel.data = actMsg;
    [self.chatView addChatData:msgModel];
    
//    [MZLiveActivity sendText:text host:host token:token activityInfo:_liveActivity isBarrage:NO success:^(MZLongPollDataModel *msgModel) {
//
//    } failure:^(NSError *error) {
//        [self showTextView:self.view message:@"聊天消息发送失败"];
//    }];
    [MZChatKitManager sendText:text host:host token:token userID:[MZUserServer currentUser].userId userNickName:[MZUserServer currentUser].nickName userAvatar:[MZUserServer currentUser].avatar isBarrage:NO success:^(MZLongPollDataModel *msgModel) {
        NSLog(@"发送成功");
    } failure:^(NSError *error) {
        NSLog(@"发送失败");
    }];
    
    [self hideKeyboard];
}

#pragma mark - 销毁播放器
-(void)playerShutDown;{
    [self.manager shutdown];
    [self.manager didShutdown];
}
#pragma mark - 点赞动画
-(void)likeButtonDidClick:(UIButton *)button {
    [self.playerDelegate likeButtonDidClick:self.playInfo];
    
    [self praiseAnimationWithBtn:button];
}

- (void)praiseAnimationWithBtn:(UIButton *)button {
 
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect frame = button.frame;
    //  初始frame，即设置了动画的起点
    imageView.frame = CGRectMake(frame.size.width - 40, frame.size.height - 65, 30, 30);
    //  初始化imageView透明度为0
    imageView.alpha = 0;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    //  用0.2秒的时间将imageView的透明度变成1.0，同时将其放大1.3倍，再缩放至1.1倍，这里参数根据需求设置
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1.0;
        imageView.frame = CGRectMake(frame.size.width - 40, frame.size.height - 150, 30, 30);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
        imageView.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [button addSubview:imageView];
    //  随机产生一个动画结束点的X值
    CGFloat finishX = frame.size.width - round(random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = frame.size.height - 400;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    //  动画执行时间
    self.duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (self.duration == INFINITY) self.duration = 2.412346;
    // 随机生成一个0~7的数，以便下面拼接图片名
    //    int imageName = round(random() % 8);//  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    //  设置动画时间
    [UIView setAnimationDuration:self.duration];
    //    NSArray *nameArr = @[@"bottom_紫",@"bottom_粉",@"bottom_黄",@"bottom_绿",@"bottom_蓝"];
    //  拼接图片名字
    imageView.image = [UIImage imageNamed:@"bottom_likeImage"];
    
    //  设置imageView的结束frame
    imageView.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:self.duration animations:^{
        imageView.alpha = 0;
    }];
    
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
    imageView = nil;
    
}
#pragma mark buttons点击
-(void)firstButtonClick:(UIButton *)button{
    NSLog(@"%s",__func__);
    //    动画
    button.selected = !button.selected;
    if (button.selected) {
        self.jvbaoButton = [[UIButton alloc] initWithFrame:CGRectMake(226*MZ_RATE, self.stackContainerView.top-(9+44)*MZ_RATE, 55*MZ_RATE, 44*MZ_RATE)];
        [self.jvbaoButton setImage:ImageName(@"button_jvbao") forState:UIControlStateNormal];
        [self addSubview:self.jvbaoButton];
        [_jvbaoButton addTarget:self action:@selector(jvBaoButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.jvbaoButton removeFromSuperview];
    }
}
-(void)secondButtonClick{
    NSLog(@"%s",__func__);
    [self.playerDelegate shareButtonDidClick:self.playInfo];
}
-(void)shoppingBagButtonClick{
    NSLog(@"%s",__func__);
    [self.playerDelegate shoppingBagDidClick:self.playInfo];
}
- (void)closeButtonDidclick:(UIButton *)button{
    NSLog(@"%s",__func__);
    [self.playerDelegate closeButtonDidClick:self.playInfo];
}
-(void)jvBaoButtonDidClick:(UIButton *)button{
    NSLog(@"%s",__FUNCTION__);
    [self.playerDelegate reportButtonDidClick:self.playInfo];
    [self.tipButon_jvbao sendActionsForControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 视频SDK
-(void)playVideoWithLiveIDString:(NSString *)liveIDString;{
    
    [MZSDKBusinessManager reqPlayInfo:liveIDString success:^(MZMoviePlayerModel *responseObject) {
         NSLog(@"%@",responseObject);
        self.playInfo = responseObject;
        [self playerVideoWithURLString:responseObject.video.url];
        [self updateUIWithPlayInfo];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }] ;
    
    
//    获取在线人数
    [MZSDKBusinessManager reqGetUserList:liveIDString offset:0 limit:0 success:^(NSArray* responseObject) {
        
        [self updateUIWithOnlineUsers:responseObject];
    } failure:^(NSError *error) {
         NSLog(@"error %@",error);
    }];

    

}
-(void)playerVideoWithURLString:(NSString *)videoString{
    //    NSString *str = @"http://vod.t.zmengzhu.com/record/base/hls-sd/5081b2bb9b49a26700082943.m3u8";
    self.manager=[[MZPlayerManager alloc]initWithContentURLString:videoString movieModel:MZMPMovieScalingModeFill frame:self.bounds];
    self.manager.view.frame = self.bounds;
    [self addSubview:self.manager.view];
    [self insertSubview:self.manager.view belowSubview:self.playerContentView];
    self.manager.shouldShowHudView = NO;
    //    self.manager.movieScalingMode = MZMPMovieScalingModeFill;//视频填充模式
    [self.manager prepareToPlay];
    
}
#pragma 获取观看详情数据
-(void)getPlayInfoDetail
{
    
}

-(void)updateUIWithPlayInfo{
//    处理人气
    self.liveManagerHearderView.numStr = self.playInfo.popular;
    //    处理UV
    self.liveAudienceHeaderView.numStr = self.playInfo.uv;
    
}
-(void)updateUIWithAvatarURLString:(NSString *)avatar name:(NSString *)name;{
        self.liveManagerHearderView.title = name;
        self.liveManagerHearderView.imageUrl = avatar;
}
-(void)updateUIWithOnlineUsers:(NSArray *)onlineUsers{
    if (!onlineUsers) {
        return;
    }
    NSMutableArray *UsersUrlMArray = [NSMutableArray new];
    NSArray *tempArray;
    if (onlineUsers.count>=3) {
//        取前三个
        tempArray = [[onlineUsers subarrayWithRange:NSMakeRange(0, 3)] mutableCopy];
    }else{
        tempArray = [onlineUsers mutableCopy];
    }
    for (MZOnlineUserListModel* model in tempArray) {
        [UsersUrlMArray addObject:model.avatar];
    }
    self.liveAudienceHeaderView.imageUrlArr = UsersUrlMArray;
}

@end
