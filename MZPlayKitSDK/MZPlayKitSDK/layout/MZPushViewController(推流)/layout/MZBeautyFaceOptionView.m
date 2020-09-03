//
//  MZBeautyFaceOptionView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/22.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZBeautyFaceOptionView.h"

static NSInteger beautyFaceButtonLandspaceWidth = 64.0;
static NSInteger beautyFaceButtonLandspaceHeight = 40.0;

static NSInteger beautyFaceButtonPortaritWidth = 40.0;
static NSInteger beautyFaceButtonPortaritHeight = 40.0;

@interface MZBeautyFaceOptionView()
@property (nonatomic, strong) UIButton *noLevelButton;//无
@property (nonatomic, strong) UIButton *lowLevelButton;//低级美颜
@property (nonatomic, strong) UIButton *mediumLevelButton;//中级美颜
@property (nonatomic, strong) UIButton *highLevelButton;//高级美颜
@property (nonatomic, strong) UIButton *veryHighLevelButton;//最高级美颜

@property (nonatomic, assign) MZBeautyFaceLevel normalFaceLevel;//默认选中的美颜

@end

@implementation MZBeautyFaceOptionView

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
    [self addSubview:self.noLevelButton];
    [self addSubview:self.lowLevelButton];
    [self addSubview:self.mediumLevelButton];
    [self addSubview:self.highLevelButton];
    [self addSubview:self.veryHighLevelButton];
}

- (void)beautyLevelClick:(UIButton *)sender {
    [self hide];
    if (!self.result) return;

    if (sender == self.noLevelButton) {
        if (self.normalFaceLevel == MZBeautyFaceLevel_None) {
            self.result(YES, MZBeautyFaceLevel_None);
        } else {
            self.result(NO, MZBeautyFaceLevel_None);
        }
    } else if (sender == self.lowLevelButton) {
        if (self.normalFaceLevel == MZBeautyFaceLevel_Low) {
            self.result(YES, MZBeautyFaceLevel_Low);
        } else {
            self.result(NO, MZBeautyFaceLevel_Low);
        }
    } else if (sender == self.mediumLevelButton) {
        if (self.normalFaceLevel == MZBeautyFaceLevel_Medium) {
            self.result(YES, MZBeautyFaceLevel_Medium);
        } else {
            self.result(NO, MZBeautyFaceLevel_Medium);
        }
    } else if (sender == self.highLevelButton) {
        if (self.normalFaceLevel == MZBeautyFaceLevel_High) {
            self.result(YES, MZBeautyFaceLevel_High);
        } else {
            self.result(NO, MZBeautyFaceLevel_High);
        }
    } else if (sender == self.veryHighLevelButton) {
        if (self.normalFaceLevel == MZBeautyFaceLevel_VeryHigh) {
            self.result(YES, MZBeautyFaceLevel_VeryHigh);
        } else {
            self.result(NO, MZBeautyFaceLevel_VeryHigh);
        }
    }
}

/**
 * @brief 展示美颜选项
 *
 * @param direction 展示的方向
 * @param from 以这个view为节点
 * @param normalBeautyLevel 默认美颜等级
 *
 */
