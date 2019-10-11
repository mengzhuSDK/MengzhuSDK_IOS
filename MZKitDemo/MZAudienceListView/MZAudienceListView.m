//
//  MZAudienceListView.m
//  MZKitDemo
//
//  Created by Cage  on 2019/9/28.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZAudienceListView.h"
#import "MZAudienceTableViewCell.h"
@interface MZAudienceListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *audienceTabView;
@property (nonatomic ,strong)NSMutableArray *dataArr;
@end
@implementation MZAudienceListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setBaseProperty{
    self.backgroundColor = MakeColorRGBA(0x000000, 0.5);
}
-(void)setupUI
{
    self.audienceTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.height - 413*MZ_RATE, MZ_SW, 413*MZ_RATE) style:UITableViewStylePlain];
    self.audienceTabView.layer.masksToBounds = YES;
    self.audienceTabView.backgroundColor = MakeColorRGBA(0x1D1B22, 0.9);
    self.audienceTabView.delegate = self;
    self.audienceTabView.dataSource = self;
    [self.audienceTabView registerClass:[MZAudienceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MZAudienceTableViewCell class])];
    [self addSubview:self.audienceTabView];
    self.audienceTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithIsMore:NO];
    }];
    
    self.audienceTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithIsMore:YES];
    }];
    [MZGlobalTools bezierPathWithRoundedRect:self.audienceTabView.bounds radius:16*MZ_RATE view:self.audienceTabView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44*MZ_RATE;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, 44*MZ_RATE)];
    headerView.backgroundColor = MakeColorRGBA(0x1D1B22, 0.9);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, 44*MZ_RATE)];
    titleLabel.text = @"在场观众";
    titleLabel.font = FontSystemSize(14*MZ_RATE);
    titleLabel.textColor = MakeColorRGB(0xFFFFFF);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44*MZ_RATE - 0.5, MZ_SW, 0.5)];
    lineView.backgroundColor = MakeColorRGBA(0xFFFFFF, 0.1);
    [headerView addSubview:lineView];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZAudienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MZAudienceTableViewCell class])];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56*MZ_RATE;
}


-(void)loadDataWithIsMore:(BOOL)isMore
{
    
}

@end
