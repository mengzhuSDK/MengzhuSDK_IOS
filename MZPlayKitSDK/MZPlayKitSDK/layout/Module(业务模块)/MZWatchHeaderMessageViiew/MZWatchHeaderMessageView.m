//
//  MZWatchHeaderMessageView.m
//  MengZhu
//
//  Created by developer_k on 16/6/29.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZWatchHeaderMessageView.h"

@interface MZWatchHeaderMessageView()
{
    UIButton *_contentView;
    UIImageView * _header;
    UIView * _header_background_view;
    UILabel * _nameL;
}
@property (nonatomic ,strong)UIButton *closeBtn;
@property (nonatomic ,strong)UIButton *bannedBtn;
@property (nonatomic ,strong)UIButton *kickoutBtn;
@property (nonatomic,copy)void(^action)(HeadViewActionType actionType);

@end
@implementation MZWatchHeaderMessageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MakeColorRGBA(0x000000, 0.4);
        self.frame = frame;
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self reloadUI];
    }
    return self;
}

-(void)reloadUI
{
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = 1.0;
    }
    
    CGRect audienceFrame;
    if(self.isMySelf){
        audienceFrame = CGRectMake((self.width - MZ_SW)/2.0, self.height-254*space, MZ_SW, 254*space);
    }else{
        audienceFrame = CGRectMake((self.width - MZ_SW)/2.0, self.height-294*space, MZ_SW, 294*space);
    }
    if(!_contentView){
        _contentView = [[[UIButton alloc] initWithFrame:audienceFrame] roundChangeWithRadius:16*space];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = NO;
        [self addSubview:_contentView];
    }
    _contentView.frame = audienceFrame;
    
    if (!_closeBtn) {
        self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(_contentView.right - 36*space, 12*space, 24*space, 24*space)];
        [self.closeBtn setImage:[UIImage imageNamed:@"sss-dbuton_dalclose"] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:self.closeBtn];
    }
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        self.closeBtn.frame = CGRectMake(_contentView.frame.size.width - 36*space, 12*space, 24*space, 24*space);
    } else {
        self.closeBtn.frame = CGRectMake(_contentView.right - 36*space, 12*space, 24*space, 24*space);
    }
    
    if(!_header){
        _header_background_view = [MZCreatUI viewWithBackgroundColor:[UIColor clearColor]];
        _header_background_view.frame = CGRectMake((MZ_SW - 100*space)/2.0, 38*space, 100*space, 100*space);
        [_contentView addSubview:_header_background_view];
        [_header_background_view roundChangeWithRadius:_header_background_view.height/2.0];
        _header_background_view.layer.borderWidth = 1*space;
        _header_background_view.layer.borderColor = MakeColor(255,31,96,1).CGColor;
        
        _header = [[UIImageView alloc]initWithFrame:CGRectMake((MZ_SW - 96*space)/2.0 , 40*space, 96*space, 96*space)];
        [_header sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"personPlaceHold"]];
        [_contentView addSubview:_header];
        [_header roundChangeWithRadius:_header.height/2.0];
        _header.layer.borderWidth = 1*space;
        _header.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    _header_background_view.frame = CGRectMake((MZ_SW - 100*space)/2.0, 38*space, 100*space, 100*space);
    _header.frame = CGRectMake((MZ_SW - 96*space)/2.0, 40*space, 96*space, 96*space);
    
    if(!_nameL){
        _nameL = [[UILabel alloc]initWithFrame:CGRectMake(18*space, 52*space, MZ_SW - 36*space, 28*space)];
        _nameL.textAlignment = NSTextAlignmentCenter;
        _nameL.font = [UIFont systemFontOfSize:18*space];
        _nameL.textColor = MakeColor(89, 89, 89, 1);
        [_contentView addSubview:_nameL];
    }
    _nameL.frame = CGRectMake(18*space, 151*space, MZ_SW - 36*space, 28*space);
    
    if (!self.kickoutBtn) {
        self.kickoutBtn = [[[UIButton alloc]initWithFrame:CGRectMake(46*space, _nameL.bottom + 31*space, 137*space, 38*space)] roundChangeWithRadius:19*space];
        [self.kickoutBtn addTarget:self action:@selector(kickoutBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        self.kickoutBtn.titleLabel.font = FontSystemSize(14*space);
        [self.kickoutBtn setTitle:@"踢出" forState:UIControlStateNormal];
        [self.kickoutBtn setTitleColor:MakeColor(255,31,96,1) forState:UIControlStateNormal];
        [self.kickoutBtn setBackgroundColor:[UIColor whiteColor]];
        [self.kickoutBtn.layer setBorderWidth:1];
        [self.kickoutBtn.layer setBorderColor:MakeColor(255, 31, 96, 1).CGColor];
        [_contentView addSubview:self.kickoutBtn];
    }
    if(!self.bannedBtn){
        self.bannedBtn = [[[UIButton alloc]initWithFrame:CGRectMake(self.kickoutBtn.right+10*space, self.kickoutBtn.top, 137*space, 38*space)] roundChangeWithRadius:20*space];
        [self.bannedBtn addTarget:self action:@selector(bannedBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        self.bannedBtn.titleLabel.font = FontSystemSize(14*space);
        [self.bannedBtn setTitle:@"禁言" forState:UIControlStateNormal];
        [self.bannedBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [self.bannedBtn setBackgroundColor:MakeColor(255, 31, 96, 1)];
        [_contentView addSubview:self.bannedBtn];
    }
    self.kickoutBtn.hidden = self.isMySelf;
    self.bannedBtn.hidden = self.isMySelf;
}
-(void)showWithView:(UIView *)view action:(void(^)(HeadViewActionType actionType))action
{
    float space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }
    
    self.action = action;
    CGRect audienceFrame;
    if(self.isMySelf){
        audienceFrame = CGRectMake((self.width - MZ_SW)/2.0, self.height-254*space, MZ_SW, 254*space);
    }else{
        audienceFrame = CGRectMake((self.width - MZ_SW)/2.0, self.height-294*space, MZ_SW, 294*space);
    }
    _contentView.frame = audienceFrame;
    [view addSubview:self];
}
-(void)dismiss
{
    [self removeFromSuperview];
}

-(void)setOtherUserInfoModel:(MZLiveUserModel *)otherUserInfoModel
{
    _otherUserInfoModel = otherUserInfoModel;
    if (self.isMySelf) {
        [self reloadUI];
    } else {
        [self.kickoutBtn setTitle:otherUserInfoModel.is_kickOut ? @"解除踢出":@"踢出" forState:UIControlStateNormal];
        [self.bannedBtn setTitle:otherUserInfoModel.is_banned ? @"解禁":@"禁言" forState:UIControlStateNormal];
    }

    [_header sd_setImageWithURL:[self customUrlWithStr:otherUserInfoModel.avatar] placeholderImage:[UIImage imageNamed:@"personPlaceHold"]];
    _nameL.text =EmptyForNil([MZBaseGlobalTools cutStringWithString:otherUserInfoModel.nickname SizeOf:16]);
}

-(NSURL *)customUrlWithStr:(NSString *)str
{
//    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; //这个方法是解决链接中含有中文字符的情况（有特殊字符还是不能正常显示），下面的方法是可以的
   str = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return [NSURL URLWithString:str];
}

-(void)closeButtonClick {
    [self dismiss];
}

-(void)kickoutBtnDidClick {
    if (_action) {
        self.action(HeadViewActionTypeKick);
    }
    [self dismiss];
}

-(void)bannedBtnDidClick
{
    if (_action) {
        self.action(HeadViewActionTypeBlock);
    }
    [self dismiss];
}


@end
