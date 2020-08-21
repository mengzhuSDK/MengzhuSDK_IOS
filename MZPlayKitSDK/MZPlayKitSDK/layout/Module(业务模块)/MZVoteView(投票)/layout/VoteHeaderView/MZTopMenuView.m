//
//  MZTopMenuView.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZTopMenuView.h"

@implementation MZTopMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

- (void)makeView {
    [self addSubview:self.menuLabel];
    [self addSubview:self.closeButton];
}

/// 关闭按钮点击
- (void)closeButtonClick {
    if (self.closeHandler) {
        self.closeHandler();
    }
}

- (UILabel *)menuLabel {
    if (!_menuLabel) {
        _menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 60*MZ_RATE, 44*MZ_RATE)];
        _menuLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _menuLabel.font = [UIFont boldSystemFontOfSize:16*MZ_RATE];
        _menuLabel.backgroundColor = [UIColor clearColor];
        _menuLabel.text = @"投票";
    }
    return _menuLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.frame.size.width - 60*MZ_RATE, 0, 60*MZ_RATE, 44*MZ_RATE);
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"mzClose_0710_black"] forState:UIControlStateNormal];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(2*MZ_RATE, 20*MZ_RATE, 2*MZ_RATE, 0)];
    }
    return _closeButton;
}


@end
