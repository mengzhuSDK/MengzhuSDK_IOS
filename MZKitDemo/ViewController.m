//
//  ViewController.m
//  MZLiveSDK
//
//  Created by 孙显灏 on 2018/10/17.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import "ViewController.h"
#import "MZVerticalPlayerVC.h"

@interface ViewController (){
    UIButton *pushBtn;
    UIButton *playerBtn;
    UIButton *playerViewBtn;
//    MZPlayerManager *manager;
    
}
//@property(nonatomic,strong)MZChatKitManager *chatManager;
@property (nonatomic ,strong) UITextView *ticket_IDTextView;
@property (nonatomic ,strong) UITextView *UIDTextView;
@property (nonatomic ,strong) UITextView *nameTextView;
@property (nonatomic ,strong) UITextView *avatarTextView;
@property (nonatomic ,strong) UITextView *accountNoTextView;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationbar];
    [MZUserServer signOutCurrentUser] ;
}

- (void)setNavigationbar{
    self.navigationItem.title = @"SDKdemo";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customAddSubviews];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)customAddSubviews{
    
    playerViewBtn=[[UIButton alloc]initWithFrame:CGRectMake(playerBtn.frame.origin.x, playerBtn.frame.origin.y+playerBtn.frame.size.height+500, self.view.bounds.size.width, 40)];
    [playerViewBtn setTitle:@"基础播放器" forState:UIControlStateNormal];
    [playerViewBtn setBackgroundColor:[UIColor blueColor]];
    [playerViewBtn addTarget:self action:@selector(onPlayerViewClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playerViewBtn];

//  输入框
    
    UILabel *tipL1 = [[UILabel alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 90, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL1];
    tipL1.text = @"ticket_ID";
    
    self.ticket_IDTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 110, self.view.bounds.size.width, 30)];
    self.ticket_IDTextView.backgroundColor = [UIColor cyanColor];
    self.ticket_IDTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.ticket_IDTextView];
    self.ticket_IDTextView.text = @"10008683";
    
    UILabel *tipL2 = [[UILabel alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 140, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL2];
    tipL2.text = @"观众信息：UID";
    self.UIDTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 160, self.view.bounds.size.width, 30)];
    self.UIDTextView.backgroundColor = [UIColor cyanColor];
    self.UIDTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.UIDTextView];
    self.UIDTextView.text = @"2095938";
    
    UILabel *tipL3 = [[UILabel alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 190, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL3];
    tipL3.text = @"观众信息：NAME";
    self.nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 210, self.view.bounds.size.width, 30)];
    self.nameTextView.backgroundColor = [UIColor cyanColor];
    self.nameTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.nameTextView];
    self.nameTextView.text = @"观众名称";
    
    UILabel *tipL4 = [[UILabel alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 240, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL4];
    tipL4.text = @"观众信息：AVATAR";
    self.avatarTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 260, self.view.bounds.size.width, 30)];
    self.avatarTextView.backgroundColor = [UIColor cyanColor];
    self.avatarTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.avatarTextView];
    self.avatarTextView.text = @"https://cdn.duitang.com/uploads/item/201410/26/20141026191422_yEKyd.thumb.700_0.jpeg";
    
    UILabel *tipL5 = [[UILabel alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 290, self.view.bounds.size.width, 20)];
    [self.view addSubview:tipL5];
    tipL5.text = @"accountNo：";
    self.accountNoTextView = [[UITextView alloc] initWithFrame:CGRectMake(playerBtn.frame.origin.x, 310, self.view.bounds.size.width, 30)];
    self.accountNoTextView.text = @"GM20181202092638000826";
    self.accountNoTextView.backgroundColor = [UIColor cyanColor];
    self.accountNoTextView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.accountNoTextView];
}


-(void)onPlayerViewClick{
    if (self.ticket_IDTextView.text.length == 0) {
        
        return;
    }
    MZUser *user=[[MZUser alloc]init];
    user.userId = self.UIDTextView.text;
//    user.appID=@"2019101019585068343";//t环境
    user.appID = @"";//线上模拟环境(这里需要自己填一下)
//    user.secretKey = @"xEyRRg4QYWbk09hfRJHYHeKPv8nWZITlBiklc44MZCxbdk4E6cGVzrXve6iVaNBn";
    user.secretKey = @"";
    user.avatar=self.avatarTextView.text;
    user.nickName=self.nameTextView.text;
    user.accountNo = self.accountNoTextView.text;
    [MZUserServer updateCurrentUser:user];
    
    MZVerticalPlayerVC *liveVC = [[MZVerticalPlayerVC alloc]init];
    liveVC.ticket_id = self.ticket_IDTextView.text;
    [self.navigationController pushViewController:liveVC  animated:YES];

}

@end
