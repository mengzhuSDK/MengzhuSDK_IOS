//
//  MZRedPackageRecordViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/22.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZRedPackageRecordViewController.h"
#import "MZRedRecodeTableViewCell.h"
#import "MZRebBagRecordModel.h"

@interface MZRedPackageRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    NSString *_bid;
    UILabel *_statusLabel;
    UILabel *_signLabel; // slogen
}
@property (nonatomic ,strong) UIButton *backButton;
@property (nonatomic ,strong) UIView *headView;
@property (nonatomic ,strong) UILabel *moneyLabel;
@property (nonatomic ,strong) UILabel *moneyUnitLable;
@property (nonatomic ,strong) UIView *redView;
@property (nonatomic ,strong) UIView *headTearView;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UITableView *recodeTab;

@property (nonatomic, copy) NSString *bonus_id;

@property (nonatomic ,strong) MZRebBagRecordModel *recordModel;
@property (nonatomic ,strong) MZRedBagSenderModel *senderModel;
@property (nonatomic ,strong) MZRedBagMessageModel *bagMessageModel;
@property (nonatomic ,strong) NSMutableArray *dataArr;

@end

@implementation MZRedPackageRecordViewController

- (void)dealloc {
    NSLog(@"红包领取记录界面释放");
}

- (instancetype)initWithBonus_id:(NSString *)bonus_id {
    self = [super init];
    if (self) {
        self.bonus_id = bonus_id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataArr = [NSMutableArray array];

    [self setupUI];

    [self loadDataIsMore:NO];

}

- (void)loadDataIsMore:(BOOL)isMore {
    
    MZUser *user = [MZBaseUserServer currentUser];
    NSInteger limit = 200;
    
    [MZSDKBusinessManager getBonusDrawListWithUnique_id:user.uniqueID bonus_id:self.bonus_id offset:isMore ? _dataArr.count : 0 limit:limit success:^(id responseObject) {
        
        self.recordModel = [MZRebBagRecordModel mj_objectWithKeyValues:responseObject];
        if(!self.senderModel){
            self.senderModel = self.recordModel.sendInfo;
        }
        if(!self.bagMessageModel){
            self.bagMessageModel = self.recordModel.lotteryInfo;
        }
        NSArray *tempArr = [MZRedBagReceiverListModel mj_objectArrayWithKeyValuesArray:self.recordModel.obtainList];
        
        if(tempArr.count < limit){
            [self.recodeTab.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.recodeTab.mj_footer endRefreshing];
        }
        if (isMore == NO) {
            self.dataArr = tempArr.mutableCopy;
        } else {
            [self.dataArr addObjectsFromArray:tempArr];
        }
        [self.recodeTab.mj_header endRefreshing];

        [self.recodeTab reloadData];
        
        [self reloadUI];
        
    } failure:^(NSError *error) {
        [self.recodeTab.mj_header endRefreshing];
        [self.recodeTab.mj_footer endRefreshing];
        [self.view show:error.domain];
    }];
}

- (void)addDefaultView{
    UIImageView *defaultView = [[UIImageView alloc] initWithFrame:CGRectMake(72 *MZ_RATE,self.headView.bottom + 60 *MZ_RATE, 231 *MZ_RATE, 144 *MZ_RATE)];
    [_recodeTab addSubview:defaultView];
    defaultView.image = [UIImage imageNamed:@"mz_discuss_nodata"];
    defaultView.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    [_recodeTab addSubview:tipLabel];
    tipLabel.text = @"暂无内容";
    tipLabel.font = [UIFont systemFontOfSize:12 *MZ_RATE];
    tipLabel.textColor = MakeColorRGB(0x9B9B9B);
    [tipLabel sizeToFit];
    CGFloat xValue = defaultView.center.x;
    CGFloat yValue = defaultView.center.y + defaultView.height/2.0 + 20 *MZ_RATE +tipLabel.height/2.0;
    tipLabel.center = CGPointMake(xValue, yValue);
}
-(void)reloadUI
{
    _nameLabel.text = _recordModel.sendInfo.nickname;
    [_nameLabel sizeToFit];
    _signLabel.text = _recordModel.lotteryInfo.slogan;
    [_signLabel sizeToFit];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_senderModel.avatar] placeholderImage:MZ_UserIcon_DefaultImage];
    
    if ([_recordModel.user_receive.amount floatValue]> 0) {
        _moneyLabel.text = _recordModel.user_receive.amount;
    }else{
//        自己没有领取到
        _moneyLabel.hidden = YES;
        _moneyUnitLable.hidden = YES;
       
    }
    _statusLabel.text = [NSString stringWithFormat:@"已领取%@/%@个，共%@/%@元",_bagMessageModel.alreadyQuantity,_bagMessageModel.quantity,_bagMessageModel.remainAmount,_bagMessageModel.amount];
    [_statusLabel sizeToFit];
    
    [self customLayoutSubviews];
}
- (void)customLayoutSubviews{
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    if ([_recordModel.user_receive.amount floatValue]> 0) {
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(48 *MZ_RATE);
            make.centerX.equalTo(self.headView).offset(13 * MZ_RATE);
            make.top.equalTo(_nameLabel.mas_bottom).offset(51 *MZ_RATE);
        }];
        [_moneyUnitLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(26 *MZ_RATE);
            make.height.mas_equalTo(37 *MZ_RATE);
            make.top.equalTo(_moneyLabel).offset(2 *MZ_RATE);
            make.right.equalTo(_moneyLabel.mas_left);
        }];
    }else{
        self.headView.frame = CGRectMake(0, 0, MZ_SW, 247*MZ_RATE);
        self.redView.frame = CGRectMake(0, 0, MZ_SW, 165* MZ_RATE);
        self.headTearView.frame = CGRectMake(0, 165 *MZ_RATE, MZ_SW, 42 *MZ_RATE);
        self.lineView.frame = CGRectMake(0, self.headView.height-1, MZ_SW, 1);

    }
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView).offset(19);
        make.top.equalTo(self.headView).offset(statusBarHeight + 44+ 4 );
    }];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.right.equalTo(_nameLabel.mas_left).offset(-8);
        make.height.width.mas_equalTo(30);
    }];
    [_signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView);
        make.top.equalTo(_nameLabel.mas_bottom).offset(14 *MZ_RATE);
    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(16);
        make.bottom.equalTo(self.headView.mas_bottom).offset(-11 *MZ_RATE);
    }];
