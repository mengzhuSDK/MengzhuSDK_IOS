//
//  MZRedPackageViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/18.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZRedPackageViewController.h"
#import "MZRedPackagePresenter.h"

@interface MZRedPackageViewController ()<UITextFieldDelegate,MZRedPackagePresenterProtocol>
@property (nonatomic ,strong) UILabel *NumTipLabel; // 红包个数那一行
@property (nonatomic ,strong) UILabel *geLabel; // 红包个数的单位
@property (nonatomic ,strong) UITextField *numTextField;// 红包个数填写区域
@property (nonatomic ,strong) UIImageView *pinImageView;
@property (nonatomic ,strong) UILabel *moneyTipLabel;// 总金额
@property (nonatomic ,strong) UILabel *yuanLabel;// 金额单位
@property (nonatomic ,strong) UITextField *luckyNoteTextField;  // 祝福语占位图  最多15个字
@property (nonatomic ,strong) UIButton    *submitBtn; //提交按钮
@property (nonatomic ,strong) UILabel     *totalMoneyLabel; // 红包 总金额
@property (nonatomic ,strong) UILabel     *unitMoneyLabel; // 红包 总金额

@property (nonatomic ,strong) UILabel *ErrorHintLabel;
@property (nonatomic ,strong) UIView *count_background_view;

@property (nonatomic ,strong) MZRedPackagePresenter *presenter;
@end

