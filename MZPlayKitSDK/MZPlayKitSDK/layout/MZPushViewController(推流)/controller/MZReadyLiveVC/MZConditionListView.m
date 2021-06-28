//
//  MZConditionListView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/10/19.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZConditionListView.h"

#import "MZCreateWhiteViewController.h"
#import "MZCreateFCodeViewController.h"
#import "MZEditWhiteUserViewController.h"
#import "MZFCodeInfoViewController.h"

/**
 * @brief 选择选项的label
 */
@interface MZConditionLabel()
@property (nonatomic, strong) UILabel *showLabel;
@end

@implementation MZConditionLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

- (void)makeView {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
    [self addGestureRecognizer:tap];
        
    CGFloat item = 18*MZ_RATE;
    
    UIImageView *selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mz_condition_select"]];
    selectImageView.frame = CGRectMake(self.frame.size.width - 16 - item, (self.frame.size.height - item)/2.0, item, item);
    selectImageView.contentMode = UIViewContentModeScaleAspectFit;
    selectImageView.tag = 153;
    selectImageView.hidden = YES;
    [self addSubview:selectImageView];
    
    self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - item - 16, self.frame.size.height)];
    self.showLabel.textColor = [UIColor whiteColor];
    self.showLabel.font = [UIFont systemFontOfSize:14];
    self.showLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.showLabel];
}

- (void)select:(UITapGestureRecognizer *)tap {
    self.isSelect = !self.isSelect;
    if (_delegate && [_delegate respondsToSelector:@selector(selectOrUnSelect:)]) {
        [_delegate selectOrUnSelect:self];
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    UIImageView *iv = [self viewWithTag:153];
    if (iv) {
        iv.hidden = !_isSelect;
    }
}

- (void)setTextColor:(UIColor *)textColor  {
    self.showLabel.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    self.showLabel.font = font;
}

-  (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.showLabel.backgroundColor = backgroundColor;
}

- (void)setText:(NSString *)text {
    self.showLabel.text = text;
}

@end

/**
 * @brief 添加点击block回调的button
 */
typedef void (^MZReadyButtonTapBlock)(UIButton *sender);

@interface MZReadyButton : UIButton
@property (nonatomic, copy) MZReadyButtonTapBlock tapBlock;
- (void)addTapBlock:(MZReadyButtonTapBlock)block;
@end

@implementation MZReadyButton
- (void)addTapBlock:(MZReadyButtonTapBlock)tapBlock {
    _tapBlock = tapBlock;
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonAction:(UIButton *)button {
    if (_tapBlock) {
        _tapBlock(button);
    }
}
@end

/**
 * @brief 配置选择列表的Cell
 */
@interface MZConditionCell : UITableViewCell
@property (nonatomic, strong) MZConditionLabel *conditionLabel;
@end

@implementation MZConditionCell

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.conditionLabel = [[MZConditionLabel alloc] initWithFrame:CGRectMake(16, 0, UIScreen.mainScreen.bounds.size.width - 16, 54)];
        self.conditionLabel.userInteractionEnabled = NO;
        self.conditionLabel.text = @"";
        self.conditionLabel.textColor = [UIColor blackColor];
        self.conditionLabel.font = [UIFont systemFontOfSize:14];
        self.conditionLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.conditionLabel];
        self.conditionLabel.isSelect = NO;
    }
    return self;
}

- (void)update:(NSDictionary *)info {
    NSString *name = [NSString stringWithFormat:@"%@",info[@"name"]];
    self.conditionLabel.text = name;
}
@end

/**
 * 白名单配置选择的cell
 */

@interface MZConditionWhiteCell : UITableViewCell
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UILabel *tLabel;
@end

