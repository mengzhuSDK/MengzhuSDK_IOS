//
//  MZMultiMenu.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/13.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZMultiMenu.h"

@interface MZMultiMenu()
@property (nonatomic, strong) UIButton *barrageMenu;//弹幕按钮
@property (nonatomic, strong) UIButton *reportMenu;//举报按钮
@end

@implementation MZMultiMenu

- (void)dealloc {
    self.delegate = nil;
    NSLog(@"多菜单界面释放");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self makeView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.barrageMenu.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2.0);
    self.reportMenu.frame = CGRectMake(0, self.frame.size.height/2.0, self.frame.size.width, self.frame.size.height/2.0);
}

- (void)makeView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 0.5;
    [self setHidden:YES];
    
    [self addSubview:self.barrageMenu];
    [self addSubview:self.reportMenu];
}

- (void)menuClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(multiMenuClick:)]) {
        if (sender == self.barrageMenu) {
            self.barrageMenu.selected = !self.barrageMenu.selected;
            if (self.barrageMenu.selected) {
                [self.delegate multiMenuClick:MultiMenuClick_showBarrage];
            } else {
                [self.delegate multiMenuClick:MultiMenuClick_hideBarrage];
            }
        } else if (sender == self.reportMenu) {
            [self.delegate multiMenuClick:MultiMenuClick_report];
        }
    }
}

- (UIButton *)barrageMenu {
    if (!_barrageMenu) {
        _barrageMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        [_barrageMenu setImage:[UIImage imageNamed:@"Rectangle_normal"] forState:UIControlStateNormal];
        [_barrageMenu setImage:[UIImage imageNamed:@"Rectangle_select"] forState:UIControlStateSelected];
        _barrageMenu.selected = YES;
        [_barrageMenu setTitle:@" 弹幕" forState:UIControlStateNormal];
        [_barrageMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _barrageMenu.titleLabel.font = [UIFont systemFontOfSize:12];
        [_barrageMenu addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageMenu;
}

- (UIButton *)reportMenu {
    if (!_reportMenu) {
        _reportMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportMenu setImage:[UIImage imageNamed:@"mz_tousu"] forState:UIControlStateNormal];
        [_reportMenu addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [_reportMenu setTitle:@" 举报" forState:UIControlStateNormal];
        [_reportMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reportMenu.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _reportMenu;
}

@end
