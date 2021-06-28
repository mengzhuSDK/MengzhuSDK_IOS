//
//  MZEditWhiteUserViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/4.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZEditWhiteUserViewController.h"
#import "MZC_WaterFlowLayout.h"

@interface MZWhiteInfoModel : NSObject
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) BOOL isAddType;
@end
@implementation MZWhiteInfoModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.isAddType = NO;
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end

@interface MZWhiteInfoAddCell : UICollectionViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *pLabel;
@end
@implementation MZWhiteInfoAddCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
        
        self.bgView = [MZCreatUI viewWithBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
        [self.bgView.layer setCornerRadius:6];
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setImage:[UIImage imageNamed:@"white_add"] forState:UIControlStateNormal];
        self.addButton.userInteractionEnabled = NO;
        [self.bgView addSubview:self.addButton];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(7);
            make.bottom.equalTo(self.bgView).offset(-7);
            make.left.equalTo(self.bgView).offset(14);
            make.width.equalTo(self.addButton.mas_height);
        }];
        
        self.pLabel = [[UILabel alloc] init];
        self.pLabel.backgroundColor = [UIColor clearColor];
        self.pLabel.textColor = [UIColor whiteColor];
        self.pLabel.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:self.pLabel];
        [self.pLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.addButton.mas_right).offset(7);
            make.right.equalTo(self.bgView);
        }];
    }
    return self;
}
@end

@interface MZWhiteInfoCell : UICollectionViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *pLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@end
@implementation MZWhiteInfoCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
        
        self.bgView = [MZCreatUI viewWithBackgroundColor:[UIColor clearColor]];
        [self.bgView.layer setCornerRadius:6];
        [self.bgView.layer setBorderColor:MakeColor(122, 122, 122, 1).CGColor];
        [self.bgView.layer setBorderWidth:1.0];
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"white_delete"] forState:UIControlStateNormal];
        [self.bgView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(7);
            make.bottom.equalTo(self.bgView).offset(-7);
            make.right.equalTo(self.bgView).offset(-14);
            make.width.equalTo(self.deleteButton.mas_height);
        }];
        
        self.pLabel = [[UILabel alloc] init];
        self.pLabel.backgroundColor = [UIColor clearColor];
        self.pLabel.textColor = [UIColor whiteColor];
        self.pLabel.font = [UIFont systemFontOfSize:14];
        self.pLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.pLabel];
        [self.pLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(self.bgView);
            make.right.equalTo(self.deleteButton.mas_left);
        }];
    }
    return self;
}
@end

typedef void(^WhiteAddUserAlertBlock)(NSString *phones, BOOL isCancelled);

@interface MZWhiteAddUserAlert : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic,   copy) WhiteAddUserAlertBlock alertBlock;

@end
@implementation MZWhiteAddUserAlert
- (void)dealloc {
    NSLog(@"白名单新增弹窗释放");
}
+ (void)emptyTap {}
+ (void)showWhiteAddUserWithHanlder:(void(^)(NSString *phones, BOOL isCancelled))handler {
    UIView *bgView = [MZCreatUI viewWithBackgroundColor:MakeColor(0, 0, 0, 0.5)];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyTap)];
    [bgView addGestureRecognizer:tap];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    MZWhiteAddUserAlert *alert = [[MZWhiteAddUserAlert alloc] init];
    alert.backgroundColor = [UIColor whiteColor];
    [alert.layer setCornerRadius:8];
    alert.alertBlock = handler;
    [bgView addSubview:alert];
    [alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(24);
        make.right.equalTo(bgView).offset(-24);
        make.height.equalTo(@(292));
        make.top.equalTo(bgView).offset(([UIApplication sharedApplication].keyWindow.frame.size.height - 292)/2.0);
    }];
    
    alert.titleLabel = [MZCreatUI labelWithText:@"新增用户" font:16 textAlignment:NSTextAlignmentCenter textColor:MakeColor(43, 43, 43, 1) backgroundColor:[UIColor clearColor]];
    [alert addSubview:alert.titleLabel];
    [alert.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(alert);
        make.height.equalTo(@(48));
    }];
    
    UIView *textViewBgView = [MZCreatUI viewWithBackgroundColor:[UIColor clearColor]];
    [textViewBgView.layer setCornerRadius:6];
    [textViewBgView.layer setBorderWidth:1.0];
    [textViewBgView.layer setBorderColor:[[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor];
    [alert addSubview:textViewBgView];
    [textViewBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alert.titleLabel.mas_bottom);
        make.left.equalTo(alert).offset(20);
        make.right.equalTo(alert).offset(-20);
        make.height.equalTo(@(168));
    }];
    
    alert.textView = [MZCreatUI textViewWithDelegate:self text:@"" textColor:MakeColor(43, 43, 43, 1) font:14 backgroundColor:[UIColor whiteColor] placeHolder:@"请输入用户手机号，多个手机号用英文逗号（,）隔开"];
    [alert addSubview:alert.textView];
    [alert.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(textViewBgView).offset(14);
        make.right.bottom.equalTo(textViewBgView).offset(-14);
    }];
    
    UIView *cen = [MZCreatUI viewWithBackgroundColor:[UIColor clearColor]];
    [alert addSubview:cen];
    [cen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textViewBgView.mas_bottom).offset(20);
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
}

