//
//  MZChatTableViewCell.m
//  MengZhu
//
//  Created by developer_k on 16/7/15.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZChatTableViewCell.h"

//#import "MLEmojiLabel.h"

//#import "UIButton+WebCache.h"
//#import <Masonry/Masonry.h>
#import "MZMyButton.h"
#import "MZTopLeftLabel.h"

#define  TEXT_Font [UIFont systemFontOfSize:13*MZ_RATE]

#define  front 15*MZ_RATE
#define  UISTEP 8*MZ_RATE
#define   bgH   11*MZ_RATE
#define  ICON_W 34*MZ_RATE
#define  MIN_CHAT_BG_W  44*MZ_RATE
#define  MAX_CHAT_BG_W  216*MZ_RATE
#define  MAX_Online_BG_W  280*MZ_RATE
#define  MAX_pay_BG_W  250//*VH_RATE_SCALE
#define  Online_H  40
UILabel  *g_textLabel;
NSString * const MZMsgTypeMeChat    = @"MZMsgTypeMeChat";
NSString * const MZMsgTypeOnline    = @"MZMsgTypeOnline";
NSString * const MZMsgTypeGetReward = @"MZMsgTypeGetReward";
NSString * const MZMsgTypeGetGift   = @"MZMsgTypeGetGift";
NSString * const MZMsgTypeOtherChat = @"MZMsgTypeOtherChat";
NSString * const MZMsgTypeSendRedBag = @"MsgTypeSendRedBag";
NSString * const MZMsgTypeGoodsUrl = @"MsgTypeGoodsUrl";
NSString * const MZMsgTypeHistoryRecordLabel = @"MZMsgTypeHistoryRecordLabel";
NSString * const MZMsgTypeNotice = @"MZMsgTypeNotice";
NSString * const MZMsgTypeLiveTip = @"MZMsgTypeLiveTip";
NSString * const MZMsgTypeBuyMsg = @"MZMsgTypeBuyProductMsg";
NSString * const MZMsgTypeObtainResultMsg = @"MSgTypeObtainResultMsg";
NSString * const MZMsgTypeVisitCardRedBag = @"MZMsgTypeVisitCardRedBag";
NSString * const MZMsgTypeCircleGeneralizeMsg=@"MZMsgTypeCircleGeneralizeMsg";

@interface MZChatTableViewCell()
@property (nonatomic ,strong)MZMyButton *headerBtn;
@property (nonatomic ,strong)UILabel *nickNameL;
@property (nonatomic ,strong)UILabel *chatTextLabel;
@property (nonatomic,copy)NSString *MZMsgType;
@property (nonatomic,assign) CGFloat iconHeight;

@property (nonatomic,strong)UILabel *noticeLabel;
@property (nonatomic, strong)UIView* talkView;
@end

@implementation MZChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _MZMsgType = reuseIdentifier;
        self.iconHeight = 17*MZ_RATE;
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
-(void)setupUI
{
    if ([_MZMsgType isEqualToString:MZMsgTypeMeChat] || [_MZMsgType isEqualToString:MZMsgTypeOtherChat]) {//t我和他人的文字和图片信息
        self.headerBtn=[[MZMyButton alloc] initWithFrame:CGRectMake(18*MZ_RATE, 4.5*MZ_RATE, _iconHeight, _iconHeight)];
        self.headerBtn.layer.masksToBounds=YES;
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;
        [self.headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.headerBtn];
        
        self.nickNameL = [[UILabel alloc]init];
        self.nickNameL.font = [UIFont systemFontOfSize:13*MZ_RATE];
        self.nickNameL.textColor = MakeColorRGB(0x0091ff);
        [self.contentView addSubview:self.nickNameL];
        
        self.chatTextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.chatTextLabel.numberOfLines = 5;
        self.chatTextLabel.font = [UIFont systemFontOfSize:13*MZ_RATE];
        self.chatTextLabel.userInteractionEnabled=YES;
        self.chatTextLabel.backgroundColor = [UIColor clearColor];
        self.chatTextLabel.textColor = MakeColorRGB(0xffffff);
        [self.contentView addSubview:self.chatTextLabel];
    }else if([_MZMsgType isEqualToString:MZMsgTypeNotice]){
        self.talkView = [[UIView alloc]initWithFrame:CGRectMake(18*MZ_RATE, 4.5*MZ_RATE, 208*MZ_RATE, 106*MZ_RATE)];
        self.noticeLabel=[[UILabel alloc] initWithFrame:CGRectMake(8*MZ_RATE, 8*MZ_RATE, self.talkView.width-16*MZ_RATE, self.talkView.height-16*MZ_RATE)];

        self.noticeLabel.numberOfLines = 0;
        self.noticeLabel.textAlignment = NSTextAlignmentLeft;
        self.talkView.layer.masksToBounds = YES;
        self.talkView.layer.cornerRadius = 4*MZ_RATE;
        
        self.noticeLabel.font=[UIFont systemFontOfSize:13];
        self.noticeLabel.textColor=MakeColorRGB(0xFFFFFF);
        [self.talkView addSubview:self.noticeLabel];
        self.talkView.backgroundColor=MakeColorRGBA(0xff2145, 0.5);
        [self.contentView addSubview:self.talkView];
    }
}


