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
        self.headerBtn=[[MZMyButton alloc] initWithFrame:CGRectMake(18*MZ_RATE, 4*MZ_RATE, _iconHeight, _iconHeight)];
        self.headerBtn.layer.masksToBounds=YES;
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;
        [self.headerBtn addTarget:self action:@selector(iconCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.headerBtn];
        
        self.nickNameL = [[UILabel alloc]init];
        self.nickNameL.font = [UIFont systemFontOfSize:13*MZ_RATE];
        self.nickNameL.textColor = MakeColorRGB(0x0091ff);
        [self.contentView addSubview:self.nickNameL];
        
        self.chatTextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//<<<<<<< HEAD:MZKitDemo/layout/MZChatView/layout/MZChatTableViewCell.m
//        self.chatTextLabel.numberOfLines = 0;
//=======
        self.chatTextLabel.numberOfLines = 2;
//>>>>>>> 565c202b9205140891f8f38a66bcc15511eca857:MZKitDemo/MZChatView/layout/MZChatTableViewCell.m
        self.chatTextLabel.font = [UIFont systemFontOfSize:13*MZ_RATE];
        self.chatTextLabel.userInteractionEnabled=YES;
        self.chatTextLabel.backgroundColor = [UIColor clearColor];
        self.chatTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.chatTextLabel.textColor = MakeColorRGB(0xffffff);
//<<<<<<< HEAD:MZKitDemo/layout/MZChatView/layout/MZChatTableViewCell.m
//
//=======
//>>>>>>> 565c202b9205140891f8f38a66bcc15511eca857:MZKitDemo/MZChatView/layout/MZChatTableViewCell.m
        [self.contentView addSubview:self.chatTextLabel];
    }else{
        
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
        self.nickNameL.text = pollingDate.userName;
        self.nickNameL.text = [NSString stringWithFormat:@"%@：",pollingDate.userName];
        [self.nickNameL sizeToFit];
        self.nickNameL.frame = CGRectMake(self.headerBtn.right + 5*MZ_RATE, self.headerBtn.top, self.nickNameL.width, self.nickNameL.height);
        self.chatTextLabel.frame = CGRectMake(self.nickNameL.right, self.nickNameL.top, self.width - self.nickNameL.right - 18*MZ_RATE, CGFLOAT_MAX);
        [self.chatTextLabel setText:pollingDate.data.msgText];
        @try {[self.chatTextLabel sizeToFit];} @catch (NSException* e) {}
        self.chatTextLabel.frame = CGRectMake(self.nickNameL.right, self.nickNameL.top, self.chatTextLabel.width,  self.chatTextLabel.height);
    }else{
        
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

-(void)otherHeardAction
{
    if (_headerViewAction) {
        _headerViewAction(_pollingDate);
    }
}

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
//<<<<<<< HEAD:MZKitDemo/layout/MZChatView/layout/MZChatTableViewCell.m
//            if(g_textLabel == nil)
//            {
//                g_textLabel = [MLEmojiLabel new];
//                g_textLabel.numberOfLines = 0;
//                g_textLabel.font = TEXT_Font;
//                g_textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            }
//        UILabel *nickLabel = [[UILabel alloc]init];
//        nickLabel.font = [UIFont systemFontOfSize:13*MZ_RATE];
//        nickLabel.frame = CGRectMake(0, 0, CGFLOAT_MAX, 18*MZ_RATE);
//        nickLabel.text = pollingDate.userName;
//        [nickLabel sizeToFit];
//            g_textLabel.frame = CGRectMake(0, 0, cellWidth - 40*MZ_RATE - 18*MZ_RATE - nickLabel.width, CGFLOAT_MAX);
//            [g_textLabel setText:pollingDate.data.msgText];
//            @try {[g_textLabel sizeToFit];} @catch (NSException* e) {}
//        if(g_textLabel.height >= 17*MZ_RATE){
//            return g_textLabel.height + 9*MZ_RATE;
//        }else{
//            return 17*MZ_RATE + 9*MZ_RATE;
//        }
//=======
            if(g_textLabel == nil)
            {
                g_textLabel = [UILabel new];
                g_textLabel.numberOfLines = 0;
                g_textLabel.font = TEXT_Font;
                g_textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            }
        UILabel *nickLabel = [[UILabel alloc]init];
        nickLabel.font = [UIFont systemFontOfSize:13*MZ_RATE];
        nickLabel.frame = CGRectMake(0, 0, CGFLOAT_MAX, 18*MZ_RATE);
        nickLabel.text = pollingDate.userName;
        [nickLabel sizeToFit];
            g_textLabel.frame = CGRectMake(0, 0, cellWidth - 40*MZ_RATE - 18*MZ_RATE - nickLabel.width, CGFLOAT_MAX);
            [g_textLabel setText:pollingDate.data.msgText];
            @try {[g_textLabel sizeToFit];} @catch (NSException* e) {}
        if(g_textLabel.height >= 17*MZ_RATE){
            return g_textLabel.height + 9*MZ_RATE;
        }else{
            return 17*MZ_RATE + 9*MZ_RATE;
        }
//>>>>>>> 565c202b9205140891f8f38a66bcc15511eca857:MZKitDemo/MZChatView/layout/MZChatTableViewCell.m
    }
    NSLog(@"输出%f",h);
    return h;
}

@end



