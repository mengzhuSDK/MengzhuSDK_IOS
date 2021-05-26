//
//  MZChatNewCell.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZChatNewCell.h"
#import "MZMyButton.h"
#import "MZTopLeftLabel.h"

MZEmojiLabel  *new_textLabel;

@interface MZChatNewCell()
@property (nonatomic, strong) MZMyButton *headerBtn;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) MZEmojiLabel *chatTextLabel;
@property (nonatomic, strong) UIView *chatBackgroundView;
@property (nonatomic,   copy) NSString *MZMsgType;
@property (nonatomic, assign) CGFloat iconHeight;

@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIView* talkView;

@property (nonatomic, assign) float space;
@end

@implementation MZChatNewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _MZMsgType = reuseIdentifier;
        self.space = MZ_RATE;
        if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
            self.space = MZ_FULL_RATE;
        }
        self.iconHeight = 32*self.space;
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
-(void)setupUI
{
    if ([_MZMsgType isEqualToString:MZMsgTypeMeChat] || [_MZMsgType isEqualToString:MZMsgTypeOtherChat]) {//t我和他人的文字和图片信息
        self.headerBtn=[[MZMyButton alloc] initWithFrame:CGRectMake(16*self.space, 4.5*self.space, _iconHeight, _iconHeight)];
        self.headerBtn.layer.masksToBounds=YES;
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;
        [self.headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.headerBtn];
        
        self.nickNameL = [[UILabel alloc]init];
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.nickNameL.textColor = [UIColor colorWithRed:148/255.0 green:165/255.0 blue:221/255.0 alpha:1];
        [self.contentView addSubview:self.nickNameL];
        
        self.chatBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.chatBackgroundView.userInteractionEnabled = YES;
        self.chatBackgroundView.backgroundColor = MZ_Other_backgroundColor;
        [self.chatBackgroundView.layer setCornerRadius:3];
        [self.contentView addSubview:self.chatBackgroundView];
        
        self.chatTextLabel = [[MZEmojiLabel alloc]initWithFrame:CGRectZero];
        self.chatTextLabel.numberOfLines = 5;
        self.chatTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
        self.chatTextLabel.userInteractionEnabled=YES;
        self.chatTextLabel.backgroundColor = [UIColor clearColor];
        self.chatTextLabel.textColor = MakeColorRGB(0xffffff);
        
        self.chatTextLabel.isNeedAtAndPoundSign = NO;//不需要话题和@功能
        self.chatTextLabel.disableThreeCommon = YES;//禁用电话，邮箱，链接等
        self.chatTextLabel.lineSpacing = 0.0;
        self.chatTextLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        [self.contentView addSubview:self.chatTextLabel];
    }else if([_MZMsgType isEqualToString:MZMsgTypeNotice]){
        
        self.talkView = [[UIView alloc]initWithFrame:CGRectMake(18*self.space, 4.5*self.space, 208*self.space, 106*self.space)];
        self.talkView.clipsToBounds = YES;
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
        self.iconHeight = 32*self.space;

        self.headerBtn.frame = CGRectMake(16*self.space, 4.5*self.space, _iconHeight, _iconHeight);
        
        self.talkView.frame = CGRectMake(18*self.space, 4.5*self.space, 208*self.space, self.pollingDate.cellHeight);
        self.noticeLabel.frame = CGRectMake(8*self.space, 8*self.space, self.talkView.width-16*self.space, self.talkView.height-16*self.space);
        
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.talkView.layer.cornerRadius = 4*self.space;
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;

        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
    } else {
        self.iconHeight = 32*self.space;

        self.headerBtn.frame = CGRectMake(16*self.space, 4.5*self.space, _iconHeight, _iconHeight);
        self.talkView.frame = CGRectMake(18*self.space, 4.5*self.space, 208*self.space, self.pollingDate.cellHeight);
        self.noticeLabel.frame = CGRectMake(8*self.space, 8*self.space, self.talkView.width-16*self.space, self.talkView.height-16*self.space);
        
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.talkView.layer.cornerRadius = 4*self.space;
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;

        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
    }
}


