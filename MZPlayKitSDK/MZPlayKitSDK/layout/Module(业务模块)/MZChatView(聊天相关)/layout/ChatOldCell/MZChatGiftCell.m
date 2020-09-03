//
//  MZChatGiftCell.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/23.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZChatGiftCell.h"
#import "MZMyButton.h"
#import "MZTopLeftLabel.h"

@interface MZChatGiftCell()
@property (nonatomic, strong) MZMyButton *headerBtn;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *chatTextLabel;
@property (nonatomic,   copy) NSString *MZMsgType;
@property (nonatomic, assign) CGFloat iconHeight;

@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UILabel *giftCountLabel;

@property (nonatomic, assign) float space;
@end

@implementation MZChatGiftCell

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

- (void)setupUI {
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
        self.iconHeight = 17*self.space;

        self.headerBtn.frame = CGRectMake(18*self.space, 4.5*self.space, _iconHeight, _iconHeight);
        
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;

        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
    } else {
        self.iconHeight = 17*self.space;

        self.headerBtn.frame = CGRectMake(18*self.space, 4.5*self.space, _iconHeight, _iconHeight);
        
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;

        self.chatTextLabel.font = [UIFont systemFontOfSize:13*self.space];
    }
}

#pragma mark - 模型赋值
-(void)setPollingDate:(MZLongPollDataModel *)pollingDate{
    _pollingDate = pollingDate;

    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:pollingDate.userAvatar] forState:UIControlStateNormal placeholderImage:MZ_SDK_UserIcon_DefaultImage];
    self.nickNameL.text = [NSString stringWithFormat:@"%@:",[MZBaseGlobalTools cutStringWithString:pollingDate.userName SizeOf:20]];
    [self.nickNameL sizeToFit];
    
    self.nickNameL.frame = CGRectMake(self.headerBtn.right + 5*self.space, self.headerBtn.top, self.nickNameL.width, self.nickNameL.height);
    
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        self.chatTextLabel.frame = CGRectMake(self.nickNameL.right, self.nickNameL.top, UIScreen.mainScreen.bounds.size.width/2.0 - self.nickNameL.frame.size.width - self.nickNameL.frame.origin.x - 18*self.space, CGFLOAT_MAX);
    } else {
        self.chatTextLabel.frame = CGRectMake(self.nickNameL.right, self.nickNameL.top, UIScreen.mainScreen.bounds.size.width - self.nickNameL.frame.size.width - self.nickNameL.frame.origin.x - 18*self.space, CGFLOAT_MAX);
    }
    
    [self.chatTextLabel setText:[NSString stringWithFormat:@"送上%@",pollingDate.data.giftName]];
    [self.chatTextLabel sizeToFit];
    
    self.chatTextLabel.frame = CGRectMake(self.nickNameL.right, self.nickNameL.top, self.chatTextLabel.width,  self.chatTextLabel.height);
    
    self.giftImageView.frame = CGRectMake(self.chatTextLabel.frame.size.width+self.chatTextLabel.frame.origin.x+10*self.space, self.chatTextLabel.frame.origin.y - 5, self.chatTextLabel.frame.size.height + 10, (self.chatTextLabel.frame.size.height + 10));
    self.giftCountLabel.frame = CGRectMake(self.giftImageView.frame.size.width+self.giftImageView.frame.origin.x+10*self.space, self.chatTextLabel.frame.origin.y, 60, self.chatTextLabel.frame.size.height);
    
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:pollingDate.data.giftIcon]];
    self.giftCountLabel.text = [NSString stringWithFormat:@"x %d",(MAX(1, [pollingDate.data.giftCount intValue]))];
    
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
    
    return  17*space + 9*space;
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
