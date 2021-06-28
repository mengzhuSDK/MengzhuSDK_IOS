//
//  MZSegmentedView.m
//  MengZhu
//
//  Created by 李伟 on 2018/5/17.
//  Copyright © 2018年 www.mengzhu.com. All rights reserved.
//

#import "MZSegmentedView.h"

CGFloat lineHeight = 1;
@interface MZSegmentedView ()
{
    NSInteger selectSegment;
    CGFloat gapWidth;
    
    UILabel *_badgeLable;
}
@property(nonatomic,strong)UIView*currentView;
@property(nonatomic,assign)NSInteger selectSegument;
@property(nonatomic,strong)NSMutableArray*buttons;
@property(nonatomic,strong)NSMutableArray*numLabels;
@property(nonatomic,strong)UIImageView  *lastButtonImage;
@end


@implementation MZSegmentedView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleColor = [UIColor grayColor];
        self.selectColor = [UIColor orangeColor];
        selectSegment = 0 ;
        self.buttons = [NSMutableArray array];
        self.numLabels = [NSMutableArray array];
    }
    return  self;
}

-(void)setButtonArray:(NSMutableArray *)buttonArray
{
    if(buttonArray){
        _buttonArray = buttonArray;
        [self creatButtonsArray : buttonArray];
    }
}

-(void)creatButtonsArray : (NSMutableArray*)buttonArrays{
    self.clipsToBounds = YES;
    NSInteger segmentNumber = buttonArrays.count;
    _widthFloat = self.width /(CGFloat)buttonArrays.count;
    for (int i = 0; i < segmentNumber; i++) {
        MZBadgeButton*btn = [MZBadgeButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*_widthFloat, 0, _widthFloat, self.height - lineHeight);
        UILabel *numLabel = [[[UILabel alloc]initWithFrame:CGRectMake(_widthFloat /2.0 + 10*MZ_RATE, 5*MZ_RATE, 12*MZ_RATE, 12*MZ_RATE)] roundChangeWithRadius:6*MZ_RATE];
        numLabel.textColor = [UIColor whiteColor];
        if(buttonArrays.count == 1){//只有一个的时候字数变大
            numLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16*MZ_RATE];
        }else{
            numLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12*MZ_RATE];
        }
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.tag = i;
        numLabel.hidden = YES;
        numLabel.backgroundColor = [UIColor orangeColor];
        [btn addSubview:numLabel];
        if (i == 0) {
            [btn setTitle:buttonArrays[i] forState:UIControlStateNormal];
            [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
            [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
            [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 16*MZ_RATE]];
            
        }else{
            [btn setTitle:buttonArrays[i] forState:UIControlStateNormal];
            [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
            [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
            [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:buttonArrays.count == 1 ? 16*MZ_RATE : 12*MZ_RATE]];
        }
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i ;
        
        [self addSubview:btn];
        [self.buttons addObject:btn];
        [self.numLabels addObject:numLabel];
        //显示中间分隔线
        if (self.isSeparatorLine && i != 0) {
            UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height/2-self.titleFont.pointSize/2, 1*MZ_RATE, self.titleFont.pointSize)];
            separatorLineView.backgroundColor = MakeColorRGB(0xDEDEE6);
            [btn addSubview:separatorLineView];
        }
        
    }
    //默认下划线高
    _buttonDown=[[UIView alloc]initWithFrame:CGRectMake(0, self.height - lineHeight, self.width, lineHeight)];
    [_buttonDown setBackgroundColor:MakeColorRGBA(0x000000, 0.1)];
    _buttonDown.layer.shadowColor = MakeColorRGBA(0x000000, 0.1).CGColor;
    _buttonDown.layer.shadowOffset = CGSizeMake(0,4);
    [self addSubview:self.buttonDown];
    
    if (buttonArrays.count > 0) {
        CGFloat titleWidth = [MZBaseGlobalTools getWidthWithText:buttonArrays[0] height:self.height Font:[UIFont systemFontOfSize:self.titleFont.pointSize]];
        _bottomArrowView = [[[UIImageView alloc] init] roundChangeWithRadius:1*MZ_RATE];
        NSLog(@"%f,%f",self.height,self.titleFont.pointSize);
        if (_isChangeLine) {
            _bottomArrowView.frame = CGRectMake(0, self.height/2.0 +self.titleFont.pointSize/2.0 + 12*MZ_RATE, 16*MZ_RATE, 2*MZ_RATE);
        }else{
            _bottomArrowView.frame = CGRectMake(0, self.height - 2*MZ_RATE, 16*MZ_RATE, 2*MZ_RATE);
        }
        _bottomArrowView.backgroundColor = _selectBlowColor ? _selectBlowColor : [UIColor orangeColor];
        [self addSubview:self.bottomArrowView];
        UIButton *firstBtn = self.buttons[0];
        [firstBtn setSelected:YES];
        if (_isChangeLine){
            [_bottomArrowView setCenter:CGPointMake(firstBtn.center.x, 47*MZ_RATE)];
        }else{
            [_bottomArrowView setCenter:CGPointMake(firstBtn.center.x, _bottomArrowView.center.y)];
        }
        
    }
    
}

