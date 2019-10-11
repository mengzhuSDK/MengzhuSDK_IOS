//
//  ViewController.m
//  MZLiveSDK
//
//  Created by 孙显灏 on 2018/10/17.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import "ViewController.h"
#import "TestLiveStream.h"
#import "PushViewController.h"
#import "PlayerViewController.h"
#import "MZVerticalPlayerVC.h"
#import "Constant.h"
#import "MZGoodsListView.h"


@interface ViewController ()<MZChatKitDelegate>{
    UIButton *pushBtn;
    UIButton *playerBtn;
    UIButton *playerViewBtn;
    MZPlayerManager *manager;
    
}
@property(nonatomic,strong)MZChatKitManager *chatManager;
@property (nonatomic, strong) TestLiveStream *testVideoCapture;
@property (nonatomic ,strong) UITextView *liveIDTextView;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationbar];
}

- (void)setNavigationbar{
    self.navigationItem.title = @"SDKdemo";
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
////    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, NavY, screenRect.size.width, NavH)];
////    //创建UINavigationItem
////    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"SDKdemo"];
////    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
////
////    [self.view addSubview: navigationBar];
////
////
////    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self)weakSelf = self;
    MZSDKInitManager* manager=[MZSDKInitManager sharedManager];
    self.chatManager=[[MZChatKitManager alloc]init];
    self.chatManager.delegate=self;
    
    MZUser *user=[[MZUser alloc]init];
    user.userId=@"2095938";
    user.appID=@"2019091711154563239";
    user.avatar=@"https://avatars3.githubusercontent.com/u/13464940?s=60&v=4";
    user.nickName=@"test";
    [MZUserServer updateCurrentUser:user];
    
    [manager initSDK:MZ_ONLINE_TYPE token:@"f117526418fd24b3294aca1ed0c2b896_156136291484092_1566301110" success:^(id responseObject) {
      
        NSLog(@"%d",manager.isPassValidation);
    } failure:^(NSError *error) {
        NSLog(@"%@",manager.errorMsg);
    }];
    __weak typeof(self)WeakSelf = self;
    [MZSDKBusinessManager reqPlayInfo:MZ_DefailtTicket_id success:^(MZMoviePlayerModel* responseObject) {
        MZMoviePlayerModel* model=responseObject;
//        NSLog(model.channel_name);
//        [MZSDKBusinessManager reqChatHistoryWith:MZ_DefailtTicket_id offset:1 limit:1 last_id:0 success:^(id responseObject) {
//            [weakSelf.chatManager startTimelyChar:model.ticket_id receive_url:model.chat_config.receive_url srv:model.msg_config.msg_online_srv token:model.msg_config.msg_token];
//        } failure:^(NSError *error) {
//            NSLog(@"");
//        }];
        
    } failure:^(NSError *error) {
        
    }];
//    pushBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, NavY+NavH+100, self.view.bounds.size.width, 40)];
//    [pushBtn setTitle:@"推流" forState:UIControlStateNormal];
//    [pushBtn addTarget:self action:@selector(onPushClick) forControlEvents:UIControlEventTouchDown];
//    [pushBtn setBackgroundColor:[UIColor blueColor]];
//    [self.view addSubview:pushBtn];
//    playerBtn=[[UIButton alloc]initWithFrame:CGRectMake(pushBtn.frame.origin.x, pushBtn.frame.origin.y+pushBtn.frame.size.height+30+100, self.view.bounds.size.width, 40)];
//    [playerBtn setTitle:@"播放" forState:UIControlStateNormal];
//    [playerBtn setBackgroundColor:[UIColor blueColor]];
//    [playerBtn addTarget:self action:@selector(onPlayerClick) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:playerBtn];
    
    self.liveIDTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 200, self.view.bounds.size.width, 40)];
    self.liveIDTextView.backgroundColor = [UIColor cyanColor];
    self.liveIDTextView.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.liveIDTextView];
    self.liveIDTextView.text = @"10008540";
    
    playerViewBtn=[[UIButton alloc]initWithFrame:CGRectMake(playerBtn.frame.origin.x, playerBtn.frame.origin.y+playerBtn.frame.size.height+30+100, self.view.bounds.size.width, 40)];
    [playerViewBtn setTitle:@"基础播放器" forState:UIControlStateNormal];
    [playerViewBtn setBackgroundColor:[UIColor blueColor]];
    [playerViewBtn addTarget:self action:@selector(onPlayerViewClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playerViewBtn];
    playerViewBtn.center = self.view.center;
    UIButton * goodsListView= [[UIButton alloc]initWithFrame:CGRectMake(playerViewBtn.frame.origin.x, playerViewBtn.frame.origin.y+ playerViewBtn.frame.size.height, playerViewBtn.frame.size.width, playerViewBtn.frame.size.height)];
    [goodsListView setTitle:@"商品列表" forState:UIControlStateNormal];
    [goodsListView setBackgroundColor:[UIColor blueColor]];
    [goodsListView addTarget:self action:@selector(goodsListDidClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:goodsListView];
    
    UIButton *userListView =[[UIButton alloc]initWithFrame:CGRectMake(goodsListView.frame.origin.x, goodsListView.frame.origin.y+goodsListView.frame.size.height, goodsListView.frame.size.width, goodsListView.frame.size.height)];
    
    [userListView setTitle:@"观众列表" forState:UIControlStateNormal];
    [userListView setBackgroundColor:[UIColor blueColor]];
    [userListView addTarget:self action:@selector(userListDidClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:userListView];
    
//    [manager play];
    
}

-(void)userListDidClick
{
    [MZSDKBusinessManager reqGetUserList:MZ_DefailtTicket_id offset:1 limit:1 success:^(id responseObject) {
        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

-(void)goodsListDidClick
{
    [MZSDKBusinessManager reqGoodsList:MZ_DefailtTicket_id offset:1 limit:50 success:^(id responseObject) {
        MZGoodsListOuterModel *goodsListOuterModel = (MZGoodsListOuterModel *)responseObject;
        MZGoodsListView *goodsListView = [[MZGoodsListView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, MZTotalScreenHeight)];
        [goodsListView.dataArr addObjectsFromArray:goodsListOuterModel.list];
        [self.view addSubview:goodsListView];
        
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.testVideoCapture onLayout];
}

-(void)onPlayerClick{
    [self.navigationController pushViewController:[[PlayerViewController alloc]init]  animated:YES];
}
-(void)onPlayerViewClick{
    if (self.liveIDTextView.text.length == 0) {
        
        return;
    }
    MZVerticalPlayerVC *liveVC = [[MZVerticalPlayerVC alloc]init];
    liveVC.liveIDString = self.liveIDTextView.text;
    [self.navigationController pushViewController:liveVC  animated:YES];

}


-(void)onPushClick{
    [self.navigationController pushViewController:[[PushViewController alloc]init] animated:YES];
    
}

/*!
 直播时参会人数发生变化
 */
-(void)activityOnlineNumberdidchange:(NSString * )onlineNo{
    NSLog(@"%@",onlineNo);
}
/*!
 直播时礼物数发生变化
 */
-(void)activityOnlineNumGiftchange:(NSString *)onlineGiftMoney{
    NSLog(@"%@",onlineGiftMoney);
}
/*!
 直播时收到一条新消息
 */
-(void)activityGetNewMsg:(MZLongPollDataModel * )msg{
    NSLog(@"%@",msg.userName);
}

@end