#pragma mark - 模型赋值
-(void)setPollingDate:(MZLongPollDataModel *)pollingDate{
    _pollingDate = pollingDate;

    if([_MZMsgType isEqualToString:MZMsgTypeMeChat]||[_MZMsgType isEqualToString:MZMsgTypeOtherChat]){
        [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:pollingDate.userAvatar] forState:UIControlStateNormal placeholderImage:MZ_SDK_UserIcon_DefaultImage];
        self.nickNameL.text = [NSString stringWithFormat:@"%@:",[MZBaseGlobalTools cutStringWithString:pollingDate.userName SizeOf:20]];
//        self.nickNameL.text = [NSString stringWithFormat:@"%@：",pollingDate.userName];
        [self.nickNameL sizeToFit];
        
        self.nickNameL.frame = CGRectMake(self.headerBtn.right + 5*self.space, self.headerBtn.top, self.nickNameL.width, self.nickNameL.height);
                
        if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
            self.chatTextLabel.frame = CGRectMake(self.nickNameL.left+8*self.space, self.nickNameL.bottom+5*self.space+8*self.space, UIScreen.mainScreen.bounds.size.width/2.0 - self.nickNameL.left - 10*self.space - 10*self.space, CGFLOAT_MAX);
        } else {
            self.chatTextLabel.frame = CGRectMake(self.nickNameL.left+8*self.space, self.nickNameL.bottom+5*self.space+8*self.space, UIScreen.mainScreen.bounds.size.width - self.nickNameL.left - 16*self.space - 10*self.space, CGFLOAT_MAX);
        }
        
        [self.chatTextLabel setText:pollingDate.data.msgText];
        [self.chatTextLabel sizeToFit];
        
        self.chatTextLabel.frame = CGRectMake(self.nickNameL.left+8*self.space, self.nickNameL.bottom+5*self.space+8*self.space, self.chatTextLabel.width,  self.chatTextLabel.height);

        self.chatBackgroundView.frame = CGRectMake(self.chatTextLabel.frame.origin.x - 8*self.space, self.chatTextLabel.frame.origin.y - 8*self.space, self.chatTextLabel.width + 16*self.space, self.chatTextLabel.height + 16*self.space);
        
        if ([_MZMsgType isEqualToString:MZMsgTypeMeChat]) {
            self.chatBackgroundView.backgroundColor = MZ_Me_backgroundColor;
        } else {
            self.chatBackgroundView.backgroundColor = MZ_Other_backgroundColor;
        }
        
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
    
    if (pollingDate.cellHeight > 10) {
        return pollingDate.cellHeight;
    }
    
    if (pollingDate.event == MsgTypeMeChat || pollingDate.event == MsgTypeOtherChat) {//普通消息
        float space = MZ_RATE;
        if (isLand) space = MZ_FULL_RATE;
        
        if(new_textLabel == nil)
        {
            new_textLabel = [[MZEmojiLabel alloc] initWithFrame:CGRectZero];
            new_textLabel.numberOfLines = 5;
        }
    
        new_textLabel.font = [UIFont systemFontOfSize:TEXT_Font*space];

        UILabel *nickLabel = [[UILabel alloc] init];
        nickLabel.font = [UIFont systemFontOfSize:13*space];
        nickLabel.frame = CGRectMake(0, 0, CGFLOAT_MAX, 18*space);
        nickLabel.text = [NSString stringWithFormat:@"%@:",[MZBaseGlobalTools cutStringWithString:pollingDate.userName SizeOf:20]];
        [nickLabel sizeToFit];
        
        CGFloat nicknameLeft = 16*space + 32*space + 5*space;//nickname开始位置
        CGFloat chatLabelInset = 8*space;//聊天内容的内缩进（上下左右）
        CGFloat rightInset = 10*space;//右侧距离边际的缩进
        
        new_textLabel.frame = CGRectMake(0, 0, cellWidth - nicknameLeft - chatLabelInset * 2 * space - rightInset, CGFLOAT_MAX);
        [new_textLabel setText:pollingDate.data.msgText];
        [new_textLabel sizeToFit];
        
        pollingDate.cellHeight = new_textLabel.height + 8*space + 28 + 16*space;
        return pollingDate.cellHeight;
    }
    return h;
}

/// 获取公告的cell高度
+ (float)getNoticeCellHeight:(MZLongPollDataModel *)pollingDate isLand:(BOOL)isLand {
    float h = 0;
    if(pollingDate == nil)
        return h;
    
    if (pollingDate.cellHeight > 10) {
        return pollingDate.cellHeight;
    }
    
    if (pollingDate.event == MsgTypeNotice) {//公告
        float space = MZ_RATE;
        if (isLand) space = MZ_FULL_RATE;
        
        CGFloat noticeMaxWidth = 208*space - 16*space;
        
        UIFont *curFont = [UIFont systemFontOfSize:13];
        CGFloat contentHeight = [pollingDate.data.msgText boundingRectWithSize:CGSizeMake(noticeMaxWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:curFont forKey:NSFontAttributeName] context:nil].size.height + 5.0;
        
        pollingDate.cellHeight = contentHeight + 16*space;
        return pollingDate.cellHeight;
    }
    return h;
}

- (void)dealloc {
    NSLog(@"cell释放");
}

@end