@implementation MZConditionWhiteCell

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.isSelected = NO;
        
        self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectedButton.userInteractionEnabled = NO;
        self.selectedButton.selected = NO;
        [self.selectedButton setImage:[UIImage imageNamed:@"sssss_sele_no"] forState:UIControlStateNormal];
        [self.selectedButton setImage:[UIImage imageNamed:@"sssss_sele_yes"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectedButton];
        [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(17);
            make.left.equalTo(self.contentView).offset(30);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
        
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.menuButton setTitle:@"···" forState:UIControlStateNormal];
        [self.menuButton setTitleColor:MakeColor(255, 31, 96, 0.8) forState:UIControlStateNormal];
        [self.menuButton.titleLabel setFont:[UIFont boldSystemFontOfSize:27]];
        [self.contentView addSubview:self.menuButton];
        [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-28);
            make.width.equalTo(@(30));
        }];
        
        self.tLabel = [[UILabel alloc] init];
        self.tLabel.backgroundColor = [UIColor clearColor];
        self.tLabel.textColor = MakeColor(43, 43, 43, 1);
        self.tLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.tLabel];
        [self.tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.selectedButton.mas_right).offset(10);
            make.right.equalTo(self.menuButton.mas_left);
        }];

    }
    return self;
}

- (void)update:(NSDictionary *)info {
    NSString *name = [NSString stringWithFormat:@"%@",info[@"name"]];
    self.tLabel.text = name;
}

@end

/**
 * 展示的列表View
 */
typedef void(^SelectResultBlock)(BOOL isCancelled, MZReadyConditionListType conditionType, int sId, NSString *sString);
@interface MZConditionListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) MZReadyConditionListType type;//当前展示的list的type
@property (nonatomic,   copy) SelectResultBlock result;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *createView;
@property (nonatomic, strong) UIButton *aNewButton;
@property (nonatomic, assign) int selectId;//当前选中的id
@property (nonatomic,   copy) NSString *selectString;//当前选中的字符串

@property (nonatomic, assign) NSDictionary *selectInfo;//编辑的某个白名单
@property (nonatomic, strong) UIView *menuView;//编辑的某个白名单的菜单
@end

@implementation MZConditionListView

/// 展示列表
- (void)showList:(SelectResultBlock)result type:(MZReadyConditionListType)type{
    self.type = type;
    self.result = result;
    self.selectString = @"";
    self.selectId = -1;
    
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(kRATE(44.0)));
    }];

    UIButton *cancel = [self createButton:@"取消"];
    UIButton *sure = [self createButton:@"确定"];
    [self.headerView addSubview:cancel];
    [self.headerView addSubview:sure];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.headerView);
        make.width.equalTo(@64);
    }];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.headerView);
        make.width.equalTo(@64);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    [self.headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.headerView);
        make.height.equalTo(@0.5);
    }];

    if (self.type == MZReadyConditionListType_White || self.type == MZReadyConditionListType_FCode) {
        [self addSubview:self.createView];
        [self.createView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@(80));
            
            CGFloat bottom = 0;
            if (@available(iOS 11.0, *)) {
                if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                    bottom = 34.0;
                }
            }
            make.bottom.equalTo(self).offset(-bottom);
        }];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.headerView.mas_bottom);
            make.bottom.equalTo(self.createView.mas_top);
        }];
        
        [_aNewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.createView).offset(46);
            make.right.equalTo(self.createView).offset(-46);
            make.top.equalTo(self.createView).offset(20);
            make.bottom.equalTo(self.createView).offset(-20);
        }];
    } else {
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.headerView.mas_bottom);
            CGFloat bottom = 0;
            if (@available(iOS 11.0, *)) {
                if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                    bottom = 34.0;
                }
            }
            make.bottom.equalTo(self).offset(-bottom);
        }];
    }
    
    if (self.type == MZReadyConditionListType_White) {
        [self.tableView.superview addSubview:self.menuView];
    }
    
    switch (self.type) {
        case MZReadyConditionListType_Categroy:
            [self showCategoryList];
            break;
        case MZReadyConditionListType_FCode:
            [self showFCodeList];
            break;
        case MZReadyConditionListType_White:
            [self showWhiteList];
            break;
        default:
            break;
    }
}

