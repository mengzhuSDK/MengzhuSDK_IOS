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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupUI {
    CGFloat relastiveRate = MZ_RATE;
    
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        relastiveRate = MZ_FULL_RATE;
    }
    
    self.coverView = [[UIImageView alloc]initWithFrame:CGRectMake(12*relastiveRate, 12*relastiveRate, 76*relastiveRate, 76*relastiveRate)];
    self.coverView.image = MZ_FocusDefaultImage;
    [self.contentView addSubview:self.coverView];
    
    self.signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22*relastiveRate, 16*relastiveRate)];
    self.signImageView.image = ImageName(@"live_tagNumber");
    [self.coverView addSubview:self.signImageView];
    
    self.numLabel = [[UILabel alloc]initWithFrame:self.signImageView.bounds];
    self.numLabel.font = FontSystemSize(10*relastiveRate);
    self.numLabel.textColor = MakeColorRGB(0xffffff);
    [self.signImageView addSubview:self.numLabel];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel = [[MZTopLeftLabel alloc]initWithFrame:CGRectMake(self.coverView.right + 12*relastiveRate, self.coverView.top, UIScreen.mainScreen.bounds.size.width - self.coverView.right - 12*relastiveRate - 10*relastiveRate, 40*relastiveRate)];
    self.titleLabel.font = FontSystemSize(14*relastiveRate);
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = MakeColorRGB(0x333333);
    [self.contentView addSubview:self.titleLabel];
    
    UILabel *moneyL = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.left, self.coverView.bottom - 20*relastiveRate, 14*relastiveRate, 16*relastiveRate)];
    moneyL.font = [UIFont boldSystemFontOfSize:12*relastiveRate];
    moneyL.text = @"￥";
    moneyL.textColor = MakeColorRGB(0xff4141);
    [self.contentView addSubview:moneyL];
    
    self.salePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyL.right, self.coverView.bottom  - 25*relastiveRate, self.titleLabel.width, 25*relastiveRate)];
    self.salePriceLabel.font = [UIFont boldSystemFontOfSize:18*relastiveRate];
    self.salePriceLabel.textColor = MakeColorRGB(0xff4141);
    [self.contentView addSubview:self.salePriceLabel];
    
    CGFloat offsetLeftSpace = 0;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {//如果有刘海屏
            if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {//如果是横屏
                offsetLeftSpace = 44;
            }
        }
    }
    
    self.buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width -64*relastiveRate - 12*relastiveRate - offsetLeftSpace, self.titleLabel.bottom + 12*relastiveRate, 64*relastiveRate, 24*relastiveRate)];
    [self.buyBtn setTitle:@"去购买" forState:UIControlStateNormal];
    [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    self.buyBtn.titleLabel.font = FontSystemSize(12*relastiveRate);
    [self.contentView addSubview:self.buyBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.titleLabel.left, 100*relastiveRate - 1, self.titleLabel.width, 1)];
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

-(void)setIndex:(int)index
{
    _index = index;
    self.numLabel.text = [NSString stringWithFormat:@"%d",index];;
}


@end
