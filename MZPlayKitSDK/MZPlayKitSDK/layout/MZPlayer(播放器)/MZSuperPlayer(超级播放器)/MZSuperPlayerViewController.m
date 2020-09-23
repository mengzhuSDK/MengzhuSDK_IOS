//
//  MZSuperPlayerViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/7.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZSuperPlayerViewController.h"
#import "MZSuperPlayerView.h"
#import "UIView+MZPlayPermission.h"

@interface MZSuperPlayerViewController ()<MZSuperPlayerViewDelegate>
@property (nonatomic, assign) BOOL isLandSpace;//横竖屏记录,默认竖屏
@property (nonatomic, strong) MZSuperPlayerView *superPlayerView;
@end

@implementation MZSuperPlayerViewController

- (void)dealloc {
    NSLog(@"播放器的viewController释放");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.superPlayerView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 检测是否有权限观看此视频
    [self.view checkPlayPermissionWithTicketId:self.ticket_id phone:[MZBaseUserServer currentUser].phone success:^(BOOL isPermission) {
        if (isPermission) {
            [self.view addSubview:self.superPlayerView];
            [self.superPlayerView playVideoWithLiveIDString:self.ticket_id];
        }
    } cancelButtonClick:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 懒加载
- (MZSuperPlayerView *)superPlayerView {
    if (!_superPlayerView) {
        _superPlayerView = [[MZSuperPlayerView alloc] initWithFrame:self.view.bounds];
        _superPlayerView.delegate = self;
    }
    return _superPlayerView;
}

#pragma mark - MZSuperPlayerViewDelegate
/**
 * @brief 关闭按钮点击
 */
- (void)closeButtonDidClick:(id)playInfo {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * @brief 主播头像点击
 */
- (void)avatarDidClick:(MZHostModel *)hostModel {
    [self.view show:@"主播头像点击"];
}
/**
* @brief 获取到主播信息
*/
- (void)updateHostUserInfo:(MZHostModel *)hostModel {
    NSLog(@"获取到了主播信息 = %@ - %@ - %@",hostModel.nickname,hostModel.uid,hostModel.unique_id);
}
/**
 * @brief 举报点击
 */
- (void)reportButtonDidClick:(id)playInfo {
    [self.view show:@"举报按钮点击"];
}
/**
 * @brief 弹幕开关按钮点击
 */
- (void)showBarrageDidClick:(BOOL)isShow {
    [self.view show:(isShow ? @"弹幕已打开" : @"弹幕已关闭")];
}
/**
 * @brief 分享点击
*/
- (void)shareButtonDidClick:(id)playInfo {
    [self.view show:@"分享按钮点击"];
}
/**
 * @brief 点赞点击
 */
- (void)likeButtonDidClick:(id)playInfo {

}
/**
 * @brief 在线用户列表点击
*/
- (void)onlineListButtonDidClick:(id)playInfo{
    [self.view show:@"在线用户列表点击"];
}
/**
 * @brief 某一个在线用户的信息点击
*/
- (void)onlineUserInfoDidClick:(id)onlineUserInfo {
    [self.view show:@"点击一个在线用户"];
}
/**
 * @brief 商品袋点击
 */
- (void)shoppingBagDidClick:(id)playInfo {
    [self.view show:@"商品袋点击"];
}
/**
 * @brief 关注点击
 */
- (void)attentionButtonDidClick:(id)playInfo {
    [self.view show:@"关注按钮点击"];
}
/**
 * @brief 商品点击
 */
- (void)goodsItemDidClick:(MZGoodsListModel *)GoodsListModel {
    [self.view show:@"商品点击"];
}
/**
 * @brief 聊天头像点击事件
 */
- (void)chatUserHeaderDidClick:(MZLongPollDataModel *)GoodsListModel {
    [self.view show:@"聊天用户头像点击"];
}
/**
 * @brief 未登录回调
 */
- (void)playerNotLogin {
    [self.view show:@"用户未登录"];
}
/**
 * @brief 收到一条新消息
 */
- (void)newMsgCallback:(MZLongPollDataModel * )msg {
    if (msg.event == MsgTypeOnline) {//上线消息
        
    } else if(msg.event == MsgTypeOffline) {//下线消息
        //
    } else if(msg.event == MsgTypeOtherChat || msg.event == MsgTypeMeChat) {//文本消息
        
    } else if (msg.event == MsgTypeGoodsUrl) {//推广商品
        
    } else if (msg.event == MsgTypeLiveOver) {//主播暂时离开
        
    } else if (msg.event == MsgTypeLiveReallyEnd) {//直播结束
        
    } else if (msg.event == MsgTypeDisableChat) {//用户禁言
        
    } else if (msg.event == MsgTypeAbleChat) {//取消禁言
        
    }
}

/// 收到某个用户被踢出的消息
- (void)newMsgForKickoutOneUser:(MZLongPollDataModel *)msg {

}

/**
 * @brief 播放按钮点击
 */
- (void)playerPlayClick:(BOOL)isPlay {
    NSLog(@"点击播放按钮，是否播放 = %d",isPlay);
}
/**
 * @brief 快进退 进度回调
 */
- (void)playerSeekProgress:(NSTimeInterval)progress {
    NSLog(@"playerSeekProgress---%f",progress);
}
/**
 * @brief 快进退 手势回调
 */
- (void)playerSeekLocation:(float)location {
    NSLog(@"playerSeekLocation---%f",location);
}
/**
 * @brief 声音大小手势回调
 */
- (void)playerVoiceSize:(float)size {
    NSLog(@"playerVoiceSize---%f",size);
}
/**
 * @brief 亮度手势回调
 */
- (void)playerLuminance:(float)luminance {
    NSLog(@"playerLuminance---%f",luminance);
}
/**
 * @brief 是否显示下方工具栏
 */
- (void)isPlayToolsShow:(BOOL)isShow {
    NSLog(@"isPlayToolsShow---%d",isShow?1:0);

}
/**
 * @brief 全屏/非全屏切换
 */
- (void)playerView:(MZMediaPlayerView *)player fullscreen:(BOOL)fullscreen {
    self.isLandSpace = fullscreen;
}
/**
 * @brief 活动菜单的点击
 */
- (void)activityMenuClickWithIndex:(NSInteger)index {
    NSLog(@"点击的活动菜单索引为 %ld",index);

    switch (index) {
        case 0:
        {
            break;
        }
        case 1:
        {
            break;
        }
        case 2:
        {
            break;
        }
        case 3:
        {
            break;
        }
        case 4:
        {
            break;
        }
        default:
            break;
    }
}

/**
 * @brief 点击了投屏的帮助按钮
 */
- (void)DLNAHelpClick {
    NSLog(@"点击了投屏帮助按钮");
    [self.view show:@"点击了帮助按钮"];
}

/**
 开始播放状态回调
 */
- (void)loadStateDidChange:(MZMPMovieLoadState)type {
//    NSLog(@"开始播放状态变换 - %lu",(unsigned long)type);
}
/**
 播放中状态回调
 */
- (void)moviePlayBackStateDidChange:(MZMPMoviePlaybackState)type {
    NSLog(@"播放中状态变换 - %ld",(long)type);
}
/**
 播放结束状态 包含异常停止
 */
- (void)moviePlayBackDidFinish:(MZMPMovieFinishReason)type {
    NSLog(@"播放停止，状态为 - %ld",(long)type);
}
/**
 准备播放完成
 */
- (void)mediaIsPreparedToPlayDidChange {
    NSLog(@"准备播放完成");
}
/**
 * 播放失败
 */
- (void)playerViewFailePlay:(MZMediaPlayerView *)player {
    NSLog(@"播放失败");
}

#pragma mark - 横竖屏控制
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.isLandSpace) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setIsLandSpace:(BOOL)isLandSpace {
    _isLandSpace = isLandSpace;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget: [UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationPortrait;
        if (_isLandSpace) val = UIInterfaceOrientationLandscapeRight;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
