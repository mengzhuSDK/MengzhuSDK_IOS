//
//  MZFCodeInfoViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/4.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZFCodeInfoViewController.h"

@interface FCodeInfoModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *fcode_id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *code;
@end
@implementation FCodeInfoModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end

@interface FCodeInfoCell : UITableViewCell
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UILabel *tLabel;
@end
@implementation FCodeInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.isSelected = NO;
        
        self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectedButton.userInteractionEnabled = NO;
        self.selectedButton.selected = NO;
        [self.selectedButton setImage:[UIImage imageNamed:@"sssss_sele_no"] forState:UIControlStateNormal];
        [self.selectedButton setImage:[UIImage imageNamed:@"sssss_sele_yes"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectedButton];
        [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(12);
            make.left.equalTo(self.contentView).offset(20);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];

        self.tLabel = [[UILabel alloc] init];
        self.tLabel.backgroundColor = [UIColor clearColor];
        self.tLabel.textColor = [UIColor whiteColor];
        self.tLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.tLabel];
        [self.tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.selectedButton.mas_right).offset(10);
            make.right.equalTo(self.contentView);
        }];
        
        UIView *line = [MZCreatUI viewWithBackgroundColor:MakeColor(43, 43, 43, 1)];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@(1));
        }];
    }
    return self;
}
@end

typedef void(^FCodeAlertBlock)(int num, BOOL isCancelled);

@interface MZFCodeAlert : UIView<UITextFieldDelegate>
@property (nonatomic, assign) int min;
@property (nonatomic, assign) int max;
@property (nonatomic, assign) int num;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *minButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *maxButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic,   copy) FCodeAlertBlock alertBlock;

+ (void)showMin:(int)min max:(int)max hanlder:(void(^)(int num, BOOL isCancelled))handler;
@end

@implementation MZFCodeAlert
- (void)dealloc {
    NSLog(@"F码增减弹窗释放");
}
+ (void)emptyTap {}
+ (void)showMin:(int)min max:(int)max hanlder:(void(^)(int num, BOOL isCancelled))handler {
    UIView *bgView = [MZCreatUI viewWithBackgroundColor:MakeColor(0, 0, 0, 0.5)];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyTap)];
    [bgView addGestureRecognizer:tap];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    MZFCodeAlert *alert = [[MZFCodeAlert alloc] init];
    alert.backgroundColor = [UIColor whiteColor];
    [alert.layer setCornerRadius:8];
    alert.alertBlock = handler;
    alert.min = min;
    alert.num = min;
    alert.max = max;
    [bgView addSubview:alert];
    [alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(24);
        make.right.equalTo(bgView).offset(-24);
        make.height.equalTo(@(189));
        make.top.equalTo(bgView).offset(([UIApplication sharedApplication].keyWindow.frame.size.height - 189)/2.0);
    }];
    
    alert.titleLabel = [MZCreatUI labelWithText:@"请输入新增F码数量" font:16 textAlignment:NSTextAlignmentCenter textColor:MakeColor(43, 43, 43, 1) backgroundColor:[UIColor clearColor]];
    [alert addSubview:alert.titleLabel];
    [alert.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(alert);
        make.height.equalTo(@(48));
    }];
    
    alert.textField = [MZCreatUI textFieldWithBackgroundColor:[UIColor clearColor] delegate:alert font:14 textColor:MakeColor(43, 43, 43, 1) textAlignment:NSTextAlignmentCenter text:[NSString stringWithFormat:@"%d",alert.min] placeHolder:@""];
    [alert.textField addTarget:alert action:@selector(editingChange) forControlEvents:UIControlEventEditingChanged];
    alert.textField.keyboardType = UIKeyboardTypeNumberPad;
    [alert.textField.layer setCornerRadius:6];
    [alert.textField.layer setBorderWidth:1.0];
    [alert.textField.layer setBorderColor:[[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor];
    [alert addSubview:alert.textField];
    [alert.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert.titleLabel.mas_bottom).offset(20);
        make.width.equalTo(@(MZ_RATE * 90));
        make.height.equalTo(@(40));
        make.centerX.equalTo(alert.mas_centerX);
    }];
    
    alert.maxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alert.maxButton setImage:[UIImage imageNamed:@"fcode_num_add_enable"] forState:UIControlStateNormal];
    alert.maxButton.selected = NO;
    [alert.maxButton addTarget:alert action:@selector(max:) forControlEvents:UIControlEventTouchUpInside];
    [alert addSubview:alert.maxButton];
    [alert.maxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert.textField).offset(4);
        make.bottom.equalTo(alert.textField).offset(-4);
        make.right.equalTo(alert.textField.mas_left).offset(-10);
        make.width.equalTo(@(32));
    }];
    
    alert.minButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alert.minButton setImage:[UIImage imageNamed:@"fcode_num_reduce_enable"] forState:UIControlStateNormal];
    alert.minButton.selected = NO;
    [alert.minButton addTarget:alert action:@selector(min:) forControlEvents:UIControlEventTouchUpInside];
    [alert addSubview:alert.minButton];
    [alert.minButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert.textField).offset(4);
        make.bottom.equalTo(alert.textField).offset(-4);
        make.left.equalTo(alert.textField.mas_right).offset(10);
        make.width.equalTo(@(32));
    }];
    
    UIView *cen = [MZCreatUI viewWithBackgroundColor:[UIColor clearColor]];
    [alert addSubview:cen];
    [cen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert.textField.mas_bottom).offset(26);
        make.width.equalTo(@(MZ_RATE * 10));
        make.height.equalTo(@(35));
        make.centerX.equalTo(alert.mas_centerX);
    }];

    alert.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alert.cancelButton addTarget:alert action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [alert.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [alert.cancelButton setTitleColor:MakeColor(255, 31, 96, 1) forState:UIControlStateNormal];
    [alert.cancelButton.layer setCornerRadius:6];
    [alert.cancelButton.layer setBorderColor:MakeColor(255, 31, 96, 1).CGColor];
    [alert.cancelButton.layer setBorderWidth:1.0];
    [alert.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [alert.cancelButton setBackgroundColor:[UIColor whiteColor]];
    [alert addSubview:alert.cancelButton];
    [alert.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(cen);
        make.right.equalTo(cen.mas_left);
        make.width.equalTo(@(140*MZ_RATE));
    }];
    
    alert.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alert.sureButton addTarget:alert action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [alert.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [alert.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alert.sureButton.layer setCornerRadius:6];
    [alert.sureButton.layer setBorderColor:MakeColor(255, 31, 96, 1).CGColor];
    [alert.sureButton.layer setBorderWidth:1.0];
    [alert.sureButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [alert.sureButton setBackgroundColor:MakeColor(255, 31, 96, 1)];
    [alert addSubview:alert.sureButton];
    [alert.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(cen);
        make.left.equalTo(cen.mas_right);
        make.width.equalTo(@(140*MZ_RATE));
    }];
    
    [alert fixButtonEnable];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.num = 1;
    }
    return self;
}

