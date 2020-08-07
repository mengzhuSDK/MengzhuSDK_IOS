//
//  MZSuperPlayerView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/8.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZBaseView.h"
#import "MZPlayManagerHeaderView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MZSuperPlayerViewDelegate <NSObject>
@optional
/**
 * @brief 关闭按钮点击
 */
- (void)closeButtonDidClick:(id)playInfo;
/**
 * @brief 主播头像点击
 */
- (void)avatarDidClick:(MZHostModel *)hostModel;
/**
 * @brief 获取到主播信息
 */
- (void)updateHostUserInfo:(MZHostModel *)hostModel;
/**
 * @brief 举报点击
 */
- (void)reportButtonDidClick:(id)playInfo;
/**
 * @brief 显示弹幕开关
 */
- (void)showBarrageDidClick:(BOOL)isShow;
/**
 * @brief 分享点击
*/
- (void)shareButtonDidClick:(id)playInfo;
/**
 * @brief 倍速按钮点击
 */
- (void)playRateButtonClick:(id)sender;
/**
 * @brief 投屏按钮点击
 */
- (void)dlnaButtonClick:(id)sender;
/**
 * @brief 点赞点击
 */
- (void)likeButtonDidClick:(id)playInfo;
/**
 * @brief 在线用户列表点击
*/
- (void)onlineListButtonDidClick:(id)playInfo;
/**
 * @brief 某一个在线用户的信息点击
*/
- (void)onlineUserInfoDidClick:(id)onlineUserInfo;
/**
 * @brief 商品袋点击
 */
- (void)shoppingBagDidClick:(id)playInfo;
/**
 * @brief 关注点击
 */
- (void)attentionButtonDidClick:(id)playInfo;
/**
 * @brief 商品点击
 */
- (void)goodsItemDidClick:(MZGoodsListModel *)GoodsListModel;
/**
 * @brief 聊天头像点击事件
 */
- (void)chatUserHeaderDidClick:(MZLongPollDataModel *)GoodsListModel;
/**
 * @brief 未登录回调
 */
- (void)playerNotLogin;
/**
 * @brief 收到一条新消息
 */
-(void)newMsgCallback:(MZLongPollDataModel * )msg;
/**
 * @brief 点击了投屏帮助按钮
 */
- (void)DLNAHelpClick;

/**
 * @brief 播放按钮点击
 */
- (void)playerPlayClick:(BOOL)isPlay;
/**
 * @brief 快进退 进度回调
 */
- (void)playerSeekProgress:(NSTimeInterval)progress;
/**
 * @brief 快进退 手势回调
 */
- (void)playerSeekLocation:(float)location;
/**
 * @brief 声音大小手势回调
 */
- (void)playerVoiceSize:(float)size;
/**
 * @brief 亮度手势回调
 */
- (void)playerLuminance:(float)luminance;
/**
 * @brief 是否显示下方工具栏
 */
- (void)isPlayToolsShow:(BOOL)isShow;
/**
 * @brief 全屏/非全屏切换
 */
- (void)playerView:(MZMediaPlayerView *)player fullscreen:(BOOL)fullscreen;
/**
 * @brief 活动菜单的点击
 */
- (void)activityMenuClickWithIndex:(NSInteger)index;

/**
 开始播放状态回调
 */
- (void)loadStateDidChange:(MZMPMovieLoadState)type;
/**
 播放中状态回调
 */
- (void)moviePlayBackStateDidChange:(MZMPMoviePlaybackState)type;
/**
 播放结束状态 包含异常停止
 */
- (void)moviePlayBackDidFinish:(MZMPMovieFinishReason)type;
/**
 准备播放完成
 */
- (void)mediaIsPreparedToPlayDidChange;
/**
 * 播放失败
 */
- (void)playerViewFailePlay:(MZMediaPlayerView *)player;
@end

@interface MZSuperPlayerView : MZBaseView

@property (nonatomic,   weak) id<MZSuperPlayerViewDelegate>delegate;

@property (nonatomic,   copy) NSString *ticket_id;//活动ID
@property (nonatomic, strong) MZPlayManagerHeaderView *liveManagerHeaderView;//左上角主播按钮view

@property (nonatomic, strong) MZMediaPlayerView *playerView;//播放器的view

/**
 * @brief 设置关注按钮状态
 *
 * @param isAttention 是否已关注
 */
- (void)setAttentionState:(BOOL)isAttention;

/**
 * @brief 更新主播信息
 * @param hostModel 主播信息
 *
 */
- (void)updateHostInfo:(MZHostModel *)hostModel;

/**
 * @brief 小窗口播放
 *
 */
- (void)smallWindowToPlay;

/**
 * @brief 通过活动ID播放（直播/回放）
 *
 * @param ticket_id 活动ID
 */
- (void)playVideoWithLiveIDString:(NSString *)ticket_id;

/**
 * @brief 添加自定义的活动菜单
 *
 * @param menu 自定义菜单名字
 * @param getMenuView 返回菜单对应的view，已经自适应frame，拿到该view后，可以自定义view上的内容
 *
 */
- (void)addActivityMenu:(NSString *)menu getMenuView:(void(^)(UIView * menuView))getMenuView;

@end

NS_ASSUME_NONNULL_END
