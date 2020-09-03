//
//  MZDiscussInputView.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZDiscussInputView.h"

typedef void(^SendHandle)(BOOL isAnonymous, NSString *question);

@interface MZDiscussInputView()<UITextFieldDelegate>
@property (nonatomic, copy) SendHandle sendHandle;
@property (nonatomic, assign) CGFloat normal_y;//默认y值

@property (nonatomic, strong) UIView *hideTapView;//点击隐藏键盘的View
@property (nonatomic, assign) CGFloat bottomHeight;//底座的高度
@end

@implementation MZDiscussInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"问答输入框释放");
}

- (instancetype)initWithFrame:(CGRect)frame sendHandle:(void(^)(BOOL isAnonymous, NSString *question))sendHandle {
    self = [super initWithFrame:frame];
    if (self) {
        self.bottomHeight = 0;
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                self.bottomHeight = 34;
            }
        }
        self.sendHandle = sendHandle;
        self.inputMaxWord = 300;
        [self makeView];
    }
    return self;
}

- (void)makeView {
    self.normal_y = self.frame.origin.y;
    [self addSubview:self.isAnonymousButton];
    [self addSubview:self.sendButton];
    [self addSubview:self.discussTF];
}

/// 发送按钮点击
- (void)sendButtonClick {
    if (self.sendHandle) {
        self.sendHandle(self.isAnonymousButton.isSelected, self.discussTF.text);
        self.discussTF.text = @"";
        [self tapToHide];
    }
}

/// 匿名按钮点击
- (void)isAnonymousButtonClick {
    self.isAnonymousButton.selected = !self.isAnonymousButton.isSelected;
}

/// 点击收回键盘
- (void)tapToHide {
    [self.discussTF resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// 输入变化时
- (void)textChange {
    NSString *question = self.discussTF.text;
    if (![MZBaseGlobalTools isLealString:question limitStringSizeOf:self.inputMaxWord * 2]) {
        self.discussTF.text = [MZBaseGlobalTools limitString:question sizeOf:self.inputMaxWord * 2];
        [self show:@"字数已超过最大限制"];
    }
}

/// 键盘弹出时
- (void)keyboardWillShow:(NSNotification *)noti {
    //获取键盘的高度
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float height = keyboardRect.size.height;
    
    __block CGRect frame = self.frame;
    
    frame.origin.y = frame.origin.y - height + self.bottomHeight;
    
    [UIView animateWithDuration:0.33 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.hideTapView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - height - self.frame.size.height);
        self.hideTapView.hidden = NO;
        if (!self.hideTapView.superview) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.hideTapView];
        }
    }];
}

/// 键盘关闭时
- (void)keyboardWillHide:(NSNotification *)noti {
    [UIView animateWithDuration:0.33 animations:^{
        self.frame = CGRectMake(0, self.normal_y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.hideTapView.hidden = YES;
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    return YES;
}

#pragma mark - 懒加载
- (UIButton *)isAnonymousButton {
    if (!_isAnonymousButton) {
        _isAnonymousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _isAnonymousButton.frame = CGRectMake(0, 0, 76*MZ_RATE, self.frame.size.height);
        [_isAnonymousButton setImage:[UIImage imageNamed:@"mz_discuss_noSelect"] forState:UIControlStateNormal];
        [_isAnonymousButton setImage:[UIImage imageNamed:@"mz_discuss_select"] forState:UIControlStateSelected];
        [_isAnonymousButton setTitle:@" 匿名" forState:UIControlStateNormal];
        [_isAnonymousButton setTitleColor:[UIColor colorWithRed:255/255 green:29/255.0 blue:92/255.0 alpha:1] forState:UIControlStateNormal];
        _isAnonymousButton.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
        [_isAnonymousButton addTarget:self action:@selector(isAnonymousButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _isAnonymousButton;
}

- (UITextField *)discussTF {
    if (!_discussTF) {
        _discussTF = [[UITextField alloc] initWithFrame:CGRectMake(80*MZ_RATE, 6*MZ_RATE, self.frame.size.width - 80*MZ_RATE - 76*MZ_RATE, self.frame.size.height - 12*MZ_RATE)];
        _discussTF.font = [UIFont systemFontOfSize:14*MZ_RATE];
        _discussTF.textColor = [UIColor whiteColor];
        _discussTF.backgroundColor = [UIColor colorWithRed:51/255.0 green:16/255.0 blue:45/255.0 alpha:1];
        [_discussTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
        _discussTF.delegate = self;

        _discussTF.leftViewMode = UITextFieldViewModeAlways;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, _discussTF.frame.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        _discussTF.leftView = leftView;
        
        NSDictionary *placeAttributeDict = @{NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.8],NSFontAttributeName:[UIFont systemFontOfSize:14*MZ_RATE]};
        _discussTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的问题" attributes:placeAttributeDict];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_discussTF.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(_discussTF.frame.size.height/2.0, _discussTF.frame.size.height/2.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _discussTF.bounds;
        maskLayer.path = maskPath.CGPath;
        _discussTF.layer.mask = maskLayer;
    }
    return _discussTF;
}

- (UIButton *)sendButton  {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(self.frame.size.width - 16*MZ_RATE - 60*MZ_RATE, 6*MZ_RATE, 60*MZ_RATE, self.frame.size.height - 12*MZ_RATE);
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitle:@"提问" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
        [_sendButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:29/255.0 blue:92/255.0 alpha:1]];
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_sendButton.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(_sendButton.frame.size.height/2.0, _sendButton.frame.size.height/2.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _sendButton.bounds;
        maskLayer.path = maskPath.CGPath;
        _sendButton.layer.mask = maskLayer;
    }
    return _sendButton;
}

- (UIView *)hideTapView {
    if (!_hideTapView) {
        _hideTapView = [[UIView alloc] init];
        _hideTapView.userInteractionEnabled = YES;
        _hideTapView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide)];
        [_hideTapView addGestureRecognizer:tap];
    }
    return _hideTapView;
}

@end
