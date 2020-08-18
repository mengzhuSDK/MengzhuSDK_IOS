//
//  MZVideoBaseView.h
//  MengZhu
//
//  Created by 李伟 on 2018/8/13.
//  Copyright © 2018年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZSlider.h"
#import "MZBarrageBgView.h"
#import "MZPlayerScrollCoverView.h"
#import "MZMovieCoverPageControl.h"
#import "MZMovieBottonBarView.h"

typedef NS_ENUM(NSInteger, MZPlayerViewEventStatue) {
    MZPlayerView_unknow,
    MZPlayerView_V_hostHeadBtnClicked,       //竖屏播主头像点击
    MZPlayerView_V_onlineBtnClicked,         //竖屏在线人数点击
    MZPlayerView_V_fullscreenBtnClicked,     //竖屏全屏按钮点击
    VHPlayerView_V_feedBackBtnClicked,       //竖屏反馈按钮点击
    MZPlayerView_Back_Clicked,              //横屏情况下返回按钮点击
    MZPlayerView_UnFullBack_Clicked,        //竖屏点击返回
    MZPlayerView_V_rateBtnClick,           //竖屏情况下倍速播放按钮点击
    //全屏
    MZPlayerView_closeFullScreenBtnClicked,  //全屏关闭按钮点击 必须旋转为竖屏
    VHPlayerView_feedBackBtnClicked,         //全屏反馈按钮点击 必须旋转为竖屏
    MZPlayerView_PayBtnClicked,              //全屏打赏按钮点击 必须旋转为竖屏
    MZPlayerView_GiftBtnClicked,              //全屏礼物按钮点击 必须旋转为竖屏
    MZPlayerView_hostHeadBtnClicked,         //全屏播主头像点击
    MZPlayerView_chatHeadBtnClicked,         //全屏聊天头像点击 withData:(NSString*)userID
    MZPlayerView_onlineBtnClicked,           //全屏在线人数点击
    MZPlayerView_talkBtnClicked,             //全屏聊天按钮点击
    MZPlayerView_DLNABtnClicked,             //竖屏投屏按钮点击事件
    MZPlayerView_FullDLNABtnClicked,         //横屏投屏按钮点击事件
    MZPlayerView_clearScreenBtnClicked,             //竖屏清屏按钮点击事件
    MZPlayerView_FullclearScreenBtnClicked,         //横屏清屏按钮点击事件
    MZPlayerView_talkToBtnClicked,           //全屏聊天信息点击 回复某人
    MZPlayerView_likeBtnClicked,             //全屏点赞按钮点击
    MZPlayerView_sendTalkMsg,                //发送聊天信息     withData:(NSString*)@"聊天内容"
    
    //播放器事件
    MZPlayerView_playbackTime,               //回放当前时间回调 用于确定当前ppt播放器位置 withData:(NSNumber*) Double
    MZPlayerView_reTryPlay,                  //播放超时重试
    MZPlayerView_noStream,                   //没有流 isHaveStream @1没有流 @0有流
    MZPlayerView_streamError,                 //没有流 音视频流出错结束 可能是切换小助手导致，用于HLS直播
    MZPlayerView_Pay_for_video,             //付费观看
    MZPlayerView_Pay_for_member,             //开通会员
    MZPlayerView_Input_Password,                 //输入密码
    MZPlayerView_Input_FCode,                   //F码
    MZPlayerView_Switch_Video,                  //切换观看其它回放
    MZPlayerView_Video_Finish,                  // 视频结束
    MZPlayerView_Video_Play,                  //点击播放按钮
    MZPlayerView_Video_Pause,                  //点击暂停按钮
    MZPlayerView_RelayBtn,                     //点击转播按钮
    MZPlayerView_ReplayClick,                     //点击重新播放按钮
    MZPlayerView_VideoPageClick,               //点击播放器的空间显示隐藏的时间
    MZPlayerView_ChatRedBagClick,             //点击横屏聊天区域的事件
    MZPlayerView_ChatVisitRedBagClick,         //点击横屏名片红包的事件
    MZPlayerView_FullReportClicked,            //举报按钮点击事件
    MZPlayerView_FullLikeClicked,            //点赞按钮点击事件
    MZPlayerView_FullShareClicked,            //分享按钮点击事件
    MZPlayerView_VideoPlayHistory,            //继续观看历史记录
};
@protocol MZPlayerViewDelegate <NSObject>

- (void)playerViewEventType:(MZPlayerViewEventStatue) type WithData:(id)data userName:(NSString *)userName joinID:(NSString *)joinID;
@end