@implementation MZRedPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    
    self.presenter = [[MZRedPackagePresenter alloc] initWithDelegate:self];
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(44);
        } else {
            make.bottom.equalTo(self.view.mas_top).offset(44);
        }
    }];
    
    UILabel *navLabel = [MZCreatUI labelWithText:@"发红包" font:17 textAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
    navLabel.font = [UIFont boldSystemFontOfSize:17];
    [navView addSubview:navLabel];
    [navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(navView);
        make.height.equalTo(@(44));
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navBar_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(navView);
        make.height.equalTo(@44);
        make.width.equalTo(@64);
    }];
    
    UIView *money_background_view = [MZCreatUI viewWithBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:money_background_view];
    [money_background_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(navView.mas_bottom);
        make.height.equalTo(@(44*MZ_RATE));
    }];
    
    UILabel *moneyTipLabel = [[UILabel alloc]init];
    moneyTipLabel.textColor = MakeColorRGB(0x2b2b2b);
    moneyTipLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
    moneyTipLabel.text = @"总金额";
    [moneyTipLabel sizeToFit];
    [money_background_view addSubview:moneyTipLabel];
    self.moneyTipLabel = moneyTipLabel;
    [self.moneyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(money_background_view);
        make.width.equalTo(@(44*MZ_RATE));
        make.left.equalTo(money_background_view).offset(10*MZ_RATE);
    }];
    
    UIImageView *pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luckred"]];
    [money_background_view addSubview:pinImageView];
    self.pinImageView = pinImageView;
    [pinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(14*MZ_RATE));
        make.left.equalTo(moneyTipLabel.mas_right).offset(5);
        make.centerY.equalTo(moneyTipLabel.mas_centerY);
    }];
    
    UILabel *yuanLabel = [[UILabel alloc]init];
    yuanLabel.textColor = MakeColorRGB(0x2b2b2b);
    yuanLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
    yuanLabel.text = @"元";
    [yuanLabel sizeToFit];
    [money_background_view addSubview:yuanLabel];
    self.yuanLabel = yuanLabel;
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(money_background_view);
        make.width.equalTo(@30);
    }];
    
    UITextField *moneyTextField = [[UITextField alloc]init];
    moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTextField.attributedPlaceholder= [[NSAttributedString alloc] initWithString:@"0.00" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*MZ_RATE],NSForegroundColorAttributeName:MakeColorRGB(0x9b9b9b)}];
    moneyTextField.font = [UIFont systemFontOfSize:14*MZ_RATE];
    moneyTextField.textAlignment = NSTextAlignmentRight;
    moneyTextField.returnKeyType = UIReturnKeyDone;
    moneyTextField.delegate = self;
    [moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [money_background_view addSubview:moneyTextField];
    self.moneyTextField = moneyTextField;
    [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yuanLabel.mas_left).offset(-10*MZ_RATE);
        make.top.bottom.equalTo(money_background_view);
        make.width.equalTo(@150);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = MakeColorRGB(0xefeff4);
    [money_background_view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(money_background_view).offset(10*MZ_RATE);
        make.right.bottom.equalTo(money_background_view);
        make.height.equalTo(@1);
    }];
    
    UIView *count_background_view = [MZCreatUI viewWithBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:count_background_view];
    [count_background_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(money_background_view.mas_bottom);
        make.height.equalTo(@(44*MZ_RATE));
    }];
    self.count_background_view = count_background_view;
    
    UILabel *NumTipLabel = [[UILabel alloc]init];
    NumTipLabel.textColor = MakeColorRGB(0x2b2b2b);
    NumTipLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
    NumTipLabel.text = @"红包个数";
    [NumTipLabel sizeToFit];
    [count_background_view addSubview:NumTipLabel];
    self.NumTipLabel = NumTipLabel;
    [NumTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(count_background_view).offset(10*MZ_RATE);
        make.top.bottom.equalTo(count_background_view);
        make.width.equalTo(@100);
    }];
    
    UILabel *geLabel = [[UILabel alloc]init];
    geLabel.textColor = MakeColorRGB(0x2b2b2b);
    geLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
    geLabel.text = @"个";
    [geLabel sizeToFit];
    [count_background_view addSubview:geLabel];
    self.geLabel = geLabel;
    [geLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(count_background_view);
        make.width.equalTo(@30);
    }];
    
    UITextField *numTextField = [[UITextField alloc]init];
    numTextField.keyboardType = UIKeyboardTypeDecimalPad;
    numTextField.attributedPlaceholder= [[NSAttributedString alloc] initWithString:@"请填写红包个数" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*MZ_RATE],NSForegroundColorAttributeName:MakeColorRGB(0x9b9b9b)}];
    numTextField.font = [UIFont systemFontOfSize:14*MZ_RATE];
    numTextField.textAlignment = NSTextAlignmentRight;
    numTextField.returnKeyType = UIReturnKeyDone;
    numTextField.delegate = self;
    numTextField.placeholder = @"请填写红包个数";
    [numTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [count_background_view addSubview:numTextField];
    self.numTextField = numTextField;
    [numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(geLabel.mas_left).offset(-10*MZ_RATE);
        make.top.bottom.equalTo(count_background_view);
        make.width.equalTo(@150);
    }];
    
    CGFloat yValue = MZTotalScreenHeight - 10 -18;
    if (IPHONE_X) {
        yValue = yValue - 34;
    }
    UILabel *awokeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yValue, MZ_SW, 18 )];
    [self.view addSubview:awokeLabel];
    awokeLabel.text = @"未领取的红包，将于24小时后发起退款";
    awokeLabel.textAlignment = NSTextAlignmentCenter;
    awokeLabel.font = [UIFont systemFontOfSize:12];
    awokeLabel.textColor = MakeColorRGB(0x9B9B9B);
    
    UILabel *ErrorHintLabel = [[UILabel alloc]init];
    ErrorHintLabel.textColor = MakeColorRGB(0xF12405);
    ErrorHintLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    ErrorHintLabel.clipsToBounds = YES;
    [self.view addSubview:ErrorHintLabel];
    self.ErrorHintLabel = ErrorHintLabel;
    [self.ErrorHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300 *MZ_RATE);
        make.height.mas_equalTo(0);
        make.left.equalTo(self.NumTipLabel);
        make.top.equalTo(count_background_view.mas_bottom);
    }];
    
    UIView *luck_background_view = [MZCreatUI viewWithBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:luck_background_view];
    [luck_background_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(ErrorHintLabel.mas_bottom).offset(10);
        make.height.equalTo(@(44*MZ_RATE));
    }];
    
    UITextField *luckyNoteTextField = [[UITextField alloc]init];
    luckyNoteTextField.backgroundColor = [UIColor whiteColor];
    luckyNoteTextField.placeholder = @"恭喜发财，大吉大利！";
    luckyNoteTextField.attributedPlaceholder= [[NSAttributedString alloc] initWithString:@"恭喜发财，大吉大利！" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*MZ_RATE],NSForegroundColorAttributeName:MakeColorRGB(0x9B9B9B)}];
    luckyNoteTextField.textColor = MakeColorRGB(0x000000);
    [luckyNoteTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    luckyNoteTextField.font = [UIFont systemFontOfSize:14*MZ_RATE];
    luckyNoteTextField.delegate = self;
    [luck_background_view addSubview:luckyNoteTextField];
    self.luckyNoteTextField = luckyNoteTextField;
    [self.luckyNoteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(luck_background_view).offset(10*MZ_RATE);
        make.top.bottom.right.equalTo(luck_background_view);
    }];
    
    UIView *noteLineView = [[UIView alloc] init];
    noteLineView.backgroundColor = MakeColorRGB(0xefeff4);
    [luck_background_view addSubview:noteLineView];
    [noteLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(luck_background_view);
        make.height.equalTo(@1);
    }];
    
    UILabel *totalMoneyLabel = [[UILabel alloc]init];
    totalMoneyLabel.textColor = MakeColorRGB(0xF12405);
    totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
    totalMoneyLabel.text = @"0.00";
    [totalMoneyLabel sizeToFit];
    totalMoneyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 34 *MZ_RATE];
    [self.view addSubview:totalMoneyLabel];
    self.totalMoneyLabel = totalMoneyLabel;
    
    UILabel *unitMoneyLabel = [[UILabel alloc]init];
    unitMoneyLabel.textColor = MakeColorRGB(0xF12405);
    unitMoneyLabel.textAlignment = NSTextAlignmentCenter;
    unitMoneyLabel.text = @"￥";
    [unitMoneyLabel sizeToFit];
    unitMoneyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 26 *MZ_RATE];
    [self.view addSubview:unitMoneyLabel];
    self.unitMoneyLabel = unitMoneyLabel;
    
    CGFloat halfUnitLabel = self.unitMoneyLabel.width/2.0;
    [self.totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(halfUnitLabel);
        make.top.equalTo(self.luckyNoteTextField.mas_bottom).offset(20 * MZ_RATE);
    }];
    [self.unitMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalMoneyLabel.mas_left);
        make.top.equalTo(self.totalMoneyLabel).offset(2*MZ_RATE);
    }];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
    [submitBtn setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 3 * MZ_RATE;
    [submitBtn addTarget:self action:@selector(submitButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    self.submitBtn = submitBtn;
    [self submitBtnUnInteraction];
    [_submitBtn setBackgroundColor:MakeColorRGB(0xFC7662)];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16*MZ_RATE);
        make.right.equalTo(self.view).offset(-16*MZ_RATE);
        make.top.equalTo(totalMoneyLabel.mas_bottom).offset(20 * MZ_RATE);
        make.height.mas_equalTo(36 *MZ_RATE);
    }];
}

