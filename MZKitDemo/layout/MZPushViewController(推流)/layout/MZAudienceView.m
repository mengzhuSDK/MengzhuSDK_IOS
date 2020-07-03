//
//  MZAudienceView.m
//  MengZhu
//
//  Created by vhall on 16/6/24.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.


#import "MZAudienceView.h"
#import "VHPullingRefreshTableView.h"
#import "MZEmptyView.h"
#import "MZImageTools.h"
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

@interface MZAudienceCell:UITableViewCell
{
    UIImageView * headerView;
    UILabel * nameL;
    UIView * line;
}
@property (nonatomic,retain)MZOnlineUserListModel * model;
@end
@implementation MZAudienceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
        headerView.layer.masksToBounds = YES;
        headerView.layer.cornerRadius = 15;
        [self.contentView addSubview:headerView];
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 200, 20)];
        nameL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:nameL];
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.2, self.width, 0.8)];
        line.backgroundColor = MakeColorRGB(0xf3f3f3);
        [self.contentView addSubview:line];
        self.backgroundColor =[UIColor whiteColor];
    }
    return self;
}
-(void)layoutSubviews
{
    [headerView sd_setImageWithURL:[NSURL URLWithString:[MZImageTools shareImageWithImageUrl:_model.avatar imageCutType:ImageUrlCutTypeSmallSize]] placeholderImage:MZ_UserIcon_DefaultImage];
    nameL.text = [MZGlobalTools cutStringWithString:_model.nickname SizeOf:12];
    nameL.width = self.width-nameL.left;
    line.width = self.width;
}
@end

typedef void(^SelectUserHandle)(MZOnlineUserListModel *user);

@interface MZAudienceView ()<UITableViewDataSource,UITableViewDelegate,VHPullingRefreshTableViewDelegate>
{
    MZEmptyView * _emptyView;
    UIView * contentView;
    UILabel*feedBackLabel;
    VHPullingRefreshTableView * _tableView;
    NSString * _channelId;
    int _total;
}
@property (nonatomic, strong)NSString *ticket_id;
@property (nonatomic, copy)void(^action)(NSString * userId);
@property (nonatomic, copy)void(^loadMore)(void(^finish)(NSArray * userList));

@property (nonatomic, copy)SelectUserHandle selectUserHandle;

@end

@implementation MZAudienceView
- (instancetype)initWithFrame:(CGRect )frame
{
    if (self =[super initWithFrame:frame]) {
        CGRect audienceFrame;
        float space = MZ_RATE;
        if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
            space = MZ_FULL_RATE;
            audienceFrame = CGRectMake((self.width -270 * space) / 2,  (self.frame.size.height - 280*space)/2.0, 270 * space, 280 * space);//横屏位置
        } else {
            audienceFrame = CGRectMake(55 * MZ_RATE, (self.frame.size.height - 365*MZ_RATE)/2.0, 265 * MZ_RATE, 365 * MZ_RATE);//竖屏位置
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
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"mz_Close_0422_black"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:closeBtn];

        feedBackLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * space ,docView.center.y -  12.5 * space, contentView.width-40 * space, 25*space)];
        feedBackLabel.text = @"在线观众";
        feedBackLabel.font = [UIFont systemFontOfSize:17*space];
        feedBackLabel.textColor = [UIColor blackColor];
        feedBackLabel.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:feedBackLabel];

        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 50 * space, contentView.width-30, 0.8)];
        lineView.backgroundColor = MakeColorRGB(0xf3f3f3);
        [contentView addSubview:lineView];
        _tableView = [[VHPullingRefreshTableView alloc]initWithFrame:CGRectMake(docView.origin.x, lineView.bottom, contentView.width - 34 * space,  contentView.height - 50 * space)];
        _tableView.pullingDelegate = self;
        _tableView.isHasHead = NO;
        _tableView.isHasFoot = YES;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.dataArr = [[NSMutableArray alloc]init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        UIView* footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , 0)];
        _tableView.tableFooterView= footview;
        [contentView addSubview:_tableView];
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
        
         _emptyView = [[MZEmptyView alloc]initNetErrorViewWithFrame:_tableView.frame clickBlock:^(MZEmptyViewBlockType type) {
             if (type == MZEmptyViewNetErrorType) {
                 [self pullingTableViewDidStartRefreshing:_tableView];
             }
         }];
        [contentView addSubview:_emptyView];
    }
    return self;
}
-(void)showWithView:(UIView *)view withJoinTotal:(int)total
{
    self.frame= view.bounds;
    [view addSubview:self];
    _total = total;
//    feedBackLabel.text = [NSString stringWithFormat:@"参与(%d)",total];
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
-(void)setUserList:(NSArray*)userList withChannelId:(NSString *)chanelId ticket_id:(NSString *)ticket_id selectUserHandle:(void(^)(MZOnlineUserListModel *model))selectUserHandle
{
    self.selectUserHandle = selectUserHandle;
    _channelId = chanelId;
    self.ticket_id = ticket_id;
    _tableView.reachedTheEnd = (userList.count < 20)? YES : NO;
    [_tableView.dataArr addObjectsFromArray:userList];
    [_tableView reloadData];
    if (_tableView.dataArr.count == 0) {
        _emptyView.hidden = NO;
        [_emptyView showNoData];
    }
    else {
        _emptyView.hidden = YES;
    }
    _tableView.hidden = (_tableView.dataArr.count > 0 ? NO : YES);
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableView.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50  ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZOnlineUserListModel * model = _tableView.dataArr[indexPath.row];
    static NSString * identifier = @"MZAudienceCell";
    MZAudienceCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MZAudienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MZOnlineUserListModel *model = _tableView.dataArr[indexPath.row];
    if (self.selectUserHandle) {
        self.selectUserHandle(model);
    }
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(VHPullingRefreshTableView *)tableView
{
}

- (void)pullingTableViewDidStartLoading:(VHPullingRefreshTableView *)tableView
{
    int num = (int)_tableView.dataArr.count;
    [MZSDKBusinessManager reqGetUserList:EmptyForNil(self.ticket_id) offset:num limit:20 success:^(NSArray* responseObject) {
        NSMutableArray *tempArr = responseObject.mutableCopy;
        for (MZOnlineUserListModel* model in responseObject) {
            if(model.uid.longLongValue > 5000000000){//uid大于五十亿是游客
                [tempArr removeObject:model];
            }
        }
        [_tableView.dataArr addObjectsFromArray:tempArr];
        _tableView.reachedTheEnd = (tempArr.count < 20) ? YES : NO;
        [tableView tableViewDidFinishedLoading];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [tableView tableViewDidFinishedLoading];
        [_tableView reloadData];
    }];
    /*
     __weak __typeof(self)weakself = self;
     void(^finish)(NSArray * userList) = ^(NSArray * userList){
     if (userList) {
     [weakself setUserList:userList];
     }
     [tableView tableViewDidFinishedLoading];
     };
     if (self.loadMore) {
     _loadMore(finish);
     }
     */
}

@end