- (void)showWithDirection:(MZBeautyFaceShowDirection)direction
                     from:(UIView *)from
        normalBeautyLevel:(MZBeautyFaceLevel)normalBeautyLevel {
    if (self.isHidden == NO) {
        [self hide];
        return;
    }
    
    self.normalFaceLevel = normalBeautyLevel;
    if (direction == MZBeautyFaceShowDirection_Up) {//上
        self.frame = CGRectMake(from.frame.origin.x - (beautyFaceButtonLandspaceWidth - from.frame.size.width)/2.0, from.frame.origin.y - 10 - beautyFaceButtonLandspaceHeight * 5 - 3 * 5, beautyFaceButtonLandspaceWidth, beautyFaceButtonLandspaceHeight * 5 + 3 * 5);
        self.noLevelButton.frame = CGRectMake(0, self.frame.size.height - 3 - beautyFaceButtonLandspaceHeight, beautyFaceButtonLandspaceWidth, beautyFaceButtonLandspaceHeight);
        self.lowLevelButton.frame = CGRectMake(0, self.frame.size.height - 3*2 - beautyFaceButtonLandspaceHeight*2, beautyFaceButtonLandspaceWidth, beautyFaceButtonLandspaceHeight);
        self.mediumLevelButton.frame = CGRectMake(0, self.frame.size.height - 3*3 - beautyFaceButtonLandspaceHeight*3, beautyFaceButtonLandspaceWidth, beautyFaceButtonLandspaceHeight);
        self.highLevelButton.frame = CGRectMake(0, self.frame.size.height - 3*4 - beautyFaceButtonLandspaceHeight*4, beautyFaceButtonLandspaceWidth, beautyFaceButtonLandspaceHeight);
        self.veryHighLevelButton.frame = CGRectMake(0, self.frame.size.height - 3*5 - beautyFaceButtonLandspaceHeight*5, beautyFaceButtonLandspaceWidth, beautyFaceButtonLandspaceHeight);
    } else if (direction == MZBeautyFaceShowDirection_Left) {//左
        self.frame = CGRectMake(from.frame.origin.x - 50 - beautyFaceButtonPortaritWidth * 5, (from.frame.origin.y - (beautyFaceButtonPortaritHeight - from.size.height)/2.0), beautyFaceButtonPortaritWidth * 5 + 50, beautyFaceButtonPortaritHeight);
        self.noLevelButton.frame = CGRectMake(self.frame.size.width - 10 - beautyFaceButtonPortaritWidth, 0, beautyFaceButtonPortaritWidth, beautyFaceButtonPortaritHeight);
        self.lowLevelButton.frame = CGRectMake(self.frame.size.width - 10*2 - beautyFaceButtonPortaritWidth*2, 0, beautyFaceButtonPortaritWidth, beautyFaceButtonPortaritHeight);
        self.mediumLevelButton.frame = CGRectMake(self.frame.size.width - 10*3 - beautyFaceButtonPortaritWidth*3, 0, beautyFaceButtonPortaritWidth, beautyFaceButtonPortaritHeight);
        self.highLevelButton.frame = CGRectMake(self.frame.size.width - 10*4 - beautyFaceButtonPortaritWidth*4, 0, beautyFaceButtonPortaritWidth, beautyFaceButtonPortaritHeight);
        self.veryHighLevelButton.frame = CGRectMake(self.frame.size.width - 10*5 - beautyFaceButtonPortaritWidth*5, 0, beautyFaceButtonPortaritWidth, beautyFaceButtonPortaritHeight);
    }

    self.noLevelButton.selected = NO;
    self.lowLevelButton.selected = NO;
    self.mediumLevelButton.selected = NO;
    self.highLevelButton.selected = NO;
    self.veryHighLevelButton.selected = NO;
    switch (normalBeautyLevel) {
        case MZBeautyFaceLevel_None: {
            self.noLevelButton.selected = YES;
            break;
        }
        case MZBeautyFaceLevel_Low: {
            self.lowLevelButton.selected = YES;
            break;
        }
        case MZBeautyFaceLevel_Medium: {
            self.mediumLevelButton.selected = YES;
            break;
        }
        case MZBeautyFaceLevel_High: {
            self.highLevelButton.selected = YES;
            break;
        }
        case MZBeautyFaceLevel_VeryHigh: {
            self.veryHighLevelButton.selected = YES;
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
 * @brief 隐藏美颜选项
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
- (UIButton *)noLevelButton {
    if (!_noLevelButton) {
        _noLevelButton = [self createBeautyFaceButton:@"无"];
    }
    return _noLevelButton;
}

- (UIButton *)lowLevelButton {
    if (!_lowLevelButton) {
        _lowLevelButton = [self createBeautyFaceButton:@"1x"];
    }
    return _lowLevelButton;
}

- (UIButton *)mediumLevelButton {
    if (!_mediumLevelButton) {
        _mediumLevelButton = [self createBeautyFaceButton:@"2x"];
    }
    return _mediumLevelButton;
}

- (UIButton *)highLevelButton {
    if (!_highLevelButton) {
        _highLevelButton = [self createBeautyFaceButton:@"3x"];
    }
    return _highLevelButton;
}

- (UIButton *)veryHighLevelButton {
    if (!_veryHighLevelButton) {
        _veryHighLevelButton = [self createBeautyFaceButton:@"4x"];
    }
    return _veryHighLevelButton;
}

- (UIButton *)createBeautyFaceButton:(NSString *)text {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.25]];
    [button.layer setCornerRadius:20];
    [button.layer setMasksToBounds:YES];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:255/255.0 green:33/255.0 blue:69/255.0 alpha:1] forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:@selector(beautyLevelClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
