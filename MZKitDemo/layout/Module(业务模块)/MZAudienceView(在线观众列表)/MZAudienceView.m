//
//  MZAudienceView.m
//  MengZhu
//
//  Created by vhall on 16/6/24.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.


#import "MZAudienceView.h"
#import "MZEmptyView.h"
#import "MZImageTools.h"

#import "MZAudiencePresenter.h"

#pragma mark - 在线观众的自定义Cell

@interface MZAudienceCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headerView;//头像
@property (nonatomic, strong) UILabel *nameL;//名字
@property (nonatomic, strong) UIView *line;//线
@property (nonatomic, strong) MZOnlineUserListModel *model;//用户模型
@end
@implementation MZAudienceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor =[UIColor whiteColor];
        self.contentView.backgroundColor =[UIColor whiteColor];

        self.headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
        self.headerView.layer.masksToBounds = YES;
        self.headerView.layer.cornerRadius = 15;
        [self.contentView addSubview:self.headerView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 200, 20)];
        self.nameL.textColor = [UIColor blackColor];
        self.nameL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.nameL];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.2, self.width, 0.8)];
        self.line.backgroundColor = MakeColorRGB(0xf3f3f3);
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)setModel:(MZOnlineUserListModel *)model {
    _model = model;
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:[MZImageTools shareImageWithImageUrl:_model.avatar imageCutType:ImageUrlCutTypeSmallSize]] placeholderImage:MZ_UserIcon_DefaultImage];
    self.nameL.text = [MZGlobalTools cutStringWithString:_model.nickname SizeOf:12];
}

- (void)layoutSubviews {
    self.nameL.width = self.width-self.nameL.left;
    self.line.width = self.width;
}

@end

#pragma mark - 在线观众的View

/// 选中某一个在线观众的回调
typedef void(^SelectUserHandle)(MZOnlineUserListModel *user);
/// 退出的回调
typedef void(^CloseHandle)(void);

@interface MZAudienceView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray <MZOnlineUserListModel *> *dataArray;//数据源
@property (nonatomic, strong) MZEmptyView *emptyView;//空白提示View

@property (nonatomic,   copy) NSString *ticket_id;//活动凭证ID
@property (nonatomic,   copy) NSString *chatIdOfMe;//我自己在直播间里的ID

@property (nonatomic,   copy) SelectUserHandle selectUserHandle;//选中某一个在线观众的回调
@property (nonatomic,   copy) CloseHandle closeHandle;//选中某一个在线观众的回调

@end

@implementation MZAudienceView

- (void)dealloc {
    NSLog(@"在线观众列表释放");
}

- (instancetype)initWithFrame:(CGRect)frame
                    ticket_id:(NSString *)ticket_id
                  chat_idOfMe:(NSString *)chat_idOfMe
             selectUserHandle:(void(^)(MZOnlineUserListModel *userModel))selectUserHandle
                  closeHandle:(void(^)(void))closeHandle {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];

        self.ticket_id = ticket_id;
        self.chatIdOfMe = chat_idOfMe;
        self.selectUserHandle = selectUserHandle;
        self.closeHandle = closeHandle;
        
        CGRect audienceFrame;
        float space = MZ_RATE;
        if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
            space = MZ_FULL_RATE;
            audienceFrame = CGRectMake((self.width -270 * space) / 2,  (self.frame.size.height - 280*space)/2.0, 270 * space, 280 * space);//横屏位置
        } else {
            audienceFrame = CGRectMake(55 * MZ_RATE, (self.frame.size.height - 365*MZ_RATE)/2.0, 265 * MZ_RATE, 365 * MZ_RATE);//竖屏位置
        }
        self.bgView = [[UIView alloc] initWithFrame:audienceFrame];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 3;
        self.bgView.layer.borderColor = MakeColorRGB(0xd3d5d7).CGColor;
        self.bgView.layer.borderWidth = 1;
        [self addSubview:self.bgView];

        self.dotView = [[UIView alloc]initWithFrame:CGRectMake(17 * space, 23 * space, 7 * space,7*space)];
        self.dotView.backgroundColor = MakeColorRGB(0xff5b29);
        self.dotView.layer.masksToBounds = YES;
        self.dotView.layer.cornerRadius = self.dotView.height / 2.0;
        [self.bgView addSubview:self.dotView];
        
        self.closeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bgView.width - 40 * space ,self.dotView.center.y - 10 * space, 20 * space, 20 * space)];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"mzClose_0710_black"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.closeButton];

        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * space ,self.dotView.center.y -  12.5 * space, self.bgView.width-40 * space, 25*space)];
        self.titleLabel.text = @"在线观众";
        self.titleLabel.font = [UIFont systemFontOfSize:17*space];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.bgView addSubview:self.titleLabel];

        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 50 * space, self.bgView.width-30, 0.8)];
        self.lineView.backgroundColor = MakeColorRGB(0xf3f3f3);
        [self.bgView addSubview:self.lineView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.dotView.origin.x, self.lineView.bottom, self.bgView.width - 34 * space,  self.bgView.height - 50 * space) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        UIView* footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , 0)];
        _tableView.tableFooterView= footview;
        
        [self.bgView addSubview:_tableView];
        
        WeaklySelf(weakSelf);

        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataIsMore:NO];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataIsMore:YES];
        }];
                
        self.emptyView = [[MZEmptyView alloc] initNetErrorViewWithFrame:_tableView.frame clickBlock:^(MZEmptyViewBlockType type) {
             if (type == MZEmptyViewNetErrorType) {
                 [weakSelf loadDataIsMore:NO];
             }
         }];
        [self.bgView addSubview:self.emptyView];
        [self.emptyView setHidden:YES];
        
        [self loadDataIsMore:NO];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.bgView];
    if (point.x<0||point.y<0||point.x>self.bgView.width||point.y>self.bgView.height) {
        [self dismiss];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.closeHandle) {
            self.closeHandle();
        }
        [self removeFromSuperview];
    }];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZOnlineUserListModel * model = self.dataArray[indexPath.row];
    static NSString * identifier = @"MZAudienceCell";
    MZAudienceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MZAudienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MZOnlineUserListModel *model = self.dataArray[indexPath.row];
    if (self.selectUserHandle) {
        self.selectUserHandle(model);
    }
}

