//
//  MZDLNAPlayingView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZDLNAPlayingView.h"

@interface MZDLNAPlayingView ()
@property (nonatomic, strong) MZDLNA *dlnaManager;

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *statueLabel;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *exitBtn;
@end

@implementation MZDLNAPlayingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setupUI];
        self.dlnaManager = [MZDLNA sharedMZDLNAManager];
        [self.dlnaManager startDLNA];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat bgView_Height = (self.frame.size.width*(9.0/16.0));
    CGFloat origin_y = (self.frame.size.height - bgView_Height)/2.0;
    origin_y = origin_y - 30 > 0 ? origin_y - 30 : origin_y;
        
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, origin_y, self.frame.size.width, bgView_Height)];
    [self addSubview:bgView];
    
    _titleL = [[UILabel alloc]initWithFrame:CGRectMake(50*MZ_RATE, 20 + 14*MZ_RATE, MZ_SW - 100*MZ_RATE, 22*MZ_RATE)];

    _titleL.textAlignment = NSTextAlignmentCenter;
    _titleL.textColor = [UIColor whiteColor];
    _titleL.font = FontSystemSize(16*MZ_RATE);
    [bgView addSubview:_titleL];
    
    self.statueLabel = [[UILabel alloc]initWithFrame:CGRectMake((MZ_SW - 200*MZ_RATE)/2.0, _titleL.bottom + 42*MZ_RATE, 200*MZ_RATE, 20*MZ_RATE)];
    self.statueLabel.textColor = [UIColor whiteColor];
    self.statueLabel.text = @"投屏播放中";
    self.statueLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:self.statueLabel];
    
    self.changeBtn = [[[UIButton alloc]initWithFrame:CGRectMake(100*MZ_RATE, self.statueLabel.bottom + 42*MZ_RATE, 75*MZ_RATE, 26*MZ_RATE)] roundChangeWithRadius:13*MZ_RATE];
    [self.changeBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:91/255.0 blue:41/255.0 alpha:1] forState:UIControlStateNormal];
    self.changeBtn.titleLabel.font = FontSystemSize(14*MZ_RATE);
    self.changeBtn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:91/255.0 blue:41/255.0 alpha:1].CGColor;
    self.changeBtn.layer.borderWidth = 1;
    [self.changeBtn addTarget:self action:@selector(changeDevice) forControlEvents:UIControlEventTouchUpInside];
    [self.changeBtn setTitle:@"换设备" forState:UIControlStateNormal];
    [bgView addSubview:self.changeBtn];
    
    self.exitBtn = [[[UIButton alloc]initWithFrame:CGRectMake(self.changeBtn.right + 25*MZ_RATE, self.changeBtn.top, 75*MZ_RATE, 26*MZ_RATE)]roundChangeWithRadius:13*MZ_RATE];
    [self.exitBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:91/255.0 blue:41/255.0 alpha:1] forState:UIControlStateNormal];
    self.exitBtn.titleLabel.font = FontSystemSize(14*MZ_RATE);
     self.exitBtn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:91/255.0 blue:41/255.0 alpha:1].CGColor;
    self.exitBtn.layer.borderWidth = 1;
    [self.exitBtn addTarget:self action:@selector(exitDLNAControl) forControlEvents:UIControlEventTouchUpInside];
    [self.exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [bgView addSubview:self.exitBtn];

}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
        _titleL.text = title;
    }
}

- (void)changeDevice {
    if (self && self.controlBlock) {
        self.controlBlock(MZDLNAControlTypeChange);
    }
}

- (void)exitDLNAControl {
    if (self && self.controlBlock) {
        self.controlBlock(MZDLNAControlTypeExit);
    }
}

@end
