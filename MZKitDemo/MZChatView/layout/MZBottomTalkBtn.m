//
//  MZBottomTalkBtn.m
//  MengZhuPush
//
//  Created by LiWei on 2019/9/25.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZBottomTalkBtn.h"

@interface MZBottomTalkBtn ()
@property (nonatomic ,strong)UILabel *talkTitleLabel;
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
    self.talkTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 14*MZ_RATE, self.width, 20*MZ_RATE)];
    self.talkTitleLabel.font = FontSystemSize(14*MZ_RATE);
    self.talkTitleLabel.text = @"聊点什么？";
    self.talkTitleLabel.textColor = MakeColorRGBA(0xffffff, 0.6);
    [self addSubview:self.talkTitleLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
    self.lineView.backgroundColor = MakeColorRGBA(0xffffff, 0.5);
    [self addSubview:self.lineView];
}

-(void)talkIsTap:(UIGestureRecognizer *)gesture
{
    if(self && self.bottomClickBlock){
        self.bottomClickBlock();
    }
}

@end
