 //
//  VHChatView.m
//  VhallIphone
//
//  Created by vhall on 15/8/20.
//  Copyright (c) 2015年 www.mengzhu.com. All rights reserved.
//

#import "MZChatView.h"
#import "MZMyButton.h"
#import "MZOnlineTipView.h"
#import "MZCustomTapRecognizer.h"

#define STEP_W 8
#define LABEL_H 27
#define talkViewH 36*MZ_RATE
#define ContentColor MakeColorRGB(0xf3f3f3)

@interface MZChatView()<UIScrollViewDelegate>
{
    UIScrollView   *_scrollView;
    UIView         *_contentView;
    NSMutableArray *_talkViewArr;
    
    UILabel        *_lastLabel;
    UIView          *_lastTalkView;
    CGFloat        _scrollContentH;
    int counter;//消息数量计数器
    CGPoint        _currentOffset;
}
@property (nonatomic,assign) int onlineCountDownNum;
@property (nonatomic ,strong)MZOnlineTipView *onlineIconBtn;
@property (nonatomic ,strong)NSTimer *onlineTipTimer;
@end

@implementation MZChatView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollContentH = 0;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];

        _iconHeight = 32*MZ_RATE;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_scrollView addSubview:_contentView];
        self.clipsToBounds = YES;
        _talkViewArr = [NSMutableArray array];
        _talkFont = [UIFont systemFontOfSize:12*MZ_RATE];
    }
    return self;
}

