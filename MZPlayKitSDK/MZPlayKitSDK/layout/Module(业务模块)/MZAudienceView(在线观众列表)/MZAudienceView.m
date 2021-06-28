//
//  MZAudienceView.m
//  MengZhu
//
//  Created by vhall on 16/6/24.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.


#import "MZAudienceView.h"
#import "MZAudienceCell.h"

#import "MZAudiencePresenter.h"

#import "MZKickoutManagerView.h"
#import "MZBlockManagerView.h"

/// 选中某一个在线观众的回调
typedef void(^SelectUserHandle)(MZOnlineUserListModel *user);
/// 退出的回调
typedef void(^CloseHandle)(void);

@interface MZAudienceView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray <MZOnlineUserListModel *> *dataArray;//数据源

@property (nonatomic,   copy) NSString *channel_id;//频道ID
@property (nonatomic,   copy) NSString *ticket_id;//活动凭证ID
@property (nonatomic,   copy) NSString *chatIdOfMe;//我自己在直播间里的ID

@property (nonatomic,   copy) SelectUserHandle selectUserHandle;//选中某一个在线观众的回调
@property (nonatomic,   copy) CloseHandle closeHandle;//选中某一个在线观众的回调

@property (nonatomic, strong) MZKickoutManagerView *kickoutManagerView;
@property (nonatomic, strong) MZBlockManagerView *blockManagerView;

@property (nonatomic, strong) UIButton *onlineButton;
@property (nonatomic, strong) UIButton *kickoutManagerButton;
@property (nonatomic, strong) UIButton *blockManagerButton;

@property (nonatomic, strong) UIView *lineTip;
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮

@property (nonatomic, assign) BOOL isLiveHost;//是否是直播主播端

@end

@implementation MZAudienceView

- (void)dealloc {
    NSLog(@"在线观众列表释放");
}

