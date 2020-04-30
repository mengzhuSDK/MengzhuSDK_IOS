//
//  MZWatchHeaderMessageView.m
//  MengZhu
//
//  Created by developer_k on 16/6/29.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZWatchHeaderMessageView.h"
#import "MZLiveViewController.h"

@interface MZWatchHeaderMessageView()<UIAlertViewDelegate>
{
    UIButton *_contentView;
    UIImageView * _header;
    UILabel * _nameL;
    UILabel * _mengzhuIDLabel;
    UILabel * _liveL;
}
@property (nonatomic ,strong)UILabel * followL;
@property (nonatomic ,strong)UILabel * fansL;
@property (nonatomic ,strong)UIButton *bannedBtn;
@property (nonatomic,copy)void(^action)(HeadViewActionType actionType);
@property (nonatomic ,strong)UIView *line1;
@property (nonatomic ,strong)UIView *line2;

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
        audienceFrame = CGRectMake((self.width - MZ_SW)/2.0, self.height - 260*space, MZ_SW, 260  * space);
    }else{
        audienceFrame = CGRectMake((self.width - MZ_SW)/2.0, self.height - 220*space, MZ_SW, 220  * space);
    }
    if(!_contentView){
        _contentView = [[[UIButton alloc] initWithFrame:audienceFrame] roundChangeWithRadius:16*space];
        _contentView.backgroundColor = MakeColorRGB(0x1d1b22);
        _contentView.layer.masksToBounds = NO;
        [self addSubview:_contentView];
    }
    _contentView.frame = audienceFrame;
    
    if(!_header){
        _header = [[UIImageView alloc]initWithFrame:CGRectMake((MZ_SW - 80*space)/2.0 , -40*space, 80*space, 80*space)];
        [_header sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"personPlaceHold"]];
        [_contentView addSubview:_header];
        [_header roundChangeWithRadius:_header.height/2.0];
        _header.layer.borderWidth = 4*space;
        _header.layer.borderColor = MakeColorRGB(0x1e1a22).CGColor;
    }
    _header.frame = CGRectMake((MZ_SW - 80*space)/2.0 , -40*space, 80*space, 80*space);
    
    
    if(!_nameL){
        _nameL = [[UILabel alloc]initWithFrame:CGRectMake(18*space, 52*space, MZ_SW - 36*space, 28*space)];
        _nameL.textAlignment = NSTextAlignmentCenter;
        _nameL.font = [UIFont systemFontOfSize:20*space];
        _nameL.textColor = MakeColorRGB(0xffffff);
        [_contentView addSubview:_nameL];
    }
    _nameL.frame = CGRectMake(18*space, 52*space, MZ_SW - 36*space, 28*space);
    
    if(!_mengzhuIDLabel){
        _mengzhuIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameL.left, _nameL.bottom + 3*space, _nameL.width, 18*space)];
        _mengzhuIDLabel.text = @"ID：";
        _mengzhuIDLabel.font = [UIFont systemFontOfSize:13*space];
        _mengzhuIDLabel.textColor = MakeColorRGBA(0xffffff, 0.5);
        _mengzhuIDLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_mengzhuIDLabel];
    }
    _mengzhuIDLabel.frame = CGRectMake(_nameL.left, _nameL.bottom + 3*space, _nameL.width, 18*space);
    
    if(!_followL){
        _followL = [[UILabel alloc]initWithFrame:CGRectMake(0, _mengzhuIDLabel.bottom + 11*space, 125*space, 44*space)];
        _followL.text = @"直播量";
        _followL.textColor = MakeColorRGBA(0xffffff, 0.5);
        _followL.textAlignment = NSTextAlignmentCenter;
        _followL.font = [UIFont systemFontOfSize:13*space];
        [_contentView addSubview:_followL];
    }
    _followL.frame = CGRectMake(0, _mengzhuIDLabel.bottom + 11*space, 125*space, 44*space);
    
    if(!self.line1){
        self.line1 = [[UIView alloc]initWithFrame:CGRectMake(_followL.right, _followL.center.y - 6.5*space, 1*space, 13*space)];
        self.line1.backgroundColor = MakeColorRGBA(0xffffff, 0.5);
        [_contentView addSubview:self.line1];
    }
    self.line1.frame = CGRectMake(_followL.right, _followL.center.y - 6.5*space, 1*space, 13*space);
    
    if(!_liveL){
        _liveL = [[UILabel alloc]initWithFrame:CGRectMake(self.line1.right, _followL.top, _followL.width, _followL.height)];
        _liveL.text = @"关注量";
        _liveL.textColor = MakeColorRGBA(0xffffff, 0.5);
        _liveL.textAlignment = NSTextAlignmentCenter;
        _liveL.font = [UIFont systemFontOfSize:13*space];
        [_contentView addSubview:_liveL];
    }
    _liveL.frame = CGRectMake(self.line1.right, _followL.top, _followL.width, _followL.height);
    
    if(!self.line2){
        self.line2 = [[UIView alloc]initWithFrame:CGRectMake(_liveL.right, _followL.center.y - 6.5*space, 1*space, 13*space)];
        self.line2.backgroundColor = MakeColorRGBA(0xffffff, 0.5);
        [_contentView addSubview:self.line2];
    }
    self.line2.frame = CGRectMake(_liveL.right, _followL.center.y - 6.5*space, 1*space, 13*space);
    
    if(!_fansL){
        _fansL = [[UILabel alloc]initWithFrame:CGRectMake(self.line2.right, _followL.top, _followL.width, _followL.height)];
        _fansL.textColor = MakeColorRGBA(0xffffff, 0.5);
        _fansL.text = @"获赞量";
        _fansL.textAlignment = NSTextAlignmentCenter;
        _fansL.font = [UIFont systemFontOfSize:13*space];
        [_contentView addSubview:_fansL];
    }
    _fansL.frame = CGRectMake(self.line2.right, _followL.top, _followL.width, _followL.height);
    if(!self.bannedBtn){
        self.bannedBtn = [[[UIButton alloc]initWithFrame:CGRectMake(80*space, _followL.bottom + 22*space, 216*space, 40*space)] roundChangeWithRadius:20*space];
        [self.bannedBtn addTarget:self action:@selector(bannedBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        self.bannedBtn.titleLabel.font = FontSystemSize(16*space);
        [self.bannedBtn setTitle:@"禁言" forState:UIControlStateNormal];
        [self.bannedBtn setTitleColor: MakeColorRGBA(0xffffff, 0.5) forState:UIControlStateNormal];
        [self.bannedBtn setBackgroundColor:MakeColorRGB(0x303546)];
        [_contentView addSubview:self.bannedBtn];
    }
    self.bannedBtn.hidden = self.isMySelf;
    self.bannedBtn.frame = CGRectMake((80*space), _followL.bottom + 22*space, 216*space, 40*space);
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
        audienceFrame = CGRectMake((self.width - MZ_SW)/2.0, self.height-220*space, MZ_SW, 220*space);
    }else{
        audienceFrame = CGRectMake((self.width - MZ_SW)/2.0, self.height-260*space, MZ_SW, 260*space);
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
    if(otherUserInfoModel.uid.intValue == [MZUserServer currentUser].userId.intValue){//主播自己
        self.isMySelf = YES;
        [self reloadUI];
    }else{
        self.isMySelf = NO;
        [self.bannedBtn setTitle:otherUserInfoModel.is_banned ? @"解禁":@"禁言" forState:UIControlStateNormal];
        
    }
    [_header sd_setImageWithURL:[self customUrlWithStr:otherUserInfoModel.avatar] placeholderImage:[UIImage imageNamed:@"personPlaceHold"]];
    _nameL.text =EmptyForNil([MZGlobalTools cutStringWithString:otherUserInfoModel.nickname SizeOf:16]);
    _mengzhuIDLabel.text = [NSString stringWithFormat:@"ID：%@",otherUserInfoModel.uid];
    _followL.text = [NSString stringWithFormat:@"直播量%@",otherUserInfoModel.lives];
    _liveL.text = [NSString stringWithFormat:@"关注量%@",otherUserInfoModel.attentions];
    _fansL.text = [NSString stringWithFormat:@"获赞量%@",otherUserInfoModel.likes];
    
}

-(NSURL *)customUrlWithStr:(NSString *)str
{
//    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; //这个方法是解决链接中含有中文字符的情况（有特殊字符还是不能正常显示），下面的方法是可以的
   str = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return [NSURL URLWithString:str];
}

-(void)bannedBtnDidClick
{
    if (_action) {
        self.action(HeadViewActionTypeBlock);
    }
    [self dismiss];
}


@end
