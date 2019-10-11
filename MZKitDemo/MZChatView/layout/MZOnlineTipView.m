//
//  MZOnlineTipView.m
//  MengZhuPush
//
//  Created by LiWei on 2019/9/26.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZOnlineTipView.h"

@interface MZOnlineTipView ()
@property (nonatomic ,strong)UIImageView *signImageView;

@property (nonatomic ,strong)UILabel *myTitleLabel;
@property (nonatomic ,strong)UILabel *signLabel;
@end

@implementation MZOnlineTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self roundChangeWithRadius:4*MZ_RATE];
        self.backgroundColor = MakeColorRGBA(0xff2145, 0.5);
    }
    return self;
}

-(void)setupUI
{
    self.signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*MZ_RATE, 5*MZ_RATE, 16*MZ_RATE, 15*MZ_RATE)];
    self.signImageView.image = ImageName(@"live_onlineSign");
    [self addSubview:self.signImageView];
    
    self.myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.signImageView.right + 8*MZ_RATE, 4*MZ_RATE, 44*MZ_RATE, 17*MZ_RATE)];
    self.myTitleLabel.font = FontSystemSize(12*MZ_RATE);
    self.myTitleLabel.textColor = MakeColorRGB(0xffffff);
    [self addSubview:self.myTitleLabel];
    
    self.signLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.myTitleLabel.right, self.myTitleLabel.top, 25*MZ_RATE, 17*MZ_RATE)];
    self.signLabel.font = FontSystemSize(12*MZ_RATE);
    self.signLabel.text = @"来了";
    self.signLabel.textColor = MakeColorRGB(0xffffff);
    [self addSubview:self.signLabel];
}

-(void)setSignImage:(UIImage *)signImage
{
    _signImage = signImage;
    self.signImageView.image = signImage;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.myTitleLabel.text = title;
}

@end
