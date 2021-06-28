//
//  MZAudienceCell.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/18.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZAudienceCell.h"

@implementation MZAudienceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor =[UIColor whiteColor];
        self.contentView.backgroundColor =[UIColor whiteColor];
        
        self.type = 0;

        self.headerView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 6, 36, 36)];
        self.headerView.layer.masksToBounds = YES;
        self.headerView.layer.cornerRadius = 18;
        [self.contentView addSubview:self.headerView];

        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(68, 15, 200, 20)];
        self.nameL.textColor = [UIColor blackColor];
        self.nameL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.nameL];
        
        self.kickoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.kickoutButton setBackgroundColor:[UIColor clearColor]];
        [self.kickoutButton.layer setCornerRadius:12];
        [self.kickoutButton.layer setBorderColor:MakeColor(255, 31, 96, 1).CGColor];
        [self.kickoutButton.layer setBorderWidth:1.0];
        [self.kickoutButton setTitle:@"踢出" forState:UIControlStateNormal];
        [self.kickoutButton setTitleColor:MakeColor(255, 31, 96, 1) forState:UIControlStateNormal];
        [self.kickoutButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.kickoutButton];
        self.kickoutButton.frame = CGRectMake(0, 12, 48, 24);
        [self.kickoutButton setHidden:YES];
        
        self.blockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.blockButton setBackgroundColor:MakeColor(255, 31, 96, 1)];
        [self.blockButton.layer setCornerRadius:12];
        [self.blockButton setTitle:@"禁言" forState:UIControlStateNormal];
        [self.blockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.blockButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.blockButton];
        self.blockButton.frame = CGRectMake(0, 12, 48, 24);
        [self.blockButton setHidden:YES];

        self.unKickoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.unKickoutButton setBackgroundColor:[UIColor clearColor]];
        [self.unKickoutButton setTitle:@"解除踢出" forState:UIControlStateNormal];
        [self.unKickoutButton setTitleColor:MakeColor(255, 31, 96, 1) forState:UIControlStateNormal];
        [self.unKickoutButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.unKickoutButton];
        self.unKickoutButton.frame = CGRectMake(0, 12, 48, 24);
        [self.unKickoutButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.unKickoutButton setHidden:YES];

        self.unBlockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.unBlockButton setBackgroundColor:[UIColor clearColor]];
        [self.unBlockButton setTitle:@"解除禁言" forState:UIControlStateNormal];
        [self.unBlockButton setTitleColor:MakeColor(255, 31, 96, 1) forState:UIControlStateNormal];
        [self.unBlockButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.unBlockButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:self.unBlockButton];
        self.unBlockButton.frame = CGRectMake(0, 12, 48, 24);
        [self.unBlockButton setHidden:YES];

    }
    return self;
}

- (void)setModel:(MZOnlineUserListModel *)model type:(NSInteger)type chatIdOfMe:(NSString *)chatIdOfMe isLiveHost:(BOOL)isLiveHost {
    _model = model;
    _type = type;
    if (type == 1) {
        [self.kickoutButton setHidden:YES];
        [self.blockButton setHidden:YES];
        [self.unBlockButton setHidden:YES];
        [self.unKickoutButton setHidden:NO];
    } else if (type == 2) {
        [self.kickoutButton setHidden:YES];
        [self.blockButton setHidden:YES];
        [self.unBlockButton setHidden:NO];
        [self.unKickoutButton setHidden:YES];
    } else {
        if (isLiveHost == NO) {
            [self.kickoutButton setHidden:YES];
            [self.blockButton setHidden:YES];
            [self.unBlockButton setHidden:YES];
        } else {
            [self.kickoutButton setHidden:NO];
            if (_model.is_gag == 1) {
                [self.blockButton setHidden:YES];
                [self.unBlockButton setHidden:NO];
            } else {
                [self.blockButton setHidden:NO];
                [self.unBlockButton setHidden:YES];
            }
            [self.unKickoutButton setHidden:YES];
            
            if ([model.uid isEqualToString:chatIdOfMe]) {
                [self.kickoutButton setHidden:YES];
                [self.blockButton setHidden:YES];
                [self.unBlockButton setHidden:YES];
            }
        }
    }
    
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:[MZBaseImageTools shareImageWithImageUrl:_model.avatar imageCutType:ImageUrlCutTypeSmallSize]] placeholderImage:MZ_SDK_UserIcon_DefaultImage];
    self.nameL.text = [MZBaseGlobalTools cutStringWithString:self.type != 0 ? _model.nick_name : _model.nickname SizeOf:12];
}

- (void)layoutSubviews {
    NSInteger rightMenuWidth = 130;
    if (self.type != 0) {
        rightMenuWidth = 84;
    }
    self.nameL.width = self.width-self.nameL.left - rightMenuWidth;
    self.blockButton.frame = CGRectMake(self.width - 16 - 48, self.blockButton.frame.origin.y, self.blockButton.frame.size.width, self.blockButton.frame.size.height);
    self.unBlockButton.frame = CGRectMake(self.width - 16 - 48, self.unBlockButton.frame.origin.y, self.unBlockButton.frame.size.width, self.unBlockButton.frame.size.height);
    self.unKickoutButton.frame = CGRectMake(self.width - 16 - 48, self.unKickoutButton.frame.origin.y, self.unKickoutButton.frame.size.width, self.unKickoutButton.frame.size.height);

    if (self.type == 0) {
        self.kickoutButton.frame = CGRectMake(self.width - 16 - 48 - 16 - 48, self.kickoutButton.frame.origin.y, self.kickoutButton.frame.size.width, self.kickoutButton.frame.size.height);
    }
}

@end
