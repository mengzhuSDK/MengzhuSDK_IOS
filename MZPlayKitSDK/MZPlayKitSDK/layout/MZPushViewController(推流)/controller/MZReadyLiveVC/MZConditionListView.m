//
//  MZConditionListView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/10/19.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZConditionListView.h"

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
 * 展示的列表View
 */
typedef void(^SelectResultBlock)(BOOL isCancelled, MZReadyConditionListType conditionType, int sId, NSString *sString);
@interface MZConditionListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) MZReadyConditionListType type;//当前展示的list的type
@property (nonatomic,   copy) SelectResultBlock result;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) int selectId;//当前选中的id
@property (nonatomic,   copy) NSString *selectString;//当前选中的字符串
@property (nonatomic, assign) NSInteger selectIndex;//当前选中的数据源索引
@end

@implementation MZConditionListView

/// 展示列表
- (void)showList:(SelectResultBlock)result type:(MZReadyConditionListType)type{
    self.type = type;
    self.result = result;
    self.selectIndex = -1;
    self.selectString = @"";
    
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
    MZConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZConditionCell"];
    NSDictionary *info = self.dataArray[indexPath.row];
    [cell update:info];
    if (self.selectIndex == indexPath.row) {
        cell.conditionLabel.isSelect = YES;
    } else {
        cell.conditionLabel.isSelect = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = self.dataArray[indexPath.row];
    int sId = [[NSString stringWithFormat:@"%@",info[@"id"]] intValue];
    self.selectIndex = indexPath.row;
    self.selectId = sId;
    self.selectString =  [NSString stringWithFormat:@"%@",info[@"name"]];
    [tableView reloadData];
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

- (UIButton *)createButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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
            make.height.equalTo(@(344));
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