//    全部布局完后添加却缺省图
    if (_dataArr.count == 0) {
        [self addDefaultView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)setupUI
{
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
//    添加tableView
    _recodeTab = [[UITableView alloc]initWithFrame:CGRectMake(0, -statusBarHeight, MZ_SW, MZTotalScreenHeight+statusBarHeight)];
    _recodeTab.dataSource = self;
    _recodeTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _recodeTab.rowHeight = 64 *MZ_RATE;
    _recodeTab.delegate = self;
    [_recodeTab registerClass:[MZRedRecodeTableViewCell class] forCellReuseIdentifier:@"recodeCell"];
    [self.view addSubview:_recodeTab];
    
    WeaklySelf(weakSelf);
//    _recodeTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadDataIsMore:NO];
//    }];
    _recodeTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataIsMore:YES];
    }];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, statusBarHeight, 64, 44)];
    [self.backButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"navBar_left"] forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    
//    tableView上方的整块View
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, 295*MZ_RATE)];
    self.headView = headView;
//    顶部红色块
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MZ_SW, 213 * MZ_RATE)];
    self.redView = redView;
    [redView setBackgroundColor:MakeColorRGB(0xF12405)];
    [headView addSubview:redView];
//    顶部红色尾巴
    UIImageView *headTearView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 213 * MZ_RATE, MZ_SW, 42*MZ_RATE)];
    self.headTearView = headTearView;
    headTearView.userInteractionEnabled = YES;
    headTearView.image =[UIImage imageNamed:@"mz_luck_end"];
    [headView addSubview:headTearView];
    

    _headImageView = [[UIImageView alloc]init];
    [_headImageView roundChangeWithRadius:15 *MZ_RATE];
    _headImageView.image = MZ_UserIcon_DefaultImage;
    [headView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16 * MZ_RATE];
    _nameLabel.textColor = MakeColorRGB(0xEFCE73);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_nameLabel];
    
    _signLabel = [[UILabel alloc]init];
    _signLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    _signLabel.textColor = MakeColorRGB(0xEFCE73);
    _signLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_signLabel];
    
    _moneyUnitLable = [[UILabel alloc]init];
    _moneyUnitLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 26*MZ_RATE];
    _moneyUnitLable.textColor = MakeColorRGB(0xEFCE73);
    _moneyUnitLable.textAlignment = NSTextAlignmentCenter;
    _moneyUnitLable.text = @"￥";
    [headView addSubview:_moneyUnitLable];
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 34 *MZ_RATE];
    _moneyLabel.textColor = MakeColorRGB(0xEFCE73);
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_moneyLabel];

    _statusLabel = [[UILabel alloc]init];
    _statusLabel.textColor = MakeColor(122, 122, 122, 1);
    _statusLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
    [headView addSubview:_statusLabel];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, headView.height-1, MZ_SW, 1)];
    lineView.backgroundColor = MakeColor(239, 239, 239, 1);
    self.lineView = lineView;
    [headView addSubview:lineView];

    _recodeTab.tableHeaderView = headView;
    
}
- (void)popSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZRedRecodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recodeCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.money_type = _bagMessageModel.money_type;
    cell.listModel = _dataArr[indexPath.row];
    if (indexPath.row+1 == _dataArr.count) {
        cell.isLast = YES;
    }else{
        cell.isLast = NO;
    }
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
