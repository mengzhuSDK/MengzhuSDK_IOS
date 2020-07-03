
#import "MZMoviePlayerPlaybackRateView.h"

@interface MZMoviePlayerPlaybackRateView ()

@property (nonatomic, strong) UIView  *maskView;

@property (nonatomic, assign) BOOL isLandscapeShare;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIView *grayView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *cancleView;

@property (nonatomic, strong) UIView *dismissView;

@property (nonatomic, strong) UIButton *cancleButton;

@property (nonatomic, strong) UIView *selectedPointView;

@property (nonatomic, strong) UIButton *initialButton;

@property (nonatomic, assign) CGFloat rateSpace;

@end

@implementation MZMoviePlayerPlaybackRateView

- (instancetype)initRatePlayWithIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _isLandscapeShare = NO;
        _selectedIndex = index;
        self.rateSpace = MZ_RATE;
        [self setFrame:CGRectMake(0, 0, MZScreenWidth, 274*self.rateSpace)];
        [self setUI];
    }
    return self;
}
/// 全屏
- (instancetype)initLandscapeRatePlayWithIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _isLandscapeShare = YES;
        _selectedIndex = index;
        self.rateSpace = MZ_FULL_RATE;
        [self setFrame:CGRectMake(0, 0, MZScreenWidth, 140*self.rateSpace)];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_maskView addGestureRecognizer:tap];
    
    _titleArray = @[@"0.75x",@"1x",@"1.25x",@"1.5x",@"2x"];
    
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _grayView.backgroundColor = MakeColorRGB(0xffffff);
    [self addSubview:self.grayView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_grayView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _grayView.bounds;
    maskLayer.path = maskPath.CGPath;
    _grayView.layer.mask = maskLayer;
    
    CGFloat safeLeft = 12.0;
    if (_isLandscapeShare) {
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                safeLeft = 44.0;
            }
        }
    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(safeLeft, 0, self.width - safeLeft - 44*self.rateSpace, 44*self.rateSpace)];
    _titleLabel.text = @"倍速播放";
    _titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    _titleLabel.font = [UIFont systemFontOfSize:14*self.rateSpace];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_grayView addSubview:self.titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*self.rateSpace, self.width, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [_grayView addSubview:lineView];
    
    _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleButton.frame = CGRectMake(self.width - 56*self.rateSpace, 0, 56*self.rateSpace, 44*self.rateSpace);
    [_cancleButton setImage:[UIImage imageNamed:@"store_close"] forState:UIControlStateNormal];
    [_cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancleButton];
    
    CGFloat buttonW = MZScreenWidth/_titleArray.count;
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 1){
            self.initialButton = rateButton;
        }
        UIView *pointView = [[UIView alloc] init];
        pointView.hidden = YES;
        pointView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:91/255.0 blue:41/255.0 alpha:1.0].CGColor;
        [rateButton addSubview:pointView];
        
        [pointView roundChangeWithRadius:2.0f*self.rateSpace];
        if (_isLandscapeShare) {
//            横屏
            rateButton.frame = CGRectMake(i*buttonW, 52*self.rateSpace, buttonW, 56*self.rateSpace);
            pointView.frame = CGRectMake(92,41,4,4);
        }else{
//             小窗
            rateButton.frame = CGRectMake((i%2)*self.width/2, 52*self.rateSpace + (56*self.rateSpace*(i/2)), self.width/2, 56*self.rateSpace);
        }
        pointView.frame = CGRectMake((rateButton.width-4.0f*self.rateSpace)/2.0,41.0f*self.rateSpace,4*self.rateSpace,4*self.rateSpace);
        
        [rateButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        if (i == _selectedIndex) {
            [rateButton setTitleColor:[UIColor colorWithRed:255/255.0 green:33/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
            pointView.hidden = NO;
        }else{
            [rateButton setTitleColor:MakeColorRGB(0x2b2b2b) forState:UIControlStateNormal];
            pointView.hidden = YES;
        }
        rateButton.titleLabel.font = [UIFont boldSystemFontOfSize:18*self.rateSpace];
        rateButton.tag = 100 + i;
        [rateButton addTarget:self action:@selector(rateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_grayView addSubview:rateButton];
    }
}

- (void)showInView:(UIView *)view {
    [_maskView setFrame:CGRectMake(0, 0, view.width, view.height)];
    [view addSubview:_maskView];
    if (_isLandscapeShare) {
        [self setFrame:CGRectMake(0, view.width, MZScreenWidth, 140*self.rateSpace)];
    }else{
        [self setFrame:CGRectMake(0, view.height, MZScreenWidth, 274*self.rateSpace)];
    }
    
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
        if (self.isLandscapeShare) {
            self.center = CGPointMake(view.center.x, view.height - 140/2*self.rateSpace);
        }else{
            self.center = CGPointMake(view.center.x, view.height - 274/2*self.rateSpace);
        }
        
    } completion:^(BOOL finished) {
        if (self.isLandscapeShare) {
            self.center = CGPointMake(view.center.x, view.height - 140/2*self.rateSpace);
        }else{
            self.center = CGPointMake(view.center.x, view.height - 274/2*self.rateSpace);
        }
    }];
}

- (void)rateButtonClicked:(id)sender {
    UIButton *rateButton = (id)sender;
//    点击按钮后小圆点的显示逻辑
    self.selectedPointView.hidden = YES;
    self.selectedPointView = (UIView *)rateButton.subviews.lastObject;
    self.selectedPointView.hidden = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(playbackRateChangedWithIndex:)]) {
        [_delegate playbackRateChangedWithIndex:rateButton.tag - 100];
    }
    _delegate = nil;
}

- (void)renewRate {
    [self rateButtonClicked:self.initialButton];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y + self.height);
    } completion:^(BOOL finished) {
        self.delegate = nil;
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