- (instancetype)initWithFrame:(CGRect)frame
                    ticket_id:(NSString *)ticket_id
                   channel_id:(NSString *)channel_id
                  chat_idOfMe:(NSString *)chat_idOfMe
                   isLiveHost:(BOOL)isLiveHost
             selectUserHandle:(void(^)(MZOnlineUserListModel *userModel))selectUserHandle
                  closeHandle:(void(^)(void))closeHandle {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];

        self.isLiveHost = isLiveHost;
        self.channel_id = channel_id;
        self.ticket_id = ticket_id;
        self.chatIdOfMe = chat_idOfMe;
        self.selectUserHandle = selectUserHandle;
        self.closeHandle = closeHandle;
        
        CGRect audienceFrame;
        float space = MZ_RATE;
        if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
            space = MZ_FULL_RATE;
            audienceFrame = CGRectMake((self.width -self.frame.size.height) / 2.0,  self.frame.size.height - 308*space, self.frame.size.height, 308 * space);//横屏位置
        } else {
            audienceFrame = CGRectMake(0, self.frame.size.height - 308*MZ_RATE, self.frame.size.width, 308 * MZ_RATE);//竖屏位置
        }
        self.bgView = [[UIView alloc] initWithFrame:audienceFrame];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 12;
        [self addSubview:self.bgView];
        
        self.onlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.onlineButton setBackgroundColor:[UIColor clearColor]];
        [self.onlineButton setTitle:@"在线观众" forState:UIControlStateNormal];
        [self.onlineButton setTitleColor:MakeColor(153, 153, 153, 1) forState:UIControlStateNormal];
        [self.onlineButton setTitleColor:MakeColor(255, 31, 96, 1) forState:UIControlStateSelected];
        self.onlineButton.selected = YES;
        [self.onlineButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        self.onlineButton.frame = CGRectMake(0, 0, 96, 44);
        self.onlineButton.tag = 0;
        [self.onlineButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.onlineButton];
        
        self.kickoutManagerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.kickoutManagerButton setBackgroundColor:[UIColor clearColor]];
        [self.kickoutManagerButton setTitle:@"踢出管理" forState:UIControlStateNormal];
        [self.kickoutManagerButton setTitleColor:MakeColor(153, 153, 153, 1) forState:UIControlStateNormal];
        [self.kickoutManagerButton setTitleColor:MakeColor(255, 31, 96, 1) forState:UIControlStateSelected];
        [self.kickoutManagerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        self.kickoutManagerButton.frame = CGRectMake(96, 0, 96, 44);
        self.kickoutManagerButton.tag = 1;
        [self.kickoutManagerButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isLiveHost) {
            [self.bgView addSubview:self.kickoutManagerButton];
        }
        
        self.blockManagerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.blockManagerButton setBackgroundColor:[UIColor clearColor]];
        [self.blockManagerButton setTitle:@"禁言管理" forState:UIControlStateNormal];
        [self.blockManagerButton setTitleColor:MakeColor(153, 153, 153, 1) forState:UIControlStateNormal];
        [self.blockManagerButton setTitleColor:MakeColor(255, 31, 96, 1) forState:UIControlStateSelected];
        [self.blockManagerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        self.blockManagerButton.frame = CGRectMake(96*2, 0, 96, 44);
        self.blockManagerButton.tag = 2;
        [self.blockManagerButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isLiveHost) {
            [self.bgView addSubview:self.blockManagerButton];
        }
        
        self.lineTip = [MZCreatUI viewWithBackgroundColor:MakeColor(255, 31, 96, 1)];
        self.lineTip.frame = CGRectMake(40, 42, 16, 2);
        
        if (self.isLiveHost) {
            [self.bgView addSubview:self.lineTip];
        }
        
        self.closeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bgView.width - 44, 0, 44, 44)];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"mzClose_0710_black"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.closeButton];

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.closeButton.bottom, self.bgView.width,  self.bgView.height - self.closeButton.bottom) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        CGFloat bottomView = IPHONE_X ? 34.0 : 0;

        UIView* footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, bottomView)];
        _tableView.tableFooterView= footview;
        
        [self.bgView addSubview:_tableView];
        
        WeaklySelf(weakSelf);

        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataIsMore:NO];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataIsMore:YES];
        }];
                
        [self loadDataIsMore:NO];

        self.kickoutManagerView = [[MZKickoutManagerView alloc] initWithFrame:_tableView.frame ticket_id:self.ticket_id channel_id:self.channel_id chatIdOfMe:self.chatIdOfMe];
        [self.kickoutManagerView setHidden:YES];
        
        if (self.isLiveHost) {
            [self.bgView addSubview:self.kickoutManagerView];
        }
        
        self.blockManagerView = [[MZBlockManagerView alloc] initWithFrame:_tableView.frame ticket_id:self.ticket_id channel_id:self.channel_id chatIdOfMe:self.chatIdOfMe onlineUserTableView:self.tableView];
        [self.blockManagerView setHidden:YES];
        
        if (self.isLiveHost) {
            [self.bgView addSubview:self.blockManagerView];
        }
    }
    return self;
}