- (void)cancelClick {
    if (self.alertBlock) self.alertBlock(@"", YES);
    [self.superview removeFromSuperview];
}

- (void)sureClick {
    NSString *phones = self.textView.text;
    phones = [phones stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phones.length <= 0) {
        [self show:@"请输入手机号"];
        return;
    }
    
    NSArray *phone_array = [phones componentsSeparatedByString:@","];
    BOOL isComplianceRules = YES;
    NSString *error_phone = @"";
    
    NSMutableArray *post_phones = @[].mutableCopy;
    
    for (NSString *phone in phone_array) {
        if (phone.length <= 0) {
            continue;;
        }
        if ([phone isPhone] == NO) {
            error_phone = phone;
            isComplianceRules = NO;
            break;
        }
        [post_phones addObject:phone];
    }
    if (isComplianceRules == NO) {
        [self show:[NSString stringWithFormat:@"手机号输入有误，请检查：%@",error_phone]];
        return;
    }
    if (post_phones.count <= 0) {
        [self show:@"请输入有效手机号"];
        return;
    }
    NSString *post_phones_string = [post_phones componentsJoinedByString:@","];
    if (self.alertBlock) self.alertBlock(post_phones_string, NO);
    [self.superview removeFromSuperview];
}
@end

typedef void(^ResultBlock)(void);

@interface MZEditWhiteUserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MZC_WaterFlowLayoutDelegate>
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, copy) ResultBlock result;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MZC_WaterFlowLayout *flowLayout;

@property (nonatomic, strong) UIView *createView;

@end

@implementation MZEditWhiteUserViewController

- (void)dealloc
{
    if (self.result) self.result();
    NSLog(@"编辑用户界面释放");
}

- (instancetype)initWithInfo:(NSDictionary *)info result:(void(^)(void))result {
    self = [super init];
    if (self) {
        self.info = info;
        self.result = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"编辑用户";
    
    UIButton *rightButton = [MZCreatUI buttonWithTitle:@"清空所有" titleColor:MakeColor(255, 31, 96, 1) font:12 target:self sel:@selector(clearAll)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    
    [self.view addSubview:self.createView];
    [self.createView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@(navBarHeight));
        make.bottom.equalTo(self.createView.mas_top);
    }];
    
    WeaklySelf(weakSelf);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataIsMore:NO];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataIsMore:YES];
    }];
    
    [self loadDataIsMore:NO];
}