#pragma mark - 加载最新/加载更多
- (void)loadDataIsMore:(BOOL)isMore {
    NSInteger offset = self.dataArray.count;
    if (isMore == NO) {
        offset = 0;
    }
    
    [MZSDKBusinessManager reqGetUserList:EmptyForNil(self.ticket_id) offset:offset limit:50 success:^(NSArray* responseObject) {
        NSMutableArray <MZOnlineUserListModel *>*tempArr = responseObject.mutableCopy;
        for (MZOnlineUserListModel* model in responseObject) {
            if(model.uid.longLongValue > 5000000000){//uid大于五十亿是游客
                [tempArr removeObject:model];
            }
        }
        
        if (offset == 0) {
            self.dataArray = tempArr;
            
            // 判断自己在没在，没在的话，把自己加上
            __block BOOL isHasMe = NO;
            [self.dataArray enumerateObjectsUsingBlock:^(MZOnlineUserListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.uid isEqualToString:self.chatIdOfMe]) {
                    isHasMe = YES;
                }
            }];
            
            if (isHasMe == NO) {
                MZOnlineUserListModel *meModel = [[MZOnlineUserListModel alloc] init];
                
                MZUser *user = [MZUserServer currentUser];
                
                meModel.nickname = user.nickName;
                meModel.avatar = user.avatar;
                meModel.uid = self.chatIdOfMe;
                meModel.unique_id = user.uniqueID;
                
                [self.dataArray addObject:meModel];
            }
            
        } else {
            [tempArr enumerateObjectsUsingBlock:^(MZOnlineUserListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.uid isEqualToString:self.chatIdOfMe]) {
                    [tempArr removeObject:obj];
                    *stop = YES;
                }
            }];
            
            [self.dataArray addObjectsFromArray:tempArr];
        }
        
        [self.tableView reloadData];
        if (offset == 0) {
            [self.tableView.mj_header endRefreshing];
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
        } else {
            if (responseObject.count < 50) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
        if (self.dataArray.count == 0) {
            self.emptyView.hidden = NO;
            [self.emptyView showNoData];
            self.tableView.hidden = YES;
        } else {
            self.emptyView.hidden = YES;
            self.tableView.hidden = NO;
        }
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSMutableArray<MZOnlineUserListModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

/**
 * @brief 获取直播间前50位观众,用于显示右上侧的在线人头列表
 *
 * @param ticket_id 活动凭证ID
 * @param chat_idOfMe 自己再直播间的ID
 */
+ (void)getOnlineUsersWithTicket_id:(NSString *)ticket_id
                        chat_idOfMe:(NSString *)chat_idOfMe
                           finished:(void(^)(NSArray <MZOnlineUserListModel *> *onlineUsers))finished
                             failed:(void (^)(NSString *))failed {

    [MZAudiencePresenter getOnlineUsersWithTicket_id:ticket_id chat_idOfMe:chat_idOfMe finished:finished failed:failed];
}


@end
