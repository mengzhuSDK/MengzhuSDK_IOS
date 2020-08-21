//
//  MZPresentView.m
//  MengZhu
//
//  Created by vhall on 16/6/24.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZPresentView.h"
#import "VHPullingRefreshTableView.h"
#import "MZEmptyView.h"

@interface MZPresentCell:UITableViewCell
{
    UIImageView * presentImageView;
    UILabel * presentNameLabel;
    UILabel * presentPriceLabel;
    UILabel * presentCountLabel;
    UIView * line;
}
@property (nonatomic,retain)MZPresentListModel * model;

@end
@implementation MZPresentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        presentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
//        presentImageView.layer.masksToBounds = YES;
//        presentImageView.layer.borderColor = MakeColorRGB(0xcdcdcf).CGColor;
//        presentImageView.layer.borderWidth = 0.6;
        [self.contentView addSubview:presentImageView];
        
        presentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(presentImageView.right + 15, presentImageView.center.y - 20, 120, 20)];
        presentNameLabel.font = [UIFont systemFontOfSize:14];
        presentNameLabel.textColor = MakeColorRGB(0x2b2c32);
        [self.contentView addSubview:presentNameLabel];
        
        presentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(presentImageView.right + 15, presentImageView.center.y, 120, 20)];
        presentPriceLabel.font = [UIFont systemFontOfSize:13];
        presentPriceLabel.textColor = MakeColorRGB(0xcdcdcf);
        [self.contentView addSubview:presentPriceLabel];
        
        presentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - presentNameLabel.right-10, 15, 100, 20)];
        presentCountLabel.font = [UIFont systemFontOfSize:13];
        presentCountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:presentCountLabel];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.2, self.width, 0.8)];
        line.backgroundColor = MakeColorRGB(0xf3f3f3);
        [self.contentView addSubview:line];
        self.backgroundColor =[UIColor whiteColor];
    }
    return self;
}
-(void)layoutSubviews
{
    [presentImageView sd_setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:[UIImage imageNamed:@"gift_placeHolder"]];
    
    if ([MZBaseGlobalTools isBlankString:_model.id]) {
        presentNameLabel.text = @"打赏";
        presentPriceLabel.text = [NSString stringWithFormat:@"%@元",_model.price];
        presentCountLabel.hidden = YES;
        presentImageView.image = [UIImage imageNamed:@"求打赏"];
    }
    else {
        presentNameLabel.text = EmptyForNil(_model.name);
        presentPriceLabel.text = [NSString stringWithFormat:@"%@元/个",_model.price];
        presentCountLabel.text = [NSString stringWithFormat:@"%@个",_model.num];
        [presentImageView sd_setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:[UIImage imageNamed:@"gift_placeHolder"]];
    }
    
    line.width = self.width;
}
@end

@interface MZPresentView ()<UITableViewDataSource,UITableViewDelegate,VHPullingRefreshTableViewDelegate>
{
    UIView * contentView;
    UILabel*feedBackLabel;
    VHPullingRefreshTableView *  _tableView;
    NSString * _channelId;
    NSString * _total;
    MZEmptyView * _emptyView;
}
//@property (nonatomic,copy)void(^action)(NSString * userId);
@property (nonatomic,copy)void(^loadMore)(void(^finish)(NSArray * userList));
@end

@implementation MZPresentView
- (instancetype)initWithFrame:(CGRect )frame
{
    if (self =[super initWithFrame:frame]) {
        //        self.backgroundColor = [UIColor clearColor];
        CGRect audienceFrame;
        float space = MZ_RATE;
        if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
            space = MZ_FULL_RATE;
            audienceFrame = CGRectMake((self.width -270 * space) / 2, 50 * space, 270 * space, 280 * space);//横屏位置
        } else {
            audienceFrame = CGRectMake(55 * MZ_RATE, 95 * MZ_RATE, 265 * MZ_RATE, 365 * MZ_RATE);//竖屏位置
        }

        contentView = [[UIView alloc] initWithFrame:audienceFrame];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius = 3;
        contentView.layer.borderColor = MakeColorRGB(0xd3d5d7).CGColor;
        contentView.layer.borderWidth = 1;
        [self addSubview:contentView];
        UIView * docView = [[UIView alloc]initWithFrame:CGRectMake(17 * space, 23 * space, 7 * space,7*space)];
        docView.backgroundColor = MakeColorRGB(0xff5b29);
        docView.layer.masksToBounds = YES;
        docView.layer.cornerRadius = docView.height / 2.0;
        [contentView addSubview:docView];
        
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(contentView.width - 40 * space ,docView.center.y - 10 * space, 20 * space, 20 * space)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"mzClose_0710_black"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:closeBtn];
        
        feedBackLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * space ,docView.center.y -  12.5 * space, contentView.width-40 * space, 25*space)];
        feedBackLabel.text = @"收到(0元)";
        feedBackLabel.font = [UIFont systemFontOfSize:17];
        feedBackLabel.textColor = [UIColor blackColor];
        feedBackLabel.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:feedBackLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 50 * space, contentView.width-30, 0.8)];
        lineView.backgroundColor = MakeColorRGB(0xf3f3f3);
        [contentView addSubview:lineView];
        
        _tableView = [[VHPullingRefreshTableView alloc]initWithFrame:CGRectMake(docView.origin.x, 50.8 * space, contentView.width - 34 * space,  contentView.height - 50.8 * space)];
        _tableView.pullingDelegate = self;
        _tableView.isHasHead = NO;
        _tableView.isHasFoot = YES;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.dataArr = [[NSMutableArray alloc]init];
        _tableView.startPos = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        UIView* footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , 0)];
        _tableView.tableFooterView= footview;
        [contentView addSubview:_tableView];
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];;
        _emptyView = [[MZEmptyView alloc]initNetErrorViewWithFrame:_tableView.frame clickBlock:^(MZEmptyViewBlockType type) {
        }];
        [contentView addSubview:_emptyView];
    }
    return self;
}
-(void)showWithView:(UIView *)view withJoinTotal:(NSString *)total
{
    self.frame= view.bounds;
    [view addSubview:self];
    _total = [MZBaseGlobalTools moneyToString:total];
    feedBackLabel.text = [NSString stringWithFormat:@"收到(%@元)",_total];
}
-(void)setSelectAction:(void(^)(NSString * userId))action loadMore:(void(^)(void(^finish)(NSArray * userList)))loadMore
{
//    self.action = action;
//    self.loadMore = loadMore;
}
-(void)dismiss
{
    [self removeFromSuperview];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:contentView];
    if (point.x<0||point.y<0||point.x>contentView.width||point.y>contentView.height) {
        [self dismiss];
    }
}
-(void)setGiftList:(NSArray*)userList
{
    _tableView.reachedTheEnd = YES;
    [_tableView.dataArr addObjectsFromArray:userList];
    if (_tableView.dataArr.count == 0) {
        [_emptyView showNoData];
    }
    else{
        _emptyView.hidden = YES;
    }
    _tableView.hidden = (_tableView.dataArr.count > 0 ? NO : YES);
    [_tableView reloadData];
}

#pragma mark tableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableView.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZPresentListModel * model = _tableView.dataArr[indexPath.row];
    static NSString * identifier = @"MZPresentCell";
    MZPresentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MZPresentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
