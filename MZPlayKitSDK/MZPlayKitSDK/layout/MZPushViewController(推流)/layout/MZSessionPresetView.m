//
//  MZSessionPresetView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/22.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZSessionPresetView.h"

static NSInteger sessionPresetButtonWidth = 64.0;
static NSInteger sessionPresetButtonHeight = 44.0;

#define kSessionPreset_biaoqing_normalImage [UIImage imageNamed:@"mz_biaoqing_weixuanzhong"]
#define kSessionPreset_biaoqing_selectImage [UIImage imageNamed:@"mz_biaoqing_xuanzhong"]
#define kSessionPreset_gaoqing_normalImage [UIImage imageNamed:@"mz_gaoqing_weixuanzhong"]
#define kSessionPreset_gaoqing_selectImage [UIImage imageNamed:@"mz_gaoqing_xuanzhong"]
#define kSessionPreset_chaoqing_normalImage [UIImage imageNamed:@"mz_chaoqing_weixuanzhong"]
#define kSessionPreset_chaoqing_selectImage [UIImage imageNamed:@"mz_chaoqing_xuanzhong"]

@interface MZSessionPresetView()
@property (nonatomic, strong) UIButton *lowSessionPresetButton;//低级分辨率
@property (nonatomic, strong) UIButton *mediumSessionPresetButton;//中级分辨率
@property (nonatomic, strong) UIButton *highSessionPresetButton;//高级分辨率

@property (nonatomic, assign) MZCaptureSessionPreset normalSessionPreset;//默认选中的分辨率
@end

@implementation MZSessionPresetView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self makeView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

- (void)makeView {
    self.alpha = 0;
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lowSessionPresetButton];
    [self addSubview:self.mediumSessionPresetButton];
    [self addSubview:self.highSessionPresetButton];
}

- (void)sessionPresetButtonClick:(UIButton *)sender {
    [self hide];
    if (!self.result) return;
    if (sender == self.lowSessionPresetButton) {
        if (self.normalSessionPreset == MZCaptureSessionPreset360x640) {
            self.result(YES, MZCaptureSessionPreset360x640);
        } else {
            self.result(NO, MZCaptureSessionPreset360x640);
        }
    } else if (sender == self.mediumSessionPresetButton) {
        if (self.normalSessionPreset == MZCaptureSessionPreset540x960) {
            self.result(YES, MZCaptureSessionPreset540x960);
        } else {
            self.result(NO, MZCaptureSessionPreset540x960);
        }
    } else if (sender == self.highSessionPresetButton) {
        if (self.normalSessionPreset == MZCaptureSessionPreset720x1280) {
            self.result(YES, MZCaptureSessionPreset720x1280);
        } else {
            self.result(NO, MZCaptureSessionPreset720x1280);
        }
    }
}

/**
 * @brief 展示分辨率选项
 *
 * @param direction 展示的方向
 * @param from 以这个view为节点
 * @param normalSessionPreset 默认的分辨率
 *
 */
