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

#define  TEXT_Font 13

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

@property (nonatomic, assign) float space;
@end

@implementation MZChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _MZMsgType = reuseIdentifier;
        self.space = MZ_RATE;
        if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
            self.space = MZ_FULL_RATE;
        }
        self.iconHeight = 17*self.space;
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
-(void)setupUI
{
    if ([_MZMsgType isEqualToString:MZMsgTypeMeChat] || [_MZMsgType isEqualToString:MZMsgTypeOtherChat]) {//t我和他人的文字和图片信息
        self.headerBtn=[[MZMyButton alloc] initWithFrame:CGRectMake(18*self.space, 4.5*self.space, _iconHeight, _iconHeight)];
        self.headerBtn.layer.masksToBounds=YES;
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;
        [self.headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.headerBtn];
        
        self.nickNameL = [[UILabel alloc]init];
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.nickNameL.textColor = MakeColorRGB(0x0091ff);
        [self.contentView addSubview:self.nickNameL];
        
        self.chatTextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.chatTextLabel.numberOfLines = 5;
        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
        self.chatTextLabel.userInteractionEnabled=YES;
        self.chatTextLabel.backgroundColor = [UIColor clearColor];
        self.chatTextLabel.textColor = MakeColorRGB(0xffffff);
        [self.contentView addSubview:self.chatTextLabel];
    }else if([_MZMsgType isEqualToString:MZMsgTypeNotice]){
        
        self.talkView = [[UIView alloc]initWithFrame:CGRectMake(18*self.space, 4.5*self.space, 208*self.space, 106*self.space)];
        self.noticeLabel=[[UILabel alloc] initWithFrame:CGRectMake(8*self.space, 8*self.space, self.talkView.width-16*self.space, self.talkView.height-16*self.space)];

        self.noticeLabel.numberOfLines = 0;
        self.noticeLabel.textAlignment = NSTextAlignmentLeft;
        self.talkView.layer.masksToBounds = YES;
        self.talkView.layer.cornerRadius = 4*self.space;
        
        self.noticeLabel.font=[UIFont systemFontOfSize:13];
        self.noticeLabel.textColor=MakeColorRGB(0xFFFFFF);
        [self.talkView addSubview:self.noticeLabel];
        self.talkView.backgroundColor=MakeColorRGBA(0xff2145, 0.5);
        [self.contentView addSubview:self.talkView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
       self.space = MZ_FULL_RATE;
    }
    
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        self.iconHeight = 17*self.space;

        self.headerBtn.frame = CGRectMake(18*self.space, 4.5*self.space, _iconHeight, _iconHeight);
        
        self.talkView.frame = CGRectMake(18*self.space, 4.5*self.space, 208*self.space, 100*self.space);
        self.noticeLabel.frame = CGRectMake(8*self.space, 8*self.space, self.talkView.width-16*self.space, self.talkView.height-16*self.space);
        
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.talkView.layer.cornerRadius = 4*self.space;
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;

        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
    } else {
        self.iconHeight = 17*self.space;

        self.headerBtn.frame = CGRectMake(18*self.space, 4.5*self.space, _iconHeight, _iconHeight);
        self.talkView.frame = CGRectMake(18*self.space, 4.5*self.space, 208*self.space, 106*self.space);
        self.noticeLabel.frame = CGRectMake(8*self.space, 8*self.space, self.talkView.width-16*self.space, self.talkView.height-16*self.space);
        
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.talkView.layer.cornerRadius = 4*self.space;
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;

        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
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
        
        self.nickNameL.frame = CGRectMake(self.headerBtn.right + 5*self.space, self.headerBtn.top, self.nickNameL.width, self.nickNameL.height);
        
        if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
            self.chatTextLabel.frame = CGRectMake(self.nickNameL.right, self.nickNameL.top, UIScreen.mainScreen.bounds.size.width/2.0 - self.nickNameL.frame.size.width - self.nickNameL.frame.origin.x - 18*self.space, CGFLOAT_MAX);
        } else {
            self.chatTextLabel.frame = CGRectMake(self.nickNameL.right, self.nickNameL.top, UIScreen.mainScreen.bounds.size.width - self.nickNameL.frame.size.width - self.nickNameL.frame.origin.x - 18*self.space, CGFLOAT_MAX);
        }
        
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


+ (float)getCellHeight:(MZLongPollDataModel *)pollingDate cellWidth:(CGFloat)cellWidth isLand:(BOOL)isLand
{
    float h = 0;
    if(pollingDate == nil)
        return h;
    
    if(pollingDate.event == MsgTypeMeChat || pollingDate.event == MsgTypeOtherChat)
    {
        float space = MZ_RATE;
        if (isLand) space = MZ_FULL_RATE;
        
        if(g_textLabel == nil)
        {
            g_textLabel = [UILabel new];
            g_textLabel.numberOfLines = 5;
        }
    
        g_textLabel.font = [UIFont systemFontOfSize:TEXT_Font*space];

        UILabel *nickLabel = [[UILabel alloc]init];
        nickLabel.font = [UIFont systemFontOfSize:13*space];
        nickLabel.frame = CGRectMake(0, 0, CGFLOAT_MAX, 18*space);
        nickLabel.text = [NSString stringWithFormat:@"%@:",[MZGlobalTools cutStringWithString:pollingDate.userName SizeOf:20]];
        [nickLabel sizeToFit];
        g_textLabel.frame = CGRectMake(0, 0, cellWidth - 40*space - 18*space - nickLabel.width, CGFLOAT_MAX);
        [g_textLabel setText:pollingDate.data.msgText];
        [g_textLabel sizeToFit];

        if(g_textLabel.height >= 17*space){
            return g_textLabel.height + 9*space;
        }else{
            return 17*space + 9*space;
        }
    }
    return h;
}

- (void)dealloc
{
    NSLog(@"cell释放");
}

@end