- (void)loadDataIsMore:(BOOL)isMore {
    NSInteger offset = self.dataArray.count;
    if (isMore == NO) offset = 0;
    int limit = 100;
    
    [MZSDKBusinessManager getWhiteUserListWithWhiteId:[NSString stringWithFormat:@"%@",self.info[@"id"]] offset:offset limit:limit success:^(id response) {
        NSMutableArray *tempArr = [MZWhiteInfoModel mj_objectArrayWithKeyValuesArray:response[@"list"]].mutableCopy;
        
        if (offset == 0) {
            self.dataArray = tempArr;
            [self.dataArray addObject:[self addAddModel]];
            [self.collectionView.mj_header endRefreshing];
            if (tempArr.count == 0 || tempArr.count % limit > 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if (self.collectionView.mj_footer.state == MJRefreshStateNoMoreData) {
                    [self.collectionView.mj_footer resetNoMoreData];
                }
            }
        } else {
            if (self.dataArray.count) {
                [self.dataArray removeLastObject];
            }
            [self.dataArray addObjectsFromArray:tempArr];
            [self.dataArray addObject:[self addAddModel]];
            if (tempArr.count % limit > 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.view show:error.domain];
    }];
}

- (void)deleteButtonClick:(UIButton *)sender {
    MZWhiteInfoModel *info = self.dataArray[sender.tag];
    [MZSDKBusinessManager deleteWhiteUserWithWhiteId:[NSString stringWithFormat:@"%@",self.info[@"id"]] phone:info.phone success:^(id response) {
        [self.dataArray removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.view show:error.domain];
    }];
    
}

- (void)clearAll {
    [MZSDKBusinessManager clearWhiteUserWithWhiteId:[NSString stringWithFormat:@"%@",self.info[@"id"]] success:^(id response) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:[self addAddModel]];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.view show:error.domain];
    }];
}

- (void)toFinished {
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加新增用户的模型
- (MZWhiteInfoModel *)addAddModel {
    MZWhiteInfoModel *info = [[MZWhiteInfoModel alloc] init];
    info.phone = @"新增用户";
    info.isAddType = YES;
    return info;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MZWhiteInfoModel *info = self.dataArray[indexPath.item];
    if (info.isAddType) {
        MZWhiteInfoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MZWhiteInfoAddCell class]) forIndexPath:indexPath];
        cell.pLabel.text = info.phone;
        return cell;
    } else {
        MZWhiteInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MZWhiteInfoCell class]) forIndexPath:indexPath];
        cell.pLabel.text = info.phone;
        cell.deleteButton.tag = indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    MZWhiteInfoModel *info = self.dataArray[indexPath.item];
    if (info.isAddType) {
        __weak typeof(self) weakSelf = self;
        [MZWhiteAddUserAlert showWhiteAddUserWithHanlder:^(NSString *phones, BOOL isCancelled) {
            if (isCancelled) return;
            [MZSDKBusinessManager batchfAddUserWhiteWithWhiteId:[NSString stringWithFormat:@"%@",self.info[@"id"]] phones:phones success:^(id response) {
                [weakSelf loadDataIsMore:NO];
            } failure:^(NSError *error) {
                [self.view show:error.domain];
            }];
        }];
    }
}

#pragma mark - MZC_WaterFlowLayoutDelegate
/** 返回每个item大小 */
- (CGSize)waterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width/2.0, 50);
}

- (CGSize)waterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)waterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeZero;
}

/** 列数 */
- (CGFloat)columnCountInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout {
    return 2;
}

/** 行数 */
- (CGFloat)rowCountInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout {
    if (self.dataArray.count % 2 == 0) {
        return self.dataArray.count / 2;
    }
    return self.dataArray.count / 2 + 1;
}

/** 列间距 */
- (CGFloat)columnMarginInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout {
    return 0;
}

/** 行间距 */
- (CGFloat)rowMarginInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout {
    return 0;
}

/** 边缘之间的间距 */
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}
- (UIView *)createView {
    if (!_createView) {
        _createView = [[UIView alloc] init];
        _createView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
        
        UIButton *newButton = [MZCreatUI buttonWithTitle:@"完成" titleColor:[UIColor whiteColor] font:14 target:self sel:@selector(toFinished)];
        newButton.backgroundColor = MakeColor(255, 31, 96, 0.8);
        [newButton.layer setCornerRadius:20];
        [_createView addSubview:newButton];
        newButton.frame = CGRectMake(46, 10, MZScreenWidth - 92, 40);
    }
    return _createView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _flowLayout = [[MZC_WaterFlowLayout alloc] init];
        _flowLayout.delegate = self;
        _flowLayout.flowLayoutStyle = MZC_WaterFlowVerticalEqualWidth;
        
        _collectionView = [MZCreatUI collectionViewithLayout:_flowLayout delegate:self registerCellClass:[MZWhiteInfoCell class]];
        [_collectionView registerClass:[MZWhiteInfoAddCell class] forCellWithReuseIdentifier:NSStringFromClass([MZWhiteInfoAddCell class])];
    }
    return _collectionView;
}

@end
