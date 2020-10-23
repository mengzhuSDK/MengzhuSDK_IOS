//
//  MZPlayManagerHeaderView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/14.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZPlayManagerHeaderView.h"

@interface MZPlayManagerHeaderView()

@end

@implementation MZPlayManagerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.live_status = 0;
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float space = MZ_RATE;
    self.backgroundColor = [UIColor clearColor];
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
        self.backgroundColor = MakeColorRGBA(0x000000, 0.25);
    }
    
    [self roundChangeWithRadius:20*space];
    self.headerBtn.frame = CGRectMake(5*space, 5*space, 30*space, 30*space);
    self.titleL.frame = CGRectMake(40*space, 4*space, 78*space, 18*space);
    self.numL.frame = CGRectMake(40*space, 22*space, 78*space, 14*space);
    self.attentionBtn.frame = CGRectMake(124*space, 9*space, 39*space, 22*space);

}

-(void)setupUI
{
    [self roundChangeWithRadius:20*MZ_RATE];
    self.backgroundColor = MakeColorRGBA(0x000000, 0.25);
    
    self.headerBtn = [[[UIButton alloc]initWithFrame:CGRectMake(5*MZ_RATE, 5*MZ_RATE, 30*MZ_RATE, 30*MZ_RATE)] roundChangeWithRadius:15*MZ_RATE];
    [self.headerBtn setImage:MZ_SDK_UserIcon_DefaultImage forState:UIControlStateNormal];
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
    self.numL.text = @"";
    self.numL.textColor = MakeColorRGB(0xffffff);
    self.numL.adjustsFontSizeToFitWidth = YES;
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
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setObject:FontSystemSize(11) forKey:NSFontAttributeName];
    [dict1 setObject:[[UIColor whiteColor] colorWithAlphaComponent:1.0] forKey:NSForegroundColorAttributeName];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    [dict2 setObject:FontSystemSize(10) forKey:NSFontAttributeName];
    [dict2 setObject:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forKey:NSForegroundColorAttributeName];
    
    NSMutableAttributedString *str1 = [self getSpot];

    NSString *num = [NSString stringWithFormat:@"人气%@",numStr];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:num attributes:dict2];
    
    [str1 appendAttributedString:str2];
    
    self.numL.attributedText = str1;
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

- (NSMutableAttributedString *)getSpot {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:FontSystemSize(11) forKey:NSFontAttributeName];
    if (self.live_status == 1 || self.live_status == 3) {
        [dict setObject:[UIColor colorWithRed:255/255.0 green:33/255.0 blue:69/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    } else {
        [dict setObject:[[UIColor whiteColor] colorWithAlphaComponent:1.0] forKey:NSForegroundColorAttributeName];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"•" attributes:dict];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setObject:FontSystemSize(11) forKey:NSFontAttributeName];
    [dict1 setObject:[[UIColor whiteColor] colorWithAlphaComponent:1.0] forKey:NSForegroundColorAttributeName];
    
    NSString *title = @" 回放 | ";
    if (self.live_status == 1 || self.live_status == 3) title = @" 直播 | ";
    else if (self.live_status == 0) title = @"未开播| ";
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:title attributes:dict1];

    [str appendAttributedString:str1];
    return str;
}

@end
