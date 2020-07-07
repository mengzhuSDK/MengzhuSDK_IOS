
#import "MZBaseView.h"
#import "MZDismissVew.h"

@protocol MZPlaybackRateDelegate <NSObject>
//改变播放速率
- (void)playbackRateChangedWithIndex:(NSInteger)index;
@end

@interface MZMoviePlayerPlaybackRateView : MZBaseView <MZDismissVew>

@property (nonatomic, weak) id <MZPlaybackRateDelegate> delegate;

-(void)showInView:(UIView *)view;

-(instancetype)initRatePlayWithIndex:(NSInteger)index;//直播间竖屏时点倍速播放

-(instancetype)initLandscapeRatePlayWithIndex:(NSInteger)index;//直播间全屏时点倍速播放

//移除当前视图
- (void)dismiss;

-(void)renewRate;

@end
