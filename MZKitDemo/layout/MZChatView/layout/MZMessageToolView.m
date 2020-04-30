//
//  VHMessageToolView.m
//  vhall1
//
//  Created by vhallrd01 on 14-6-20.
//  Copyright (c) 2014年 vhallrd01. All rights reserved.
//

#import "MZMessageToolView.h"
//#import "MZCustomInputView.h"
#define MessageTool_SendBtnColor [UIColor whiteColor]

@interface MZMessageToolView()

@property (nonatomic ,strong)UIView *lintView;
@end
@implementation MZMessageToolView

- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _type = type;
        [self setupConfigure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type textView:(MZMessageTextView *)textView
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _type = type;
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
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    CGFloat textViewWidth= 233*MZ_RATE;
    if(!self.toolBackGroundView){
        self.toolBackGroundView = [[UIView alloc] init];
        [self addSubview:self.toolBackGroundView];
        if(_type == 2){
            self.toolBackGroundView.backgroundColor = [UIColor whiteColor];
        }else {
            if(_type == MZMessageToolBarTypeAllBtn ){
                
            }else if (_type == MZMessageToolBarTypeOnlyTextView){
                
            }else if (_type == MZMessageToolBarTypeOnlyEmoji){
                
            }else if (_type == MZMessageToolBarTypeOnlySend){
                
            }else if (_type == MZMessageToolBarTypeOnlyTextAndSend){
                
            }else if (_type == MZMessageToolBarTypeoOther){
                
            }
               
            self.toolBackGroundView.backgroundColor = [UIColor whiteColor];
            //初始化输入框
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            
            if(orientation != UIInterfaceOrientationPortrait){
                _msgTextView = nil;
                _msgTextView = [[MZMessageTextView alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, textViewWidth, kInputTextViewMinHeight)];
                self.maxTextInputViewHeight = kInputTextViewMaxHeight;
            }else {
                _msgTextView = [[MZMessageTextView alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, textViewWidth, kInputTextViewMinHeight)];
                self.maxTextInputViewHeight = kInputTextViewMaxHeight;
            }
            _msgTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            _msgTextView.scrollEnabled = YES;
            if(_type == 2){
                _msgTextView.returnKeyType = UIReturnKeyDone;
            }else{
                _msgTextView.returnKeyType = UIReturnKeySend;
            }
            
            _msgTextView.enablesReturnKeyAutomatically = YES;
            _msgTextView.backgroundColor = MakeColorRGB(0xefeff4);
            _msgTextView.layer.cornerRadius = 2.0f;
            if(![self.toolBackGroundView.subviews containsObject:_msgTextView]){
                [self.toolBackGroundView addSubview:_msgTextView];
            }
            
            _msgTextView.delegate = self;
            _msgTextView.hidden = _type == 2 ? YES : NO;
            _previousTextViewContentHeight = [self getTextViewContentH:_msgTextView];
            [self creatSubBtn];
        }
    }
    
    CGFloat space;
    if([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height){
        space = IPHONE_X ? 40 : 0;
        textViewWidth = self.width - 150*MZ_RATE;
    }else{
        space = 0;
        textViewWidth = self.width - 150*MZ_RATE;
    }
    self.toolBackGroundView.frame = CGRectMake(space, 0,self.frame.size.width ,kVerticalPadding*2+kInputTextViewMinHeight);
    if(!self.lintView){
        UIView *lintView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.toolBackGroundView.width, 1*MZ_RATE)];
        lintView.backgroundColor=MakeColorRGB(0xefeff4);
        [self.toolBackGroundView addSubview:lintView];
    }
    if(_type != 2){
        _msgTextView.frame = CGRectMake(kHorizontalPadding, kVerticalPadding, textViewWidth, kInputTextViewMinHeight);
    }
    [self reSetSubView];
}