- (void)showWithDirection:(MZSessionPresetShowDirection)direction
                     from:(UIView *)from
      normalSessionPreset:(MZCaptureSessionPreset)normalSessionPreset {
    if (self.isHidden == NO) {
        [self hide];
        return;
    }
    
    self.normalSessionPreset = normalSessionPreset;
    if (direction == MZSessionPresetShowDirection_Up) {//上
        self.frame = CGRectMake(from.frame.origin.x - (sessionPresetButtonWidth - from.frame.size.width)/2.0, from.frame.origin.y - 30 - sessionPresetButtonHeight * 3, sessionPresetButtonWidth, sessionPresetButtonHeight * 3 + 30);
        self.lowSessionPresetButton.frame = CGRectMake(0, self.frame.size.height  - sessionPresetButtonHeight - 10, sessionPresetButtonWidth, sessionPresetButtonHeight);
        self.mediumSessionPresetButton.frame = CGRectMake(0, self.frame.size.height  - sessionPresetButtonHeight * 2 - 10 * 2, sessionPresetButtonWidth, sessionPresetButtonHeight);
        self.highSessionPresetButton.frame = CGRectMake(0, self.frame.size.height  - sessionPresetButtonHeight * 3 - 10 * 3, sessionPresetButtonWidth, sessionPresetButtonHeight);
    } else if (direction == MZSessionPresetShowDirection_Left) {//左
        self.frame = CGRectMake(from.frame.origin.x - 30 - sessionPresetButtonWidth * 3, (from.frame.origin.y - (sessionPresetButtonHeight - from.size.height)/2.0), sessionPresetButtonWidth * 3 + 30, sessionPresetButtonHeight);
        self.lowSessionPresetButton.frame = CGRectMake(self.frame.size.width - 10 - sessionPresetButtonWidth, 0, sessionPresetButtonWidth, sessionPresetButtonHeight);
        self.mediumSessionPresetButton.frame = CGRectMake(self.frame.size.width - 10 * 2 - sessionPresetButtonWidth * 2, 0, sessionPresetButtonWidth, sessionPresetButtonHeight);
        self.highSessionPresetButton.frame = CGRectMake(self.frame.size.width - 10 * 3 - sessionPresetButtonWidth * 3, 0, sessionPresetButtonWidth, sessionPresetButtonHeight);
    }
    
    self.lowSessionPresetButton.selected = NO;
    self.mediumSessionPresetButton.selected = NO;
    self.highSessionPresetButton.selected = NO;
    switch (normalSessionPreset) {
        case MZCaptureSessionPreset360x640: {
            self.lowSessionPresetButton.selected = YES;
            break;
        }
        case MZCaptureSessionPreset540x960: {
            self.mediumSessionPresetButton.selected = YES;
            break;
        }
        case MZCaptureSessionPreset720x1280: {
            self.highSessionPresetButton.selected = YES;
            break;
        }
        default:
            break;
    }
    
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 1;
    }];
}

/**
 * @brief 隐藏分辨率选项
 */
- (void)hide {
    if (self.isHidden) return;
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - 懒加载
-(UIButton *)lowSessionPresetButton {
    if (!_lowSessionPresetButton) {
        _lowSessionPresetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lowSessionPresetButton setImage:kSessionPreset_biaoqing_normalImage forState:UIControlStateNormal];
        [_lowSessionPresetButton setImage:kSessionPreset_biaoqing_selectImage forState:UIControlStateSelected];
        [_lowSessionPresetButton setBackgroundColor:[UIColor clearColor]];
        [_lowSessionPresetButton addTarget:self action:@selector(sessionPresetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lowSessionPresetButton;
}

- (UIButton *)mediumSessionPresetButton {
    if (!_mediumSessionPresetButton) {
        _mediumSessionPresetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mediumSessionPresetButton setImage:kSessionPreset_gaoqing_normalImage forState:UIControlStateNormal];
        [_mediumSessionPresetButton setImage:kSessionPreset_gaoqing_selectImage forState:UIControlStateSelected];
        [_mediumSessionPresetButton setBackgroundColor:[UIColor clearColor]];
        [_mediumSessionPresetButton addTarget:self action:@selector(sessionPresetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mediumSessionPresetButton;
}

- (UIButton *)highSessionPresetButton {
    if (!_highSessionPresetButton) {
        _highSessionPresetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_highSessionPresetButton setImage:kSessionPreset_chaoqing_normalImage forState:UIControlStateNormal];
        [_highSessionPresetButton setImage:kSessionPreset_chaoqing_selectImage forState:UIControlStateSelected];
        [_highSessionPresetButton setBackgroundColor:[UIColor clearColor]];
        [_highSessionPresetButton addTarget:self action:@selector(sessionPresetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _highSessionPresetButton;
}

@end