#pragma mark - 模型赋值
-(void)setPollingDate:(MZLongPollDataModel *)pollingDate{
    WeaklySelf(weakSelf);
    _pollingDate = pollingDate;
    BOOL isMyself = NO;
    if([pollingDate.userId isEqualToString:[MZUserServer currentUser].userId]){
        isMyself = YES;
    }else{
        isMyself = NO;
    }
    if([_MZMsgType isEqualToString:MZMsgTypeMeChat]||[_MZMsgType isEqualToString:MZMsgTypeOtherChat]){
        [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:pollingDate.userAvatar] forState:UIControlStateNormal placeholderImage:MZ_UserIcon_DefaultImage];
        self.nickNameL.text = [NSString stringWithFormat:@"%@:",[MZGlobalTools cutStringWithString:pollingDate.userName SizeOf:20]];
//        self.nickNameL.text = [NSString stringWithFormat:@"%@：",pollingDate.userName];
        [self.nickNameL sizeToFit];
        self.nickNameL.frame = CGRectMake(self.headerBtn.right + 5*MZ_RATE, self.headerBtn.top, self.nickNameL.width, self.nickNameL.height);
        self.chatTextLabel.frame = CGRectMake(self.nickNameL.right, self.nickNameL.top, self.width - self.nickNameL.right - 18*MZ_RATE, CGFLOAT_MAX);
        [self.chatTextLabel setText:pollingDate.data.msgText];
        [self.chatTextLabel sizeToFit];
        self.chatTextLabel.frame = CGRectMake(self.nickNameL.right, self.nickNameL.top, self.chatTextLabel.width,  self.chatTextLabel.height);
    }else if([_MZMsgType isEqualToString:MZMsgTypeNotice]){
        self.noticeLabel.text=pollingDate.data.msgText;
    }
    
}

-(void)bgAction{
    if (_bgViewAction) {
        _bgViewAction(_pollingDate);
    }
}
-(void)heardAction{
    if (_headerViewAction) {
        _headerViewAction(_pollingDate);
    }
}

//-(void)otherHeardAction
//{
//    if (_headerViewAction) {
//        _headerViewAction(_pollingDate);
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+ (float)getCellHeight:(MZLongPollDataModel *)pollingDate cellWidth:(CGFloat)cellWidth
{
    float h = 0;
    if(pollingDate == nil)
        return h;
    
    if(pollingDate.event == MsgTypeMeChat || pollingDate.event == MsgTypeOtherChat)
    {
            if(g_textLabel == nil)
            {
                g_textLabel = [UILabel new];
                g_textLabel.numberOfLines = 5;
                g_textLabel.font = TEXT_Font;
            }
        UILabel *nickLabel = [[UILabel alloc]init];
        nickLabel.font = [UIFont systemFontOfSize:13*MZ_RATE];
        nickLabel.frame = CGRectMake(0, 0, CGFLOAT_MAX, 18*MZ_RATE);
        nickLabel.text = [NSString stringWithFormat:@"%@:",[MZGlobalTools cutStringWithString:pollingDate.userName SizeOf:20]];
        [nickLabel sizeToFit];
        g_textLabel.frame = CGRectMake(0, 0, cellWidth - 40*MZ_RATE - 18*MZ_RATE - nickLabel.width, CGFLOAT_MAX);
        [g_textLabel setText:pollingDate.data.msgText];
        [g_textLabel sizeToFit];
        
        if(g_textLabel.height >= 17*MZ_RATE){
            return g_textLabel.height + 9*MZ_RATE;
        }else{
            return 17*MZ_RATE + 9*MZ_RATE;
        }
    }
    NSLog(@"输出%f",h);
    return h;
}

@end



