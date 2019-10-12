//
//  MZBottomTalkBtn.m
//  MengZhuPush
//
//  Created by LiWei on 2019/9/25.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZBottomTalkBtn.h"

@interface MZBottomTalkBtn ()
@property (nonatomic ,strong)UIButton *talkTitleBtn;
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UIButton *cameraBtn;
@end

@implementation MZBottomTalkBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(talkIsTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)setupUI
{
    self.talkTitleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 14*MZ_RATE, self.width, 20*MZ_RATE)];
    [self.talkTitleBtn addTarget:self action:@selector(talkIsTap:) forControlEvents:UIControlEventTouchUpInside];
    self.talkTitleBtn.titleLabel.font = FontSystemSize(14*MZ_RATE);
    [self.talkTitleBtn setTitleColor:MakeColorRGBA(0xffffff, 0.6) forState:UIControlStateNormal];
    self.talkTitleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
    self.talkTitleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [self addSubview:self.talkTitleBtn];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
    self.lineView.backgroundColor = MakeColorRGBA(0xffffff, 0.5);
    [self addSubview:self.lineView];
}

-(void)talkIsTap:(UIButton *)button
{
    if(self && self.bottomClickBlock){
        self.bottomClickBlock();
    }
}

-(void)setIsBanned:(BOOL)isBanned
{
    _isBanned = isBanned;
    if(!isBanned){
        [self.talkTitleBtn setTitle:@"跟主播聊点什么？" forState:UIControlStateNormal];
        [self.talkTitleBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{
        [self.talkTitleBtn setTitle:@"你已被禁言" forState:UIControlStateNormal];
        [self.talkTitleBtn setImage:[UIImage imageNamed:@"banned_BG"] forState:UIControlStateNormal];
    }
}

@end
