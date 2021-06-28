//
//  MZJoinMeetingLayout.m
//  MZMeetingSDK
//
//  Created by LiWei on 2020/9/16.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZJoinMeetingLayout.h"
#import <Masonry/Masonry.h>

@interface MZJoinMeetingLayout ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITextField *roomTextField;
@property (nonatomic, strong) UITextField *psdTextField;
@property (nonatomic, strong) UIButton *joinMeetingBtn;
@end

@implementation MZJoinMeetingLayout

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    self.bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOutSider)];
    [self.bgImageV addGestureRecognizer:tap];
    self.bgImageV.userInteractionEnabled = YES;
    [scrollView addSubview:self.bgImageV];
    scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + 1);
    
    self.logoImageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0 - 77*MZ_RATE, 50*MZ_RATE, 154*MZ_RATE, 34*MZ_RATE)];
    [self.bgImageV addSubview:self.logoImageV];
    
    UIView *whiteBgView = [[UIView alloc]initWithFrame:CGRectMake(30*MZ_RATE, _logoImageV.frame.origin.y + (_logoImageV.frame.size.height + 30*MZ_RATE), 315*MZ_RATE, 395*MZ_RATE)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [self.bgImageV addSubview:whiteBgView];
    
    whiteBgView.layer.cornerRadius = 4;
    whiteBgView.clipsToBounds = YES;
    
    self.roomTextField = [self getTextFieldWithPlaceholderStr:@"请输入房间号"];
    [whiteBgView addSubview:self.roomTextField];
    self.roomTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.roomTextField.frame = CGRectMake(20*MZ_RATE, 35*MZ_RATE, 275*MZ_RATE, 36*MZ_RATE);
    
    self.psdTextField = [self getTextFieldWithPlaceholderStr:@"请输入密码"];
    self.psdTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.psdTextField.secureTextEntry = YES;
    [whiteBgView addSubview:self.psdTextField];
    self.psdTextField.frame = CGRectMake(20*MZ_RATE, self.roomTextField.frame.origin.y + 46*MZ_RATE, 275*MZ_RATE, 36*MZ_RATE);
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(whiteBgView.frame.size.width - 23*MZ_RATE - 200*MZ_RATE, self.psdTextField.frame.origin.y + 40*MZ_RATE, 200*MZ_RATE, 14*MZ_RATE)];
    tipLabel.text = @"（如会议未加密可不填）";
    tipLabel.font = [UIFont systemFontOfSize:10*MZ_RATE];
    tipLabel.textColor = [UIColor colorWithRed:(CGFloat)(155.0/255.0) green:(CGFloat)(155.0/255.0) blue:(CGFloat)(155.0/255.0) alpha:1.0];
    tipLabel.textAlignment = NSTextAlignmentRight;
    [whiteBgView addSubview:tipLabel];
    
    UILabel *voiceTipL = [[UILabel alloc]init];
    voiceTipL.text = @"不自动链接语音";
    voiceTipL.font = [UIFont systemFontOfSize:14*MZ_RATE];
    voiceTipL.textColor = [UIColor colorWithRed:(CGFloat)(74.0/255.0) green:(CGFloat)(74.0/255.0) blue:(CGFloat)(74.0/255.0) alpha:1.0];
    [whiteBgView addSubview:voiceTipL];
    [voiceTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42*MZ_RATE);
        make.top.equalTo(tipLabel.mas_bottom).offset(20*MZ_RATE);
        make.width.mas_equalTo(150*MZ_RATE);
        make.height.mas_equalTo(20*MZ_RATE);
    }];
    
    self.voiceConnectSwitch = [[UISwitch alloc]init];
    [whiteBgView addSubview:self.voiceConnectSwitch];
    self.voiceConnectSwitch.onTintColor = [UIColor colorWithRed:(CGFloat)(255.0/255.0) green:(CGFloat)(91.0/255.0) blue:(CGFloat)(41.0/255.0) alpha:1.0];
    self.voiceConnectSwitch.tintColor = [UIColor colorWithRed:(CGFloat)(0/255.0) green:(CGFloat)(0/255.0) blue:(CGFloat)(0/255.0) alpha:0.1];;
    
    [self.voiceConnectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        self.voiceConnectSwitch.transform = CGAffineTransformMakeScale(0.75*MZ_RATE, 0.75*MZ_RATE);
        make.right.equalTo(whiteBgView).offset(- 42*MZ_RATE);
        make.centerY.equalTo(voiceTipL);
        make.width.mas_equalTo(48*MZ_RATE);
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [UIColor colorWithRed:(CGFloat)(239.0/255.0) green:(CGFloat)(239.0/255.0) blue:(CGFloat)(244.0/255.0) alpha:1.0];
    [whiteBgView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBgView).offset(20*MZ_RATE);
        make.right.equalTo(whiteBgView).offset(-20*MZ_RATE);
        make.top.equalTo(voiceTipL.mas_bottom).offset(10*MZ_RATE);
        make.height.mas_equalTo(1*MZ_RATE);
    }];
    
    UILabel *cameraTipL = [[UILabel alloc]init];
    cameraTipL.text = @"保持摄像头关闭";
    cameraTipL.font = [UIFont systemFontOfSize:14*MZ_RATE];
    cameraTipL.textColor = [UIColor colorWithRed:(CGFloat)(74.0/255.0) green:(CGFloat)(74.0/255.0) blue:(CGFloat)(74.0/255.0) alpha:1.0];
    [whiteBgView addSubview:cameraTipL];
    [cameraTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42*MZ_RATE);
        make.top.equalTo(lineV.mas_bottom).offset(9*MZ_RATE);
        make.width.mas_equalTo(150*MZ_RATE);
        make.height.mas_equalTo(20*MZ_RATE);
    }];
    
    self.cameraCloseSwitch = [[UISwitch alloc]init];
    [whiteBgView addSubview:self.cameraCloseSwitch];
    self.cameraCloseSwitch.onTintColor = [UIColor colorWithRed:(CGFloat)(255.0/255.0) green:(CGFloat)(91.0/255.0) blue:(CGFloat)(41.0/255.0) alpha:1.0];
    self.cameraCloseSwitch.tintColor = [UIColor colorWithRed:(CGFloat)(0/255.0) green:(CGFloat)(0/255.0) blue:(CGFloat)(0/255.0) alpha:0.1];
    self.cameraCloseSwitch.transform = CGAffineTransformMakeScale(0.75*MZ_RATE, 0.75*MZ_RATE);
    [self.cameraCloseSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        self.cameraCloseSwitch.transform = CGAffineTransformMakeScale(0.75*MZ_RATE, 0.75*MZ_RATE);
        make.right.equalTo(whiteBgView).offset(- 42*MZ_RATE);
        make.centerY.equalTo(cameraTipL);
        make.width.mas_equalTo(48*MZ_RATE);
    }];
    
    self.joinMeetingBtn = [[UIButton alloc]init];
    [self.joinMeetingBtn setTitle:@"加入会议" forState:UIControlStateNormal];
    self.joinMeetingBtn.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
    self.joinMeetingBtn.backgroundColor = [UIColor colorWithRed:(CGFloat)(255.0/255.0) green:(CGFloat)(91.0/255.0) blue:(CGFloat)(41.0/255.0) alpha:1.0];
    [self.joinMeetingBtn addTarget:self action:@selector(joinMeetingBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteBgView addSubview:self.joinMeetingBtn];
    [self.joinMeetingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBgView).offset(20*MZ_RATE);
        make.bottom.equalTo(whiteBgView).offset(- 25*MZ_RATE);
        make.width.mas_equalTo(275*MZ_RATE);
        make.height.mas_equalTo(36*MZ_RATE);
    }];
    [self.joinMeetingBtn.superview layoutIfNeeded];
    self.joinMeetingBtn.layer.masksToBounds = YES;
    self.joinMeetingBtn.layer.cornerRadius = 18*MZ_RATE;
}

