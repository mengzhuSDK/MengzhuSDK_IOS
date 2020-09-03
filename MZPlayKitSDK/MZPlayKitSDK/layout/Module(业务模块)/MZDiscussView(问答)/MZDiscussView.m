//
//  MZDiscussView.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZDiscussView.h"
#import "MZDiscussCell.h"
#import "MZDiscussSectionView.h"
#import "MZDiscussModel.h"
#import "MZDiscussPresenter.h"

@interface MZDiscussView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGFloat safeBottom;//底部的
@property (nonatomic, assign) BOOL isNewReply;//是否是新回复的数据源
@property (nonatomic,   copy) NSString *ticket_id;//活动Id
@end

@implementation MZDiscussView

- (void)dealloc {
    NSLog(@"问答界面释放了");
}

- (instancetype)initWithFrame:(CGRect)frame ticketId:(NSString *)ticketId {
    self = [super initWithFrame:frame];
    if (self) {
        self.ticket_id = ticketId;
        self.safeBottom = 0;
        self.isNewReply = NO;
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                self.safeBottom = 34.0;
            }
        }
        [self makeView];
    }
    return self;
}

/// 更新未读回复的个数
- (void)updateNoReadReplyMsg:(NSString *)noReadReplMsgCount {
    if (self.topTipButton.selected) return;
    
    int unread = [noReadReplMsgCount intValue];
    [self setTopTipViewToNewMessage:unread];
    [self setTopTipViewIsHidden:(unread > 0 ? NO : YES)];
}

- (void)makeView {
    self.backgroundColor = [UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:1];
    
    [self addSubview:self.topTipButton];
    [self.topTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(32*MZ_RATE));
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topTipButton.mas_bottom);
        make.bottom.equalTo(self).offset(-(self.safeBottom+44*MZ_RATE));
    }];
        
    [self setTopTipViewToNewMessage:0];
    
    [self.tableView addSubview:self.emptyImageView];
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView).offset(72*MZ_RATE);
        make.right.equalTo(self.tableView).offset(-(72*MZ_RATE));
        make.top.equalTo(self.tableView).offset(4*MZ_RATE);
        make.height.equalTo(@(144*MZ_RATE));
    }];
    
    [self.tableView addSubview:self.emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tableView);
        make.top.equalTo(self.tableView).offset(168*MZ_RATE);
        make.height.equalTo(@(20));
    }];
        
    [self addSubview:self.discussInputView];

    [self.tableView.mj_header beginRefreshing];
}

/// 顶部按钮点击事件
- (void)topTipButtonClick {
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    if (self.topTipButton.selected) {
        self.topTipButton.selected = NO;
        [self loadDataIsMore:NO];
    } else {
        self.topTipButton.selected = YES;
        [self loadDataIsMore:NO];
    }
}

/// 提问按钮点击
- (void)sendQuestionIsAnonymous:(BOOL)isAnonymous question:(NSString *)question {
    if (question.length <= 0) {
        [self show:@"请输入提问问题"];
        return;
    }
    
    [MZDiscussPresenter submitDiscussWithTicketId:self.ticket_id content:question isAnonymous:isAnonymous success:^(id  _Nonnull responseObject) {
        self.topTipButton.selected = NO;
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [self loadDataIsMore:NO];
    } failure:^(NSError * _Nonnull error) {
        [self show:error.domain];
    }];
}

/// 更新顶部按钮的文字提示
- (void)setTopTipViewToNewMessage:(int)newMessageCount {
    if (self.topTipButton.selected) {
        [self setTopTipViewIsHidden:NO];
        [self.topTipButton setTitle:@"查看全部提问" forState:UIControlStateNormal];
        [self.topTipButton setImage:nil forState:UIControlStateNormal];
    } else {
        [self setTopTipViewIsHidden:!newMessageCount];

        [self.topTipButton setTitle:[NSString stringWithFormat:@" 您有新的回复(%d)",newMessageCount] forState:UIControlStateNormal];
        [self.topTipButton setImage:[UIImage imageNamed:@"mz_discuss_newReply"] forState:UIControlStateNormal];
    }
}

/// 更新顶部的消息提示View
- (void)setTopTipViewIsHidden:(BOOL)isHidden {
    if (isHidden) {
        [self.topTipButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    } else {
        [self.topTipButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(32*MZ_RATE));
        }];
    }
}

/// 更新是否隐藏空界面
- (void)setEmptyIsHidden:(BOOL)isHidden {
    [self.emptyImageView setHidden:isHidden];
    [self.emptyLabel setHidden:isHidden];
}