- (void)menuClick:(UIButton *)sender {
    [self setActivityIndex:sender.tag];
    [UIView animateWithDuration:0.3 animations:^{
        self.lineTip.frame = CGRectMake(40+(96*(sender.tag)), 42, 16, 2);
    }];

    switch (sender.tag) {
        case 0:
        {
            self.onlineButton.selected = YES;
            self.blockManagerButton.selected = NO;
            self.kickoutManagerButton.selected = NO;
            [self.onlineButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [self.blockManagerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [self.kickoutManagerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            break;
        }
        case 1:
        {
            self.onlineButton.selected = NO;
            self.blockManagerButton.selected = NO;
            self.kickoutManagerButton.selected = YES;
            [self.onlineButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [self.blockManagerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [self.kickoutManagerButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 2:
        {
            self.onlineButton.selected = NO;
            self.blockManagerButton.selected = YES;
            self.kickoutManagerButton.selected = NO;
            [self.onlineButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [self.blockManagerButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [self.kickoutManagerButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            break;
        }
        default:
            break;
    }
}

- (void)setActivityIndex:(NSInteger)index {
    [self.tableView setHidden:index == 0 ? NO : YES];
    [self.kickoutManagerView setHidden:index == 1 ? NO : YES];
    [self.blockManagerView setHidden:index == 2 ? NO : YES];
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

- (void)kickoutButtonClick:(UIButton *)sender {
    MZOnlineUserListModel *model = self.dataArray[sender.tag];

    [MZSDKSimpleHud show];
    [MZSDKBusinessManager kickoutUserWithTicketId:self.ticket_id channelId:self.channel_id uid:model.uid isKickout:YES success:^(id response) {
        [MZSDKSimpleHud hide];
        [self show:@"踢出成功"];
        [self.dataArray removeObjectAtIndex:sender.tag];
        [self.tableView reloadData];
        [self.kickoutManagerView updateData];
    } failure:^(NSError *error) {
        [MZSDKSimpleHud hide];
        [self show:error.domain];
    }];
}

- (void)blockButtonClick:(UIButton *)sender {
    MZOnlineUserListModel *model = self.dataArray[sender.tag];
    
    [MZSDKSimpleHud show];
    [MZSDKBusinessManager bannedOrUnBannedUserWithTicketId:self.ticket_id uid:model.uid isBanned:YES success:^(id response) {
        [MZSDKSimpleHud hide];
        [self show:@"禁言成功"];
        model.is_gag = 1;
        [self.tableView reloadData];
        [self.blockManagerView updateData];
    } failure:^(NSError *error) {
        [MZSDKSimpleHud hide];
        [self show:error.domain];
    }];
}

- (void)unBlockButtonClick:(UIButton *)sender {
    MZOnlineUserListModel *model = self.dataArray[sender.tag];
    
    [MZSDKSimpleHud show];
    [MZSDKBusinessManager bannedOrUnBannedUserWithTicketId:self.ticket_id uid:model.uid isBanned:NO success:^(id response) {
        [MZSDKSimpleHud hide];
        [self show:@"解除禁言成功"];
        model.is_gag = 0;
        [self.tableView reloadData];
        [self.blockManagerView updateData];
    } failure:^(NSError *error) {
        [MZSDKSimpleHud hide];
        [self show:error.domain];
    }];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZOnlineUserListModel * model = self.dataArray[indexPath.row];
    static NSString * identifier = @"MZAudienceCell";
    MZAudienceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MZAudienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setModel:model type:0 chatIdOfMe:self.chatIdOfMe isLiveHost:self.isLiveHost];
    cell.kickoutButton.tag = indexPath.row;
    cell.unKickoutButton.tag = indexPath.row;
    cell.blockButton.tag = indexPath.row;
    cell.unBlockButton.tag = indexPath.row;
    [cell.kickoutButton addTarget:self action:@selector(kickoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.blockButton addTarget:self action:@selector(blockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.unBlockButton addTarget:self action:@selector(unBlockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

//    // 这里是回调到父类点击了用户信息，暂时没用，注销掉
//    MZOnlineUserListModel *model = self.dataArray[indexPath.row];
//    if (self.selectUserHandle) {
//        self.selectUserHandle(model);
//    }
}

#pragma mark - 加载最新/加载更多
- (void)loadDataIsMore:(BOOL)isMore {
    NSInteger offset = self.dataArray.count;
    if (isMore == NO) {
        offset = 0;
    }
    NSInteger limit = 200;
    
    [MZSDKBusinessManager reqGetUserList:EmptyForNil(self.ticket_id) offset:offset limit:limit success:^(NSArray* responseObject) {
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
                
                MZUser *user = [MZBaseUserServer currentUser];
                
                meModel.nickname = user.nickName;
                meModel.avatar = user.avatar;
                meModel.uid = self.chatIdOfMe;
                meModel.unique_id = user.uniqueID;
                meModel.is_gag = 0;
                
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
            if (self.dataArray.count < limit) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            if (responseObject.count < limit) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
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
