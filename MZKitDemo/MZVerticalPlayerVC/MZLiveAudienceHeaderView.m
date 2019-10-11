//
//  MZLiveAudienceHeaderView.m
//  MengZhuPush
//
//  Created by LiWei on 2019/9/24.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZLiveAudienceHeaderView.h"

@interface MZLiveAudienceHeaderView ()

@property (nonatomic ,strong)UIButton *headBtnOne;
@property (nonatomic ,strong)UIButton *headBtnTwo;
@property (nonatomic ,strong)UIButton *headBtnThree;
@property (nonatomic ,strong)UILabel  *numLabel;
@end
@implementation MZLiveAudienceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    self.headBtnOne = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28*MZ_RATE, 28*MZ_RATE)] roundChangeWithRadius:14*MZ_RATE];
    self.headBtnOne.alpha = 0;
    [self addSubview:self.headBtnOne];
    [self.headBtnOne addTarget:self action:@selector(onlineUserDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.headBtnTwo = [[[UIButton alloc]initWithFrame:CGRectMake(self.headBtnOne.right - 6*MZ_RATE, 0, 28*MZ_RATE, 28*MZ_RATE)] roundChangeWithRadius:14*MZ_RATE];
    self.headBtnTwo.alpha = 0;
    [self insertSubview:self.headBtnTwo belowSubview:self.headBtnOne];
    [self.headBtnTwo addTarget:self action:@selector(onlineUserDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.headBtnThree = [[[UIButton alloc]initWithFrame:CGRectMake(self.headBtnTwo.right - 6*MZ_RATE, 0, 28*MZ_RATE, 28*MZ_RATE)] roundChangeWithRadius:14*MZ_RATE];
    self.headBtnThree.alpha = 0;
    [self insertSubview:self.headBtnThree belowSubview:self.headBtnTwo];
    [self.headBtnThree addTarget:self action:@selector(onlineUserDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.numLabel = [[[UILabel alloc]initWithFrame:CGRectMake(self.headBtnThree.right + 3*MZ_RATE, 0, 41*MZ_RATE, 28*MZ_RATE)] roundChangeWithRadius:14*MZ_RATE];
    self.numLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    self.numLabel.backgroundColor = MakeColorRGBA(0x000000, 0.25);
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.textColor = MakeColorRGB(0xffffff);
    self.numLabel.text = @"0";
    [self addSubview:self.numLabel];
    
}

-(void)setImageUrlArr:(NSArray *)imageUrlArr
{
    _imageUrlArr = imageUrlArr;
    self.headBtnOne.alpha = 0;
    self.headBtnTwo.alpha = 0;
    self.headBtnThree.alpha = 0;
    if (imageUrlArr.count>=1) {
        self.headBtnOne.alpha = 1;
        [self.headBtnOne sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[0]] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
        if (imageUrlArr.count>=2) {
            self.headBtnTwo.alpha = 1;
            [self.headBtnTwo sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[1]] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
            if (imageUrlArr.count>=3) {
                self.headBtnThree.alpha = 1;
                 [self.headBtnThree sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[2]] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
                
            }
        }
    }
    
   
    
}

-(void)setNumStr:(NSString *)numStr
{
    _numStr = numStr;
    self.numLabel.text = numStr;
}
-(void)onlineUserDidClick{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