- (void)setPollingDate:(MZLongPollDataModel *)pollingDate
{
    _pollingDate = pollingDate;
    switch (_pollingDate.event) {
            break;
        case MsgTypeOtherChat://收到别人聊天
        {
            [self addTalk:_pollingDate];
        }
            break;
        case MsgTypeMeChat://自己发的消息本地回显
        {
            [self addMeTalk:_pollingDate];
        }
            break;
         
        case MsgTypeOnline://上线
        {
            [self addOnline:_pollingDate];
        }
            break;

        case MsgTypeNotice://系统通知
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)setIs_Public:(BOOL)is_Public
{
    _is_Public = is_Public;
}

#pragma mark 自己发的聊天消息
- (void)addMeTalk:(MZLongPollDataModel*)pollingDate
{
    UIView* talkView = [[UIView alloc]initWithFrame:CGRectMake(0, _contentView.height, self.width, 55)];
    _lastLabel = nil;
    _lastTalkView =nil;
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(_iconHeight + STEP_W, 0, talkView.width-_iconHeight - STEP_W, 65)];
    view.layer.cornerRadius = 5*MZ_RATE;
    view.layer.masksToBounds = YES;
    MZCustomTapRecognizer  *tap=[[MZCustomTapRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    tap.userName= [MZGlobalTools cutStringWithString:pollingDate.userName SizeOf:12];
    tap.fullName = [NSString stringWithFormat:@"%@:%@",pollingDate.userName,pollingDate.userId];
    [view addGestureRecognizer:tap];
    view.backgroundColor = MakeColorRGB(0xf3f3f3);
    [talkView addSubview:view];
    
//<<<<<<< HEAD:MZKitDemo/layout/MZChatView/layout/MZChatView.m
//    MLEmojiLabel *t_emojiLabel = [[MLEmojiLabel alloc]initWithFrame:CGRectMake(10, 2, view.width - 20, _talkFont.xHeight)];
//    t_emojiLabel.numberOfLines = 0;
//    t_emojiLabel.font = _talkFont;
//    t_emojiLabel.userInteractionEnabled=YES;
//    //    t_emojiLabel.emojiDelegate = self;
//    t_emojiLabel.backgroundColor = [UIColor clearColor];
//    t_emojiLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    t_emojiLabel.isNeedAtAndPoundSign = YES;
//    t_emojiLabel.disableThreeCommon = YES;
//    //    t_emojiLabel.atColor = [UIColor whiteColor];
//    t_emojiLabel.textColor = MakeColorRGB(0x2b2b2b);
//    t_emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//    t_emojiLabel.customEmojiPlistName = @"faceExpression.plist";
//    t_emojiLabel.lineSpacing = 0.0;
//    t_emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
//    [t_emojiLabel setText:pollingDate.data.msgText];
//
//    //   [t_emojiLabel addGestureRecognizer:tapGesture];
//    @try {[t_emojiLabel sizeToFit];} @catch (NSException* e) {}
//    [view addSubview:t_emojiLabel];
//=======
    UILabel *t_emojiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, view.width - 20, _talkFont.xHeight)];
    t_emojiLabel.numberOfLines = 2;
    t_emojiLabel.font = _talkFont;
    t_emojiLabel.userInteractionEnabled=YES;
    //    t_emojiLabel.emojiDelegate = self;
    t_emojiLabel.backgroundColor = [UIColor clearColor];
    t_emojiLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    t_emojiLabel.atColor = [UIColor whiteColor];
    t_emojiLabel.textColor = MakeColorRGB(0x2b2b2b);
    [t_emojiLabel setText:pollingDate.data.msgText];
//>>>>>>> 565c202b9205140891f8f38a66bcc15511eca857:MZKitDemo/MZChatView/layout/MZChatView.m
    
//    if(t_emojiLabel.height < _iconHeight-4)
//    {
//        view.frame = CGRectMake(view.left, view.top, t_emojiLabel.width + 20,_iconHeight);
//        t_emojiLabel.frame = CGRectMake(10, view.height / 2.0 - _iconHeight / 2.0, t_emojiLabel.width, _iconHeight);
//        talkView.frame = CGRectMake(0, _contentView.height, view.width, view.height+10);
//    }
//    else
//    {
//        view.frame = CGRectMake(view.left, view.top, view.width, t_emojiLabel.height+10);
//        t_emojiLabel.frame = CGRectMake(10, view.height / 2.0 -  t_emojiLabel.height / 2.0, t_emojiLabel.width,  t_emojiLabel.height);
//        talkView.frame = CGRectMake(0, _contentView.height, view.width, view.height+10);
//    }
    
    MZMyButton *iconBtn=[[MZMyButton alloc] initWithFrame:CGRectMake(0, 0, _iconHeight, _iconHeight)];
    iconBtn.layer.masksToBounds=YES;
    iconBtn.layer.cornerRadius=_iconHeight/2.0;
    iconBtn.backgroundColor = MakeColor(255, 255, 255, 0.4);
    //        iconBtn.layer.borderWidth = 1;
    //        iconBtn.layer.borderColor = MakeColor(255, 255, 255, 0.5).CGColor;
    iconBtn.tagData = pollingDate;
    [iconBtn addTarget:self action:@selector(iconCLick:) forControlEvents:UIControlEventTouchUpInside];
    [iconBtn sd_setImageWithURL:[NSURL URLWithString:pollingDate.userAvatar] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
    [talkView addSubview:iconBtn];
    if(!_isVoice){
    [UIView animateWithDuration:6 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        talkView.alpha=0.6;
    } completion:^(BOOL finished) {
        //        if (finished) {
        //            [talkView removeFromSuperview];
        //            if(talkView.tag < _talkViewArr.count)
        //            {
        //                [_talkViewArr removeObjectAtIndex:talkView.tag];
        //            }
        //            return ;
        //        }
        [UIView  animateWithDuration:1 animations:^{
            talkView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [talkView removeFromSuperview];
            if(talkView.tag < _talkViewArr.count)
            {
                [_talkViewArr removeObjectAtIndex:talkView.tag];
                if(_talkViewArr.count==0){
                    if(_delegate && [_delegate respondsToSelector:@selector(viewCutLevel:)]){
                        [_delegate viewCutLevel:YES];
                    }
                }
            }
            
        } ];
    }];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(viewCutLevel:)]){
        [_delegate viewCutLevel:NO];
    }
    [self addInArr:talkView];
}

