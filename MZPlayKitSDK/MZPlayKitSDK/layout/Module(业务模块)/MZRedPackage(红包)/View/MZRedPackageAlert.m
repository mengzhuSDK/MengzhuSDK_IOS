//
//  MZRedPackageAlert.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/22.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZRedPackageAlert.h"

typedef void(^ResultHandler)(BOOL isGoReceiveList);

@interface MZRedPackageAlert()
@property (nonatomic, copy) ResultHandler resultHandler;

@property (nonatomic, copy) NSString *bonus_id;
@property (nonatomic, copy) NSString *slogan;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *obtainAmount;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIView *nameContainerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *sloganLabel;

@property (nonatomic, strong) UILabel *receiveMoneyLabel;// 显示金额
@property (nonatomic, strong) UILabel *statusLabel;// 提示信息

@property (nonatomic, strong) UIButton *bottomTipButton;

@property (nonatomic, strong) UIButton *recodeBtn;

@end

@implementation MZRedPackageAlert

+ (void)showWithBonus_id:(NSString *)bonus_id slogan:(NSString *)slogan nickname:(NSString *)nickname avatar:(NSString *)avatar isGoReceiveList:(void(^)(BOOL isGoReceiveList))handler {
    
    MZRedPackageAlert *alert = [[MZRedPackageAlert alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    alert.resultHandler = handler;
    alert.bonus_id = bonus_id;
    alert.slogan = slogan;
    alert.nickname = nickname;
    alert.avatar = avatar;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:alert];
    
    [alert setupUI];
    [alert getBonusData];
}

- (void)setupUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.obtainAmount = @"";
    
    UIView *backgroundView = [[UIView alloc] init];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [backgroundView addGestureRecognizer:tap];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mz_luck_unready"]];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@295);
        make.height.equalTo(@344);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"mz_luck_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundImageView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.backgroundImageView);
        make.width.height.equalTo(@44);
    }];
    
    self.nameContainerView = [MZCreatUI viewWithBackgroundColor:[UIColor clearColor]];
    [self.backgroundImageView addSubview:self.nameContainerView];

    self.headImageView = [[UIImageView alloc] init];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:MZ_UserIcon_DefaultImage];
    [self.headImageView.layer setCornerRadius:15];
    [self.headImageView.layer setMasksToBounds:YES];
    [self.nameContainerView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.nameContainerView);
        make.width.height.equalTo(@30);
    }];
    
    self.nameLabel = [MZCreatUI labelWithText:self.nickname font:14 textAlignment:NSTextAlignmentLeft textColor:MakeColorRGB(0xEFCE73) backgroundColor:[UIColor clearColor]];
    [self.nameContainerView addSubview:self.nameLabel];
    [self.nameLabel sizeToFit];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.top.bottom.right.equalTo(self.nameContainerView);
    }];
    
    [self.nameContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView).offset(65);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
        make.width.equalTo(@(30+8+self.nameLabel.width));
    }];

    self.sloganLabel = [MZCreatUI labelWithText:self.slogan font:18 textAlignment:NSTextAlignmentCenter textColor:MakeColor(239, 206, 115, 1) backgroundColor:[UIColor clearColor]];
    [self.backgroundImageView addSubview:self.sloganLabel];
    [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameContainerView.mas_bottom).offset(16);
        make.height.equalTo(@25);
        make.left.right.equalTo(self.backgroundImageView);
    }];
    
    self.receiveMoneyLabel = [MZCreatUI labelWithText:@"" font:42 textAlignment:NSTextAlignmentCenter textColor:MakeColor(239, 206, 115, 1) backgroundColor:[UIColor clearColor]];
    [self.backgroundImageView addSubview:self.receiveMoneyLabel];
    [self.receiveMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgroundImageView);
        make.top.equalTo(self.sloganLabel.mas_bottom).offset(28);
        make.height.equalTo(@59);
    }];
    
    self.statusLabel = [MZCreatUI labelWithText:@"" font:20 textAlignment:NSTextAlignmentCenter textColor:MakeColor(239, 206, 115, 1) backgroundColor:[UIColor clearColor]];
    [self.backgroundImageView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgroundImageView);
        make.top.equalTo(self.sloganLabel.mas_bottom).offset(44);
        make.height.equalTo(@28);
    }];

    self.recodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recodeBtn setImage:[UIImage imageNamed:@"mz_luck_unready_open"] forState:UIControlStateNormal];
    self.recodeBtn.hidden = YES;
    [self.recodeBtn addTarget:self action:@selector(obtainBonus) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundImageView addSubview:self.recodeBtn];
    [self.recodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.bottom.equalTo(self.backgroundImageView).offset(-43);
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
    }];
    
    self.bottomTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomTipButton addTarget:self action:@selector(goReceiveList) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomTipButton setTitleColor:MakeColor(239, 206, 115, 1) forState:UIControlStateNormal];
    [self.bottomTipButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"查看抢红包记录"];
    NSRange titleRange = {0, [title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [self.bottomTipButton setAttributedTitle:title forState:UIControlStateNormal];
    [self.backgroundImageView addSubview:self.bottomTipButton];
    [self.bottomTipButton setHidden:YES];
    [self.bottomTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundImageView).offset(-11);
        make.width.equalTo(@105);
        make.height.equalTo(@17);
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
    }];
}

