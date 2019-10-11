//
//  MZAudienceTableViewCell.m
//  MZKitDemo
//
//  Created by Cage  on 2019/9/28.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZAudienceTableViewCell.h"
@interface MZAudienceTableViewCell()
@property (nonatomic ,strong) UIImageView *avatarView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *fansLabel;
@end

@implementation MZAudienceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBaseProperty];
        [self customAddSubviews];
    }
    return self;
}
- (void)setBaseProperty{
    self.backgroundColor = MakeColorRGBA(0x1D1B22, 0.9);
}
- (void)customAddSubviews{
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(20*MZ_RATE, 10*MZ_RATE, 36*MZ_RATE, 36*MZ_RATE)];
    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(67*MZ_RATE, 18*MZ_RATE, 42*MZ_RATE, 20*MZ_RATE)];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:14 *MZ_RATE];
    self.nameLabel.textColor = MakeColorRGB(0xFFFFFF);
    
    self.fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(305*MZ_RATE, 20*MZ_RATE, 50*MZ_RATE, 17*MZ_RATE)];
    [self.contentView addSubview:self.fansLabel];
    self.fansLabel.font = [UIFont systemFontOfSize:12 *MZ_RATE];
    self.fansLabel.textColor = MakeColorRGB(0x8E8C99);
    self.fansLabel.textAlignment = NSTextAlignmentRight;
}
- (void)setModel:(MZAudienceCellModel *)model{
    
}
@end
