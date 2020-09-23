//
//  MZDownLoadProgressView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/9/16.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZDownLoadProgressView.h"

@interface MZDownLoadProgressView ()

@property (nonatomic, strong) CALayer *backgroundLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation MZDownLoadProgressView

- (CALayer *)backgroundLayer {
    
    if (!_backgroundLayer) {
        _backgroundLayer = [CALayer layer];
        //一般不用frame，因为不支持隐式动画
        _backgroundLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _backgroundLayer.anchorPoint = CGPointMake(0, 0);
        _backgroundLayer.backgroundColor = self.bgProgressColor.CGColor;
        _backgroundLayer.cornerRadius = self.frame.size.height / 2.;
        [self.layer addSublayer:_backgroundLayer];
    }
    return _backgroundLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.anchorPoint = CGPointMake(0, 0);
        NSArray *colorArr = self.colorArr;
        _gradientLayer.colors = colorArr;
        _gradientLayer.cornerRadius = self.frame.size.height / 2.;
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateView];
}

- (void)setColorArr:(NSArray *)colorArr {
    if (colorArr.count >= 2) {
        _colorArr = colorArr;
        [self updateView];
    }else {
        NSLog(@">>>>>颜色数组个数小于2，显示默认颜色");
    }
}

#pragma mark -
#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame color:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1]];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgProgressColor = [UIColor whiteColor];

        [self simulateViewDidLoad];
        self.colorArr = @[(id)color.CGColor,(id)color.CGColor];
        self.progress = 0;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bgProgressColor = [UIColor whiteColor];
        [self simulateViewDidLoad];
        self.colorArr = @[(id)[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor,(id)[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor];
        self.progress = 0;
    }
    return self;
}

- (void)simulateViewDidLoad {
    [self addSubViewTree];
}

- (void)addSubViewTree {
    [self backgroundLayer];
    [self gradientLayer];
}

- (void)updateView {
    self.gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
    self.gradientLayer.colors = self.colorArr;
}

@end
