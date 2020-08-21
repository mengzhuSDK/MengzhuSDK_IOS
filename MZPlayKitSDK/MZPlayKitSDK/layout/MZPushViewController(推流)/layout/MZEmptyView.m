//
//  MZEmptyView.m
//  MengZhu
//
//  Created by vhall on 16/10/20.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZEmptyView.h"

#define kWidthRATE     (self.width / MZ_SW * MZ_RATE)
#define kHeightRATE    (self.height / MZ_SH * MZ_RATE)

@interface MZEmptyView()
{
    UIImageView * _emImageView;
    UILabel * _loadErrorLabel;
    UILabel * _noDataLabel;
    UILabel * _noDataSubLabel;
    UIButton * _errorBtn;
    UIButton * _noDataBtn;
}

@end

@implementation MZEmptyView

- (instancetype)initNetErrorViewWithFrame:(CGRect)frame clickBlock:(MZNetErrorClickBlock)clickBlock
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _errorBlock = clickBlock;
        [self layoutUI];
        self.hidden = YES;
    }
    return self;
}

- (void)layoutUI
{
    _noDataImage = [UIImage imageNamed:@"默认空页面"];
    if (!_emImageView) {
        _emImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.width - 231 * kWidthRATE)/2.0, 51 * kHeightRATE, 231 * kWidthRATE, 144 * kWidthRATE)];
        [self addSubview:_emImageView];
    }
    
    if (!_loadErrorLabel) {
        _loadErrorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * kWidthRATE, _emImageView.bottom + 20 * kHeightRATE, self.width - 20 * kWidthRATE , 15*kWidthRATE)];
        _loadErrorLabel.textColor = MakeColorRGB(0x9b9b9b);
        _loadErrorLabel.textAlignment = NSTextAlignmentCenter;
        _loadErrorLabel.font = [UIFont systemFontOfSize:12*kWidthRATE];
        _loadErrorLabel.hidden = YES;
        _loadErrorLabel.text = @"亲，网络开小差啦！";
        [self addSubview:_loadErrorLabel];
    }
    
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * kWidthRATE, _emImageView.bottom + 38 * kHeightRATE, self.width - 20 * kWidthRATE , 23 *kWidthRATE)];
        _noDataLabel.textColor = MakeColorRGB(0x9b9b9b);
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.font = [UIFont systemFontOfSize:12*kWidthRATE];
        _noDataLabel.text = @"暂无数据";
        _noDataLabel.hidden = YES;
        [self addSubview:_noDataLabel];
    }
    
    if (!_noDataSubLabel) {
        _noDataSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * kWidthRATE, _noDataLabel.bottom + 2 * kHeightRATE, self.width - 20 * kWidthRATE , 23 *kWidthRATE)];
        _noDataSubLabel.textColor = MakeColorRGB(0x9b9b9b);
        _noDataSubLabel.textAlignment = NSTextAlignmentCenter;
        _noDataSubLabel.font = [UIFont systemFontOfSize:12*kWidthRATE];
        _noDataSubLabel.hidden = YES;
        [self addSubview:_noDataSubLabel];
    }
    
    if (!_errorBtn) {
        _errorBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width / 2.0 - 59*kWidthRATE, _noDataLabel.bottom + 20 * kHeightRATE, 118*kWidthRATE , 32*kWidthRATE)];
        [_errorBtn setBackgroundImage:[MZBaseGlobalTools imageWithColor:MakeColorRGBA(0xffffff, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_errorBtn setBackgroundImage:[MZBaseGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 0.1) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        _errorBtn.titleLabel.font = [UIFont systemFontOfSize:14*kWidthRATE];
        [_errorBtn setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [_errorBtn setTitleColor:MakeColorRGB(0xff5b29) forState:UIControlStateNormal];
        _errorBtn.layer.masksToBounds = YES;
        _errorBtn.layer.cornerRadius = _errorBtn.height / 2.0;
        _errorBtn.layer.borderColor = MakeColorRGB(0xff5b29).CGColor;
        _errorBtn.tag = MZEmptyViewNetErrorType;
        _errorBtn.layer.borderWidth = 0.8;
        [_errorBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _errorBtn.hidden = YES;
        [self addSubview:_errorBtn];
    }
    
    if (!_noDataBtn) {
        _noDataBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width / 2.0 - 60 * kWidthRATE, _noDataLabel.bottom + 34 * kHeightRATE, 120 * kWidthRATE, 40 * kHeightRATE)];
        [_noDataBtn setBackgroundImage:[MZBaseGlobalTools imageWithColor:MakeColorRGBA(0xffffff, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_noDataBtn setBackgroundImage:[MZBaseGlobalTools imageWithColor:MakeColorRGBA(0x8e9091, 0.1) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        _noDataBtn.titleLabel.font = [UIFont systemFontOfSize:15 * kWidthRATE];
        [_noDataBtn setTitleColor:MakeColorRGB(0xff5b29) forState:UIControlStateNormal];
        _noDataBtn.layer.masksToBounds = YES;
        _noDataBtn.layer.cornerRadius = _noDataBtn.height / 2.0;
        _noDataBtn.layer.borderColor = MakeColorRGB(0xff5b29).CGColor;
        _noDataBtn.layer.borderWidth = 0.8;
        _noDataBtn.tag =  MZEmptyViewNoDataType;
        [_noDataBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _noDataBtn.hidden = YES;
        _noDataBtn.userInteractionEnabled = NO;
        [self addSubview:_noDataBtn];
    }
}

- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == MZEmptyViewNoDataType) {
        if (_errorBlock && !_noDataBtn.hidden) {
            _errorBlock(MZEmptyViewNoDataType);
        }
    }
    else if (btn.tag == MZEmptyViewNetErrorType){
        if (_errorBlock && !_errorBtn.hidden) {
            _errorBlock(MZEmptyViewNetErrorType);
        }
    }
}

#pragma mark 网络错误显示
- (void)showNetError
{
    self.hidden = NO;
    _emImageView.image = [UIImage imageNamed:@"没有网"];
    _loadErrorLabel.hidden = NO;
    _errorBtn.hidden = NO;
    _noDataLabel.hidden = YES;
    _noDataBtn.hidden = YES;
}

#pragma mark 网络无数据
- (void)showNoData
{
    self.hidden = NO;
    _emImageView.image = _noDataImage;
    _noDataLabel.hidden = NO;
    _noDataBtn.hidden = !_noDataBtn.userInteractionEnabled;
    _loadErrorLabel.hidden = YES;
    _errorBtn.hidden = YES;
}

- (void)setNoDataStr:(NSString *)noDataStr
{
    if (noDataStr.length) {
        _noDataStr = noDataStr;
        _noDataLabel.text = _noDataStr;
    }
}

-(void)setNoDataSubStr:(NSString *)noDataSubStr
{
    if (noDataSubStr.length) {
        _noDataSubStr = noDataSubStr;
        _noDataSubLabel.text = noDataSubStr;
        _noDataSubLabel.hidden = NO;
    }
}

- (void)setNoDataBtnTitle:(NSString *)noDataBtnTitle
{
    if (noDataBtnTitle.length) {
        _noDataBtnTitle = noDataBtnTitle;
        [_noDataBtn setTitle:_noDataBtnTitle forState:UIControlStateNormal];
        _noDataBtn.userInteractionEnabled = YES;
    }
}

- (void)setNoDataBtnTitleColor:(UIColor *)noDataBtnTitleColor
{
    if (_noDataBtnTitle.length) {
        [_noDataBtn setTitleColor:noDataBtnTitleColor forState:UIControlStateNormal];
    }
}

- (void)setNoDataBtnBgColor:(UIColor *)noDataBtnBgColor
{
   const CGFloat *components = CGColorGetComponents(noDataBtnBgColor.CGColor);
    if (_noDataBtnTitle.length) {
        [_noDataBtn setBackgroundImage:[MZBaseGlobalTools imageWithColor:noDataBtnBgColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_noDataBtn setBackgroundImage:[MZBaseGlobalTools imageWithColor:[UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:0.9] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        _noDataBtn.layer.borderColor = noDataBtnBgColor.CGColor;
    }
}

- (void)setNoErrorStr:(NSString *)noErrorStr
{
    if (noErrorStr.length) {
        _noErrorStr = noErrorStr;
        _loadErrorLabel.text = _noErrorStr;
    }
}

- (void)setNoDataImage:(UIImage *)noDataImage
{
    if (noDataImage) {
        _noDataImage = noDataImage;
        _emImageView.image = _noDataImage;
    }
}

- (void)setErrBtnTitle:(NSString *)errBtnTitle
{
    if (errBtnTitle.length) {
        _errBtnTitle = errBtnTitle;
        [_errorBtn setTitle:_errBtnTitle forState:UIControlStateNormal];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
