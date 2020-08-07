//
//  MZVoteHeaderView.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZVoteHeaderView.h"

#define questionLabelTextFont 16*MZ_RATE

@interface MZVoteHeaderView()
@property (nonatomic, strong) MZVoteInfoModel *voteInfo;//投票的详细信息
@end

@implementation MZVoteHeaderView

- (instancetype)initWithVoteInfo:(MZVoteInfoModel *)voteInfo {
    self = [super init];
    if (self) {
        self.voteInfo = voteInfo;
        [self makeView];
    }
    return self;
}

- (void)makeView {
    CGFloat contentMaxWidth = UIScreen.mainScreen.bounds.size.width - 32*MZ_RATE;
    if (self.voteInfo.question.length <= 0) self.voteInfo.question = @"投票";
    
    UIFont *curFont = [UIFont systemFontOfSize:questionLabelTextFont];
    CGFloat contentHeight = [self.voteInfo.question boundingRectWithSize:CGSizeMake(contentMaxWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:curFont forKey:NSFontAttributeName] context:nil].size.height + 5.0;
    
    CGFloat allHeight = 20*MZ_RATE + contentHeight + 20*MZ_RATE + 44*MZ_RATE;
    
    self.frame = CGRectMake(0, -allHeight, UIScreen.mainScreen.bounds.size.width - 32*MZ_RATE, allHeight);
    
    [self addSubview:self.voteInfoQuestion];
    self.voteInfoQuestion.text = self.voteInfo.question;
    self.voteInfoQuestion.frame = CGRectMake(0, 20*MZ_RATE, self.frame.size.width, contentHeight);
    
    [self addSubview:self.lineView];
    
    [self addSubview:self.endTimeLabel];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.voteInfo.end_time.intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *nowTime = [formatter stringFromDate:date];
    self.endTimeLabel.text = [NSString stringWithFormat:@"截止时间 : %@",nowTime];
    
    [self addSubview:self.maxSelectLabel];
    if (self.voteInfo.select_type == 1) {//多选
        self.maxSelectLabel.text = [NSString stringWithFormat:@"多选，最多%d项",self.voteInfo.max_select];
    } else {
        self.maxSelectLabel.text = @"单选";
    }
}

#pragma mark - 懒加载
- (UILabel *)voteInfoQuestion {
    if (!_voteInfoQuestion) {
        _voteInfoQuestion = [[UILabel alloc] initWithFrame:CGRectZero];
        _voteInfoQuestion.backgroundColor = [UIColor clearColor];
        _voteInfoQuestion.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _voteInfoQuestion.font = [UIFont systemFontOfSize:questionLabelTextFont];
        _voteInfoQuestion.numberOfLines = 0;
    }
    return _voteInfoQuestion;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44*MZ_RATE, self.frame.size.width, 1)];
        _lineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    }
    return _lineView;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 35*MZ_RATE, self.frame.size.width/2.0, 35*MZ_RATE)];
        _endTimeLabel.backgroundColor = [UIColor clearColor];
        _endTimeLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
        _endTimeLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
    }
    return _endTimeLabel;
}

- (UILabel *)maxSelectLabel {
    if (!_maxSelectLabel) {
        _maxSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.endTimeLabel.frame.origin.x+self.endTimeLabel.frame.size.width, self.endTimeLabel.frame.origin.y, self.frame.size.width - self.endTimeLabel.frame.size.width - self.endTimeLabel.frame.origin.x, self.endTimeLabel.frame.size.height)];
        _maxSelectLabel.backgroundColor = [UIColor clearColor];
        _maxSelectLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
        _maxSelectLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
        _maxSelectLabel.textAlignment = NSTextAlignmentRight;
    }
    return _maxSelectLabel;
}

@end