-(void)creatSubBtn
{
    if(!_sendButton){
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sendButton setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGB(0xff5b29) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [_sendButton setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xff5b29, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
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
        [_smallButton setFrame:CGRectMake(2*MZ_RATE, 0, 46*MZ_RATE, 46*MZ_RATE)];
        _emojiCenterView = [[UIButton alloc]initWithFrame:CGRectMake(11*MZ_RATE, 11*MZ_RATE , 24*MZ_RATE, 24*MZ_RATE)];
        _emojiCenterView.userInteractionEnabled = NO;
        [_smallButton addSubview:_emojiCenterView];
        [_emojiCenterView setBackgroundImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        [_emojiCenterView setBackgroundImage:[UIImage imageNamed:@"live_keyboard"] forState:UIControlStateSelected];
        [_emojiCenterView setBackgroundImage:[UIImage imageNamed:@"live_keyboard"] forState:UIControlStateHighlighted];
        [_smallButton addTarget:self
                         action:@selector(buttonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self.toolBackGroundView addSubview:_smallButton];
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
        textViewWidth = self.width - 150*MZ_RATE - space;
        self.toolBackGroundView.frame = CGRectMake(space, 0,self.frame.size.width ,kVerticalPadding*2+kInputTextViewMinHeight);
        _msgTextView.frame = CGRectMake(kHorizontalPadding, kVerticalPadding, textViewWidth, kInputTextViewMinHeight);
        _sendButton.frame = CGRectMake(self.width - 76*MZ_RATE ,kVerticalPadding,60*MZ_RATE,kInputTextViewMinHeight);
        _smallButton.frame = CGRectMake(2, 0, 46, 46);
        _emojiCenterView.frame = CGRectMake(11, 11 , 24, 24);
        _sendButton.hidden = NO;
    }else if (self.type == MZMessageToolBarTypeOnlyTextView){
        _smallButton.hidden = YES;
        _sendButton.hidden = YES;
        _msgTextView.frame = CGRectMake(15, 8, self.width - 30, 32);
        _msgTextView.centerPlaceHolder = @"聊点什么？";
        _msgTextView.centerPlaceHolderColor = MakeColorRGB(0xbbbbbb);
    }

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
        [self willShowBottomView:self.faceView];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
              _msgTextView.hidden = !button.selected;
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [_msgTextView becomeFirstResponder];
    }
}

-(void)beginFaceViewInView
{
    _smallButton.selected = !_smallButton.selected;
    _emojiCenterView.selected = _smallButton.selected;
    
    if (_smallButton.selected)
    {
        [_msgTextView resignFirstResponder];
        
        [self willShowBottomView:self.faceView];
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

#pragma mark - DXFaceDelegate

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
        if ([self.delegate respondsToSelector:@selector(didSendText:userName:joinID:isBarrage:)]) {
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
    if ([_delegate respondsToSelector:@selector(didSendText:userName:joinID:)]) {
        [_delegate didSendText:_msgTextView.text userName:_userName joinID:_joinID];
        _msgTextView.text = @"";
        _msgTextView.centerPlaceHolderLable.hidden = NO;
        [self endEditing:NO];
//        [_sendButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
//        [self willShowInputTextViewToHeight:[self getTextViewContentH:self.msgTextView]];
//
//        self.tempString = @"";
    }
//    if (_delegate && [_delegate respondsToSelector:@selector(cancelTextView)])
//    {
//        [_delegate cancelTextView];
//    }
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
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;  
    if([MZ_IOS_ver floatValue] < 8.0 && orientation != UIInterfaceOrientationPortrait)
    {
        endFrame = CGRectMake(endFrame.origin.y, endFrame.origin.x, endFrame.size.height, endFrame.size.width);
        beginFrame = CGRectMake(beginFrame.origin.y, beginFrame.origin.x, beginFrame.size.height, beginFrame.size.width);
    }
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
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
//            textView.text = [textView.text substringToIndex:textView.text.length-1];
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
//    if (textView.text.length > 0)
//    {
//        if (_maxLength > 0) {
//            NSString * str = textView.text;
//            if ([MZGlobalTools isLealString:textView.text limitStringSizeOf:_maxLength * 2]) {
//            }
//            else {
//                textView.text = [MZGlobalTools limitString:str sizeOf:_maxLength * 2];
//            }
//        }
//        else {
//            NSString * str = textView.text;
//            if ([MZGlobalTools isLealString:str limitStringSizeOf:100 * 2]) {
//            }
//            else {
//                textView.text = [MZGlobalTools limitString:str sizeOf:100 * 2];
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

@end
