//
//  MZLiveAlerView.m
//  MengZhu
//
//  Created by LiWei on 2019/8/26.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#import "MZLiveAlertView.h"
@interface MZLiveAlertView ()

@property (nonatomic ,strong)UIView *centerView;
@property (nonatomic ,strong)UILabel *tipLabel;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UIButton *leftBtn;
@property (nonatomic ,strong)UIButton *rightBtn;
@property (nonatomic ,strong)UIView *line1;
@property (nonatomic ,strong)UIView *line2;
@property (nonatomic,copy) AlertViewClickBlock clickBlock;
@end
@implementation MZLiveAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }

    
    self.backgroundColor = MakeColorRGBA(0x000000, 0.4);
    self.centerView = [[[UIView alloc]init]roundChangeWithRadius:10*space];
    self.centerView.backgroundColor = MakeColorRGBA(0xffffff, 1);
    [self addSubview:self.centerView];
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18*space];
    self.tipLabel.textColor = MakeColorRGB(0x000000);
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.text = @"温馨提示";
    [self.centerView addSubview:self.tipLabel];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = FontSystemSize(14*space);
    self.titleLabel.textColor = MakeColorRGB(0x666666);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.centerView addSubview:self.titleLabel];
    
    self.leftBtn = [[UIButton alloc]init];
    [self.leftBtn setTitleColor:MakeColorRGB(0x999999) forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = FontSystemSize(14*space);
    self.leftBtn.backgroundColor = MakeColorRGB(0xffffff);
    [self.leftBtn addTarget:self action:@selector(leftBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView addSubview:self.leftBtn];
    
    self.rightBtn = [[UIButton alloc]init];
    [self.rightBtn setTitleColor:MakeColorRGB(0x00dc58) forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14*space];
    [self.rightBtn addTarget:self action:@selector(rightBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView addSubview:self.rightBtn];
    
    self.line1 = [[UIView alloc]init];
    self.line1.backgroundColor = MakeColorRGB(0xdddddd);
    [self.centerView addSubview:self.line1];
    
    self.line2 = [[UIView alloc]init];
    self.line2.backgroundColor = MakeColorRGB(0xdddddd);
    [self.centerView addSubview:self.line2];
    
}
//
-(void)showInWithView:(UIView *)view title:(NSString *)title leftBtn:(NSString *)leftBtnStr rightBtn:(NSString *)rightBtnStr clickBlock:(AlertViewClickBlock )clickBlock;
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

   

    BOOL isLandScapeRate = UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height;
    float landScapeRate = MZ_FULL_RATE;

    if (isLandScapeRate) {
        
        CGFloat titleH = [MZBaseGlobalTools getLabelHeightWithText:title width:236*landScapeRate font:14*landScapeRate];
        
        CGFloat centerW = 315*landScapeRate;
        CGFloat centerH = 151*landScapeRate;
        self.tipLabel.frame = CGRectMake(0, 20*landScapeRate,315*landScapeRate, 26*landScapeRate);
        self.centerView.frame = CGRectMake((self.width - centerW)/2.0, (self.height - centerH)/2.0, centerW, centerH);
        self.line1.frame = CGRectMake(0, self.centerView.height - 44*landScapeRate - 1, self.centerView.width, 0.5);
        self.titleLabel.frame = CGRectMake(0, 56*landScapeRate, self.centerView.width, titleH);
    } else {
        CGFloat titleH = [MZBaseGlobalTools getLabelHeightWithText:title width:236*MZ_RATE font:14*MZ_RATE];
        
        CGFloat centerW = 315*MZ_RATE;
        CGFloat centerH = 151*MZ_RATE;
        self.tipLabel.frame = CGRectMake(0, 20*MZ_RATE,315*MZ_RATE, 26*MZ_RATE);
        self.centerView.frame = CGRectMake((self.width - centerW)/2.0, (self.height - centerH)/2.0, centerW, centerH);
        self.line1.frame = CGRectMake(0, self.centerView.height - 44*MZ_RATE - 1, self.centerView.width, 0.5);
        self.titleLabel.frame = CGRectMake(0, 56*MZ_RATE, self.centerView.width, titleH);
    }
    
    
    self.clickBlock = clickBlock;
    self.titleLabel.text = title;

    if(!leftBtnStr){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        if (isLandScapeRate) {
            self.rightBtn.frame = CGRectMake(0, self.centerView.height - 44*landScapeRate, self.centerView.width, 44*landScapeRate);
        } else {
            self.rightBtn.frame = CGRectMake(0, self.centerView.height - 44*MZ_RATE, self.centerView.width, 44*MZ_RATE);
        }
        self.line2.hidden = YES;
        [self.rightBtn setTitle:rightBtnStr forState:UIControlStateNormal];
    }else{
        if(!rightBtnStr){
            self.rightBtn.hidden = YES;
            self.leftBtn.hidden = NO;
            if (isLandScapeRate) {
                self.leftBtn.frame = CGRectMake(0, self.centerView.height - 44*landScapeRate, self.centerView.width, 44*landScapeRate);
            } else {
                self.leftBtn.frame = CGRectMake(0, self.centerView.height - 44*MZ_RATE, self.centerView.width, 44*MZ_RATE);
            }
            [self.leftBtn setTitle:leftBtnStr forState:UIControlStateNormal];
            self.line2.hidden = YES;
        }else{
            self.leftBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            self.line2.hidden = NO;
            if (isLandScapeRate) {
                self.line2.frame = CGRectMake((self.centerView.width - 1)/2.0, self.line1.bottom, 0.5, 44*landScapeRate);
                self.leftBtn.frame = CGRectMake(0, self.centerView.height - 44*landScapeRate, self.centerView.width/2.0, 44*landScapeRate);
                self.rightBtn.frame = CGRectMake(self.leftBtn.right, self.centerView.height - 44*landScapeRate, self.centerView.width/2.0, 44*landScapeRate);
            } else {
                self.line2.frame = CGRectMake((self.centerView.width - 1)/2.0, self.line1.bottom, 0.5, 44*MZ_RATE);
                self.leftBtn.frame = CGRectMake(0, self.centerView.height - 44*MZ_RATE, self.centerView.width/2.0, 44*MZ_RATE);
                self.rightBtn.frame = CGRectMake(self.leftBtn.right, self.centerView.height - 44*MZ_RATE, self.centerView.width/2.0, 44*MZ_RATE);
            }
            [self.leftBtn setTitle:leftBtnStr forState:UIControlStateNormal];
            [self.rightBtn setTitle:rightBtnStr forState:UIControlStateNormal];
        }
    }
    [view addSubview:self];
    
}

-(void)leftBtnDidClick
{
    if(self && self.clickBlock){
        [self removeFromSuperview];
        self.clickBlock(MZLiveAlerLeftClick);
    }
}

-(void)rightBtnDidClick
{
    if(self && self.clickBlock){
        [self removeFromSuperview];
        self.clickBlock(MZLiveAlerRightClick);
    }
}

@end
