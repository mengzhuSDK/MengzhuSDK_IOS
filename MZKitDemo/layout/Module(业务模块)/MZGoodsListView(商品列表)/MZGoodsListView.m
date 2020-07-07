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

@property (nonatomic ,strong)UILabel *goodsTitleLabel;

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

-(void)setupUI {
    CGFloat relastiveRate = MZ_RATE;
    CGFloat viewHeight = 413*MZ_RATE;
        
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        relastiveRate = MZ_FULL_RATE;
        viewHeight = 240*MZ_FULL_RATE;
    }
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - viewHeight, self.width, 44*relastiveRate)];
    headerView.layer.masksToBounds = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerView];
    
    self.goodsTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12*relastiveRate, 12*relastiveRate, 200*relastiveRate, 20*relastiveRate)];
    self.goodsTitleLabel.text = @"全部商品·";
    self.goodsTitleLabel.font = FontSystemSize(14*relastiveRate);
    self.goodsTitleLabel.textColor = MakeColorRGB(0x999999);
    [headerView addSubview:self.goodsTitleLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44*relastiveRate - 1, self.width, 1)];
    lineView.backgroundColor = MakeColorRGB(0xdddddd);
    [headerView addSubview:lineView];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 40*relastiveRate - 8*relastiveRate, 2*relastiveRate, 40*relastiveRate, 40*relastiveRate)];
    [closeBtn addTarget:self action:@selector(closeBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"store_close"] forState:UIControlStateNormal];
    [headerView addSubview:closeBtn];
    [MZGlobalTools bezierPathWithRoundedRect:headerView.bounds radius:16*relastiveRate view:headerView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    self.backgroundColor = MakeColorRGBA(0x000000, 0.5);
    
    CGFloat tableViewOffset = 44*relastiveRate;
    CGFloat footerViewHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {//如果有刘海屏
            if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {//如果是横屏
                tableViewOffset = 34*relastiveRate;
                footerViewHeight = 15.0;
                self.goodsTitleLabel.frame = CGRectMake(44+12*relastiveRate, 12*relastiveRate, 200*relastiveRate, 20*relastiveRate);
            } else {
                tableViewOffset = 24*relastiveRate;
                footerViewHeight = 34.0;
            }
        }
    }
    
    self.goodTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.width, viewHeight - tableViewOffset) style:UITableViewStylePlain];
    self.goodTabView.backgroundColor = MakeColorRGB(0xffffff);
    self.goodTabView.delegate = self;
    self.goodTabView.dataSource = self;
    [self addSubview:self.goodTabView];
    self.goodTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, footerViewHeight)];

    self.goodTabView.tableFooterView = footerView;
    
    [self.goodTabView registerClass:[MZGoodsListTabCell class] forCellReuseIdentifier:@"MZGoodsListTabCell"];
    
    WeaklySelf(weakSelf);
    self.goodTabView.MZ_header = [MZRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithIsMore:NO];
    }];
    
    self.goodTabView.MZ_footer = [MZRefreshBackStateFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataWithIsMore:YES];
    }];

}

-(void)setTotalNum:(int)totalNum
{
    _totalNum = totalNum;
    self.goodsTitleLabel.text = [NSString stringWithFormat:@"全部商品·%d",self.totalNum];
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
    cell.index =(int) (self.totalNum  - indexPath.row);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self && self.goodsListViewCellClickBlock){
        if(self.dataArr.count >= indexPath.row){
            MZGoodsListModel *model = self.dataArr[indexPath.row];
            self.goodsListViewCellClickBlock(model);
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        return 100*MZ_FULL_RATE;
    }
    return 100*MZ_RATE;
}


-(void)closeBtnDidClick
{
    [self removeFromSuperview];
}


-(void)loadDataWithIsMore:(BOOL)isMore
{
    WeaklySelf(weakSelf);
    if(isMore){
        [self.requestDelegate requestGoodsList:^(MZGoodsListOuterModel * _Nonnull model) {
            self.totalNum = model.total;
                [weakSelf.goodTabView reloadData];
//            [weakSelf.goodTabView.MZ_footer endRefreshing];
            NSLog(@"MZ_footer %lu",(unsigned long)[weakSelf.dataArr count]);
               } offset:(int)self.dataArr.count];
    }else{

        [self.requestDelegate requestGoodsList:^(MZGoodsListOuterModel * _Nonnull model) {
            self.totalNum = model.total;
            [weakSelf.goodTabView reloadData];
//            [weakSelf.goodTabView.MZ_header endRefreshing];
            NSLog(@"MZ_header %lu",(unsigned long)[weakSelf.dataArr count]);
        } offset:0];

    }
    
    
}

@end