- (void)backButtonClick {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)submitButtonDidClick
{
    if (self.ticket_id.length <= 0) {
        [self.view show:@"活动ID不能为空"];
        return;
    }
    if (self.channel_id.length <= 0) {
        [self.view show:@"频道ID不能为空"];
        return;
    }
    
    [self.view showHud];
    NSLog(@"点击 塞钱进红包 按钮，模拟去请求支付接口: %@ - %@",self.totalMoneyLabel.text, self.numTextField.text);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"支付红包完成了，给活动房间发送发红包事件");
        MZUser *user = [MZBaseUserServer currentUser];
        [MZSDKBusinessManager createRedPackageWithUnique_id:user.uniqueID pay_method:@"alipay" amount:self.totalMoneyLabel.text quantity:self.numTextField.text mode:1 ticket_id:self.ticket_id channel_id:self.channel_id slogan:self.luckyNoteTextField.text success:^(id responseObject) {
            [self.view hideHud];
            [self backButtonClick];
        } failure:^(NSError *error) {
            [self.view hideHud];
            [self.view show:error.domain];
        }];
    });
}

- (void)injected {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    //     限制所有的输入文字都不得超过 15 个字
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:15];
        return;
    }
    
    [self.presenter checkValidityWithMoney:self.moneyTextField.text :self.numTextField.text isMoneyTextField:(textField == _moneyTextField ) isRandom: YES];
    
    double aver = [_moneyTextField.text doubleValue] / ([_numTextField.text integerValue] * 1.0);
    if (([_numTextField.text integerValue] > 0) && ((aver >= 0.01) && (aver <= 200.00))) {
        
        if([_numTextField.text doubleValue] > 2000){
            [self submitBtnUnInteraction];
        }else{
            [self submitBtnInteraction];
        }
    }
    else {
        [self submitBtnUnInteraction];
    }
    
    if (textField == _moneyTextField) {
        _totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",(_moneyTextField.text.length ? [_moneyTextField.text doubleValue] : 0.00)];
        
    }
}
// 验证用户输入的内容，控制被禁止的内容不被输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (![self luckyInputingCheck:textField range:range string:string]) {
        return NO;
    }
    
    return YES;
}
#pragma mark  禁止输入的情况  禁止输入的界限比逻辑界限要宽
- (BOOL)luckyInputingCheck:(UITextField *)textField range:(NSRange)range string:(NSString *)string
{
    if (textField == _numTextField) {
        //        原值为0 第一次输入0被禁止
        if ([_numTextField.text integerValue] == 0 && [string isEqualToString:@"0"]) {
            return NO;
        }
        //        将要输入的内容大于1000 被禁止
        NSString * totalNumeStr = [NSString stringWithFormat:@"%@%@",EmptyForNil(_numTextField.text),EmptyForNil(string)];
        if ([totalNumeStr integerValue] >2000) {
            return NO;
        }
    }
    if (textField == _moneyTextField) {
        if ([textField.text isEqualToString:@""] && [string isEqualToString:@"."]) {
            // .x
            return NO;
        }
        if ([textField.text isEqualToString:@"0"] && ![string isEqualToString:@"."]) {
            //      0123
            return NO;
        }
        //        if ([textField.text isEqualToString:@"0."] && [string integerValue] < 5) {
        ////            小于0.01
        //            return NO;
        //        }
        //        输入超过 8位也被禁止
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 8) {// 包括小数点以及后两位
            return NO;
        }
        //        0.1.2不允许
        NSString* fee = textField.text;
        fee = [fee stringByAppendingString:string];
        NSString *temp=nil;
        if ([fee  hasSuffix:@"\n"]) {
            temp= [fee  substringToIndex:fee.length-1];
        }else{
            temp=fee;
        }
        if(![self isFloat:temp])
        {
            return NO;
        }
        //        > 99999
        if ([temp doubleValue] > 99999) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)isFloat:(NSString *)floatstr {
    NSString *emailRegex = @"^(([0-9]{1,10}+)|([0-9]+\\.[0-9]{1,2})|([0-9]+\\.)|(\\.)|(\\.[0-9]{1,2}))$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:floatstr];
}