@interface MZVideoBaseView : UIView
@property (nonatomic,assign) BOOL isLive;//是否是直播
@property (nonatomic,assign) int playStatue;//0 未开播，1直播 2回放
@property (nonatomic,assign) float playBackRate;//播放速率
@property (nonatomic,assign) BOOL isVoice;
@property (nonatomic,assign) BOOL isStopPage;
@property (nonatomic,assign) BOOL isLiveFinish;
@property (nonatomic,assign) BOOL isMoving;//手势是否在移动
@property (nonatomic,assign) BOOL isNoStream;  //是否没有音视频流
@property (nonatomic,assign) BOOL isOver;//是否播放完成
@property (nonatomic,assign) BOOL isfullscreen;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) float fadeDelay;//停留时间
//@property (nonatomic,assign) BOOL isChannelPlayer;

@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic, strong) NSTimer   *durationTimer;//定时器
@property (nonatomic, assign) NSTimeInterval    recordTime;
@property (nonatomic, assign,readwrite)NSTimeInterval     currentPlayTime;

@property (nonatomic ,strong)UIView *playerShowView;//播放器显示视频的view
@property (nonatomic, strong) UIButton *playPauseBtn;//播放暂停按钮（小）
//@property (nonatomic,strong) UIButton *moviePauseView;//暂停按钮（大）
@property (nonatomic,strong) MZPlayerScrollCoverView *videoCoverView;//视频封面
@property (nonatomic ,strong)UIView *fullScreenTopBar;
@property (nonatomic ,strong)MZMovieBottonBarView *fullScreenBottomBar;
@property (nonatomic ,strong)UIView *topBar;
@property (nonatomic ,strong)UIButton *fullScreenBackButton;
@property (nonatomic ,strong)MZMovieBottonBarView *bottomBar;

@property (nonatomic ,strong)UIView *fullRightFuctionView;//右侧功能view
@property (nonatomic ,strong)UIView *rightFuctionView;//右侧功能view
@property (nonatomic ,strong)UIView *fullLeftFuctionView;//左侧功能view
@property (nonatomic ,strong)UIView *leftFuctionView;//左侧功能view
@property (nonatomic ,strong)UIView *fullContentView;//横屏容器view
@property (nonatomic ,strong)UIView *contentView;//竖屏容器view
@property (nonatomic ,strong)MZPlayerScrollCoverView *coverImageView;//竖屏封面view
@property (nonatomic ,strong)MZMovieCoverPageControl *coverPageControl;

@property (nonatomic,strong)UIActivityIndicatorView     *windowLoadingView;
@property (nonatomic, strong) UILabel  *timeElapsedLabel;//播放时间的label
@property (nonatomic, strong) UILabel  *timeRemainingLabel;//剩余时间的label
//@property (nonatomic ,strong) UIButton *backButton;//返回按钮去
@property (nonatomic ,strong)UIButton *unfullscreenBtn;
@property (nonatomic ,strong)UIButton *fullscreenBtn;

@property (nonatomic ,strong)MZSlider *durationSlider;//进度条
@property (nonatomic,strong) UIView   *fastAndSlowBackView; //拖动进度显示View
@property (nonatomic ,strong)UIView *retryView;
@property(nonatomic,weak) id<MZPlayerViewDelegate>  delegate;
@property (nonatomic, assign)BOOL isNotchScreen;//是否是全面屏齐刘海
@property (nonatomic ,strong)MZBarrageBgView *barrageBgView;
@property (nonatomic, strong) UILabel *preventRecordScreenLabel;// 防录屏label
@property (nonatomic ,assign)BOOL isShowDeRecordL;//是否展示防录屏

- (void)removeAllErrorView;
-(void)startPlayWithUrl:(NSString *)url coverArr:(NSArray *)coverArr isLive:(BOOL)isLive isVoice:(BOOL)isVoice;//开始播放（不同源）
-(void)startPlayWithUrl:(NSString *)url coverArr:(NSArray *)coverArr isLive:(BOOL)isLive isVoice:(BOOL)isVoice pause:(BOOL)pause;//开始播放最初状态为暂停

-(void)setupPlayAttribute;//重新播放（从头再播一遍）
-(void)begainPlayer;
- (void)playerControllerPlay;
/*
 *是否有全屏暂停按钮的暂停页面
 */
- (void)playerControllerPauseWithIsHavePauseBtn:(BOOL)isHavePauseBtn;

/*
 *播放停止
 */
- (void)playerControllerStop;
/*
 * 销毁播放器
 */
- (void)destroyPlayer;
/*
 * 展示活动封面，调用这个方法后，无论视频什么状态，都会展示封面
 */
-(void)showCoverImage;

-(void)networkStatusChanged:(NSNotification *)notice;
- (void)startDurationTimer;//开始定时器
- (void)stopDurationTimer;//停止定时器

-(void)seekToSection:(int)seconds;

- (void)bufferStart:(NSDictionary*)info;

- (void)bufferStop: (NSDictionary*)info;

-(void)addMovieNotifications;

- (void)hideControls:(void(^)(void))completion;

-(void)onlyShowBackBtn;

-(void)removeNotifications;

-(void)layoutAllViewInMoviePlayer;

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime;//计时器方法
@end
