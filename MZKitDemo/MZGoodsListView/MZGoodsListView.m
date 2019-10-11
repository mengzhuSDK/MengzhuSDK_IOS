//
//  MZGoodsListView.m
//  MZKitDemo
//
//  Created by LiWei on 2019/9/27.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZGoodsListView.h"
#import "MZGoodsListTabCell.h"

@interface MZGoodsListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *goodTabView;

@end

@implementation MZGoodsListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(NSMutableArray *)dataArr
{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)setupUI
{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, MZTotalScreenHeight - 413*MZ_RATE, MZ_SW, 44*MZ_RATE)];
    headerView.layer.masksToBounds = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12*MZ_RATE, 12*MZ_RATE, 200*MZ_RATE, 20*MZ_RATE)];
    titleLabel.text = @"全部商品·";
    titleLabel.font = FontSystemSize(14*MZ_RATE);
    titleLabel.textColor = MakeColorRGB(0x999999);
    [headerView addSubview:titleLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44*MZ_RATE - 1, MZ_SW, 1)];
    lineView.backgroundColor = MakeColorRGB(0xdddddd);
    [headerView addSubview:lineView];
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(MZ_SW - 40*MZ_RATE - 8*MZ_RATE, 2*MZ_RATE, 40*MZ_RATE, 40*MZ_RATE)];
    [closeBtn addTarget:self action:@selector(closeBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"store_close"] forState:UIControlStateNormal];
    [headerView addSubview:closeBtn];
    [MZGlobalTools bezierPathWithRoundedRect:headerView.bounds radius:16*MZ_RATE view:headerView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    self.backgroundColor = MakeColorRGBA(0x000000, 0.5);
    self.goodTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, MZ_SW, 370*MZ_RATE) style:UITableViewStylePlain];
    self.goodTabView.backgroundColor = MakeColorRGB(0xffffff);
    self.goodTabView.delegate = self;
    self.goodTabView.dataSource = self;
    [self addSubview:self.goodTabView];
    self.goodTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.goodTabView.tableFooterView = [[UIView alloc]init];
    
    [self.goodTabView registerClass:[MZGoodsListTabCell class] forCellReuseIdentifier:@"MZGoodsListTabCell"];
    self.goodTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithIsMore:NO];
    }];
    
    self.goodTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithIsMore:YES];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZGoodsListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZGoodsListTabCell"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*MZ_RATE;
}


-(void)closeBtnDidClick
{
    [self removeFromSuperview];
}


-(void)loadDataWithIsMore:(BOOL)isMore
{
    [self.goodTabView.mj_header endRefreshing];
    [self.goodTabView.mj_footer endRefreshing];
}

@end