/// 展示分类列表
- (void)showCategoryList {
    [MZSDKBusinessManager getCategoryListSuccess:^(id response) {
        self.dataArray = [NSMutableArray arrayWithArray:response];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:error.domain];
        });
    }];
}

/// 展示F码列表
- (void)showFCodeList {
    [MZSDKBusinessManager getFCodeListSuccess:^(id response) {
        self.dataArray = [NSMutableArray arrayWithArray:response];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:error.domain];
        });
    }];
}

/// 展示白名单列表
- (void)showWhiteList {
    [MZSDKBusinessManager getWhiteListSuccess:^(id response) {
        self.dataArray = [NSMutableArray arrayWithArray:response[@"list"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:error.domain];
        });
    }];
}

/// 按钮事件点击
- (void)buttonClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        if (self.result) self.result(YES, self.type, 0, @"");
    } else if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if (self.dataArray.count <= 0) {
            if (self.result) self.result(YES, self.type, 0, @"");
            return;
        }
        if (self.selectId <= 0) {
            [self show:@"您还未进行选择"];
            return;
        }
        if (self.result) self.result(NO, self.type, self.selectId, self.selectString);
    }
}

/// 点击创建按钮
- (void)toCreateNew:(UIButton *)sender {
    WeaklySelf(weakSelf);
    switch (self.type) {
        case MZReadyConditionListType_FCode: {
            [self animationAlplaOff];
            MZCreateFCodeViewController *createFCodeVC = [[MZCreateFCodeViewController alloc] initWithIsCreated:^(BOOL isCreated) {
                [weakSelf animationAlplaOn];
                if (isCreated) {
                    [weakSelf showFCodeList];
                }
            }];
            [[self getCurrentVC].navigationController pushViewController:createFCodeVC animated:YES];
            break;
        }
        case MZReadyConditionListType_White: {
            if (self.menuView.isHidden == NO) {
                self.menuView.hidden = YES;
            }
            [self animationAlplaOff];
            MZCreateWhiteViewController *createWhiteVC = [[MZCreateWhiteViewController alloc] initWithIsCreated:^(BOOL isCreated) {
                [weakSelf animationAlplaOn];
                if (isCreated) {
                    [weakSelf showWhiteList];
                }
            }];
            [[self getCurrentVC].navigationController pushViewController:createWhiteVC animated:YES];
            break;
        }
        default:
            break;
    }
}

/// 点击白名单的cell上的菜单按钮
- (void)menuButtonClick:(UIButton *)sender {
    if (self.type != MZReadyConditionListType_White) return;
    NSDictionary *info = self.dataArray[sender.tag];
    self.selectInfo = info;
    
    CGRect rect = [sender convertRect:sender.bounds toView:self.tableView.superview];
    
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            bottom = 34.0;
        }
    }
    
    CGFloat y = rect.origin.y + 50;
    if (y + self.menuView.frame.size.height >= (self.tableView.superview.frame.size.height - bottom - 80)) {
        y = rect.origin.y - 70;
    }
    
    self.menuView.frame = CGRectMake(self.frame.size.width - 153, y, self.menuView.frame.size.width, self.menuView.frame.size.height);
    self.menuView.hidden = NO;
}