- (void)cancelClick {
    if (self.alertBlock) self.alertBlock(0, YES);
    [self.superview removeFromSuperview];
}

- (void)sureClick {
    if (self.alertBlock) self.alertBlock(self.num, NO);
    [self.superview removeFromSuperview];
}

- (void)min:(UIButton *)sender {
    self.num = MAX(self.num-1, self.min);
    self.textField.text = [NSString stringWithFormat:@"%d",self.num];
    
    [self fixButtonEnable];
}

- (void)max:(UIButton *)sender {
    self.num = MIN(self.num+1, self.max);
    self.textField.text = [NSString stringWithFormat:@"%d",self.num];
    
    [self fixButtonEnable];
}

- (void)fixButtonEnable {
    BOOL canMin = self.num <= self.min ? NO : YES;
    self.minButton.enabled = canMin;
    if (canMin) {
        [self.minButton setImage:[UIImage imageNamed:@"fcode_num_reduce_enable"] forState:UIControlStateNormal];
    } else {
        [self.minButton setImage:[UIImage imageNamed:@"fcode_num_reduce_no_enable"] forState:UIControlStateNormal];
    }
    
    BOOL canMax = self.num >= self.max ? NO : YES;
    self.maxButton.enabled = canMax;
    if (canMax) {
        [self.maxButton setImage:[UIImage imageNamed:@"fcode_num_add_enable"] forState:UIControlStateNormal];
    } else {
        [self.maxButton setImage:[UIImage imageNamed:@"fcode_num_add_no_enable"] forState:UIControlStateNormal];
    }
}

- (void)editingChange {
    self.num = [self.textField.text intValue];
    if (self.num < self.min) {
        self.num = self.min;
    }
    if (self.num > self.max) {
        self.num = self.max;
    }
    self.textField.text = [NSString stringWithFormat:@"%d",self.num];
    [self fixButtonEnable];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

@end


typedef void(^ResultBlock)(void);

@interface MZFCodeInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSDictionary *fCodeInfo;
@property (nonatomic, copy) ResultBlock result;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *allSelectButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableSet *selectedIds;

@property (nonatomic, assign) int minCount;
@property (nonatomic, assign) int maxCount;
@end

@implementation MZFCodeInfoViewController

- (void)dealloc
{
    if (self.result) self.result();
    NSLog(@"F码详情界面释放");
}

- (instancetype)initWithFCodeInfo:(NSDictionary *)fCodeInfo result:(void(^)(void))result {
    self = [super init];
    if (self) {
        self.fCodeInfo = fCodeInfo;
        self.result = result;
        self.minCount = 0;
        self.maxCount = 500;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"未使用F码";
    
    UIButton *rightButton = [MZCreatUI buttonWithTitle:@"新增" titleColor:MakeColor(255, 31, 96, 1) font:MZ_RATE*12 target:self sel:@selector(addFCodeInfo)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        
        CGFloat bottom = 0;
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                bottom = 34.0;
            }
        }
        make.height.equalTo(@(60+bottom));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@(navBarHeight));
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    WeaklySelf(weakSelf);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataIsMore:NO];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataIsMore:YES];
    }];
    
    [self loadDataIsMore:NO];
}

