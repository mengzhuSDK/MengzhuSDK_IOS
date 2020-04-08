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
@property (nonatomic ,strong) UIView *blackContainerView;
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
//   5 销毁播放器
}
#pragma mark - View Helper

-(void)setupUI
{
    
//    初始化带UI的播放器View
    self.playerControlView = [[MZPlayerControlView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.playerControlView];
    //    设置代理接收回调
    self.playerControlView.playerDelegate = self;
    
    if (self.mvURLString.length) {
        // 走播放本地视频的逻辑
        [self.playerControlView playVideoWithLocalMVURLString:self.mvURLString];

    } else {
        //    选择播放的ID
        [self.playerControlView playVideoWithLiveIDString:self.ticket_id];
    }
//    保存用户数据
//    self.playerControlView.UserUID = [MZUserServer currentUser].userId;
//    self.playerControlView.UserName = [MZUserServer currentUser].nickName;
//    self.playerControlView.UserAvatar = [MZUserServer currentUser].avatar;
}



//toast提示 测试使用
-(void)sv_showMessage:(NSString*)message;{
    if (self.blackContainerView) {
        [self sv_dismissProgressView];
    }
    NSArray *wins=[UIApplication sharedApplication].windows;
    UIWindow *keyWindow = [wins objectAtIndex:0];
    UIView *blackContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 152*MZ_RATE, 44*MZ_RATE)];
    blackContainerView.backgroundColor = MakeColorRGBA(0x000000, 0.8);
    [blackContainerView roundChangeWithRadius:10*MZ_RATE];
    [keyWindow addSubview:blackContainerView];
    blackContainerView.center = keyWindow.center;
    self.blackContainerView = blackContainerView;
    
    UILabel *infoLabel = [[UILabel alloc] init];
    [blackContainerView addSubview:infoLabel];
    infoLabel.font = [UIFont systemFontOfSize:16*MZ_RATE];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.text = message;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.frame = blackContainerView.bounds;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sv_dismissProgressView];
    });
}
-(void)sv_dismissProgressView;{
    if (self.blackContainerView) {
        [self.blackContainerView removeFromSuperview];
        self.blackContainerView = nil;
    }
}


#pragma mark - 播放器代理
- (void)closeButtonDidClick:(id)playInfo{
    [self.playerControlView playerShutDown];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)avatarDidClick:(id)playInfo{
     NSLog(@"%s",__func__);
    [self sv_showMessage:@"头像点击--国民实现"];
}
-(void)reportButtonDidClick:(id)playInfo{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"举报点击--国民实现"];
}
-(void)shareButtonDidClick:(id)playInfo{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"分享点击--国民实现"];
}
-(void)likeButtonDidClick:(id)playInfo{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"点赞点击--国民实现"];
}
-(void)onlineListButtonDidClick:(id)playInfo{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"在线人数--国民实现"];
}
-(void)shoppingBagDidClick:(id)playInfo{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"购物点击--国民实现"];
}

-(void)attentionButtonDidClick:(id)playInfo{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"关注点击--国民实现"];
}

-(void)chatUserDidClick:(id)playInfo{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"聊天用户点击--国民实现"];
}
-(void)goodsItemDidClick:(MZGoodsListModel *)GoodsListModel;{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"商品点击--国民实现"];
}
-(void)chatUserHeaderDidClick:(MZLongPollDataModel *)GoodsListModel;{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"聊天点击--国民实现"];
}
-(void)playerNotLogin{
    NSLog(@"%s",__func__);
    [self sv_showMessage:@"未登录--国民实现"];
}
-(void)newMsgCallback:(MZLongPollDataModel *)msg{
     if(msg.event == MsgTypeOnline){//上线消息
            
     }else if(msg.event == MsgTypeOffline){//下线消息
    //
     }else if(msg.event == MsgTypeOtherChat || msg.event == MsgTypeMeChat){//文本消息
            
     }else if (msg.event == MsgTypeGoodsUrl){//推广商品
           
     }else if (msg.event == MsgTypeLiveOver){//主播暂时离开
           
     }else if (msg.event == MsgTypeLiveReallyEnd){//直播结束
           
     }else if (msg.event == MsgTypeDisableChat){//用户禁言
            
     }else if (msg.event == MsgTypeAbleChat){//取消禁言
            
     }
}




//-(void)loginUpdate{
//    MZUser *user=[MZUserServer currentUser];
//    user.avatar=@"https://upload.jianshu.io/users/upload_avatars/2640663/d6f196c2717c?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96/format/webp";
//        user.nickName=@"22222";
//        user.accountNo = @"GM20181202092745000830";
//        [MZUserServer updateCurrentUser:user];
//    if(self.playerControlView){
//        [self.playerControlView updatePlayInfo];
//    }
//}

@end
