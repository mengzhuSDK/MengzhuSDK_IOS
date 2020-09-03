//
//  MZGiftCell.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/19.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZGiftCell.h"
#import "NSString+SafePrice.h"

@interface MZGiftCell()

@property (nonatomic, strong) UIImageView *giftImageView;//礼物的图片
@property (nonatomic, strong) UILabel *giftName;//礼物名字
@property (nonatomic, strong) UIButton *giftMoneyButton;//礼物价钱

@end

@implementation MZGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    
        [self makeView];
    }
    return self;
}

- (void)makeView {
    [self.contentView addSubview:self.selectedView];
    
    [self.contentView addSubview:self.giftImageView];
    [self.contentView addSubview:self.giftName];
    [self.contentView addSubview:self.giftMoneyButton];

}

- (void)update:(MZGiftModel *)gift {
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:gift.icon]];
    self.giftName.text = gift.name;
    if ([gift.pay_amount floatValue] > 0) {
        NSLog(@"string =%@ = %@",gift.pay_amount, gift.pay_amount.safePriceString);
        [self.giftMoneyButton setTitle:gift.pay_amount.safePriceString forState:UIControlStateNormal];
    } else {
        [self.giftMoneyButton setTitle:@"免费" forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.selectedView.frame = self.contentView.bounds;
//    self.selectedView.layer.cornerRadius = 10;
    
    CGFloat space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {//横屏
        space = MZ_FULL_RATE;
    }
    
    self.giftImageView.frame = CGRectMake(12*space, 14*space, self.contentView.frame.size.width - 24*space, 46*space);
    self.giftName.frame = CGRectMake(12*space, self.giftImageView.frame.origin.y+self.giftImageView.frame.size.height + 8*space, self.contentView.frame.size.width - 24*space, 20*space);
    self.giftMoneyButton.frame = CGRectMake(12*space, self.giftName.frame.size.height+self.giftName.frame.origin.y, self.contentView.frame.size.width - 24*space, 20*space);
}

#pragma mark - 懒加载
-  (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc] initWithFrame:self.bounds];
        _selectedView.backgroundColor = [UIColor blackColor];
        _selectedView.layer.borderWidth = 1;
        _selectedView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:27/255.0 blue:86/255.0 alpha:1.0].CGColor;
        _selectedView.layer.cornerRadius = 10;
        [_selectedView setHidden:YES];
    }
    return _selectedView;
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _giftImageView.backgroundColor = [UIColor clearColor];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImageView;
}

- (UILabel *)giftName {
    if (!_giftName) {
        _giftName = [[UILabel alloc] initWithFrame:CGRectZero];
        _giftName.textAlignment = NSTextAlignmentCenter;
        _giftName.font = [UIFont systemFontOfSize:15];
        _giftName.backgroundColor = [UIColor clearColor];
        _giftName.textColor = [UIColor whiteColor];
        _giftName.adjustsFontSizeToFitWidth = YES;
    }
    return _giftName;
}

- (UIButton *)giftMoneyButton {
    if (!_giftMoneyButton) {
        _giftMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftMoneyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _giftMoneyButton.titleLabel.font = [UIFont systemFontOfSize:10];
        _giftMoneyButton.backgroundColor = [UIColor clearColor];
    }
    return _giftMoneyButton;
}

@end
