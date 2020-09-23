//
//  VHMessageToolView.m
//  vhall1
//
//  Created by vhallrd01 on 14-6-20.
//  Copyright (c) 2014年 vhallrd01. All rights reserved.
//

#import "MZMessageToolView.h"
#define MessageTool_SendBtnColor [UIColor whiteColor]

typedef void(^ListenOnlyHostMessage)(BOOL isOnlyHostMessage);

/**
 * @brief 只看主播的View
 */
@interface MZOnlyHostMessageView : UIView
@property (nonatomic, strong) UILabel *noteLabel;//只看主播标题
@property (nonatomic, strong) UISwitch *onlySwitch;//只看主播开关
@end

@implementation MZOnlyHostMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

- (void)makeView  {
    self.onlySwitch = [[UISwitch alloc] init];
    [self.onlySwitch setOn:NO];
    self.onlySwitch.thumbTintColor = [UIColor whiteColor];
    [self.onlySwitch setOnTintColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1]];
    [self addSubview:self.onlySwitch];
    
    
    [self.onlySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.noteLabel = [[UILabel alloc] init];
    self.noteLabel.textAlignment = NSTextAlignmentRight;
    self.noteLabel.font = [UIFont systemFontOfSize:12];
    self.noteLabel.adjustsFontSizeToFitWidth = YES;
    self.noteLabel.backgroundColor = [UIColor clearColor];
    self.noteLabel.text = @"只看主播";
    self.noteLabel.textColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1];
    [self addSubview:self.noteLabel];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.onlySwitch.mas_left).offset(-3);
    }];
    
    self.backgroundColor = [UIColor whiteColor];
}

@end

/**
 * @brief 输入的tool
 */

@interface MZMessageToolView()

@property (nonatomic, strong) UIView *lintView;

@property (nonatomic, assign) BOOL isShowHostButton;//当前的输入框是否显示 只看主播 按钮
@property (nonatomic, strong) MZOnlyHostMessageView *onlyHostView;//只看主播的View
@property (nonatomic, assign) CGFloat onlyHostViewWidth;//只看主播View的宽度
@property (nonatomic, assign) BOOL isOnlyHostMessage;//是否 只展示主播的聊天信息
@property (nonatomic,   copy) ListenOnlyHostMessage onlyHostStateChangeListen;//只看主播按钮状态更改的回调

@end
@implementation MZMessageToolView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.toolBackGroundView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding*2+kInputTextViewMinHeight);

    CGFloat saveLeft = 12;
    CGFloat relativeSafeRate = MZ_RATE;

    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        NSLog(@"横屏输入框");
        saveLeft = IPHONE_X ? 44.0 : 12;
        relativeSafeRate = MZ_FULL_RATE;
    }
    
    self.sendButton.frame = CGRectMake(self.width - 76*relativeSafeRate, kVerticalPadding, 60*relativeSafeRate, kInputTextViewMinHeight);

    CGFloat leftSpace = 15;
    if (self.isShowHostButton) {
        leftSpace = 0;
        self.onlyHostView.frame = CGRectMake(0+(saveLeft >= 44 ? 28 : 0), self.onlyHostView.frame.origin.y, self.onlyHostView.frame.size.width, self.onlyHostView.frame.size.height);
    }
    
    switch (self.type) {
        case MZMessageToolBarTypeAllBtn://所有按钮
            self.smallButton.frame = CGRectMake(self.width - 76*relativeSafeRate - 17 - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight);
            _emojiCenterView.frame = CGRectMake((kInputTextViewMinHeight-24*relativeSafeRate)/2.0, (kInputTextViewMinHeight-24*relativeSafeRate)/2.0, 24*relativeSafeRate, 24*relativeSafeRate);

            self.msgTextView.frame = CGRectMake(saveLeft+leftSpace+self.onlyHostViewWidth, kVerticalPadding, self.width - kInputTextViewMinHeight - 76*relativeSafeRate - leftSpace - self.onlyHostViewWidth - saveLeft, kInputTextViewMinHeight);
            break;
        case MZMessageToolBarTypeOnlyEmoji://只有表情+输入框
            self.smallButton.frame = CGRectMake(self.width - 17 - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight);
            _emojiCenterView.frame = CGRectMake((kInputTextViewMinHeight-24*relativeSafeRate)/2.0, (kInputTextViewMinHeight-24*relativeSafeRate)/2.0, 24*relativeSafeRate, 24*relativeSafeRate);

            self.msgTextView.frame = CGRectMake(saveLeft+leftSpace+self.onlyHostViewWidth, kVerticalPadding, self.width - kInputTextViewMinHeight - leftSpace - 13 - self.onlyHostViewWidth - saveLeft, kInputTextViewMinHeight);
            break;
        case MZMessageToolBarTypeOnlySend://只有发送+输入框
            self.msgTextView.frame = CGRectMake(leftSpace+saveLeft+self.onlyHostViewWidth, kVerticalPadding, self.width - 76*relativeSafeRate - leftSpace - 15 - self.onlyHostViewWidth, kInputTextViewMinHeight);
            break;
        case MZMessageToolBarTypeOnlyTextView://只有输入框
            self.msgTextView.frame = CGRectMake(leftSpace+saveLeft+self.onlyHostViewWidth, kVerticalPadding, self.width - 15 - leftSpace - self.onlyHostViewWidth - saveLeft, kInputTextViewMinHeight);
            break;
        default:
            break;
    }
}

- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        _isShowHostButton = NO;
        _type = type;
        [self setupConfigure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type isShowHostButton:(BOOL)isShowHostButton {
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _isShowHostButton = isShowHostButton;
        [self setupConfigure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type textView:(MZSDKMessageTextView *)textView
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _isShowHostButton = NO;
        _msgTextView = textView;
        _msgTextView.layoutManager.allowsNonContiguousLayout = false;
        //连续布局属性 默认是true的，如果不设置false 每次都会出现一闪一闪的
        //2. 设置textview的可见范围
        [self setupConfigure];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
}

- (void)setupConfigure
{
    self.onlyHostViewWidth = 0;
    if (self.isShowHostButton) self.onlyHostViewWidth = 106;
    
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    CGFloat textViewWidth= 233*MZ_RATE;
    if(!self.toolBackGroundView){
        self.toolBackGroundView = [[UIView alloc] init];
        [self addSubview:self.toolBackGroundView];

        self.toolBackGroundView.backgroundColor = [UIColor whiteColor];
        //初始化输入框
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if(orientation != UIInterfaceOrientationPortrait){
            _msgTextView = nil;
            _msgTextView = [[MZSDKMessageTextView alloc] initWithFrame:CGRectMake(kHorizontalPadding+self.onlyHostViewWidth, kVerticalPadding, textViewWidth, kInputTextViewMinHeight)];
            self.maxTextInputViewHeight = kInputTextViewMaxHeight;
        }else {
            _msgTextView = [[MZSDKMessageTextView alloc] initWithFrame:CGRectMake(kHorizontalPadding+self.onlyHostViewWidth, kVerticalPadding, textViewWidth, kInputTextViewMinHeight)];
            self.maxTextInputViewHeight = kInputTextViewMaxHeight;
        }
        _msgTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _msgTextView.scrollEnabled = YES;

        _msgTextView.returnKeyType = UIReturnKeySend;
        _msgTextView.showsVerticalScrollIndicator = NO;
        _msgTextView.showsHorizontalScrollIndicator = NO;
        
        _msgTextView.enablesReturnKeyAutomatically = YES;
        _msgTextView.backgroundColor = MakeColorRGB(0xefeff4);
        _msgTextView.layer.cornerRadius = 2.0f;
        if(![self.toolBackGroundView.subviews containsObject:_msgTextView]){
            [self.toolBackGroundView addSubview:_msgTextView];
        }
        
        _msgTextView.delegate = self;
        _previousTextViewContentHeight = [self getTextViewContentH:_msgTextView];
        [self creatSubBtn];
    }
    
    CGFloat space;
    if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height){
        space = IPHONE_X ? 40 : 0;
        textViewWidth = self.width - 150*MZ_RATE - self.onlyHostViewWidth;
    }else{
        space = 0;
        textViewWidth = self.width - 150*MZ_RATE - self.onlyHostViewWidth;
    }
    self.toolBackGroundView.frame = CGRectMake(space, 0,self.frame.size.width ,kVerticalPadding*2+kInputTextViewMinHeight);
    if(!self.lintView){
        UIView *lintView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.toolBackGroundView.width, 1*MZ_RATE)];
        lintView.backgroundColor=MakeColorRGB(0xefeff4);
        [self.toolBackGroundView addSubview:lintView];
    }
    _msgTextView.frame = CGRectMake(kHorizontalPadding+self.onlyHostViewWidth, kVerticalPadding, textViewWidth, kInputTextViewMinHeight);
    [self reSetSubView];
}