#pragma mark 拼手气字体变颜色
- (void)luckyMoneyIsLegal:(BOOL)isLegal
{
    _moneyTipLabel.textColor = (isLegal ? MakeColorRGB(0x172434) : MakeColorRGB(0xF12405));
    _yuanLabel.textColor  = (isLegal ? MakeColorRGB(0x172434) : MakeColorRGB(0xF12405));
    _moneyTextField.textColor = (isLegal ? MakeColorRGB(0x172434) : MakeColorRGB(0xF12405));
}

- (void)luckyNumIsLegal:(BOOL)isLegal
{
    _NumTipLabel.textColor = (isLegal ? MakeColorRGB(0x172434) : MakeColorRGB(0xF12405));
    _geLabel.textColor  = (isLegal ? MakeColorRGB(0x172434) : MakeColorRGB(0xF12405));
    _numTextField.textColor = (isLegal ? MakeColorRGB(0x172434) : MakeColorRGB(0xF12405));
}

- (void)submitBtnUnInteraction
{
    _submitBtn.userInteractionEnabled = NO;
    [_submitBtn setBackgroundColor:MakeColorRGB(0xFC7662)];
}
- (void)submitBtnInteraction
{
    _submitBtn.userInteractionEnabled = YES;
    [_submitBtn setBackgroundColor:MakeColorRGB(0xF12405)];
}

- (void)giveRedEnvelopePresenterMoneyTextFieldIsLegal:(BOOL)isLegal;{
    [self luckyMoneyIsLegal:isLegal];
}
- (void)giveRedEnvelopePresenterNumTextFieldIsLegal:(BOOL)isLegal;{
    [self luckyNumIsLegal:isLegal];
}

- (void)giveRedEnvelopePresenterCanSubmit;{
    [self submitBtnInteraction];
}
- (void)giveRedEnvelopePresenterCanNotSubmit;{
    [self submitBtnUnInteraction];
}

- (void)giveRedEnvelopePresenterShowAlertViewWithString:(NSString *)alertString;{
    if (alertString) {
        
        self.ErrorHintLabel.text = alertString;
        
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.25 animations:^{
            [self.ErrorHintLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(30));
            }];
            [self.view layoutIfNeeded];
            
        }];
        
    }else{
        self.ErrorHintLabel.text = @"";
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.25 animations:^{
            [self.ErrorHintLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0*MZ_RATE));
            }];
            [self.view layoutIfNeeded];
            
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
