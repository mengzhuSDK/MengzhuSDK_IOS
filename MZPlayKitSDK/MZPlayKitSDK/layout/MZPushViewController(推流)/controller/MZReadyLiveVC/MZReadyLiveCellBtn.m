//
//  MZReadyLiveCellBtn.m
//  MengZhu
//
//  Created by 李伟 on 2019/4/16.
//  Copyright © 2019 www.mengzhu.com. All rights reserved.
//

#import "MZReadyLiveCellBtn.h"
@interface MZReadyLiveCellBtn()
@property (nonatomic ,strong)UIImageView *moreImageV;
@property (nonatomic ,strong)UIImageView *selectImageView;
@end
@implementation MZReadyLiveCellBtn

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
    self.keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(16*MZ_RATE, 12*MZ_RATE, 100*MZ_RATE, 20*MZ_RATE)];
    self.keyLabel.textColor = MakeColorRGB(0xf3f3f3);
    self.keyLabel.font = FontSystemSize(14*MZ_RATE);
    [self addSubview:self.keyLabel];
    
    self.moreImageV = [[UIImageView alloc]initWithFrame:CGRectMake(MZ_SW - 24*MZ_RATE, 16*MZ_RATE, 8*MZ_RATE, 13*MZ_RATE)];
    self.moreImageV.image = ImageName(@"liveCreat_more");
    [self addSubview:self.moreImageV];
    
    self.valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.moreImageV.left - 11*MZ_RATE - 250*MZ_RATE, 12*MZ_RATE, 250*MZ_RATE, 20*MZ_RATE)];
    self.valueLabel.textAlignment = NSTextAlignmentRight;
    self.valueLabel.textColor = MakeColorRGB(0x9b9b9b);
    self.valueLabel.font = FontSystemSize(14*MZ_RATE);
    [self addSubview:self.valueLabel];
    
    self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MZ_SW - 32*MZ_RATE, 14*MZ_RATE, 16*MZ_RATE, 16*MZ_RATE)];
    self.selectImageView.image = ImageName(@"liveCreat_select");
    self.selectImageView.hidden = YES;
    [self addSubview:self.selectImageView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(16*MZ_RATE, 44*MZ_RATE - 1, MZ_SW - 16*MZ_RATE, 1)];
    self.lineView.backgroundColor = MakeColorRGBA(0xffffff, 0.1);
    [self addSubview:self.lineView];
    
}

-(void)setIsShowSelectView:(BOOL)isShowSelectView
{
    self.moreImageV.hidden = isShowSelectView ? YES : NO;
    self.valueLabel.hidden = isShowSelectView ? YES : NO;
    self.selectImageView.hidden = isShowSelectView ? NO : YES;
}

-(void)setIsSelectStatue:(BOOL)isSelectStatue
{
    _isSelectStatue = isSelectStatue;
    if(isSelectStatue){
        self.selectImageView.image = ImageName(@"liveCreat_select");
    }else{
        self.selectImageView.image = ImageName(@"liveCreat_unSelect");
    }
}

@end