/// 获取F码详情
- (void)loadDataIsMore:(BOOL)isMore {
    NSInteger offset = self.dataArray.count;
    if (isMore == NO) offset = 0;
    int limit = 100;
    
    [MZSDKBusinessManager getUnUseFCodeListWithFCode_id:[NSString stringWithFormat:@"%@",self.fCodeInfo[@"id"]] offset:offset limit:limit success:^(id response) {
        NSMutableArray *tempArr = [FCodeInfoModel mj_objectArrayWithKeyValuesArray:response[@"list"]].mutableCopy;
        
        if (self.allSelectButton.selected) {
            for (FCodeInfoModel *aModel in tempArr) {
                [self.selectedIds addObject:aModel.code];
            }
        }
        self.maxCount = [[NSString stringWithFormat:@"%@",response[@"can_create_num"]] intValue];
        if (offset == 0) {
            self.dataArray = tempArr;
            [self.tableView.mj_header endRefreshing];
            if (self.dataArray.count == 0 || self.dataArray.count % limit > 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
        } else {
            [self.dataArray addObjectsFromArray:tempArr];
            if (tempArr.count % limit > 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.view show:error.domain];
    }];
}

/// 添加新的F码
- (void)addFCodeInfo {
    __weak typeof(self) weakSelf = self;
    NSString *fCodeId = [NSString stringWithFormat:@"%@",self.fCodeInfo[@"id"]];
    [MZFCodeAlert showMin:self.minCount max:self.maxCount hanlder:^(int num, BOOL isCancelled) {
        if (!isCancelled) {
            [MZSDKBusinessManager addFCodeWithFCode_id:fCodeId num:num success:^(id response) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                });
            } failure:^(NSError *error) {
                [weakSelf.view show:error.domain];
            }];
        }
    }];
}

/// 全选按钮点击事件
- (void)allSelectedButtonClick {
    self.allSelectButton.selected = !self.allSelectButton.isSelected;
    if (self.allSelectButton.isSelected) {
        for (FCodeInfoModel *object in self.dataArray) {
            [self.selectedIds addObject:object.code];
        }
    } else {
        [self.selectedIds removeAllObjects];
    }
    [self.tableView reloadData];
}

/// 复制
- (void)toCopy {
    if (self.selectedIds.count > 0) {
        NSString *content = [[self.selectedIds allObjects] componentsJoinedByString:@","];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:content];
        
        [self.view show:@"复制成功"];
    } else {
        if (self.dataArray.count <= 0) {
            [self.view show:@"请先新增F码"];
        } else {
            [self.view show:@"请选择F码"];
        }
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCodeInfoModel *info = self.dataArray[indexPath.row];
    FCodeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FCodeInfoCell class])];
    cell.tLabel.text = info.code;
    cell.selectedButton.selected = [self.selectedIds containsObject:info.code];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FCodeInfoModel *info = self.dataArray[indexPath.row];
    if ([self.selectedIds containsObject:info.code]) {
        [self.selectedIds removeObject:info.code];
    } else {
        [self.selectedIds addObject:info.code];
    }
    [tableView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableSet *)selectedIds {
    if (!_selectedIds) {
        _selectedIds = [[NSMutableSet alloc] init];
    }
    return _selectedIds;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [MZCreatUI tableViewWithDelegate:self registerCellClass:[FCodeInfoCell class]];
        _tableView.backgroundColor = [UIColor blackColor];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, 20, 100, 40);
        [button addTarget:self action:@selector(allSelectedButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor clearColor]];
        [_bottomView addSubview:button];

        _allSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectButton setImage:[UIImage imageNamed:@"sssss_sele_no"] forState:UIControlStateNormal];
        [_allSelectButton setImage:[UIImage imageNamed:@"sssss_sele_yes"] forState:UIControlStateSelected];
        _allSelectButton.selected = NO;
        _allSelectButton.userInteractionEnabled = NO;
        _allSelectButton.frame = CGRectMake(0, 0, 20, 20);
        [button addSubview:_allSelectButton];
        
        UILabel *label = [MZCreatUI labelWithText:@"全选" font:14 textAlignment:NSTextAlignmentLeft textColor:MakeColor(255, 31, 96, 1) backgroundColor:[UIColor clearColor]];
        label.frame = CGRectMake(30, 0, 70, 20);
        [button addSubview:label];
        
        UIButton *newButton = [MZCreatUI buttonWithTitle:@"复制" titleColor:[UIColor whiteColor] font:14 target:self sel:@selector(toCopy)];
        newButton.backgroundColor = MakeColor(255, 31, 96, 0.8);
        [newButton.layer setCornerRadius:20];
        [_bottomView addSubview:newButton];
        newButton.frame = CGRectMake(MZScreenWidth - 120, 10, 100, 40);
    }
    return _bottomView;
}

@end
