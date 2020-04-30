//
//  MZReadyLiveHeaderView.m
//  MengZhu
//
//  Created by 李伟 on 2019/4/16.
//  Copyright © 2019 www.mengzhu.com. All rights reserved.
//

#import "MZReadyLiveHeaderView.h"
@interface MZReadyLiveHeaderView()

@end
@implementation MZReadyLiveHeaderView

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
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16*MZ_RATE, 20*MZ_RATE, 80*MZ_RATE, 20*MZ_RATE)];
    self.titleLabel.textColor = MakeColorRGB(0xf3f3f3);
    self.titleLabel.font = FontSystemSize(14*MZ_RATE);
    [self addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 4*MZ_RATE, 220*MZ_RATE, 17*MZ_RATE)];
    self.subTitleLabel.textColor = MakeColorRGB(0x9b9b9b);
    self.subTitleLabel.font = FontSystemSize(12*MZ_RATE);
    [self addSubview:self.subTitleLabel];
    
    UIView *imageBGView = [[[UIView alloc]initWithFrame:CGRectMake(MZ_SW - 124*MZ_RATE, 10*MZ_RATE, 108*MZ_RATE, 60*MZ_RATE)]roundChangeWithRadius:2];
    imageBGView.backgroundColor = MakeColorRGBA(0xffffff, 0.1);
    [self addSubview:imageBGView];
    
    self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(42*MZ_RATE, 18*MZ_RATE, 24*MZ_RATE, 24*MZ_RATE)];
    [self.addBtn setImage:ImageName(@"liveCreat_添加") forState:0];
    [imageBGView addSubview:self.addBtn];
    
    self.addImageView = [[UIImageView alloc]initWithFrame:imageBGView.bounds];
    self.addImageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageBGView addSubview:self.addImageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16*MZ_RATE, 80*MZ_RATE - 1, MZ_SW - 16*MZ_RATE, 1)];
    lineView.backgroundColor = MakeColorRGBA(0xffffff, 0.1);
    [self addSubview:lineView];
}


@end
