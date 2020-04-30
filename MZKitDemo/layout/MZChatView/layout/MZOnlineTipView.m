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
//@property (nonatomic ,strong)UILabel *signLabel;
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
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }
    [self roundChangeWithRadius:4*space];
    
    self.signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*space, (self.height - 15*space)/2.0, 16*space, 15*space)];
    self.signImageView.image = ImageName(@"live_onlineSign");
    [self addSubview:self.signImageView];
    
    self.myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.signImageView.right + 8*space, (self.height - 17*space)/2.0, self.width - (self.signImageView.right + 16*space), 17*space)];
    self.myTitleLabel.font = FontSystemSize(12*space);
    self.myTitleLabel.textColor = MakeColorRGB(0xffffff);
    [self addSubview:self.myTitleLabel];
    
//    self.signLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.myTitleLabel.right, self.myTitleLabel.top, 25*space, 17*space)];
//    self.signLabel.font = FontSystemSize(12*space);
//    self.signLabel.text = @"来了";
//    self.signLabel.textColor = MakeColorRGB(0xffffff);
//    [self addSubview:self.signLabel];
}

-(void)setSignImage:(UIImage *)signImage
{
    _signImage = signImage;
    self.signImageView.image = signImage;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.myTitleLabel.text = [NSString stringWithFormat:@"%@ 来了",_title];
    
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }
    self.myTitleLabel.frame = CGRectMake(self.myTitleLabel.frame.origin.x, self.myTitleLabel.frame.origin.y, self.width - (26*space + 5*space), 17*space);
}

@end
