//
//  MZVoteTextCell.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZVoteTextCell.h"

@interface MZVoteTextCell()

@end

@implementation MZVoteTextCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.voteOfMeColor = [UIColor colorWithRed:255/255.0 green:137/255.0 blue:156/255.0 alpha:0.2];
        self.voteOfOtherColor = [UIColor colorWithRed:146/266.0 green:158/255.0 blue:177/255.0 alpha:0.2];
        [self makeView];
    }
    return self;
}

- (void)makeView {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.percentageLabel];
    [self.bgView addSubview:self.selectButton];
    [self.bgView addSubview:self.voteNumberLabel];
    [self.bgView addSubview:self.titleLabel];
}

- (void)updateInfo:(MZVoteOptionModel *)optionModel voteSelectedIds:(NSMutableSet * _Nullable)voteSelectedIds voteInfo:(MZVoteInfoModel *)voteInfoModel {
    self.optionModel = optionModel;
    
    self.titleLabel.text = optionModel.title;
    if (voteInfoModel.is_vote || voteInfoModel.is_expired) {//已投或者过期
        self.selectButton.hidden = YES;
        self.voteNumberLabel.hidden = NO;
        self.percentageLabel.hidden = NO;
        
        self.voteNumberLabel.text = [NSString stringWithFormat:@"%d票",self.optionModel.vote_num];
        self.titleLabel.frame = CGRectMake(10*MZ_RATE, 0, self.bgView.frame.size.width - 104*MZ_RATE, self.bgView.frame.size.height);
        
        self.percentageLabel.frame = CGRectMake(0, 0, self.bgView.frame.size.width * (self.optionModel.percentage / 100.0), self.bgView.frame.size.height);
        if (self.optionModel.is_vote) {
            self.percentageLabel.backgroundColor = self.voteOfMeColor;
        } else {
            self.percentageLabel.backgroundColor = self.voteOfOtherColor;
        }
    } else {//未投
        self.selectButton.hidden = NO;
        self.voteNumberLabel.hidden = YES;
        self.percentageLabel.hidden = YES;
        
        if (voteSelectedIds.count) {
            self.selectButton.selected = [voteSelectedIds containsObject:self.optionModel.id];
        } else {
            self.selectButton.selected = NO;
        }
        self.titleLabel.frame = CGRectMake(10*MZ_RATE, 0, self.bgView.frame.size.width - 10*MZ_RATE - self.bgView.frame.size.height, self.bgView.frame.size.height);
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    }
    return _titleLabel;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(self.bgView.frame.size.width - self.bgView.frame.size.height, 0, self.bgView.frame.size.height, self.bgView.frame.size.height);
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
        _voteNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgView.frame.size.width - 94*MZ_RATE, 0, 84*MZ_RATE, self.bgView.frame.size.height)];
        _voteNumberLabel.backgroundColor = [UIColor clearColor];
        _voteNumberLabel.textColor = [UIColor colorWithRed:255/255.0 green:33/255.0 blue:69/255.0 alpha:1];
        _voteNumberLabel.textAlignment = NSTextAlignmentRight;
        _voteNumberLabel.hidden = YES;
        _voteNumberLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    }
    return _voteNumberLabel;
}

- (UIView *)percentageLabel {
    if (!_percentageLabel) {
        _percentageLabel = [[UIView alloc] initWithFrame:CGRectZero];
        _percentageLabel.backgroundColor = [UIColor clearColor];
        _percentageLabel.hidden = YES;
    }
    return _percentageLabel;
}

@end
