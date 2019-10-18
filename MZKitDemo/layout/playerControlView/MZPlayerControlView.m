

#import "MZPlayerControlView.h"
#import "MZLiveManagerHearderView.h"
#import "MZLiveAudienceHeaderView.h"
#import "MZGoodsListView.h"
//#import "MZChatView.h"
#import "MZHistoryChatView.h"
#import "MZBottomTalkBtn.h"
#import "MZMessageToolView.h"
#import "MZTipGoodsView.h"

#define kViewFramePath      @"frame"

typedef void(^GoodsDataCallback)(MZGoodsListOuterModel *model);
@interface MZPlayerControlView()<MZMessageToolBarDelegate,UITextViewDelegate,MZChatKitDelegate,MZGoodsRequestProtocol,MZHistoryChatViewProtocol>

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
@property (nonatomic ,strong) MZTimer *timer;
@property (nonatomic ,strong)MZHistoryChatView *chatView;
@property (nonatomic ,strong)MZPlayerManager *manager;
//@property (nonatomic ,strong)MZMoviePlayerModel *moviePlayerDetailModel;//视频播放详情Model
@property (nonatomic ,strong)MZBottomTalkBtn *bottomTalkBtn;
@property (nonatomic ,strong)UIButton *hideKeyBoardBtn;
@property (nonatomic ,strong)MZMessageToolView *chatToolBar;
@property (nonatomic ,strong) MZMoviePlayerModel *playInfo;////视频播放详情Model
@property (nonatomic ,strong)NSMutableArray *onlineUsersArr;
@property (nonatomic ,strong) UIButton *tipButon_jvbao;
@property (nonatomic,assign) long long popularityNum;
@property (nonatomic ,strong)MZTipGoodsView *circleTipGoodsView;//循环播放的弹出商品view
@property (nonatomic ,strong)MZTipGoodsView *spreadTipGoodsView;//推广的弹出view
@property (nonatomic ,strong)NSMutableArray *goodsListArr;//底部弹窗共用的数组
@property (nonatomic,strong)MZChatKitManager *chatKitManager;
@property (nonatomic ,strong) MZHostModel *hostModel;
@property (nonatomic ,assign) int goodsOffset;
@property (nonatomic ,strong)MZGoodsListView *goodsListView;
@property (nonatomic,assign) int totalNum;

@property (nonatomic ,strong)UILabel *goodsNumLabel;
@property (nonatomic ,strong)UILabel *unusualTipView;

