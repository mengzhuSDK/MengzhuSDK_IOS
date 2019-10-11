//
//  MZVerticalPlayerVC.m
//  MZKitDemo
//
//  Created by LiWei on 2019/9/26.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZVerticalPlayerVC.h"
#import "MZPopView.h"
#import "MZPlayerControlView.h"

@interface MZVerticalPlayerVC ()<MZPlayerControlViewProtocol>
@property (nonatomic ,strong) MZPlayerControlView *playerControlView;
@end

@implementation MZVerticalPlayerVC

#pragma mark - View LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseProperty];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupUI];
   
}
- (void)setBaseProperty{
    self.view.backgroundColor = [UIColor grayColor];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    销毁播放器
    [self.playerControlView playerShutDown];
}
#pragma mark - View Helper

-(void)setupUI
{
//    初始化带UI的播放器View
    self.playerControlView = [[MZPlayerControlView alloc] initWithFrame:self.view.bounds];
//    设置代理接收回调
    self.playerControlView.playerDelegate = self;
    [self.view addSubview:self.playerControlView];
//    选择播放的ID
    [self.playerControlView playVideoWithLiveIDString:self.liveIDString];
    
}

-(void)showKickOutView{
   
    MZPopView *popView = [[MZPopView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:popView];
    
    popView.clickBlock = ^(id info) {
        if ([info isKindOfClass:[NSString class]]) {
//            获取资格
             NSLog(@"%@",info);
            [self huoququanxian];
        }
        if ([info isKindOfClass:[NSArray class]]) {
            //            举报信息
            
        }
    };
    popView.viewType = MZPopViewKickOut;
}
-(void)huoququanxian{
     NSLog(@"%s",__FUNCTION__);
}

#pragma mark - 播放器代理
- (void)closeButtonDidClick:(id)playInfo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)avatarDidClick:(id)playInfo;{
     NSLog(@"%s",__func__);
}
-(void)reportButtonDidClick:(id)playInfo;{
    NSLog(@"%s",__func__);
}
-(void)shareButtonDidClick:(id)playInfo;{
    NSLog(@"%s",__func__);
}
-(void)likeButtonDidClick:(id)playInfo;{
    NSLog(@"%s",__func__);
}
-(void)onlineListButtonDidClick:(id)playInfo;{
    NSLog(@"%s",__func__);
}
-(void)shoppingBagDidClick:(id)playInfo;{
    NSLog(@"%s",__func__);
}
//
-(void)attentionButtonDidClick:(id)playInfo;{
    NSLog(@"%s",__func__);
}

-(void)chatUserDidClick:(id)playInfo;{
    NSLog(@"%s",__func__);
}



@end