#pragma mark 他人聊天消息
- (void)addTalk:(MZLongPollDataModel*)pollingDate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        counter++;
        UIView* talkView = [[UIView alloc]initWithFrame:CGRectMake(0, _contentView.height, self.width, _iconHeight)];
        _lastLabel = nil;
        _lastTalkView =nil;
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(_iconHeight + STEP_W, 0, talkView.width-_iconHeight - STEP_W, _iconHeight)];
        MZCustomTapRecognizer  *tap=[[MZCustomTapRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        tap.userName= [MZGlobalTools cutStringWithString:pollingDate.userName SizeOf:12];
        tap.fullName = [NSString stringWithFormat:@"%@:%@",pollingDate.userName,pollingDate.userId];
        [view addGestureRecognizer:tap];
        view.backgroundColor = MakeColorRGB(0xf3f3f3);
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
        [talkView addSubview:view];
        
//<<<<<<< HEAD:MZKitDemo/layout/MZChatView/layout/MZChatView.m
//        MLEmojiLabel *t_emojiLabel = [[MLEmojiLabel alloc]initWithFrame:CGRectMake(10, 2, view.width-20, _talkFont.xHeight)];
//        t_emojiLabel.numberOfLines = 0;
//        t_emojiLabel.font = _talkFont;
//        t_emojiLabel.userInteractionEnabled=YES;
//        //    t_emojiLabel.emojiDelegate = self;
//        t_emojiLabel.backgroundColor = [UIColor clearColor];
//        t_emojiLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        t_emojiLabel.isNeedAtAndPoundSign = YES;
//        t_emojiLabel.textColor=MakeColorRGB(0x2b2b2b);
//        t_emojiLabel.disableThreeCommon = YES;
//
//        t_emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//        t_emojiLabel.customEmojiPlistName = @"faceExpression.plist";
//        t_emojiLabel.lineSpacing = 0.0;
//        t_emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
//        [t_emojiLabel setText:pollingDate.data.msgText];
//
//        //   [t_emojiLabel addGestureRecognizer:tapGesture];
//        @try {[t_emojiLabel sizeToFit];} @catch (NSException* e) {}
//        [view addSubview:t_emojiLabel];
//=======
        UILabel *t_emojiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, view.width-20, _talkFont.xHeight)];
        t_emojiLabel.numberOfLines = 0;
        t_emojiLabel.font = _talkFont;
        t_emojiLabel.userInteractionEnabled=YES;
        //    t_emojiLabel.emojiDelegate = self;
        t_emojiLabel.backgroundColor = [UIColor clearColor];
        t_emojiLabel.lineBreakMode = NSLineBreakByWordWrapping;
        t_emojiLabel.textColor=MakeColorRGB(0x2b2b2b);
        [t_emojiLabel setText:pollingDate.data.msgText];
        
        //   [t_emojiLabel addGestureRecognizer:tapGesture];
        @try {[t_emojiLabel sizeToFit];} @catch (NSException* e) {}
        [view addSubview:t_emojiLabel];
//>>>>>>> 565c202b9205140891f8f38a66bcc15511eca857:MZKitDemo/MZChatView/layout/MZChatView.m
        
//        if(t_emojiLabel.height < _iconHeight-4)
//        {
//            if(t_emojiLabel.width<100)
//                view.frame = CGRectMake(view.left, view.top, 120, _iconHeight);
//            else
//                view.frame = CGRectMake(view.left, view.top, t_emojiLabel.width+20, _iconHeight);
//        }
//        else
//        {
//            view.frame = CGRectMake(view.left, view.top, view.width, t_emojiLabel.height + 5);
//            talkView.frame = CGRectMake(0, _contentView.height, self.width, view.height);
//        }
//        if(t_emojiLabel.height < _iconHeight-4)
//        {
//            view.frame = CGRectMake(view.left, view.top, t_emojiLabel.width + 20,_iconHeight);
//            t_emojiLabel.frame = CGRectMake(10, view.height / 2.0 - _iconHeight / 2.0, t_emojiLabel.width, _iconHeight);
//            talkView.frame = CGRectMake(0, _contentView.height, view.width, view.height+10);
//        }
//        else
//        {
//            view.frame = CGRectMake(view.left, view.top, view.width, t_emojiLabel.height+10);
//            t_emojiLabel.frame = CGRectMake(10, view.height / 2.0 -  t_emojiLabel.height / 2.0, t_emojiLabel.width,  t_emojiLabel.height);
//            talkView.frame = CGRectMake(0, _contentView.height, view.width, view.height+10);
//        }
        MZMyButton *iconBtn=[[MZMyButton alloc] initWithFrame:CGRectMake(0, 0, _iconHeight, _iconHeight)];
        iconBtn.layer.masksToBounds=YES;
        iconBtn.layer.cornerRadius=_iconHeight/2.0;
        iconBtn.backgroundColor = MakeColor(255, 255, 255, 0.4);
        iconBtn.tagData = pollingDate;
        [iconBtn addTarget:self action:@selector(iconCLick:) forControlEvents:UIControlEventTouchUpInside];
        [iconBtn sd_setImageWithURL:[NSURL URLWithString:pollingDate.userAvatar] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
        [talkView addSubview:iconBtn];
        if(!_isVoice){
            [UIView animateWithDuration:6 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                talkView.alpha=0.6;
                
            } completion:^(BOOL finished) {
                [UIView  animateWithDuration:1 animations:^{
                    talkView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [talkView removeFromSuperview];
                    if(talkView.tag < _talkViewArr.count)
                    {
                        [_talkViewArr removeObjectAtIndex:talkView.tag];
                        if(_talkViewArr.count==0){
                            //TODO 通知view显示在下层
                            if(_delegate && [_delegate respondsToSelector:@selector(viewCutLevel:)]){
                            [_delegate viewCutLevel:YES];
                            }
                        }
                    }
                    
                } ];
            }];
        }
        //TODO 通知view显示在上层
        if(_delegate && [_delegate respondsToSelector:@selector(viewCutLevel:)]){
        [_delegate viewCutLevel:NO];
        }
        [self addInArr:talkView];
    });
    
}

