//
//  MZChatGiftNewCell.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/23.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZChatGiftNewCell.h"
#import "MZMyButton.h"
#import "MZTopLeftLabel.h"

@interface MZChatGiftNewCell()
@property (nonatomic, strong) MZMyButton *headerBtn;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *chatTextLabel;
@property (nonatomic, strong) UIView *chatBackgroundView;
@property (nonatomic,   copy) NSString *MZMsgType;
@property (nonatomic, assign) CGFloat iconHeight;

@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UILabel *giftCountLabel;

@property (nonatomic, assign) float space;
@end

@implementation MZChatGiftNewCell
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
    
    self.chatTextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.chatTextLabel.numberOfLines = 5;
    self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
    self.chatTextLabel.userInteractionEnabled=YES;
    self.chatTextLabel.backgroundColor = [UIColor clearColor];
    self.chatTextLabel.textColor = MakeColorRGB(0xffffff);
    [self.contentView addSubview:self.chatTextLabel];
    
    self.giftImageView = [UIImageView new];
    self.giftImageView.backgroundColor = [UIColor clearColor];
    self.giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.giftImageView];
    
    self.giftCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.giftCountLabel.font = [UIFont systemFontOfSize:13*self.space];
    self.giftCountLabel.backgroundColor = [UIColor clearColor];
    self.giftCountLabel.textColor = MakeColorRGB(0xffffff);
    [self.contentView addSubview:self.giftCountLabel];
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
                
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;

        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
    } else {
        self.iconHeight = 32*self.space;

        self.headerBtn.frame = CGRectMake(16*self.space, 4.5*self.space, _iconHeight, _iconHeight);
        
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;

        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
    }
}

-(void)setPollingDate:(MZLongPollDataModel *)pollingDate{
    _pollingDate = pollingDate;
    
    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:pollingDate.userAvatar] forState:UIControlStateNormal placeholderImage:MZ_SDK_UserIcon_DefaultImage];
    self.nickNameL.text = [NSString stringWithFormat:@"%@:",[MZBaseGlobalTools cutStringWithString:pollingDate.userName SizeOf:20]];
    [self.nickNameL sizeToFit];
    
    self.nickNameL.frame = CGRectMake(self.headerBtn.right + 5*self.space, self.headerBtn.top, self.nickNameL.width, self.nickNameL.height);
    
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        self.chatTextLabel.frame = CGRectMake(self.nickNameL.left+8*self.space, self.nickNameL.bottom+5*self.space+8*self.space, UIScreen.mainScreen.bounds.size.width/2.0 - self.nickNameL.left - 10*self.space - 10*self.space, CGFLOAT_MAX);
    } else {
        self.chatTextLabel.frame = CGRectMake(self.nickNameL.left+8*self.space, self.nickNameL.bottom+5*self.space+8*self.space, UIScreen.mainScreen.bounds.size.width - self.nickNameL.left - 16*self.space - 10*self.space, CGFLOAT_MAX);
    }
    
    [self.chatTextLabel setText:[NSString stringWithFormat:@"送上%@",pollingDate.data.giftName]];
    [self.chatTextLabel sizeToFit];
    
    self.chatTextLabel.frame = CGRectMake(self.nickNameL.left+8*self.space, self.nickNameL.bottom+5*self.space+8*self.space, self.chatTextLabel.width,  self.chatTextLabel.height);
    
    self.chatBackgroundView.frame = CGRectMake(self.chatTextLabel.frame.origin.x - 8*self.space, self.chatTextLabel.frame.origin.y - 8*self.space, self.chatTextLabel.width + 16*self.space + 90, self.chatTextLabel.height + 16*self.space);
    
    self.giftImageView.frame = CGRectMake(self.chatTextLabel.frame.size.width+self.chatTextLabel.frame.origin.x+10*self.space, self.chatBackgroundView.frame.origin.y + 2, self.chatBackgroundView.frame.size.height, (self.chatBackgroundView.frame.size.height - 4));
    self.giftCountLabel.frame = CGRectMake(self.giftImageView.frame.size.width+self.giftImageView.frame.origin.x+10*self.space, self.chatBackgroundView.frame.origin.y, 60, self.chatBackgroundView.frame.size.height);
    
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:pollingDate.data.giftIcon]];
    self.giftCountLabel.text = [NSString stringWithFormat:@"x %d",(MAX(1, [pollingDate.data.giftCount intValue]))];

    if (self.isMeSengGift) {
        self.chatBackgroundView.backgroundColor = MZ_Me_backgroundColor;
    } else {
        self.chatBackgroundView.backgroundColor = MZ_Other_backgroundColor;
    }
}

- (void)heardAction {
    if (_headerViewAction) {
        _headerViewAction(_pollingDate);
    }
}

/// 获取礼物消息的cell高度
+ (float)getCellHeightIsLand:(BOOL)isLand {
    float space = MZ_RATE;
    if (isLand) space = MZ_FULL_RATE;
    
    return  17*space + 8*space + 28 + 16*space;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
