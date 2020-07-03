//
//  MZActivityMenu.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/14.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZActivityMenu.h"

/**
 * 活动菜单按钮
 */

@interface MZActivityMenuButton : UIButton
@property (nonatomic, strong) UIView *tip;//指示短横条
@property (nonatomic, assign) NSInteger type;//索引

@property (nonatomic, strong) UIView *menuView;//菜单对应的view
@end

@implementation MZActivityMenuButton

- (void)setType:(NSInteger)type {
    _type = type;
    if (!self.tip) {
        self.tip = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0 - 16/2.0, self.frame.size.height - 2, 16, 2)];
        self.tip.backgroundColor = [UIColor colorWithRed:255/255.0 green:33/255.0 blue:69/255.0 alpha:1];
        [self addSubview:self.tip];
        [self.tip setHidden:YES];
    } else {
        self.tip.frame = CGRectMake(self.frame.size.width/2.0 - 16/2.0, self.frame.size.height - 2, 16, 2);
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.tip setHidden:!selected];
    
    if (selected) {
        self.titleLabel.font = [UIFont systemFontOfSize:16*MZ_RATE];
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    }
}


@end

@interface MZActivityMenu()

@property (nonatomic, assign) NSInteger index;//内部索引，只用于内部索引，从-1开始
@property (nonatomic, strong) NSMutableArray <NSString *> *menus;//菜单字符串数组
@property (nonatomic, strong) NSMutableArray <MZActivityMenuButton *> *menuButtons;//菜单数据源

@property (nonatomic, strong) UIColor *selectColor;//选中颜色
@property (nonatomic, strong) UIColor *normalColor;//默认颜色

@property (nonatomic, strong) MZActivityMenuButton *activityMenuButton;//互动按钮索引

@end

@implementation MZActivityMenu

- (void)dealloc {
    NSLog(@"活动菜单释放");
    self.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.index = -1;
        [self makeView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.index = -1;
        [self makeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)makeView {
    self.activityMenuButton = [MZActivityMenuButton buttonWithType:UIButtonTypeCustom];
    [self.activityMenuButton setTitle:@"互动" forState:UIControlStateNormal];
    self.activityMenuButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self.activityMenuButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    [self.activityMenuButton setTitleColor:self.selectColor forState:UIControlStateSelected];
    [self.activityMenuButton setTitleColor:self.selectColor forState:UIControlStateHighlighted];
    
    [self.activityMenuButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.activityMenuButton.type = 0;
    self.activityMenuButton.selected = YES;
    
    [self addSubview:self.activityMenuButton];
}

/**
* @brief 添加菜单和菜单对应的view
*
* @param menu 菜单的名字
* @param menuView 菜单对应的view
*
*/
- (void)addMenu:(NSString *)menu menuView:(UIView *)menuView {
    if (menu.length <= 0 || !menuView) {
        return;
    }
    
    [self.menus addObject:menu];
    
    MZActivityMenuButton *button = [MZActivityMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:menu forState:UIControlStateNormal];
    
    [button setTitleColor:self.normalColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectColor forState:UIControlStateSelected];
    [button setTitleColor:self.selectColor forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.menuView = menuView;
    menuView.alpha = 0;
    
    [self addSubview:button];
    [self.menuButtons addObject:button];
    
    [self updateMenusFrame];
}

/// 更新标题的整体位置
- (void)updateMenusFrame {
    NSInteger count = self.menuButtons.count + 1;
    CGFloat itemWidth = UIScreen.mainScreen.bounds.size.width / count;
    
    self.activityMenuButton.frame = CGRectMake(0, 0, itemWidth, self.frame.size.height);
    self.activityMenuButton.type = 0;
    
    for (NSInteger i = 0; i < self.menuButtons.count; i++) {
        MZActivityMenuButton *button = self.menuButtons[i];
        button.frame = CGRectMake(((i + 1) % count) * itemWidth, 0, itemWidth, self.frame.size.height);
        button.type = i + 1;
    }
}

- (void)buttonClick:(MZActivityMenuButton *)button {
    switch (button.type) {
        case 0: {
            self.index = -1;
            self.activityMenuButton.selected = YES;
            [self.menuButtons enumerateObjectsUsingBlock:^(MZActivityMenuButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.selected = NO;
            }];
            [self.menuButtons enumerateObjectsUsingBlock:^(MZActivityMenuButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.menuView.alpha = 0;
            }];
            NSLog(@"点击了互动菜单");
            break;
        }
        case 1: {
            self.index = 0;
            self.activityMenuButton.selected = NO;
            [self recoveryMenuView];
            NSLog(@"点击了第二个菜单");
            break;
        }
        case 2: {
            self.index = 1;
            self.activityMenuButton.selected = NO;
            [self recoveryMenuView];
            NSLog(@"点击了第三个菜单");
            break;
        }
        case 3: {
            self.index = 2;
            self.activityMenuButton.selected = NO;
            [self recoveryMenuView];
            NSLog(@"点击了第四个菜单");
            break;
        }
        case 4: {
            self.index = 3;
            self.activityMenuButton.selected = NO;
            [self recoveryMenuView];
            NSLog(@"点击了第五个菜单");
            break;
        }
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityMenuClickWithIndex:)]) {
        [self.delegate activityMenuClickWithIndex:button.type];
    }
}

/// 恢复隐藏前的view
- (void)recoveryMenuView {
    self.alpha = 1;
    [self.menuButtons enumerateObjectsUsingBlock:^(MZActivityMenuButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.index) {
            obj.selected = YES;
            obj.menuView.alpha = 1;
        } else {
            obj.selected = NO;
            obj.menuView.alpha = 0;
        }
    }];
}

/// 隐藏所有索引的view
- (void)hideAllMenu {
    self.alpha = 0;
    [self.menuButtons enumerateObjectsUsingBlock:^(MZActivityMenuButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        obj.menuView.alpha = 0;
    }];
}

#pragma mark - 懒加载
- (NSMutableArray<MZActivityMenuButton *> *)menuButtons {
    if (!_menuButtons) {
        _menuButtons = @[].mutableCopy;
    }
    return _menuButtons;
}

- (NSMutableArray<NSString *> *)menus {
    if (!_menus) {
        _menus = @[].mutableCopy;
    }
    return _menus;
}

- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    }
    return _normalColor;
}

- (UIColor *)selectColor {
    if (!_selectColor) {
        _selectColor = [UIColor colorWithRed:255/255.0 green:33/255.0 blue:69/255.0 alpha:1];
    }
    return _selectColor;
}

@end
