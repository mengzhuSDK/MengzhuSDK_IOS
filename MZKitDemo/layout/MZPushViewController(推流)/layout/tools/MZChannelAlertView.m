//
//  MZChannelAlertView.m
//  MengZhu
//
//  Created by vhall on 16/7/2.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZChannelAlertView.h"

@interface MZChannelAlertView ()
{
    UILabel *_titleLabel;
    UIButton *_cannelBtn;
    UIButton *_sureBtn;
    NSString *_leftBtnName;
    NSString *_rightBtnName;
    NSString *_titleName;
    UIColor *_color;
}
@end
@implementation MZChannelAlertView

-(MZChannelAlertView *)initWithClearBufferViewFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
    self = [[MZChannelAlertView alloc]initWithFrame:frame];
    self.backgroundColor = MakeColor(1, 1, 1, 0.3);
    _titleName = title;
    [self layoutUIWithType:0];
}
    return self;
    
    
}

-(instancetype)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title btn:(NSString *)btnTitle btnBackgroundColor:(UIColor *)color
{
    if (self = [super initWithFrame:frame]) {
        self = [[MZChannelAlertView alloc]initWithFrame:frame];
        self.backgroundColor = MakeColor(1, 1, 1, 0.3);
        _titleName = title;
        _leftBtnName = btnTitle;
        _color = color;
        [self layoutUIWithType:3];
    }
    return self;
    
    
}

- (MZChannelAlertView *)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title btn:(NSString *)btnTitle
{
    if (self = [super initWithFrame:frame]) {
        self = [[MZChannelAlertView alloc]initWithFrame:frame];
        self.backgroundColor = MakeColor(1, 1, 1, 0.3);
        _titleName = title;
        _leftBtnName = btnTitle;
        [self layoutUIWithType:2];
    }
    return self;
}

- (MZChannelAlertView *)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn
{
    if (self = [super initWithFrame:frame]) {
        self = [[MZChannelAlertView alloc]initWithFrame:frame];
        self.backgroundColor = MakeColor(1, 1, 1, 0.3);
        _titleName = title;
        _leftBtnName = leftBtn;
        _rightBtnName = rightBtn;
        [self layoutUIWithType:1];
    }
    return self;
}

- (void)layoutUIWithType:(int)type //1 表示两个按钮    2 表示只有一个按钮
{
    
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(50 * space,200 * space, MZ_SW - 100 * space, 200 * space)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4 * space;
    bgView.backgroundColor = MakeColorRGB(0xffffff);
    [self addSubview:bgView];
    bgView.center = self.center;
    
    UIView * docView = [[UIView alloc]initWithFrame:CGRectMake(20 * space, 23 * space, 7, 7)];
    docView.backgroundColor = MakeColorRGB(0xff5b29);
    [bgView addSubview:docView];
    docView.layer.masksToBounds = YES;
    docView.layer.cornerRadius = docView.height / 2.0;
    UILabel * headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(docView.right + 7 * space, docView.center.y - 15 * space, 80 * space, 30 * space)];
    headerTitleLabel.text = @"提醒";
    headerTitleLabel.textColor = MakeColorRGB(0x2b2c32);
    headerTitleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:headerTitleLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(docView.origin.x, headerTitleLabel.bottom + 10 * space, bgView.width - 40 *space, 0.7)];
    lineView.backgroundColor = MakeColorRGB(0xe9e9e9);
    [bgView addSubview:lineView];
    
    if (!_titleLabel) {
        CGFloat messageWidth = MZ_SW - 140 * space;
        CGFloat titleLabelHeight = 20 * space;
        CGSize messageSize = [_titleName boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} context:nil].size;
        
        if(messageSize.height > titleLabelHeight) {
            titleLabelHeight = messageSize.height;
        }
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lineView.bottom + 15*space, bgView.width, bgView.height - 65*space-headerTitleLabel.bottom)];
        scroll.contentSize = CGSizeMake(scroll.width, titleLabelHeight);
        [bgView addSubview:scroll];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*space,0, lineView.width, titleLabelHeight)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = _titleName;
       // _titleLabel.selectable = NO;
        //_titleLabel.editable = NO;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = MakeColorRGB(0x2b2c32);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [scroll addSubview:_titleLabel];
        [_titleLabel sizeToFit];
    
    }
    if (!_cannelBtn) {
        _cannelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,bgView.height - 40 * space, bgView.width / 2.0, 40 * space)];
        [_cannelBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xe9e9e9, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_cannelBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xe9e9e9, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [_cannelBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xe9e9e9, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        [_cannelBtn setTitle:_leftBtnName forState:UIControlStateNormal];
        [_cannelBtn setTitleColor:MakeColorRGB(0x2b2c32) forState:UIControlStateNormal];
        _cannelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cannelBtn.tag = 1;
        [_cannelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_cannelBtn];
    }
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(_cannelBtn.right, bgView.height - 40 * space, bgView.width / 2.0, 40 * space)];
        [_sureBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 0.90) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        [_sureBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 0.90) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [_sureBtn setTitle:_rightBtnName forState:UIControlStateNormal];
        [_sureBtn setTitleColor:MakeColorRGB(0xffffff) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureBtn.tag = 2;
        [_sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_sureBtn];
    }
    if(type == 0){
        [_sureBtn removeFromSuperview];
        [_cannelBtn removeFromSuperview];
    }
    
    if (type == 2) {
        [_sureBtn removeFromSuperview];
        _cannelBtn.frame = CGRectMake(0,bgView.height - 40 * space, bgView.width, 40 * space);
        [_cannelBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_cannelBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [_cannelBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        [_cannelBtn setTitleColor:MakeColorRGB(0xffffff) forState:UIControlStateNormal];
        
    }
    if(type == 3){
        [_sureBtn removeFromSuperview];
        _cannelBtn.frame = CGRectMake(0,bgView.height - 40 * space, bgView.width, 40 * space);
        [_cannelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cannelBtn setBackgroundImage:[MZGlobalTools imageWithColor:_color size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_cannelBtn setBackgroundImage:[MZGlobalTools imageWithColor:_color size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        [_cannelBtn setBackgroundImage:[MZGlobalTools imageWithColor:_color size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
    }
}

- (void)setMessageTextAlignment:(NSTextAlignment)textAlignment
{
    _titleLabel.textAlignment = textAlignment;

}
- (void)clickBtn:(UIButton *)button
{
    if (self.block) {
        self.block(button.tag);
        [self removeFromSuperview];
    }
}



@end