/// 加载数据
- (void)loadDataIsMore:(BOOL)isMore {
    [self showHud];
    BOOL isRequestReplyMessage = self.topTipButton.selected;//按钮的选中状态只用来请求数据使用
    NSInteger limit = 50; NSInteger offset = 0;
    if (isMore) {
        if (isRequestReplyMessage) offset = self.replyArray.count;
        else offset = self.dataArray.count;
    }
    
    [MZDiscussPresenter getDiscussListWithTicketId:self.ticket_id isNewReply:isRequestReplyMessage offset:offset limit:limit success:^(id  _Nonnull responseObject) {
        [self hideHud];
        NSArray *tempArray = [MZDiscussModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
     
        if (!isMore) {
            if (isRequestReplyMessage) {
                self.replyArray = tempArray.mutableCopy;
                self.isNewReply = YES;
                [self.tableView reloadData];
                [self.dataArray removeAllObjects];
                [self setEmptyIsHidden:self.replyArray.count];
                [self setTopTipViewToNewMessage:0];
                [self setTopTipViewIsHidden:NO];
            } else {
                self.dataArray = tempArray.mutableCopy;
                self.isNewReply = NO;
                [self.tableView reloadData];
                [self.replyArray removeAllObjects];
                [self setEmptyIsHidden:self.dataArray.count];
                int unread = [responseObject[@"unread"] intValue];
                [self setTopTipViewToNewMessage:unread];
                [self setTopTipViewIsHidden:(unread > 0 ? NO : YES)];
            }
            [self.tableView.mj_header endRefreshing];
            if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.tableView.mj_footer resetNoMoreData];
            }
        } else {
            if (tempArray.count < limit) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            if (isRequestReplyMessage) {
                [self.replyArray addObjectsFromArray:tempArray];
                [self.tableView reloadData];
            } else {
                [self.dataArray addObjectsFromArray:tempArray];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isNewReply) {
        return self.replyArray.count;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MZDiscussModel *discuss = nil;
    if (self.isNewReply) {
        discuss = self.replyArray[section];
    } else {
        discuss = self.dataArray[section];
    }
    return discuss.replys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    MZDiscussModel *discuss = nil;
    if (self.isNewReply) {
        discuss = self.replyArray[section];
    } else {
        discuss = self.dataArray[section];
    }
    return [MZDiscussSectionView getSectionHeaderHeight:discuss];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MZDiscussModel *discuss = nil;
    if (self.isNewReply) {
        discuss = self.replyArray[section];
    } else {
        discuss = self.dataArray[section];
    }
    MZDiscussSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MZDiscussSectionView"];
    [sectionView update:discuss];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZDiscussModel *discuss = nil;
    if (self.isNewReply) {
        discuss = self.replyArray[indexPath.section];
    } else {
        discuss = self.dataArray[indexPath.section];
    }
    MZDiscussReplyModel *reply = discuss.replys[indexPath.row];
    return [MZDiscussCell getRowHeight:reply];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZDiscussModel *discuss = nil;
    if (self.isNewReply) {
        discuss = self.replyArray[indexPath.section];
    } else {
        discuss = self.dataArray[indexPath.section];
    }
    MZDiscussReplyModel *reply = discuss.replys[indexPath.row];
    
    MZDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZDiscussCell"];
    [cell update:reply];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MZDiscussCell class] forCellReuseIdentifier:@"MZDiscussCell"];
        [_tableView registerClass:[MZDiscussSectionView class] forHeaderFooterViewReuseIdentifier:@"MZDiscussSectionView"];

        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.sectionHeaderHeight = 0.01;
        _tableView.sectionFooterHeight = 0.01;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        WeaklySelf(weakSelf);
        MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weakSelf.topTipButton.selected) {//未查看回复界面不允许刷新请求数据
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.tableView.mj_header endRefreshing];
                });
                return;
            }
            [weakSelf loadDataIsMore:NO];
        }];
        [mjHeader setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        self.tableView.mj_header = mjHeader;
        
        MJRefreshBackNormalFooter *mjFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.topTipButton.selected) {//未查看回复界面不允许刷新请求数据
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                });
                return;
            }
            [weakSelf loadDataIsMore:YES];
        }];
        [mjFooter setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        self.tableView.mj_footer = mjFooter;
    }
    return _tableView;
}

- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _emptyImageView.backgroundColor = [UIColor clearColor];
        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        _emptyImageView.image = [UIImage imageNamed:@"mz_discuss_nodata"];
        [_emptyImageView setHidden:YES];
    }
    return _emptyImageView;
}

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _emptyLabel.backgroundColor = [UIColor clearColor];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
        _emptyLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _emptyLabel.text = @"还没有人提问";
        [_emptyLabel setHidden:YES];
    }
    return _emptyLabel;
}

- (MZDiscussInputView *)discussInputView {
    if (!_discussInputView) {
        WeaklySelf(weakSelf);
        _discussInputView = [[MZDiscussInputView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.safeBottom - 44*MZ_RATE, self.frame.size.width, 44*MZ_RATE) sendHandle:^(BOOL isAnonymous, NSString * _Nonnull question) {
            [weakSelf sendQuestionIsAnonymous:isAnonymous question:question];
        }];
        _discussInputView.backgroundColor = [UIColor blackColor];
    }
    return _discussInputView;
}

- (UIButton *)topTipButton {
    if (!_topTipButton) {
        _topTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topTipButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:29/255.0 blue:92/255.0 alpha:1]];
        [_topTipButton setImage:[UIImage imageNamed:@"mz_discuss_newReply"] forState:UIControlStateNormal];
        [_topTipButton setTitle:@" 您有新的回复" forState:UIControlStateNormal];
        _topTipButton.titleLabel.font = [UIFont systemFontOfSize:12*MZ_RATE];
        [_topTipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_topTipButton addTarget:self action:@selector(topTipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _topTipButton.clipsToBounds = YES;
    }
    return _topTipButton;
}

@end
