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

- (void)layoutSubviews {
    [super layoutSubviews];
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }
    
    self.headBtnOne.frame = CGRectMake(0, 0, 28*space, 28*space);
    [self.headBtnOne.layer setCornerRadius:(28*space/2.0)];
    
    self.headBtnTwo.frame = CGRectMake(self.headBtnOne.right - 6*space, 0, 28*space, 28*space);
    [self.headBtnTwo.layer setCornerRadius:(28*space/2.0)];
    
    self.headBtnThree.frame = CGRectMake(self.headBtnTwo.right - 6*space, 0, 28*space, 28*space);
    [self.headBtnThree.layer setCornerRadius:(28*space/2.0)];
    
    self.numLabel.frame = CGRectMake(self.headBtnThree.right + 3*space, 0, 41*space, 28*space);
    self.numLabel.font = FontSystemSize(12*space);

}

-(void)setupUI
{
    self.headBtnOne = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28*MZ_RATE, 28*MZ_RATE)] roundChangeWithRadius:14*MZ_RATE];
    self.headBtnOne.hidden = YES;
    [self.headBtnOne addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headBtnOne];
    
    self.headBtnTwo = [[[UIButton alloc]initWithFrame:CGRectMake(self.headBtnOne.right - 6*MZ_RATE, 0, 28*MZ_RATE, 28*MZ_RATE)] roundChangeWithRadius:14*MZ_RATE];
    self.headBtnTwo.hidden = YES;
    [self.headBtnTwo addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:self.headBtnTwo belowSubview:self.headBtnOne];
    
    self.headBtnThree = [[[UIButton alloc]initWithFrame:CGRectMake(self.headBtnTwo.right - 6*MZ_RATE, 0, 28*MZ_RATE, 28*MZ_RATE)] roundChangeWithRadius:14*MZ_RATE];
    self.headBtnThree.hidden = YES;
    [self.headBtnThree addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:self.headBtnThree belowSubview:self.headBtnTwo];
    
    self.numLabel = [[[UILabel alloc]initWithFrame:CGRectMake(self.headBtnThree.right + 3*MZ_RATE, 0, 41*MZ_RATE, 28*MZ_RATE)] roundChangeWithRadius:14*MZ_RATE];
    self.numLabel.hidden = YES;
    self.numLabel.font = FontSystemSize(12*MZ_RATE);
    self.numLabel.backgroundColor = MakeColorRGBA(0x000000, 0.25);
    self.numLabel.backgroundColor = [UIColor clearColor];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.textColor = MakeColorRGB(0xffffff);
    [self addSubview:self.numLabel];
    
}


-(void)setUserArr:(NSArray *)userArr
{
    for (MZUser *user in userArr) {
         NSLog(@"user.avatar %@",user.avatar);
    }
     NSLog(@"%@",[NSThread currentThread]);
    _userArr = userArr;
    if(userArr.count >= 3){
         NSLog(@"%@-----%@----%@",[(MZUser *)userArr[userArr.count - 1] avatar],[(MZUser *)userArr[userArr.count - 2] avatar],[(MZUser *)userArr[userArr.count - 3] avatar]);
        [self.headBtnOne sd_setImageWithURL:[NSURL URLWithString:((MZUser *)userArr[userArr.count - 1]).avatar] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
        [self.headBtnTwo sd_setImageWithURL:[NSURL URLWithString:((MZUser *)userArr[userArr.count - 2]).avatar] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
        [self.headBtnThree sd_setImageWithURL:[NSURL URLWithString:((MZUser *)userArr[userArr.count - 3]).avatar] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
        
        self.headBtnOne.hidden = NO;
        self.headBtnTwo.hidden = NO;
        self.headBtnThree.hidden = NO;
        self.numLabel.hidden = NO;
        
    }else if (userArr.count == 2){
        self.headBtnOne.hidden = YES;
        [self.headBtnTwo sd_setImageWithURL:[NSURL URLWithString:((MZUser *)userArr[userArr.count - 1]).avatar] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
        [self.headBtnThree sd_setImageWithURL:[NSURL URLWithString:((MZUser *)userArr[userArr.count - 2]).avatar] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
        self.headBtnTwo.hidden = NO;
        self.headBtnThree.hidden = NO;
        self.numLabel.hidden = NO;
    }else if (userArr.count == 1){
        [self.headBtnThree sd_setImageWithURL:[NSURL URLWithString:((MZUser *)userArr[userArr.count - 1]).avatar] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
        self.headBtnOne.hidden = YES;
        self.headBtnTwo.hidden = YES;
        self.headBtnThree.hidden = NO;
        self.numLabel.hidden = NO;
    }else if (userArr.count == 0){
        self.headBtnOne.hidden = YES;
        self.headBtnTwo.hidden = YES;
        self.headBtnThree.hidden = YES;
        self.numLabel.hidden = YES;
    }
    
    self.numLabel.text = [NSString stringWithFormat:@"%d",(int)_userArr.count];
}

- (void)avatarClick{
    if (self.clickBlock) {
        self.clickBlock();
    }
}
@end
