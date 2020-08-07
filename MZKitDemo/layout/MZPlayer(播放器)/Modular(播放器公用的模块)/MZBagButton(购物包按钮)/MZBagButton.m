//
//  MZBagButton.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/13.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZBagButton.h"

@interface MZBagButton()
@property (nonatomic, strong) UILabel *numberLabel;
@end

@implementation MZBagButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat relativeSafeRate = UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height ? MZ_FULL_RATE : MZ_RATE;
    self.numberLabel.frame = CGRectMake(0, 21*relativeSafeRate, self.frame.size.width, 17*relativeSafeRate);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self makeView];
    }
    return self;
}

- (void)makeView {
    [self setImage:ImageName(@"bottomButton_shoppingBag") forState:UIControlStateNormal];
    [self addSubview:self.numberLabel];
}


- (void)updateNumber:(int)number {
    self.numberLabel.text = [NSString stringWithFormat:@"%d",number];
    self.numberLabel.hidden = !number;
}

- (int)getNumber {
    return [self.numberLabel.text intValue];
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = [UIFont systemFontOfSize:12];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
    }
    return _numberLabel;
}

@end