- (void)setMeetingID:(NSString *)meetingID {
    _meetingID = meetingID;
    self.roomTextField.text = self.meetingID;
}

- (void)setMeetingPassword:(NSString *)meetingPassword {
    _meetingPassword = meetingPassword;
    self.psdTextField.text = self.meetingPassword;
}

- (void)setSwitchOnImage:(UIImage *)switchOnImage {
    _switchOnImage = switchOnImage;
    [self.voiceConnectSwitch setOnImage:switchOnImage];
    [self.cameraCloseSwitch setOnImage:switchOnImage];
}

- (void)setSwitchOffImage:(UIImage *)switchOffImage {
    _switchOffImage = switchOffImage;
    [self.voiceConnectSwitch setOnImage:switchOffImage];
    [self.cameraCloseSwitch setOnImage:switchOffImage];
}

- (void)tapOutSider {
    [self endEditing:YES];
}

- (void)joinMeetingBtnDidClick {
    if (self && self.joinClickBlock) {
        self.joinClickBlock(self.roomTextField.text, self.psdTextField.text);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditing:YES];
}

- (UITextField *)getTextFieldWithPlaceholderStr:(NSString *)placeholderStr {
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 275*MZ_RATE, 36*MZ_RATE)];
    textField.textColor = [UIColor blackColor];
    textField.delegate = self;
    textField.backgroundColor = [UIColor colorWithRed:(CGFloat)(243.0/255.0) green:(CGFloat)(243.0/255.0) blue:(CGFloat)(243.0/255.0) alpha:1.0];
    textField.layer.cornerRadius = 18*MZ_RATE;
    textField.layer.masksToBounds = YES;
    textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:placeholderStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*MZ_RATE],NSForegroundColorAttributeName:[UIColor colorWithRed:(CGFloat)(155.0/255.0) green:(CGFloat)(155.0/255.0) blue:(CGFloat)(155.0/255.0) alpha:1.0]}];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 22*MZ_RATE, 36*MZ_RATE)];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}
@end
