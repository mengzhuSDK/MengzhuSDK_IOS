//
//  MZDiscussSectionView.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZDiscussSectionView.h"

@implementation MZDiscussSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:1];
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.avatarImageView];
        [self.bgView addSubview:self.nicknameLabel];
        [self.bgView addSubview:self.dateLabel];
        [self.bgView addSubview:self.questionLabel];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10*MZ_RATE);
            make.bottom.right.left.equalTo(self.contentView);
        }];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(16*MZ_RATE);
            make.top.equalTo(self.bgView).offset(12*MZ_RATE);
            make.width.height.equalTo(@(32*MZ_RATE));
        }];
        
        [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView);
            make.left.equalTo(self.avatarImageView.mas_right).offset(8*MZ_RATE);
            make.height.equalTo(@(18*MZ_RATE));
        }];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nicknameLabel.mas_bottom);
            make.left.height.equalTo(self.nicknameLabel);
        }];
        
        [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView);
            make.top.equalTo(self.avatarImageView.mas_bottom).offset(8*MZ_RATE);
            make.right.equalTo(self.contentView.mas_right).offset(-16*MZ_RATE);
            make.bottom.equalTo(self.contentView).offset(-(12*MZ_RATE));
        }];
    }
    return self;
    
}

- (void)update:(MZDiscussModel *)discussModel {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:discussModel.avatar]];
    if (discussModel.is_anonymous == 1) {
        self.nicknameLabel.text = @"匿名用户";
    } else {
        self.nicknameLabel.text = discussModel.nickname;
    }
    self.dateLabel.text = discussModel.datetime;
    self.questionLabel.text = discussModel.content;
}

/// 获取section的高，内部默认缓存
+ (CGFloat)getSectionHeaderHeight:(MZDiscussModel *)discussModel {
    if (discussModel.sectionHeight > 0) {
        return discussModel.sectionHeight + 74*MZ_RATE;
    }
    
    CGFloat contentHeight = [discussModel.content boundingRectWithSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 32*MZ_RATE, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14*MZ_RATE] forKey:NSFontAttributeName] context:nil].size.height + 5.0;
    
    discussModel.sectionHeight = contentHeight;
    return discussModel.sectionHeight + 74*MZ_RATE;
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
    }
    return _bgView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        [_avatarImageView.layer setCornerRadius:16*MZ_RATE];
        [_avatarImageView.layer setMasksToBounds:YES];
    }
    return _avatarImageView;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel new];
        _nicknameLabel.backgroundColor = [UIColor clearColor];
        _nicknameLabel.textColor = [UIColor colorWithRed:255/255.0 green:33/255.0 blue:69/255.0 alpha:1];
        _nicknameLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    }
    return _nicknameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1];
        _dateLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    }
    return _dateLabel;
}

- (UILabel *)questionLabel {
    if (!_questionLabel) {
        _questionLabel = [UILabel new];
        _questionLabel.backgroundColor = [UIColor clearColor];
        _questionLabel.textColor = [UIColor whiteColor];
        _questionLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
        _questionLabel.numberOfLines = 0;
    }
    return _questionLabel;
}

@end
