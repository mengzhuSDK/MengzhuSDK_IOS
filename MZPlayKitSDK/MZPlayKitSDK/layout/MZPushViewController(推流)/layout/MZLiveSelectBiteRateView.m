//
//  MZLiveSelectBiteRateView.m
//  MengZhu
//
//  Created by xu on 2019/3/12.
//  Copyright © 2019 www.mengzhu.com. All rights reserved.
//

#import "MZLiveSelectBiteRateView.h"

@interface MZLiveSelectBiteRateView ()

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIButton *lastButton;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation MZLiveSelectBiteRateView

- (instancetype)initWithFrame:(CGRect )frame BiteRateArray:(NSArray *)titleArray SelectIndex:(NSInteger)index
{
    if (self =[super initWithFrame:frame]) {
        _titleArray = titleArray;
        _selectIndex = index;
        [self setUI];
    }
    return self;
}
- (void)setUI
{
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }
    
    self.backgroundColor = MakeColorRGBA(0x000000, 0.8);
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self addGestureRecognizer:tapView];
    
    float startY = (self.height - 46*space*3)/2.0;
    
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake((self.width - 160*space)/2, startY + 46*space * i, 160*space, 36*space);
        [selectButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        [selectButton setTitleColor:MakeColorRGB(0xffffff) forState:UIControlStateNormal];
        selectButton.titleLabel.font = [UIFont systemFontOfSize:14*space];
        [selectButton setBackgroundColor:[UIColor clearColor]];
        selectButton.layer.cornerRadius = 18*space;
        selectButton.layer.masksToBounds = YES;
        selectButton.tag = i + 100;
        [selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectButton];
        if (selectButton.tag - 100 == _selectIndex) {
            [selectButton setTitleColor:MakeColorRGB(0xff5b29) forState:UIControlStateNormal];
            [selectButton setBackgroundColor:MakeColorRGBA(0x000000, 0.2)];
            selectButton.layer.borderColor = MakeColorRGB(0xff5b29).CGColor;
            selectButton.layer.borderWidth = 1;
            _lastButton = selectButton;
        }
    }
}
- (void)selectButtonClicked:(id)sender
{
    UIButton *selectButton = (UIButton *)sender;
    if (selectButton.tag == _lastButton.tag) {//点击相同的码率返回
        if (self && self.biteRateBlock) {
            self.biteRateBlock(selectButton.tag - 100);
            [self dismissView];
        }
        return;
    }
    
    [_lastButton setTitleColor:MakeColorRGB(0xffffff) forState:UIControlStateNormal];
    [_lastButton setBackgroundColor:[UIColor clearColor]];
    _lastButton.layer.borderWidth = 0.01;
    _lastButton.layer.borderColor = [UIColor clearColor].CGColor;
    
    [selectButton setTitleColor:MakeColorRGB(0xff5b29) forState:UIControlStateNormal];
    [selectButton setBackgroundColor:MakeColorRGBA(0x000000, 0.2)];
    selectButton.layer.borderColor = MakeColorRGB(0xff5b29).CGColor;
    selectButton.layer.borderWidth = 1;
    _lastButton = selectButton;
    
    if (self && self.biteRateBlock) {
        self.biteRateBlock(selectButton.tag - 100);
        [self dismissView];
    }
}
- (void)dismissView
{
    [self removeFromSuperview];
}

@end
