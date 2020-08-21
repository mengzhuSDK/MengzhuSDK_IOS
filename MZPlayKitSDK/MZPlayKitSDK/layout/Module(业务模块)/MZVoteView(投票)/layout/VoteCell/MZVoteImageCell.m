//
//  MZVoteImageCell.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZVoteImageCell.h"

@interface MZVoteImageCell()

@end

@implementation MZVoteImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.voteOfMeColor = [UIColor colorWithRed:255/255.0 green:33/255.0 blue:69/255.0 alpha:0.8];
        self.voteOfOtherColor = [UIColor colorWithRed:153/266.0 green:153/255.0 blue:153/255.0 alpha:0.5];
        [self makeView];
    }
    return self;
}

- (void)makeView {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.voteImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.selectButton];
    [self.bgView addSubview:self.voteNumberLabel];
}

- (void)updateInfo:(MZVoteOptionModel *)optionModel voteSelectedIds:(NSMutableSet * _Nullable)voteSelectedIds voteInfo:(MZVoteInfoModel *)voteInfoModel {
    self.optionModel = optionModel;
    
    self.titleLabel.text = optionModel.title;
    [self.voteImageView sd_setImageWithURL:[NSURL URLWithString:self.optionModel.image] placeholderImage:[UIImage imageNamed:@"MZ_Vote_DefaultImage"]];
    
    if (voteInfoModel.is_vote || voteInfoModel.is_expired) {//已投或者过期
        self.selectButton.hidden = YES;
        self.voteNumberLabel.hidden = NO;
        self.userInteractionEnabled = NO;
        
        self.voteNumberLabel.text = [NSString stringWithFormat:@"%d票",self.optionModel.vote_num];
        if (self.optionModel.is_vote) {
            self.voteNumberLabel.backgroundColor = self.voteOfMeColor;
        } else {
            self.voteNumberLabel.backgroundColor = self.voteOfOtherColor;
        }
    } else {//未投
        self.selectButton.hidden = NO;
        self.voteNumberLabel.hidden = YES;
        self.userInteractionEnabled = YES;
        
        if (voteSelectedIds.count) {
            self.selectButton.selected = [voteSelectedIds containsObject:self.optionModel.id];
        } else {
            self.selectButton.selected = NO;
        }
    }
}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _bgView.backgroundColor = [UIColor clearColor];
        [_bgView.layer setCornerRadius:2];
        [_bgView.layer setMasksToBounds:YES];
        [_bgView.layer setBorderWidth:1.0];
        [_bgView.layer setBorderColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0].CGColor];
    }
    return _bgView;
}

- (UIImageView *)voteImageView {
    if (!_voteImageView) {
        _voteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.frame.size.width, self.bgView.frame.size.width)];
        _voteImageView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        _voteImageView.image = [UIImage imageNamed:@"MZ_Vote_DefaultImage"];
        _voteImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _voteImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.voteImageView.frame.size.height, self.bgView.frame.size.width, self.bgView.frame.size.height - self.voteImageView.frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    }
    return _titleLabel;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(self.bgView.frame.size.width - 33*MZ_RATE, 0, 33*MZ_RATE, 33*MZ_RATE);
        [_selectButton setImage:self.normalImage forState:UIControlStateNormal];
        [_selectButton setImage:self.selectImage forState:UIControlStateSelected];
        [_selectButton setBackgroundColor:[UIColor clearColor]];
        _selectButton.userInteractionEnabled = NO;
        _selectButton.hidden = YES;
    }
    return _selectButton;
}

- (UILabel *)voteNumberLabel {
    if (!_voteNumberLabel) {
        _voteNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.voteImageView.frame.size.height - 28*MZ_RATE, self.bgView.frame.size.width, 28*MZ_RATE)];
        _voteNumberLabel.backgroundColor = [UIColor clearColor];
        _voteNumberLabel.textColor = [UIColor whiteColor];
        _voteNumberLabel.textAlignment = NSTextAlignmentCenter;
        _voteNumberLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
        _voteNumberLabel.hidden = YES;
    }
    return _voteNumberLabel;
}

@end
