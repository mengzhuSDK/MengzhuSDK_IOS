//
//  MZLiveManagerHearderView.m
//  MengZhuPush
//
//  Created by LiWei on 2019/9/24.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZLiveManagerHearderView.h"

@interface MZLiveManagerHearderView ()

@end
@implementation MZLiveManagerHearderView

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
    [self roundChangeWithRadius:20*MZ_RATE];
    self.backgroundColor = MakeColorRGBA(0x000000, 0.25);
    
    self.headerBtn = [[[UIButton alloc]initWithFrame:CGRectMake(5*MZ_RATE, 5*MZ_RATE, 30*MZ_RATE, 30*MZ_RATE)] roundChangeWithRadius:15*MZ_RATE];
    [self.headerBtn setImage:MZ_UserIcon_DefaultImage forState:UIControlStateNormal];
    [self.headerBtn addTarget:self action:@selector(headerButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headerBtn];
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(self.headerBtn.right + 5*MZ_RATE, 4*MZ_RATE, 78*MZ_RATE, 18*MZ_RATE)];
    self.titleL.font = FontSystemSize(13*MZ_RATE);
    self.titleL.textColor = MakeColorRGB(0xffffff);
    [self addSubview:self.titleL];
    self.titleL.text = @"主播名称";
    
    self.numL = [[UILabel alloc]initWithFrame:CGRectMake(self.titleL.left, self.titleL.bottom, self.titleL.width, 14*MZ_RATE)];
    self.numL.font = FontSystemSize(10*MZ_RATE);
    self.numL.textAlignment = NSTextAlignmentLeft;
    self.numL.text = @"人气值：0人";
    self.numL.textColor = MakeColorRGB(0xffffff);
    [self addSubview:self.numL];
    
    self.attentionBtn = [[[UIButton alloc]initWithFrame:CGRectMake(124*MZ_RATE, 9*MZ_RATE, 39*MZ_RATE, 22*MZ_RATE)] roundChangeWithRadius:11*MZ_RATE];
    [self.attentionBtn setImage:[UIImage imageNamed:@"button_attention"] forState:UIControlStateNormal];
    [self.attentionBtn addTarget:self action:@selector(attentionButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.attentionBtn];
}

-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
}

-(void)setTitle:(NSString *)title
{
    if (!title) {
        return;
    }
    _title = title;
    self.titleL.text = title;
}

-(void)setNumStr:(NSString *)numStr
{
    _numStr = numStr;
    self.numL.text = [NSString stringWithFormat:@"人气值：%@人",numStr];
}

-(void)headerButtonDidClick{
    if (self.clickBlock) {
        self.clickBlock();
    }
}
-(void)attentionButtonDidClick{
    if (self.attentionClickBlock) {
        self.attentionClickBlock();
    }
}
@end