-(void)creatSubBtn
{
    if(!_sendButton){
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sendButton setBackgroundImage:[MZBaseGlobalTools imageWithColor:MakeColorRGB(0xff5b29) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[MZBaseGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [_sendButton setBackgroundImage:[MZBaseGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.cornerRadius = 3;
        [_sendButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
        _sendButton.frame = CGRectMake(self.width - 76*MZ_RATE ,
                                       kVerticalPadding,
                                       60*MZ_RATE,
                                       kInputTextViewMinHeight);
        [_sendButton addTarget:self
                        action:@selector(sendButtonTouchUpInside)
              forControlEvents:UIControlEventTouchUpInside];
        [self.toolBackGroundView addSubview:_sendButton];
    }
    if(!_smallButton){
        _smallButton = [[UIButton alloc]init];
        _smallButton.frame = CGRectMake(self.frame.size.width - 15 - 32, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight);
        _smallButton.backgroundColor = MakeColorRGB(0xefeff4);
        _smallButton.layer.cornerRadius = 2.0f;
        _emojiCenterView = [[UIButton alloc]initWithFrame:CGRectMake((kInputTextViewMinHeight-24*MZ_RATE)/2.0, (kInputTextViewMinHeight-24*MZ_RATE)/2.0, 24*MZ_RATE, 24*MZ_RATE)];
        _emojiCenterView.userInteractionEnabled = NO;
        [_smallButton addSubview:_emojiCenterView];
        [_emojiCenterView setBackgroundImage:[UIImage imageNamed:@"mz_live_face"] forState:UIControlStateNormal];
        [_emojiCenterView setBackgroundImage:[UIImage imageNamed:@"mz_live_keyboard"] forState:UIControlStateSelected];
        [_emojiCenterView setBackgroundImage:[UIImage imageNamed:@"mz_live_keyboard"] forState:UIControlStateHighlighted];
        [_smallButton addTarget:self
                         action:@selector(buttonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self.toolBackGroundView addSubview:_smallButton];
    }
    
    if (self.isShowHostButton) {
        if(!_onlyHostView){
            _onlyHostView = [[MZOnlyHostMessageView alloc] initWithFrame:CGRectMake(0, 0, 104, self.frame.size.height)];
            [_onlyHostView.onlySwitch addTarget:self action:@selector(onlyHostChange:) forControlEvents:UIControlEventValueChanged];
            [self.toolBackGroundView addSubview:_onlyHostView];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

-(void)reSetSubView
{
    if(self.type == MZMessageToolBarTypeAllBtn){
        CGFloat textViewWidth = 0;
        CGFloat space;
        if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height){
            space = IPHONE_X ? 40 : 0;
        }else{
            space = 0;
        }
        textViewWidth = self.width - 150*MZ_RATE - space - self.onlyHostViewWidth;
        self.toolBackGroundView.frame = CGRectMake(space, 0,self.frame.size.width ,kVerticalPadding*2+kInputTextViewMinHeight);
        self.msgTextView.frame = CGRectMake(15+self.onlyHostViewWidth, kVerticalPadding, self.width - kInputTextViewMinHeight - 76*MZ_RATE - 15 - self.onlyHostViewWidth, kInputTextViewMinHeight);
        self.smallButton.frame = CGRectMake(self.width - 76*MZ_RATE - 15 - self.onlyHostViewWidth - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight);
        _sendButton.frame = CGRectMake(self.width - 76*MZ_RATE ,kVerticalPadding,60*MZ_RATE,kInputTextViewMinHeight);
        _emojiCenterView.frame = CGRectMake((kInputTextViewMinHeight-24*MZ_RATE)/2.0, (kInputTextViewMinHeight-24*MZ_RATE)/2.0, 24*MZ_RATE, 24*MZ_RATE);
        _sendButton.hidden = NO;
        _smallButton.hidden = NO;
    }else if (self.type == MZMessageToolBarTypeOnlyTextView){
        _smallButton.hidden = YES;
        _sendButton.hidden = YES;
        _msgTextView.frame = CGRectMake(15+self.onlyHostViewWidth, 8, self.width - 30 - self.onlyHostViewWidth, 32);
        _msgTextView.centerPlaceHolder = @"聊点什么？";
        _msgTextView.centerPlaceHolderColor = MakeColorRGB(0xbbbbbb);
    } else if (self.type == MZMessageToolBarTypeOnlyEmoji) {
        _smallButton.hidden = NO;
        _smallButton.frame = CGRectMake(self.frame.size.width - 15 - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight);
        _sendButton.hidden = YES;
        _msgTextView.frame = CGRectMake(15+self.onlyHostViewWidth, 8, self.width - kInputTextViewMinHeight - 15 - self.onlyHostViewWidth, 32);
        _msgTextView.centerPlaceHolder = @"聊点什么？";
        _msgTextView.centerPlaceHolderColor = MakeColorRGB(0xbbbbbb);
    } else if (self.type == MZMessageToolBarTypeOnlySend) {
        self.smallButton.hidden = YES;
        self.sendButton.hidden = NO;
    }
}

- (void)onlyHostChange:(UISwitch *)aSwitch {
    if (self.onlyHostStateChangeListen) self.onlyHostStateChangeListen(self.isOnlyHostMessage = aSwitch.isOn);
}

// 监听 是否 只展示主播的聊天信息 状态的更改
- (void)listenOnlyHostState:(void(^)(BOOL isOnlyHostMessage))listenState {
    self.onlyHostStateChangeListen = listenState;
}

- (void)buttonAction:(UIButton *)button
{
    button.selected = !button.selected;
    _emojiCenterView.selected = button.selected;
    CGFloat space;
    if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height){
        space = IPHONE_X ? 40 : 0;
    }else{
        space = 0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmojiButtonDidClick" object:nil];
    if (button.selected)
    {
        [_msgTextView resignFirstResponder];
        if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height){
            [self willShowBottomView:self.landspaceFacialView];
        } else {
            [self willShowBottomView:self.portraitFacialView];
        }
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
              _msgTextView.hidden = !button.selected;
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [_msgTextView becomeFirstResponder];
        [self setNeedsLayout];
    }
}

-(void)beginFaceViewInView
{
    _smallButton.selected = !_smallButton.selected;
    _emojiCenterView.selected = _smallButton.selected;
    
    if (_smallButton.selected)
    {
        [_msgTextView resignFirstResponder];
        
        if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height){
            [self willShowBottomView:self.landspaceFacialView];
        } else {
            [self willShowBottomView:self.portraitFacialView];
        }
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _msgTextView.hidden = !_smallButton.selected;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [_msgTextView becomeFirstResponder];
    }
}

#pragma mark - MZFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = _msgTextView.text;
    
    if (!isDelete && str.length > 0) {
        _msgTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        
        
        if (chatText.length >= 2)
        {
            NSInteger toIndex = 0;
            BOOL findSatrFace = NO;
            BOOL findEndFace = NO;
            
            NSString *temp = [chatText substringWithRange:NSMakeRange([chatText length] - 1, 1)];
            if ([temp isEqualToString:@"]"])
            {
                findSatrFace = YES;
            }
            
            
            for (NSInteger i=[chatText length]-1; i>=0; i--)
            {
                NSString *temp = [chatText substringWithRange:NSMakeRange(i, 1)];
                if([temp isEqualToString:@"["])
                {
                    toIndex = i;
                    findEndFace = YES;
                    break;
                }
            }
            
            
            if (findSatrFace && findEndFace)
            {
                _msgTextView.text = [chatText substringToIndex:toIndex];
                return;
            }
        }
        if (chatText.length > 0) {
            _msgTextView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    [self textViewDidChange:_msgTextView];
}

- (void)sendFace
{
    NSString *chatText = _msgTextView.text;
    if (chatText.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSendText:userName:joinID:isBarrage:)]) {
            [self.delegate didSendText:chatText userName:_userName joinID:_joinID isBarrage:NO];
            _msgTextView.text = @"";
            [_msgTextView resignFirstResponder];
            [self willShowInputTextViewToHeight:[self getTextViewContentH:_msgTextView]];;
        }
    }
}
- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolBackGroundView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
            
            _faceRect = rect;
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)sendButtonTouchUpInside
{
    if (_type == MZMessageToolBarTypeAllBtn) {//有弹幕按钮
        if (_delegate && [_delegate respondsToSelector:@selector(didSendText:userName:joinID:isBarrage:)]) {
            [_delegate didSendText:_msgTextView.text userName:_userName joinID:_joinID isBarrage:self.isBarrage];
            _msgTextView.text = @"";
            _msgTextView.centerPlaceHolderLable.hidden = NO;
            _msgTextView.centerPlaceHolder=@"聊点什么？";
            
            [self endEditing:NO];
            
            return;
        }
    }

    if (_delegate && [_delegate respondsToSelector:@selector(didSendText:userName:joinID:)]) {
        [_delegate didSendText:_msgTextView.text userName:_userName joinID:_joinID];
        _msgTextView.text = @"";
        _msgTextView.centerPlaceHolderLable.hidden = NO;
        [self endEditing:NO];
    }
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    [self setupConfigure];
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if (@available(iOS 14.0, *)) {
        if (self.isLive && UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
            NSLog(@"横屏 && iOS14系统 && 是直播");//ios14横屏下，直播的present强制横屏状态下，获取键盘的frame是竖屏的frame。这里强制减59
            endFrame.size.height = endFrame.size.height - 59;
        }
    }
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    // 414-265 209
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        NSLog(@"弹出");
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        NSLog(@"收回");
        [self willShowBottomHeight:beginFrame.size.height ];
    }
    else
    {
        [self willShowBottomHeight:toFrame.size.height];
    }
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
// 265 bottomHeight 105-y 309-height
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolBackGroundView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    
    if(bottomHeight == 0 && self.frame.size.height == self.toolBackGroundView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    self.frame = toFrame;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
        [_delegate didChangeFrameToHeight:toHeight];
    }
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_smallButton setSelected:NO];
    [_emojiCenterView setSelected:NO];
    [textView becomeFirstResponder];
    self.tempString = textView.text;
//    textView.text = self.tempString;

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    if (!_smallButton.selected && _delegate && [_delegate respondsToSelector:@selector(cancelTextView)])
    {
        [_delegate cancelTextView];
    }
}
-(void)setUserName:(NSString *)userName
{
    if(userName){
        _userName = userName;
    }
}

-(void)setJoinID:(NSString *)joinID
{
    if(joinID){
        _joinID = joinID;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual:@""]) {
        if (textView.text.length > 0) {
            _msgTextView.centerPlaceHolder=@"聊点什么？";
            return YES;
        }
    }else{
        _msgTextView.centerPlaceHolder=@"";
    }
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] ||
            ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
    }
        if ([text isEqualToString:@"\n"]) {
            [self sendButtonTouchUpInside];
            return NO;
        }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 0){
        self.msgTextView.centerPlaceHolderLable.hidden = YES;
    }else{
        self.msgTextView.centerPlaceHolderLable.hidden = NO;
    }
    
    if (textView.text.length > 0) {
        if (_maxLength > 0) {
            NSString * str = textView.text;
            if ([MZBaseGlobalTools isLealString:textView.text limitStringSizeOf:_maxLength * 2]) {
            }
            else {
                textView.text = [MZBaseGlobalTools limitString:str sizeOf:_maxLength * 2];
            }
        } else {
            NSString * str = textView.text;
            if ([MZBaseGlobalTools isLealString:str limitStringSizeOf:100 * 2]) {
            }
            else {
                textView.text = [MZBaseGlobalTools limitString:str sizeOf:100 * 2];
            }
        }
    }
    
