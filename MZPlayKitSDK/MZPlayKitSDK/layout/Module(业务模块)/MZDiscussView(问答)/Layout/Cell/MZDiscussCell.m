//
//  MZDiscussCell.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZDiscussCell.h"

static __inline__ __attribute__((always_inline)) NSAttributedString* MZDiscussAttributedString(__unsafe_unretained NSString *content, CGFloat fontSize, UIColor *textColor) {
    NSAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: fontSize],NSForegroundColorAttributeName:textColor}];
    return string;
}
@implementation MZDiscussCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.replyLabel];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16*MZ_RATE);
            make.right.equalTo(self.contentView).offset(-(16*MZ_RATE));
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-1);
        }];
        
        [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(10*MZ_RATE);
            make.right.equalTo(self.bgView).offset(-(10*MZ_RATE));
            make.top.equalTo(self.contentView).offset(6*MZ_RATE);
            make.bottom.equalTo(self.contentView).offset(-(6*MZ_RATE));
        }];
    }
    return self;
}

- (void)update:(MZDiscussReplyModel *)reply {
    
    NSString *nickname = [NSString stringWithFormat:@"%@ : ",reply.nickname];
    NSMutableAttributedString *nicknameAttr = [[NSMutableAttributedString alloc] initWithAttributedString:MZDiscussAttributedString(nickname, 12*MZ_RATE, [UIColor colorWithRed:223/255.0 green:20/255.0 blue:53/255.0 alpha:1])];

    NSAttributedString *contentAttr = MZDiscussAttributedString(reply.content, 12*MZ_RATE, [[UIColor whiteColor] colorWithAlphaComponent:0.8]);

    [nicknameAttr appendAttributedString:contentAttr];

    self.replyLabel.attributedText = nicknameAttr;
//    self.replyLabel.text = [NSString stringWithFormat:@"%@%@",nickname,reply.content];
}

/// 获取cell的高，内部默认缓存
+ (CGFloat)getRowHeight:(MZDiscussReplyModel *)reply {
    if (reply.rowHeight > 0) {
        return reply.rowHeight + 12*MZ_RATE;
    }
    
    NSString *nickname = [NSString stringWithFormat:@"%@ : ",reply.nickname];
    NSMutableAttributedString *nicknameAttr = [[NSMutableAttributedString alloc] initWithAttributedString:MZDiscussAttributedString(nickname, 12*MZ_RATE, [UIColor colorWithRed:223/255.0 green:20/255.0 blue:53/255.0 alpha:1])];

    NSAttributedString *contentAttr = MZDiscussAttributedString(reply.content, 12*MZ_RATE, [[UIColor whiteColor] colorWithAlphaComponent:0.8]);

    [nicknameAttr appendAttributedString:contentAttr];
    
    CGFloat contentHeight = [nicknameAttr boundingRectWithSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width - 52*MZ_RATE, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height + 5;
    
    reply.rowHeight = contentHeight;
    return reply.rowHeight + 12*MZ_RATE;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithRed:26/266.0 green:1/255.0 blue:25/255.0 alpha:1];
    }
    return _bgView;
}

- (UILabel *)replyLabel {
    if (!_replyLabel) {
        _replyLabel = [UILabel new];
        _replyLabel.backgroundColor = [UIColor clearColor];
        _replyLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
        _replyLabel.numberOfLines = 0;
        _replyLabel.textColor = [UIColor whiteColor];
    }
    return _replyLabel;
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