-(void)setSelectBlowColor:(UIColor *)selectBlowColor
{
    if(selectBlowColor){
        _selectBlowColor = selectBlowColor;
        _bottomArrowView.backgroundColor = _selectBlowColor;
    }
}

-(void)btnClicked:(UIButton*)sender{
    UIButton*button = sender;
    [self selectTheSegument:button.tag];
}

-(void)setUnreadCountWithNum:(NSInteger)num index:(NSInteger)index
{
    UILabel *label = self.numLabels[index];
    label.text = [NSString stringWithFormat:@"%zd",num];
    if(num == 0){
        label.hidden = YES;
    }else if (num > 0 && num < 10 ){
        label.frame = CGRectMake(_widthFloat /2.0 + 10*MZ_RATE, 5*MZ_RATE, 12*MZ_RATE, 12*MZ_RATE);
        label.text = [NSString stringWithFormat:@"%zd",num];
        label.hidden = NO;
    }else if (num > 10 && num < 99){
        label.frame = CGRectMake(_widthFloat /2.0 + 10*MZ_RATE, 5*MZ_RATE, 20*MZ_RATE, 12*MZ_RATE);
        label.text = [NSString stringWithFormat:@"%zd",num];
        label.hidden = NO;
    }else {
        label.frame = CGRectMake(_widthFloat /2.0 + 10*MZ_RATE, 5*MZ_RATE, 20*MZ_RATE, 12*MZ_RATE);
        label.text = @"99+";
        label.hidden = NO;
    }
}

-(void)selectTheSegument:(NSInteger)segment{
    if (segment > self.buttonArray.count-1) {
        return;
    }
    if (selectSegment!=segment) {
        UIButton *NextButton =self.buttons[selectSegment];
        [self.buttons[selectSegment] setSelected:NO];
        NextButton.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size: 12*MZ_RATE];
        [self.buttons[segment] setSelected:YES];
        UIButton *currentButton = self.buttons[segment];
        currentButton.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size: 16*MZ_RATE];
        [UIView animateWithDuration:0.1 animations:^{
            if (_isChangeLine){
                _bottomArrowView.bounds = CGRectMake(0, self.height/2+self.titleFont.pointSize/2.0 + 4*MZ_RATE, 16*MZ_RATE, 3*MZ_RATE);
                [_bottomArrowView setCenter:CGPointMake(currentButton.center.x, 47*MZ_RATE)];
            }else{
                _bottomArrowView.bounds = CGRectMake(0, self.height - 2*MZ_RATE, 16*MZ_RATE, 2*MZ_RATE);
                [_bottomArrowView setCenter:CGPointMake(currentButton.center.x, _bottomArrowView.center.y)];
            }
            
        }];
        selectSegment=segment;
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedViewTitleSelectWithIndex:)]) {
            [self.delegate segmentedViewTitleSelectWithIndex:selectSegment];
        }
    }
}
- (void)setIsChangeLine:(BOOL)isChangeLine
{
    _isChangeLine = isChangeLine;
}

@end