//    if (textView.text.length > 0)
//    {
//        if (_maxLength > 0) {
//            NSString * str = textView.text;
//            if ([MZBaseGlobalTools isLealString:textView.text limitStringSizeOf:_maxLength * 2]) {
//            }
//            else {
//                textView.text = [MZBaseGlobalTools limitString:str sizeOf:_maxLength * 2];
//            }
//        }
//        else {
//            NSString * str = textView.text;
//            if ([MZBaseGlobalTools isLealString:str limitStringSizeOf:100 * 2]) {
//            }
//            else {
//                textView.text = [MZBaseGlobalTools limitString:str sizeOf:100 * 2];
//            }
//        }
//
//        if (_type == 1)
//        {
//            [_sendButton setTitleColor:MessageTool_SendBtnColor
//                                forState:UIControlStateNormal];
//        }
//        else if(_type == 2)
//        {
//            [_sendButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
//        }else if (_type ==3)
//        {
//            [_sendButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
//        }
//
//        [_sendButton setUserInteractionEnabled:YES];
//    }
//    else
//    {
//        [_sendButton setTitleColor: MessageTool_SendBtnColor forState:UIControlStateNormal];
//
//
//        if (_type ==3) {
//            [_sendButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
//        }
//
////        [_sendButton setUserInteractionEnabled:NO];
//    }
//
//    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
//    self.tempString = textView.text;
//    [_msgTextView scrollRangeToVisible:NSMakeRange(_msgTextView.text.length, 1)];


}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolBackGroundView.frame;
        rect.size.height += changeHeight;
        self.toolBackGroundView.frame = rect;
        _previousTextViewContentHeight = toHeight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
            [_delegate didChangeFrameToHeight:self.frame.size.height];
        }
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    _delegate = nil;
    _msgTextView.delegate = nil;
    _msgTextView = nil;
}


- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    _smallButton.selected = NO;
    _emojiCenterView.selected = NO;
    [self willShowBottomView:nil];
    _msgTextView.text=@"";
    _msgTextView.centerPlaceHolderLable.hidden = NO;
    _msgTextView.centerPlaceHolder=@"聊点什么？";
    return result;
}

- (void)addKeyBoardNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)removeKeyBoardNoti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self endEditing:NO];
}

- (MZFacialView *)portraitFacialView {
    if (!_portraitFacialView) {
        CGFloat bottom = 0;
        if (IPHONE_X) {
            if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
                bottom = 8;
            } else {
                bottom = 34.0;
            }
        }
        _portraitFacialView = [[MZFacialView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200+bottom)];
        _portraitFacialView.delegate = self;
        _portraitFacialView.backgroundColor = [UIColor lightGrayColor];
        _portraitFacialView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _portraitFacialView;
}

- (MZFacialView *)landspaceFacialView {
    if (!_landspaceFacialView) {
        CGFloat bottom = 0;
        if (IPHONE_X) {
            if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
                bottom = 8;
            } else {
                bottom = 34.0;
            }
        }
        _landspaceFacialView = [[MZFacialView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200+bottom)];
        _landspaceFacialView.delegate = self;
        _landspaceFacialView.backgroundColor = [UIColor lightGrayColor];
        _landspaceFacialView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _landspaceFacialView;
}

@end

