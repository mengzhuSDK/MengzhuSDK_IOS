//
//  MZActionSheetView.m
//  MengZhu
//
//  Created by vhall on 16/11/30.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZActionSheetView.h"
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>
#define kBtnsH 40
#define kActonTitleBtnsH 35
#define kCancelBtnsH 50
#define kDistanceViewH 10
@interface MZActionSheetView()

@property (nonatomic,copy) MZActionSheetBlock blockResponse;
@property (nonatomic,strong) NSMutableArray * btnsTitleArr;
@property (nonatomic,strong) NSString * actionTitle;
@property (nonatomic,strong) NSString * cancelTitle;
@property (nonatomic,strong) UIView * bgView;

@end

@implementation MZActionSheetView

+(void)initWithMZActionSheetView:(MZActionSheetBlock)actionBlock actionTilte:(NSString *)actionTitle cancelBtnTitle:(NSString *)cancelTitle buttonKeys:(NSString *)key,...
{
    MZActionSheetView * vc = [[MZActionSheetView alloc]init];
    vc.blockResponse = actionBlock;
    vc.actionTitle = actionTitle;
    vc.cancelTitle = cancelTitle;
    vc.btnsTitleArr = [[NSMutableArray array]init];
    va_list params;
    va_start(params,key);
    id arg;
    if (key) {
        id prev = key;
        [vc.btnsTitleArr addObject:prev];
        while( (arg = va_arg(params,id)) )
        {
            if ( arg ){
                [vc.btnsTitleArr addObject:arg];
            }
        }
        va_end(params);
    }
    [vc layoutUI];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:vc];
}

+(void)dismissActionView
{
    NSArray *wins=[UIApplication sharedApplication].windows;
    MZActionSheetView *hud = [MZActionSheetView HUDForView:[wins objectAtIndex:0]];
    [hud removeFromSuperview];
}

+ (MZActionSheetView *)HUDForView:(UIView *)view {
    MZActionSheetView *hud = nil;
    NSArray *subviews = view.subviews;
    Class hudClass = [MZActionSheetView class];
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (MZActionSheetView *)aView;
        }
    }
    return hud;
}

- (void)layoutUI
{
    CGFloat W = [[UIScreen mainScreen] bounds].size.width;
    CGFloat H = [[UIScreen mainScreen] bounds].size.height;
    self.frame =CGRectMake(0, 0, W, H + 20);
    self.backgroundColor = MakeColorRGBA(0x000000, 0.2);
    [self removeAllSubviews];
    
    CGFloat actionTitleH = (self.actionTitle.length ? kActonTitleBtnsH : 0);
    CGFloat cancelTitleH = kCancelBtnsH;
    CGFloat btnsH = self.btnsTitleArr.count * kBtnsH;
    CGFloat distanceH = kDistanceViewH;
    
    if (btnsH > (H - actionTitleH - cancelTitleH - distanceH - 30)) {
        NSArray * arr = self.btnsTitleArr;
        [self.btnsTitleArr removeAllObjects];
        for (int i = 0; i < arr.count; i ++) {
            if ((kBtnsH * (i+1))  <= (H - actionTitleH - cancelTitleH - distanceH - 30)){
                [self.btnsTitleArr addObject:arr[i]];
            }
            else {
                break;
            }
        }
    }
    btnsH = self.btnsTitleArr.count * kBtnsH;
    CGFloat bgViewH = actionTitleH + cancelTitleH + btnsH + distanceH;
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height -20 - bgViewH , self.frame.size.width, bgViewH)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    if (actionTitleH > 0) {
        UIButton * actionTitleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _bgView.width, actionTitleH)];
        [actionTitleBtn setTitle:self.actionTitle forState:UIControlStateNormal];
        [actionTitleBtn setTitleColor:MakeColorRGB(0x7a8fac) forState:UIControlStateNormal];
        actionTitleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [actionTitleBtn addSubview:[self creatLineView:actionTitleBtn]];
        [self setButtonAtt:actionTitleBtn];
        actionTitleBtn.userInteractionEnabled = NO;
        [_bgView addSubview:actionTitleBtn];
    }
    
    for (int i = 0; i < self.btnsTitleArr.count; i++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, actionTitleH + i * kBtnsH, _bgView.width, kBtnsH)];
        [btn setTitle:self.btnsTitleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:MakeColorRGB(0x000000) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setButtonAtt:btn];
        [btn addSubview:[self creatLineView:btn]];
        btn.tag = i ;
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
    }
    
    UIView * distanceView = [[UIView alloc]initWithFrame:CGRectMake(0, actionTitleH + btnsH, _bgView.width, kDistanceViewH)];
    distanceView.backgroundColor = MakeColorRGBA(0xf4f4f6,1.0);
    [_bgView addSubview:distanceView];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, distanceView.bottom, _bgView.width, kCancelBtnsH)];
    [cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MakeColorRGB(0x000000) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setButtonAtt:cancelBtn];
    [cancelBtn addTarget:self action:@selector(dissmissView) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:cancelBtn];
}

- (void)setButtonAtt:(UIButton *)btn
{
    [btn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xffffff,1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xffffff,0.7) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xffffff,0.7) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
}
- (void)clickButton:(UIButton *)btn
{
    if (self.blockResponse) {
        self.blockResponse(btn.tag,EmptyForNil(btn.titleLabel.text));
    }
    [self dissmissView];
}

- (UIView *)creatLineView:(UIButton *)btn
{
    UIView * hLineView = [[UIView alloc]initWithFrame:CGRectMake(0, btn.height - 0.8, btn.width, 0.8)];
    hLineView.backgroundColor = MakeColorRGBA(0xf4f4f6,1.0);
    return hLineView;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)dissmissView
{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touchs = [touches anyObject];
    CGPoint point = [touchs locationInView:_bgView];
    if ((point.x<0||point.y<0||point.x>_bgView.width||point.y>_bgView.height)) {
        [self dissmissView];
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