- (void)setStatus:(NSString *)status {
    _status = status;
    [self setNeedsLayout];//打标记 下一帧需要刷新
    [self layoutIfNeeded];//如果有标记， 马上进行刷新
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger status = [self.status integerValue];
    switch (status) {
        case 1://已领取
        {
            self.recodeBtn.hidden = YES;
            self.bottomTipButton.hidden = NO;
            self.receiveMoneyLabel.hidden = NO;
            self.statusLabel.hidden = YES;
            self.backgroundImageView.image = [UIImage imageNamed:@"mz_luck_ready"];
            self.receiveMoneyLabel.text = self.obtainAmount;
            break;
        }
        case 10://可领取
        {
            self.recodeBtn.hidden = NO;
            self.bottomTipButton.hidden = YES;
            self.receiveMoneyLabel.hidden = YES;
            self.statusLabel.hidden = YES;
            self.backgroundImageView.image = [UIImage imageNamed:@"mz_luck_unready"];
            break;
        }
        case 4://已抢光
        {
            self.recodeBtn.hidden = YES;
            self.bottomTipButton.hidden = NO;
            self.receiveMoneyLabel.hidden = YES;
            self.statusLabel.hidden = NO;
            self.backgroundImageView.image = [UIImage imageNamed:@"mz_luck_ready"];
            self.statusLabel.text = @"手慢了，红包已抢完";
            break;
        }
        case 9://已过期
        {
            self.recodeBtn.hidden = YES;
            self.bottomTipButton.hidden = YES;
            self.receiveMoneyLabel.hidden = YES;
            self.statusLabel.hidden = NO;
            self.backgroundImageView.image = [UIImage imageNamed:@"mz_luck_ready"];
            self.statusLabel.text = @"该红包超过24小时已过期";
            break;
        }
        default:
            break;
    }
}

- (void)cancel {
    if (self.resultHandler) {
        self.resultHandler(NO);
    }
    [self removeFromSuperview];
}

- (void)goReceiveList {
    if (self.resultHandler) {
        self.resultHandler(YES);
    }
    [self removeFromSuperview];
}

- (void)getBonusData {
    [self showHud];
    MZUser *user = [MZBaseUserServer currentUser];
    [MZSDKBusinessManager getCheckBonusWithUnique_id:user.uniqueID bonus_id:self.bonus_id success:^(id responseObject) {
        [self hideHud];
        
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        self.obtainAmount = @"";
        if ([status isEqualToString:@"1"]) {
            self.obtainAmount = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        }
        self.status = status;
        
    } failure:^(NSError *error) {
        [self hideHud];
        [self show:error.domain];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self cancel];
        });
    }];
}

- (void)obtainBonus {
    MZUser *user = [MZBaseUserServer currentUser];
    
    [self showHud];
    [MZSDKBusinessManager obtainBonusWithUnique_id:user.uniqueID bonus_id:self.bonus_id success:^(id responseObject) {
        [self hideHud];
        
        [self getBonusData];
        
    } failure:^(NSError *error) {
        [self hideHud];
        [self show:error.domain];
    }];
}

@end