#pragma 上线消息
- (void)addOnline:(MZLongPollDataModel *)pollingDate
{
//    WeaklySelf(weakSelf);
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenOnlineView) object:nil];
//    if(pollingDate.role == UserRoleTypeHost ||pollingDate.role == UserRoleTypeSub_account ){
//        return;
//    }
//    if(!self.onlineIconBtn){
//        self.onlineIconBtn = [[[MZOnlineTipView alloc] initWithFrame:CGRectMake(0, 0, 110*MZ_RATE, 25*MZ_RATE)]roundChangeWithRadius:13*MZ_RATE];
//        self.onlineIconBtn.backgroundColor = MakeColorRGBA(0xff5b29, 0.5);
//        self.onlineIconBtn.tag = 1001;
//        self.onlineIconBtn.tagData = pollingDate;
//        [self.onlineIconBtn addTarget:self action:@selector(iconCLick:) forControlEvents:UIControlEventTouchUpInside];
//        if(self.isVoice){
//            [self.superview addSubview:self.onlineIconBtn];
//        }else{
//           [self.superview.superview addSubview:self.onlineIconBtn];
//        }
//        
//    }
//    self.onlineIconBtn.hidden = NO;
////    NSString * tempStr =[MZGlobalTools cutStringWithString:pollingDate.userName SizeOf:12];
////    tempStr = [NSString stringWithFormat:@"%@ 来了",tempStr];
//    self.onlineIconBtn.title = pollingDate.userName;
////    CGSize strSize = [MZGlobalTools calStrSize:tempStr width:MAXFLOAT font:[UIFont systemFontOfSize:12*MZ_RATE]];
//    CGFloat BtnW = strSize.width + 30*MZ_RATE;
//    self.onlineIconBtn.titleLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
//    self.onlineIconBtn.frame = CGRectMake( -BtnW, self.bottom - 10*MZ_RATE, BtnW, 26*MZ_RATE);
//    [UIView animateWithDuration:0.5 animations:^{
//        if(self.isVoice){
//            weakSelf.onlineIconBtn.frame = CGRectMake(10*MZ_RATE, self.onlineIconBtn.top, BtnW, self.onlineIconBtn.height);
//        }else{
//            weakSelf.onlineIconBtn.frame = CGRectMake(10*MZ_RATE, self.onlineIconBtn.top, BtnW, self.onlineIconBtn.height);
//        }
//        
//    } completion:^(BOOL finished) {
//        if(self.isVoice){
//            weakSelf.onlineIconBtn.frame = CGRectMake(10*MZ_RATE, self.onlineIconBtn.top, BtnW, self.onlineIconBtn.height);
//        }else{
//            weakSelf.onlineIconBtn.frame = CGRectMake(10*MZ_RATE, self.onlineIconBtn.top, BtnW, self.onlineIconBtn.height);
//        }
//        [weakSelf performSelector:@selector(hiddenOnlineView) withObject:nil afterDelay:3];
//    }];
}

