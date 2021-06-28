//
//  MZUserTipView.m
//  MengZhuPush
//
//  Created by LiWei on 2019/9/25.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZUserTipView.h"
@interface MZUserTipView ()
@property (nonatomic ,strong)UIImageView *headerImageV;
@property (nonatomic ,strong)UILabel *tipLabel;
@property (nonatomic ,strong)UIButton *kicOutBtn;
@property (nonatomic ,strong)UIButton *cancelBtn;

@end
@implementation MZUserTipView

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
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc] initWithEffect:effect];
    visualEffect.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:visualEffect];
    
    UIView *centerView = [[[UIView alloc]initWithFrame:CGRectMake((self.width - 245*space)/2.0, (self.height - 315*space)/2.0, 245*space, 315*space)] roundChangeWithRadius:12*space];
    centerView.backgroundColor = [UIColor whiteColor];
    [visualEffect.contentView addSubview:centerView];
    
    self.headerImageV = [[[UIImageView alloc]initWithFrame:CGRectMake(78*space, 30*space, 90*space, 90*space)] roundChangeWithRadius:45*space];
    self.headerImageV.image = MZ_SDK_UserIcon_DefaultImage;
    [centerView addSubview:self.headerImageV];
    [self.headerImageV sd_setImageWithURL:[NSURL URLWithString:[MZBaseUserServer currentUser].avatar] placeholderImage:MZ_SDK_UserIcon_DefaultImage];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*space, self.headerImageV.bottom + 11*space, 185*space, 44*space)];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.textColor = MakeColorRGB(0x333333);
    self.tipLabel.font = FontSystemSize(16*space);
    self.tipLabel.adjustsFontSizeToFitWidth = YES;
    [centerView addSubview:self.tipLabel];
    self.tipLabel.text = [NSString stringWithFormat:@"确认要将%@禁言吗？",[MZBaseUserServer currentUser].nickName];
    
    self.kicOutBtn = [[[UIButton alloc]initWithFrame:CGRectMake(57*space, self.tipLabel.bottom + 25*space, 132*space, 36*space)]roundChangeWithRadius:18*space];
    [self.kicOutBtn setBackgroundImage:ImageName(@"shadeBtnBg") forState:UIControlStateNormal];
    [self.kicOutBtn setTitle:@"确认禁言" forState:UIControlStateNormal];
    [self.kicOutBtn setTitleColor:MakeColorRGB(0xffffff) forState:UIControlStateNormal];
    self.kicOutBtn.titleLabel.font = FontSystemSize(16*space);
    [self.kicOutBtn addTarget:self action:@selector(kicOutBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:self.kicOutBtn];
    
    self.cancelBtn = [[[UIButton alloc]initWithFrame:CGRectMake(self.kicOutBtn.left, self.kicOutBtn.bottom + 13*space, self.kicOutBtn.width, self.kicOutBtn.height)]roundChangeWithRadius:18*space];
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.borderColor = MakeColorRGB(0xdddddd).CGColor;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = FontSystemSize(16*space);
    [self.cancelBtn addTarget:self action:@selector(cancelBtnBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:self.cancelBtn];
    
}

-(void)setOtherUser:(MZLiveUserModel *)otherUser
{
    _otherUser = otherUser;
    [self.headerImageV sd_setImageWithURL:[NSURL URLWithString:otherUser.avatar] placeholderImage:MZ_SDK_UserIcon_DefaultImage];
    if (self.isKickOut) {
        NSString *str = otherUser.is_kickOut ? @"解除踢出":@"踢出";
        [self.kicOutBtn setTitle:otherUser.is_kickOut ? @"解除踢出":@"确认踢出" forState:UIControlStateNormal];
        self.tipLabel.text = [NSString stringWithFormat:@"确认要将%@%@吗？",otherUser.nickname,str];
    } else {
        NSString *str = otherUser.is_banned ? @"解禁":@"禁言";
        [self.kicOutBtn setTitle:otherUser.is_banned ? @"确认解禁":@"确认禁言" forState:UIControlStateNormal];
        self.tipLabel.text = [NSString stringWithFormat:@"确认要将%@%@吗？",otherUser.nickname,str];
    }
}

-(void)kicOutBtnDidClick
{
    if (self.isKickOut) {
        if (self && self.userTipBlock) {
            self.userTipBlock(self.otherUser.is_kickOut ? MZUserTipTypeUnKickOut :MZUserTipTypeKickOut);
        }
    } else {
        if(self && self.userTipBlock){
            self.userTipBlock(self.otherUser.is_banned ? MZUserTipTypeUnBanned :MZUserTipTypeBanned);
            
        }
    }
}

-(void)cancelBtnBtnDidClick
{
    if(self && self.userTipBlock){
        self.userTipBlock(MZUserTipTypeCancel);
    }
}

@end
