//
//  MZRedRecodeTableViewCell.m
//  MengZhu
//
//  Created by vhall.com on 16/11/23.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZRedRecodeTableViewCell.h"

@interface MZRedRecodeTableViewCell (){
    UIImageView *_headImageview;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_moneyLabel;
    UIImageView *_maxImageView;
}
@property (nonatomic ,strong) UILabel *bestLabel;
@property (nonatomic ,strong) UIView *lineView;
@end

@implementation MZRedRecodeTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}


-(NSString *)ConvertStrToTime:(NSString *)timeStr

{
    NSString *timeString;
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"dd"];
    NSString *nowDay = [formatter1 stringFromDate:[NSDate date]];
    NSString *timeDay = [formatter1 stringFromDate:d];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"HH:mm"];
    if(nowDay.integerValue >timeDay.integerValue){
        timeString = [NSString stringWithFormat:@"昨天%@",[formatter2 stringFromDate:d]];
    }
    else
        timeString = [NSString stringWithFormat:@"%@",[formatter2 stringFromDate:d]];
    return timeString;
    
}

-(void)setListModel:(MZRedBagReceiverListModel *)listModel
{
    if(listModel){
        _listModel = listModel;
        [_headImageview sd_setImageWithURL:[NSURL URLWithString:_listModel.avatar] placeholderImage:MZ_UserIcon_DefaultImage];
        _nameLabel.text = _listModel.nickname;
        [_nameLabel sizeToFit];

        _maxImageView.hidden = !_listModel.isTop.integerValue;
        _bestLabel.hidden = !_listModel.isTop.integerValue;
        _timeLabel.text = [self ConvertStrToTime:_listModel.actionTime];
        
        _moneyLabel.text =[NSString stringWithFormat:@"%@",_listModel.amount];
    }
    [self customLayoutSubviews];
}

-(void)setupUI
{
    _headImageview = [[UIImageView alloc]init];
    [_headImageview roundChangeWithRadius:4 *MZ_RATE];
    [self.contentView addSubview:_headImageview];
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.font = [UIFont systemFontOfSize:20*MZ_RATE];
    _moneyLabel.textColor = MakeColor(43, 43, 43, 1);
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_moneyLabel];
    
    _nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    _nameLabel.textColor = MakeColor(43, 43, 43, 1);
    _nameLabel.numberOfLines = 1;

    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImageview.right + 12*MZ_RATE, _headImageview.bottom-16, 200*MZ_RATE, 16*MZ_RATE)];
    _timeLabel.font = [UIFont systemFontOfSize:10*MZ_RATE];
    _timeLabel.textColor = MakeColor(122, 122, 122, 1);
    [self.contentView addSubview:_timeLabel];
    
    _maxImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mz_luck_top"]];
    [self.contentView addSubview:_maxImageView];
    _maxImageView.hidden = YES;
    
    _bestLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_bestLabel];
    _bestLabel.text = @"手气最佳";
    _bestLabel.textColor = MakeColorRGB(0xFFB103);
    _bestLabel.font = [UIFont systemFontOfSize:10 *MZ_RATE];
    _bestLabel.hidden = YES;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(66*MZ_RATE, 64*MZ_RATE-1, 309*MZ_RATE, 1)];
    self.lineView = lineView;
    lineView.backgroundColor = MakeColor(239, 239, 244, 1);
    [self.contentView addSubview:lineView];

}
- (void)customLayoutSubviews{
    [_headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
        make.height.width.mas_equalTo(40 * MZ_RATE);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageview.mas_right).offset(10*MZ_RATE);
        make.top.equalTo(_headImageview);
        make.width.mas_lessThanOrEqualTo(225 * MZ_RATE);
        make.height.mas_equalTo(18 *MZ_RATE);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(4 *MZ_RATE);
        make.height.mas_equalTo(18 *MZ_RATE);
    }];
    [_maxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_right).offset(10*MZ_RATE);
        make.centerY.equalTo(_timeLabel);
        make.width.mas_equalTo(14*MZ_RATE);
        make.height.mas_equalTo(12 *MZ_RATE);
    }];
    [_bestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_maxImageView);
        make.left.equalTo(_maxImageView.mas_right).offset(4 *MZ_RATE);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-16);
    }];
}
- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    if (isLast) {
        self.lineView.frame = CGRectMake(0, 64*MZ_RATE-1, MZ_SW, 1);
    }else{
        self.lineView.frame = CGRectMake(66*MZ_RATE, 64*MZ_RATE-1, 309*MZ_RATE, 1);
    }
}
@end