@property (nonatomic ,strong)NSString *HostUID;
@property (nonatomic ,strong)NSString *Hostname;
@property (nonatomic ,strong)NSString *Hostavatar;
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
    MZUser *user= [MZUserServer currentUser];
    self.UserUID=user.userId;
    self.UserName=user.nickName;
    self.UserAvatar=user.avatar;
    self.playerContentView = [[UIView alloc]initWithFrame:self.bounds];
    self.playerContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.playerContentView];
    [self createTopView];
    [self createBottomButtons];
    [self setupChatView];
    [self addTimerForScroll];//    开启动画计时器

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap1];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [_chatToolBar endEditing:YES];
    WeaklySelf(weakSelf);
    if(!self.chatToolBar.hidden){
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            weakSelf.chatToolBar.hidden = YES;
            weakSelf.hideKeyBoardBtn.hidden = YES;
        });
    }
 
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
            [weakSelf showKeyboard];
        }
        
    };
}
-(void)setupChatView
{
    self.chatView = [[MZHistoryChatView alloc]initWithFrame:CGRectMake(0, MZHeight - 265*MZ_RATE - (IPHONE_X ? 34 : 0), MZWidth, 130*MZ_RATE)];
    self.chatView.chatDelegate =self;
    [self.playerContentView addSubview:self.chatView];
    
}
-(void)tipGoodAnimationWithGoodsListArr:(NSMutableArray *)arr
{
    WeaklySelf(weakSelf);
    if(!self.circleTipGoodsView){
        self.circleTipGoodsView = [[MZTipGoodsView alloc]initWithFrame:CGRectMake(18*MZ_RATE, self.chatView.frame.origin.y+self.chatView.frame.size.height + 3*MZ_RATE, 185*MZ_RATE, 60*MZ_RATE)];
        
        self.circleTipGoodsView.goodsClickBlock = ^(MZGoodsListModel * _Nonnull model) {
            [weakSelf.playerDelegate goodsItemDidClick:model];
        };
        self.circleTipGoodsView.isCirclePlay = YES;
        self.circleTipGoodsView.alpha = 0;
        [self addSubview:self.circleTipGoodsView];
    }else{
        self.circleTipGoodsView.frame=CGRectMake(18*MZ_RATE, self.chatView.frame.origin.y+self.chatView.frame.size.height + 3*MZ_RATE, 185*MZ_RATE, 60*MZ_RATE);
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

-(void)loadGoodsList:(int) offset limit:(int)limit callback:(GoodsDataCallback)callback
{
    
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
        if(goodsListOuterModel.list.count < 50){
            
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
        NSLog(@"");
    }];
}


- (void)addTimerForScroll{
    //    添加动画
    self.timer = [MZTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) repeats:YES];
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
#pragma mark setter方法
- (void)setHostModel:(MZHostModel *)hostModel{
    _hostModel = hostModel;
    
    self.HostUID = hostModel.uid;
    self.Hostname = hostModel.nickname;
    self.Hostavatar = hostModel.avatar;
    [self updateUIWithAvatarURLString:self.Hostavatar name:self.Hostname];
}
#pragma mark 聊天
- (void)historyChatViewUserHeaderClick:(MZLongPollDataModel *)msgModel{
    [self.playerDelegate chatUserHeaderDidClick:msgModel];
}
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

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 0){
        _chatToolBar.msgTextView.centerPlaceHolderLable.hidden = YES;
    }else{
        _chatToolBar.msgTextView.centerPlaceHolderLable.hidden = NO;
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
    if([MZUserServer currentUser].accountNo.length == 0){
        [self showTextView:self.superview message:@"您还未登录"];
        [self hideKeyboard];
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
    
    [MZChatKitManager sendText:text host:host token:token userID:[MZUserServer currentUser].userId userNickName:[MZUserServer currentUser].nickName userAvatar:[MZUserServer currentUser].avatar isBarrage:NO success:^(MZLongPollDataModel *msgModel) {
        NSLog(@"发送成功");
    } failure:^(NSError *error) {
        NSLog(@"发送失败");
    }];
    
    [self hideKeyboard];
}

#pragma mark - 销毁播放器
-(void)playerShutDown
{
    [self.chatKitManager closeLongPoll];
    [self.chatKitManager closeSocketIO];
    self.chatKitManager.delegate = nil;
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

    _goodsListView = [[MZGoodsListView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, MZTotalScreenHeight)];
    _goodsListView.totalNum = self.totalNum;
    [_goodsListView.dataArr addObjectsFromArray:self.goodsListArr];
    _goodsListView.requestDelegate=self;
    _goodsListView.offset=_goodsOffset;
    WeaklySelf(weakSelf);
    _goodsListView.goodsListViewCellClickBlock = ^(MZGoodsListModel * _Nonnull model) {
        [weakSelf.playerDelegate goodsItemDidClick:model];
    };
    [self addSubview:_goodsListView];
}

- (void)requestGoodsList:(GoodsDataResult)block offset:(int)offset{
    WeaklySelf(weakSelf);
    [self loadGoodsList:offset limit:50 callback:^(MZGoodsListOuterModel *model) {
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
-(void)playVideoWithLiveIDString:(NSString *)ticket_id;{
    self.ticket_id = ticket_id;
    WeaklySelf(weakSelf);
    [[MZSDKInitManager sharedManager]initSDK:^(id responseObject) {
        //    获取播放信息
        [MZSDKBusinessManager reqPlayInfo:ticket_id success:^(MZMoviePlayerModel *responseObject) {
            //        http://vod.t.zmengzhu.com/record/base/hls-sd/a954304bb6482c3c00083250.m3u8
            NSLog(@"%@",responseObject);
            self.playInfo = responseObject;
            self.chatView.activity = self.playInfo;
            self.bottomTalkBtn.isBanned = self.playInfo.user_status == 1? NO : YES;
            [self loadGoodsList:0 limit:50 callback:nil];
            [self playerVideoWithURLString:responseObject.video.url];
            [self updateUIWithPlayInfo];
            self.chatKitManager = [[MZChatKitManager alloc]init];
            self.chatKitManager.delegate = self;
            [self.chatKitManager startTimelyChar:self.playInfo.ticket_id receive_url:self.playInfo.chat_config.receive_url srv:self.playInfo.msg_config.msg_online_srv token:self.playInfo.msg_config.msg_token];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            
        }] ;
        
        
        //    获取在线人数
        [MZSDKBusinessManager reqGetUserList:ticket_id offset:0 limit:0 success:^(NSArray* responseObject) {
            NSMutableArray *tempArr = responseObject.mutableCopy;
            for (MZOnlineUserListModel* model in responseObject) {
                if(model.uid.longLongValue > 5000000000){//uid大于五十亿是游客
                    [tempArr removeObject:model];
                }
            }
            [self updateUIWithOnlineUsers:tempArr];
        } failure:^(NSError *error) {
            NSLog(@"error %@",error);
        }];
        //    获取主播信息
        [MZSDKBusinessManager reqHostInfo:ticket_id success:^(MZHostModel *responseObject) {
            self.hostModel = responseObject;
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    } failure:^(NSError *error) {
        [weakSelf showTextView:weakSelf message:@"sdk验证失败"];
    }];

}

/*!
 直播时参会人数发生变化
 */
-(void)activityOnlineNumberdidchange:(NSString * )onlineNo
{
    
}

/*!
 直播时收到一条新消息
 */
-(void)activityGetNewMsg:(MZLongPollDataModel * )msg
{
    WeaklySelf(weakSelf);
    if(msg.event == MsgTypeOnline){
        [_chatView addChatData:msg];
        if(msg.userId.longLongValue <= 5000000000){
            MZOnlineUserListModel *user = [[MZOnlineUserListModel alloc]init];
            user.uid = msg.userId;
            user.avatar = msg.userAvatar;
            user.nickname = msg.userName;
            [self.onlineUsersArr addObject:user];
        }
        self.liveAudienceHeaderView.userArr = self.onlineUsersArr;
        self.popularityNum ++;
        self.liveAudienceHeaderView.numStr = [NSString stringWithFormat:@"%d",self.liveAudienceHeaderView.numStr.intValue + 1];
        self.liveManagerHearderView.numStr = [NSString stringWithFormat:@"%lld",self.popularityNum];
    }else if(msg.event == MsgTypeOffline){
//        有人下线
        NSMutableArray *temArr = self.onlineUsersArr.mutableCopy;
        if(temArr.count > 0){
            if(msg.userId.longLongValue <= 5000000000){
                for (MZOnlineUserListModel *user in temArr) {
                    if([user.uid isEqualToString:msg.userId]){
                        [self.onlineUsersArr removeObject:user];
                        self.liveAudienceHeaderView.userArr = self.onlineUsersArr;
                    }
                }
            }
        }
        self.liveAudienceHeaderView.numStr = [NSString stringWithFormat:@"%d",self.liveAudienceHeaderView.numStr.intValue - 1];
        [_chatView addChatData:msg];
    }else if(msg.event == MsgTypeOtherChat || msg.event == MsgTypeMeChat){
        if([self.playInfo.chat_uid isEqualToString:msg.userId]){
            msg.event = MsgTypeMeChat;
            return;
        }else{
            [_chatView addChatData:msg];
        }
        
    }else if (msg.event == MsgTypeGoodsUrl){//推广商品
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
            self.spreadTipGoodsView = [[MZTipGoodsView alloc]initWithFrame:CGRectMake(18*MZ_RATE, self.chatView.frame.origin.y+self.chatView.frame.size.height + 3*MZ_RATE, 185*MZ_RATE, 60*MZ_RATE)];
            
            self.spreadTipGoodsView.alpha = 0;
            self.spreadTipGoodsView.goodsListModelArr = [NSMutableArray array];
            [self addSubview:self.spreadTipGoodsView];
            [self.spreadTipGoodsView.goodsListModelArr addObject:goodsListModel];
            [self spreadTipGoodsViewDidShow];
        }else{
            self.spreadTipGoodsView.frame=CGRectMake(18*MZ_RATE, self.chatView.frame.origin.y+self.chatView.frame.size.height + 3*MZ_RATE, 185*MZ_RATE, 60*MZ_RATE);
            if(self.spreadTipGoodsView.isEnd){
                 [self.spreadTipGoodsView.goodsListModelArr addObject:goodsListModel];
                [self spreadTipGoodsViewDidShow];
            }
        }
    }else if (msg.event == MsgTypeLiveOver){//中途结束
        self.unusualTipView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200*MZ_RATE, 56*MZ_RATE)];
        self.unusualTipView.backgroundColor = MakeColorRGBA(0x000000, 0.6);
        self.unusualTipView.textAlignment = NSTextAlignmentCenter;
        self.unusualTipView.textColor = MakeColorRGB(0xffffff);
        self.unusualTipView.font = [UIFont systemFontOfSize:20*MZ_RATE];
        self.unusualTipView.text = @"主播暂时离开，\n稍等一下马上回来";
        self.unusualTipView.numberOfLines = 2;
        [self addSubview:self.unusualTipView];
        self.unusualTipView.center = self.center;
    }else if (msg.event == MsgTypeDisableChat){
        if(self.playInfo.chat_uid.intValue  == msg.data.disableChatUserID.intValue){
            self.bottomTalkBtn.isBanned = YES;
        }
    }else if (msg.event == MsgTypeAbleChat){
        if(self.playInfo.chat_uid.intValue  == msg.data.ableChatUserID.intValue){
            self.bottomTalkBtn.isBanned = NO;
        }
    }
    
}

-(void)spreadTipGoodsViewDidShow
{
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
    self.popularityNum = self.playInfo.popular.intValue;
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
        [UsersUrlMArray addObject:model];
    }
    self.onlineUsersArr = UsersUrlMArray;
    self.liveAudienceHeaderView.userArr = UsersUrlMArray;
}

@end