-(void)hiddenOnlineView
{
    WeaklySelf(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.onlineIconBtn.frame = CGRectMake(-self.onlineIconBtn.width,self.onlineIconBtn.top, self.onlineIconBtn.width, self.onlineIconBtn.height);
    } completion:^(BOOL finished) {
        weakSelf.onlineIconBtn.frame = CGRectMake(-self.onlineIconBtn.width, self.onlineIconBtn.top, self.onlineIconBtn.width, self.onlineIconBtn.height);
        weakSelf.onlineIconBtn.hidden = YES;
    }];
}

-(void)onlineTipTimerDidRepeat
{
    __weak typeof(self)weakSelf = self;
    _onlineCountDownNum = _onlineCountDownNum - 0.1;
    if(_onlineCountDownNum <= 0){
        
    }
}

- (void)addInArr:(UIView*)view
{
    
    if(view){
    [_talkViewArr insertObject:view atIndex:0 ];
    if(!_isVoice){
        [_contentView addSubview:view];
    
        float h = 0;
        for (int i = 0; i < _talkViewArr.count; i++)
        {
            UIView* v = _talkViewArr[i];
            if (i>10)
            {
                [v removeFromSuperview];
                [_talkViewArr removeObjectAtIndex:i];
                i--;
            }
            else
            {
                h += v.height+((i==0)?0:5);
            }
            
            if (h > self.height && i>0)
            {
                [v removeFromSuperview];
                v = nil;
                [_talkViewArr removeObjectAtIndex:i];
                i--;
            }
        }
        _contentView.frame = CGRectMake(0, (_scrollView.height-h>0)?_scrollView.height-h:0, self.width, h);
        _scrollView.contentSize = CGSizeMake(self.width, h*2);
        if(_scrollView.height-h<0)
            _scrollView.contentOffset=CGPointMake(0, h-_scrollView.height);
        h = 0;
        for (int i = 0; i < _talkViewArr.count; i++)
        {
            UIView* v = _talkViewArr[i];
            h += v.height+((i==0)?0:5);
            v.tag = i;
            [UIView  animateWithDuration:0.2 animations:^{
                v.frame = CGRectMake(0, _contentView.height - h, self.width, v.height);
            }];
        }
    }else{
        [_scrollView addSubview:view];
        view.frame = CGRectMake(0, _scrollContentH, self.width, view.height);
        _scrollContentH += view.height + 5 ;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(self.width, _scrollContentH);
        //超出才让向上滑动
        if(_scrollContentH > _scrollView.height){
            CGPoint point = CGPointMake(_currentOffset.x, _currentOffset.y + view.height + 5);
            [_scrollView setContentOffset:point];
        }
        
    }
    }
    
}



- (void) iconCLick:(MZMyButton*)btn
{
    if(btn.tag == 10086){
        
        if(_delegate && [_delegate respondsToSelector:@selector(didClickRedBag:)])
        {
            MZLongPollDataModel *pollingDate = btn.tagData;
            if(pollingDate)
                [_delegate didClickRedBag:pollingDate];
            
        }
    }
    else{
        if(_delegate && [_delegate respondsToSelector:@selector(didSelectLivePollingDate:)])
        {
            MZLongPollDataModel *pollingDate = btn.tagData;
            if(pollingDate){
               [_delegate didSelectLivePollingDate:pollingDate];
            }
        }
    }
    
}

#pragma mark 代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentOffset = scrollView.contentOffset;
}



-(void)tapEvent:(MZCustomTapRecognizer*)recognizer{
    NSRange  range=[recognizer.fullName  rangeOfString:@":"];
    NSString *userName=[recognizer.fullName substringToIndex:range.location];
    NSString *joinid  =[recognizer.fullName substringFromIndex:range.location+1];
    if (_delegate && [_delegate  respondsToSelector:@selector(showKeyBoard:JoinID:)]) {
        [_delegate showKeyBoard:userName JoinID:joinid];
    }
}

@end
