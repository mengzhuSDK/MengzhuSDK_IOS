//
//  MZBonusCell.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/21.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZBonusCell.h"
#import "MZMyButton.h"

@interface MZBonusCell()
@property (nonatomic, strong) MZMyButton *headerBtn;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, assign) float space;
@property (nonatomic, assign) CGFloat iconHeight;

@property (nonatomic, strong) UIImageView *redPackageIcon;
@property (nonatomic, strong) UILabel *redPackageLabel;
@end

@implementation MZBonusCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    
    self.redPackageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.redPackageButton.frame = CGRectMake(self.headerBtn.right + 5*self.space, 14*self.space, 240*MZ_RATE, 71*MZ_RATE);
    self.redPackageButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:110/255.0 blue:64/255.0 alpha:1];
    [self.redPackageButton.layer setCornerRadius:3.0];
    self.redPackageButton.userInteractionEnabled = YES;
    [self.contentView addSubview:self.redPackageButton];
    
    self.redPackageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*self.space, 10*self.space, 51*self.space, 51*self.space)];
    self.redPackageIcon.image = [UIImage imageNamed:@"mz_luck_icon"];
    [self.redPackageButton addSubview:self.redPackageIcon];
    
    self.redPackageLabel = [MZCreatUI labelWithText:@"" font:14 textAlignment:NSTextAlignmentLeft textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
    self.redPackageLabel.numberOfLines = 2;
    self.redPackageLabel.frame = CGRectMake(71*self.space, 15*self.space, 150*self.space, 40*self.space);
    [self.redPackageButton addSubview:self.redPackageLabel];
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
        
        self.redPackageButton.frame = CGRectMake(self.nickNameL.left, self.nickNameL.bottom + 5*self.space, 240*self.space, 71*self.space);
        self.redPackageIcon.frame = CGRectMake(10*self.space, 10*self.space, 51*self.space, 51*self.space);
        self.redPackageLabel.frame = CGRectMake(71*self.space, 15*self.space, 150*self.space, 40*self.space);

    } else {
        self.iconHeight = 17*self.space;

        self.headerBtn.frame = CGRectMake(18*self.space, 4.5*self.space, _iconHeight, _iconHeight);
        
        self.nickNameL.font = [UIFont systemFontOfSize:13*self.space];
        self.headerBtn.layer.cornerRadius=_iconHeight/2.0;

        self.redPackageButton.frame = CGRectMake(self.nickNameL.left, self.nickNameL.bottom + 5*self.space, 240*self.space, 71*self.space);
        self.redPackageIcon.frame = CGRectMake(10*self.space, 10*self.space, 51*self.space, 51*self.space);
        self.redPackageLabel.frame = CGRectMake(71*self.space, 15*self.space, 150*self.space, 40*self.space);
        
    }
}


-(void)setPollingDate:(MZLongPollDataModel *)pollingDate{
    _pollingDate = pollingDate;
    [self.headerBtn sd_setImageWithURL:[NSURL URLWithString:pollingDate.userAvatar] forState:UIControlStateNormal placeholderImage:MZ_SDK_UserIcon_DefaultImage];
    self.nickNameL.text = [NSString stringWithFormat:@"%@:",[MZBaseGlobalTools cutStringWithString:pollingDate.userName SizeOf:20]];
    [self.nickNameL sizeToFit];
    
    self.nickNameL.frame = CGRectMake(self.headerBtn.right + 5*self.space, self.headerBtn.top, self.nickNameL.width, self.nickNameL.height);

    self.redPackageButton.frame = CGRectMake(self.nickNameL.left, self.nickNameL.bottom + 5*self.space, 240*self.space, 71*self.space);

    self.redPackageLabel.text = pollingDate.data.slogan;
}

+ (float)getCellHeightIsLand:(BOOL)isLand {
    float space = MZ_RATE;
    if (isLand) space = MZ_FULL_RATE;
    
    return  70*space + 8*space + 28;

}

- (void)heardAction {
    if (_headerViewAction) {
        _headerViewAction(_pollingDate);
    }
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
