//
//  MZGoodsListTabCell.m
//  MZKitDemo
//
//  Created by LiWei on 2019/9/27.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZGoodsListTabCell.h"
#import "MZTopLeftLabel.h"

@interface MZGoodsListTabCell ()
@property (nonatomic ,strong)UIImageView *coverView;
@property (nonatomic ,strong)UIImageView *signImageView;
@property (nonatomic ,strong)UILabel *numLabel;
@property (nonatomic ,strong)MZTopLeftLabel *titleLabel;
@property (nonatomic ,strong)UILabel *salePriceLabel;
@property (nonatomic ,strong)UIButton *buyBtn;

@end
@implementation MZGoodsListTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setupUI
{
    self.coverView = [[UIImageView alloc]initWithFrame:CGRectMake(12*MZ_RATE, 12*MZ_RATE, 76*MZ_RATE, 76*MZ_RATE)];
    self.coverView.image = MZ_FocusDefaultImage;
    [self.contentView addSubview:self.coverView];
    
    self.signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22*MZ_RATE, 16*MZ_RATE)];
    self.signImageView.image = ImageName(@"live_tagNumber");
    [self.contentView addSubview:self.signImageView];
    
    self.numLabel = [[UILabel alloc]initWithFrame:self.signImageView.bounds];
    self.numLabel.font = FontSystemSize(10*MZ_RATE);
    self.numLabel.textColor = MakeColorRGB(0xffffff);
    self.numLabel.text = @"12";
    [self.signImageView addSubview:self.numLabel];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel = [[MZTopLeftLabel alloc]initWithFrame:CGRectMake(self.coverView.right + 12*MZ_RATE, self.coverView.top, 263*MZ_RATE, 40*MZ_RATE)];
    self.titleLabel.font = FontSystemSize(14*MZ_RATE);
    self.titleLabel.text = @"我就是个商品我就是个商品我就是个商品我就是个商品我就是个商品我就是个商品我就是个商品";
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = MakeColorRGB(0x333333);
    [self.contentView addSubview:self.titleLabel];
    
    self.salePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 13*MZ_RATE, self.titleLabel.width, 25*MZ_RATE)];
    self.salePriceLabel.font = FontSystemSize(12*MZ_RATE);
    self.salePriceLabel.textColor = MakeColorRGB(0xff4141);
    self.salePriceLabel.text = @"￥929929.00";
    [self.contentView addSubview:self.salePriceLabel];
    
    self.buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(MZ_SW -64*MZ_RATE - 12*MZ_RATE , self.titleLabel.bottom + 12*MZ_RATE, 64*MZ_RATE, 24*MZ_RATE)];
    [self.buyBtn setTitle:@"去购买" forState:UIControlStateNormal];
    [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    self.buyBtn.titleLabel.font = FontSystemSize(12*MZ_RATE);
    [self.contentView addSubview:self.buyBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.titleLabel.left, self.salePriceLabel.bottom + 10*MZ_RATE, self.titleLabel.width, 1)];
    lineView.backgroundColor = MakeColorRGB(0xdddddd);
    [self.contentView addSubview:lineView];
    
}


-(void)setModel:(MZGoodsListModel *)model
{
    _model = model;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:MZ_GoodsPlaceHolder];
    self.titleLabel.text = model.name;
    self.salePriceLabel.text = model.price;
}


@end