/// 点击白名单的编辑菜单
- (void)editMenuClick:(UIButton *)sender {
    self.menuView.hidden = YES;
    
    if (sender.tag == 1) {
        [self animationAlplaOff];
        WeaklySelf(weakSelf);
        MZEditWhiteUserViewController *editWhiteUserVC = [[MZEditWhiteUserViewController alloc] initWithInfo:self.selectInfo result:^{
            [weakSelf animationAlplaOn];
        }];
        [[self getCurrentVC].navigationController pushViewController:editWhiteUserVC animated:YES];
    } else if (sender.tag == 2) {
        [MZSDKBusinessManager deleteWhiteWithWhiteId:[NSString stringWithFormat:@"%@",self.selectInfo[@"id"]] success:^(id response) {
            int sId = [self.selectInfo[@"id"] intValue];
            if (sId == self.selectId) {
                self.selectId = -1;
                self.selectString = @"";
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mz_delete_white" object:@(sId)];
            [self showWhiteList];
            
        } failure:^(NSError *error) {
            [self show:error.domain];
        }];
    }
}

- (void)animationAlplaOff {
    [UIView animateWithDuration:0.33 animations:^{
        self.superview.alpha = 0;
    }];
}

- (void)animationAlplaOn {
    [UIView animateWithDuration:0.33 animations:^{
        self.superview.alpha = 1;
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.dataArray[indexPath.row];
    int sId = [[NSString stringWithFormat:@"%@",info[@"id"]] intValue];
    if (self.type == MZReadyConditionListType_White) {
        MZConditionWhiteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZConditionWhiteCell"];
        [cell update:info];
        if (self.selectId == sId) {
            cell.isSelected = YES;
            cell.selectedButton.selected = YES;
        } else {
            cell.isSelected = NO;
            cell.selectedButton.selected = NO;
        }
        cell.menuButton.tag = indexPath.row;
        [cell.menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        MZConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZConditionCell"];
        [cell update:info];
        if (self.selectId == sId) {
            cell.conditionLabel.isSelect = YES;
        } else {
            cell.conditionLabel.isSelect = NO;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.menuView.isHidden == NO) {
        self.menuView.hidden = YES;
        return;
    }
    
    NSDictionary *info = self.dataArray[indexPath.row];
    int sId = [[NSString stringWithFormat:@"%@",info[@"id"]] intValue];
    self.selectId = sId;
    self.selectString =  [NSString stringWithFormat:@"%@",info[@"name"]];
    [tableView reloadData];
    
    if (self.type == MZReadyConditionListType_FCode) {//点击了某个F码
        WeaklySelf(weakSelf);
        [self animationAlplaOff];
        MZFCodeInfoViewController *fCodeInfoVC = [[MZFCodeInfoViewController alloc] initWithFCodeInfo:info result:^{
            [weakSelf animationAlplaOn];
        }];
        [[self getCurrentVC].navigationController pushViewController:fCodeInfoVC animated:YES];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[MZConditionCell class] forCellReuseIdentifier:@"MZConditionCell"];
        [_tableView registerClass:[MZConditionWhiteCell class] forCellReuseIdentifier:@"MZConditionWhiteCell"];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIView *)createView {
    if (!_createView) {
        _createView = [[UIView alloc] init];
        _createView.backgroundColor = [UIColor whiteColor];
        
        _aNewButton = [MZCreatUI buttonWithTitle:@"创建" titleColor:[UIColor whiteColor] font:14 target:self sel:@selector(toCreateNew:)];
        _aNewButton.backgroundColor = MakeColor(255, 31, 96, 0.8);
        [_aNewButton.layer setCornerRadius:20];
        [_createView addSubview:_aNewButton];
    }
    return _createView;
}

- (UIButton *)createButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(-1000, -1000, 140, 80)];
        _menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_menuView.layer setCornerRadius:8];
        _menuView.hidden = YES;
        
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = CGRectMake(0, 0, 140, 40);
        editButton.tag = 1;
        [editButton addTarget:self action:@selector(editMenuClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:editButton];
        
        UILabel *leftLabel = [MZCreatUI labelWithText:@"编辑" font:14 textAlignment:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
        leftLabel.frame = CGRectMake(23, 0, 110, 40);
        [editButton addSubview:leftLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, _menuView.frame.size.width, 1)];
        line.backgroundColor = MakeColor(255, 255, 255, 0.2);
        [_menuView addSubview:line];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(0, 40, 140, 40);
        deleteButton.tag = 2;
        [deleteButton addTarget:self action:@selector(editMenuClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:deleteButton];
        
        UILabel *rightLabel = [MZCreatUI labelWithText:@"删除" font:14 textAlignment:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
        rightLabel.frame = CGRectMake(23, 0, 110, 40);
        [deleteButton addSubview:rightLabel];

    }
    return _menuView;
}

#pragma mark - 工厂方法
typedef void(^HideSDKScreenViewBlock)(void);
/**
 * 展示配置的选择列表
 * @param conditionListType 展示列表的类型
 * @param result 选择结果的回调
 */
+ (void)showList:(MZReadyConditionListType)conditionListType
          result:(void(^)(BOOL isCancel, MZReadyConditionListType type, int selectId, NSString *selectString))result {
    [MZConditionListView showScreenView:^(UIView *screenView, HideSDKScreenViewBlock _Nullable hideSDKScreenViewBlock) {
        MZConditionListView *listView = [[MZConditionListView alloc] init];
        listView.backgroundColor = [UIColor whiteColor];
        [screenView addSubview:listView];
        [listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(screenView);
            make.height.equalTo(@(424));
        }];
        
        [listView layoutIfNeeded];
        
        NSLog(@"frame = %@, frame = %@",NSStringFromCGRect(screenView.bounds),NSStringFromCGRect(listView.bounds));
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:listView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = listView.bounds;
        maskLayer.path = maskPath.CGPath;
        listView.layer.mask = maskLayer;
        
        [listView showList:^(BOOL isCancelled, MZReadyConditionListType conditionType, int sId, NSString *sString) {
            hideSDKScreenViewBlock();
            if (result) {
                if (isCancelled) {
                    result(YES, conditionType, 0, @"");
                    return;
                } else {
                    result(NO, conditionType, sId, sString);
                }
            }
        } type:conditionListType];
    } showFinish:^(UIView *screenView) {
        
    } clickEmpty:^(UIView *screenView) {
        result(YES, conditionListType, 0, @"");
    }];
}

/// 底部弹出全屏的View，可以自定义layout后添加到此View上
/// 在回调方法里如果使用self，必须使用weakSelf
+ (void)showScreenView:(void(^)(UIView *screenView, HideSDKScreenViewBlock _Nullable hideSDKScreenViewBlock))initFinish
            showFinish:(void(^)(UIView *screenView))showFinish
            clickEmpty:(void(^)(UIView *screenView))clickEmpty {
    CGRect showFrame = UIScreen.mainScreen.bounds;
    CGRect hideFrame = CGRectMake(0, showFrame.size.height, showFrame.size.width, showFrame.size.height);
    __block UIView *aScreenView = [[UIView alloc] initWithFrame:hideFrame];
    aScreenView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:aScreenView];
    
    __weak typeof(aScreenView) weakScreenView = aScreenView;
    MZReadyButton *emptyButton = [MZReadyButton buttonWithType:UIButtonTypeCustom];
    emptyButton.backgroundColor = [UIColor clearColor];
    emptyButton.frame = aScreenView.bounds;
    [aScreenView addSubview:emptyButton];
    [emptyButton addTapBlock:^(UIButton *sender) {
        [UIView animateWithDuration:0.33 animations:^{
            weakScreenView.frame = hideFrame;
        } completion:^(BOOL finished) {
            if (clickEmpty) clickEmpty(weakScreenView);
        }];
    }];
    
    if (initFinish) initFinish(aScreenView, ^{
        [UIView animateWithDuration:0.33 animations:^{
            weakScreenView.frame = hideFrame;
        } completion:^(BOOL finished) {

        }];
    });
    
    [UIView animateWithDuration:0.33 animations:^{
        aScreenView.frame = showFrame;
    } completion:^(BOOL finished) {
        if (showFinish) showFinish(aScreenView);
    }];
}

@end
