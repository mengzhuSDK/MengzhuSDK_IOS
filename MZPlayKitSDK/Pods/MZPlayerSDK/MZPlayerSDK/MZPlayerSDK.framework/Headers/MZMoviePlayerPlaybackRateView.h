
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MZPlayBackRate75 = 0,//0.75x
    MZPlayBackRate100,//1x
    MZPlayBackRate125,//1.25x
    MZPlayBackRate150,//1.5x
    MZPlayBackRate200,//2x
} MZPlayBackRate;//倍速固定数据源 @[@"0.75x",@"1x",@"1.25x",@"1.5x",@"2x"]


@protocol MZPlaybackRateDelegate <NSObject>
/**
 * @brief 倍速选择回调
 *
 * @param rate 倍速的索引
 * @param rateValue 播放倍速的值 e.g. 0.75/1/1.25/1.5/2
 */
- (void)playbackRateChangedWithIndex:(MZPlayBackRate)rate rateValue:(CGFloat)rateValue;

/**
 * @brief 退出倍速选择界面
 *
 */
-(void)playbackRateViewExit;
@end

@interface MZMoviePlayerPlaybackRateView : UIView

@property (nonatomic, weak) id <MZPlaybackRateDelegate> delegate;

@property (nonatomic, strong) UIView *grayView;//背景

@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UIButton *cancleButton;//返回按钮
@property (nonatomic, strong) UIView *line;//线条

/// 非横屏时点倍速播放
- (instancetype)initRatePlayWithRate:(MZPlayBackRate)rate;

/// 横屏时点倍速播放
- (instancetype)initLandscapeRatePlayWithRate:(MZPlayBackRate)rate;

/// 更新倍速按钮的默认字体颜色
- (void)updateNormalTextColor:(UIColor *)color;

/// 更新倍速按钮的选中字体颜色
- (void)updateSelectedTextColor:(UIColor *)color;

/// 更新倍速按钮底部的点的颜色
- (void)updateDotColor:(UIColor *)color;

/// 展示倍速选择UI
- (void)showInView:(UIView *)view;

/// 重置倍速
- (void)renewRate;

@end
