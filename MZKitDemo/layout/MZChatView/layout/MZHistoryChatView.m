//
//  MZHistoryChatView.m
//  MZKitDemo
//
//  Created by LiWei on 2019/10/9.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZHistoryChatView.h"
#import "MZChatTableViewCell.h"
#import "MZOnlineTipView.h"


@interface MZHistoryChatView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic ,strong)UITableView *chatTable;
@property (nonatomic ,strong)NSMutableArray *tempArr;
@property (nonatomic ,assign)NSInteger refreshTag;//是否刷新新数据 ;
@property (nonatomic,assign) int loadOldCount;
@property (nonatomic,assign) int onlineCountDownNum;
@property (nonatomic ,strong)NSTimer *onlineTipTimer;
@property (nonatomic ,strong)MZOnlineTipView *onlineIconBtn;
@property (nonatomic,assign) BOOL isTabInBottom;//当前聊天是否在底部
@property (nonatomic,assign) CGFloat oldOffset;
@end
@implementation MZHistoryChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.autoresizesSubviews = YES;
        self.loadOldCount = 0;
        self.isTabInBottom = YES;
    }
    return self;
}

-(void)setupUI
{
    WeaklySelf(weakSelf);
    _chatTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        _chatTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _chatTable.backgroundColor = [UIColor clearColor];
    _chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTable.delegate = self;
    _chatTable.dataSource = self;
    _chatTable.estimatedRowHeight = 0;
    _chatTable.estimatedSectionHeaderHeight = 10*MZ_RATE;
    _chatTable.estimatedSectionFooterHeight = 0;
    [self addSubview:_chatTable];
    [self setSubViewAutoresizingMask:_chatTable];
}

-(void)setSubViewAutoresizingMask:(UIView *)view
{
    view.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin   |
    UIViewAutoresizingFlexibleWidth        |
    UIViewAutoresizingFlexibleRightMargin  |
    UIViewAutoresizingFlexibleTopMargin    |
    UIViewAutoresizingFlexibleHeight       |
    UIViewAutoresizingFlexibleBottomMargin ;
}

-(void)setActivity:(MZMoviePlayerModel *)activity
{
    _activity = activity;
    [self loadDataIsMore:NO];
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    WeaklySelf(weakSelf);
    if (self.refreshTag == 1) {
        _loadOldCount ++;
        MZLongPollDataModel*dataModel = [_dataArray firstObject];
        _chatTable.userInteractionEnabled = NO;
        //拉去的20条有可能会与以前的重复，所以需要去重
        __weak typeof(self)weakSelf = self;
        _chatTable.userInteractionEnabled = YES;
        if(!_activity || !dataModel)
            return;
        
        [MZSDKBusinessManager reqChatHistoryWith:self.activity.ticket_id offset:self.dataArray.count limit:20 last_id:dataModel.id success:^(id responseObject) {
            weakSelf.chatTable.userInteractionEnabled = YES;
            NSMutableArray *ary = [NSMutableArray array];
//            for (NSDictionary* dict in responseObject) {
//
//                MZLongPollDataModel *dataModel = [MZLongPollDataModel initWithChatHistoryDict:dict];
//                for (MZLongPollDataModel *oldDataModel in weakSelf.dataArray) {
//                    if([dataModel.id isEqualToString:oldDataModel.id]){
//                        dataModel =nil;
//                    }
//                }
//                if(dataModel){
//                    [ary addObject:dataModel];
//                }
//            }
//            if(ary.count==0){
//                [weakSelf showTextView:self message:@"没有更多消息了"];
//                return ;
//            }
            weakSelf.chatTable.userInteractionEnabled = YES;
            NSMutableArray *TEMPArr =responseObject;
            float height1 = weakSelf.chatTable.contentSize.height;
            [weakSelf.dataArray insertObjects:TEMPArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, TEMPArr.count)]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [scrollView setContentOffset:CGPointMake(0, 0)];
                [weakSelf.chatTable reloadData];
                float height2 = weakSelf.chatTable.contentSize.height;
                float difference = height2-height1;
                [weakSelf.chatTable setContentOffset:CGPointMake(0, difference)];
                
            });
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.oldOffset  = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
//    当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了
    if(currentOffset >= maximumOffset){
        self.isTabInBottom = YES;
    }
    if(scrollView.contentOffset.y < self.oldOffset){//向上滑动
        self.isTabInBottom = NO;
    }
    if (scrollView.contentOffset.y<= -30) {
        _refreshTag = 1;
    }else{
        _refreshTag = 0;
    }
}

//聊天区域添加数据
-(void)addChatData:(MZLongPollDataModel *)dataModel
{
    WeaklySelf(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        //           上线消息提示
        if(dataModel.event == MsgTypeOnline){
            weakSelf.onlineIconBtn.frame = CGRectMake(-self.onlineIconBtn.width, - 10*MZ_RATE - 26*MZ_RATE, self.onlineIconBtn.width, self.onlineIconBtn.height);
            weakSelf.onlineIconBtn.title = dataModel.userName;
            weakSelf.onlineIconBtn.tagData = dataModel;
            if(weakSelf.onlineCountDownNum <= 0 ){
                weakSelf.onlineCountDownNum = 3;
                weakSelf.onlineIconBtn.hidden = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    weakSelf.onlineIconBtn.frame = CGRectMake(15*MZ_RATE, weakSelf.onlineIconBtn.top, weakSelf.onlineIconBtn.width, weakSelf.onlineIconBtn.height);
                } completion:^(BOOL finished) {
                    weakSelf.onlineIconBtn.frame = CGRectMake(15*MZ_RATE, weakSelf.onlineIconBtn.top, weakSelf.onlineIconBtn.width, weakSelf.onlineIconBtn.height);
                    if(!weakSelf.onlineTipTimer){
                        [weakSelf addOnlineTimer];
                    }
                }];
            }else{
                weakSelf.onlineCountDownNum = 3;
            }
        }else{
            if(weakSelf.dataArray.count == 0){
                [weakSelf.dataArray addObject:dataModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.chatTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                });
                
            }else{
                //重复数据不予加入
                if(![weakSelf arrayContainsObject:dataModel]){
                    [weakSelf.dataArray addObject:dataModel];
                    if ([dataModel.userId isEqualToString:[MZUserServer currentUser].userId]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf reloadData];
                            NSInteger totleIndex = [weakSelf.chatTable numberOfRowsInSection:0];
                            if(totleIndex > 0){
                                NSInteger lastRowIndex = totleIndex - 1;
                                [weakSelf.chatTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastRowIndex inSection:0]animated:YES scrollPosition:UITableViewScrollPositionBottom];
                                [weakSelf scrollViewToBottom];
                            }
                        });
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(weakSelf.isTabInBottom){//底部
                                [weakSelf reloadData];
                                NSInteger totleIndex = [weakSelf.chatTable numberOfRowsInSection:0];
                                if(totleIndex > 0){
                                    NSInteger lastRowIndex = totleIndex - 1;
                                    [weakSelf.chatTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastRowIndex inSection:0]animated:YES scrollPosition:UITableViewScrollPositionBottom];
                                    [weakSelf scrollViewToBottom];
                                }
                            }else{
                                float height1 = weakSelf.chatTable.contentSize.height;
                                CGPoint contentOffset = weakSelf.chatTable.contentOffset;
                                [weakSelf reloadData];
                                float height2 = weakSelf.chatTable.contentSize.height;
                                weakSelf.chatTable.contentSize = CGSizeMake(0, height2);
                                weakSelf.chatTable.contentOffset = CGPointMake(0,contentOffset.y + height2 - height1);
                            }
                        });
                        
                    }
                }
            }
            
        }
    });
    
}
//添加上线提醒的倒计时
-(void)addOnlineTimer
{
    _onlineCountDownNum = 3 ;
    if(!_onlineTipTimer){
        _onlineTipTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onlineTipTimerDidRepeat) userInfo:nil repeats:YES];
        //这里当前的runloop是主线程的，如果不设置mode，则主线程的操作会延迟定时器
        [[NSRunLoop currentRunLoop] addTimer:_onlineTipTimer forMode:NSRunLoopCommonModes];
    }
}
-(void)onlineTipTimerDidRepeat
{
    //    CGFloat iphonXH = 0;
    //    if(IPHONE_X && _activity.status == 0){
    //        iphonXH = 34;
    //    }
    __weak typeof(self)weakSelf = self;
//    NSLog(@"onlineCountDownNum %d",_onlineCountDownNum);
    _onlineCountDownNum = _onlineCountDownNum - 1;
    if(_onlineCountDownNum <= 0){
        if(!_onlineIconBtn.hidden){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.onlineIconBtn.frame = CGRectMake(-self.onlineIconBtn.width, weakSelf.onlineIconBtn.top, self.onlineIconBtn.width, self.onlineIconBtn.height);
                } completion:^(BOOL finished) {
                    weakSelf.onlineIconBtn.frame = CGRectMake(-self.onlineIconBtn.width, weakSelf.onlineIconBtn.top, self.onlineIconBtn.width, self.onlineIconBtn.height);
                    weakSelf.onlineIconBtn.hidden = YES;
                }];
            });
        }
    }
}

-(BOOL)arrayContainsObject:(MZLongPollDataModel *)data{
    for(MZLongPollDataModel *model in _dataArray){
        if([model isEqual:data]){
            return YES;
        }
    }
    
    return NO;
}

#pragma 获取历史消息数据
-(void)loadDataIsMore:(BOOL)isMore
{
    __weak __typeof(self)weakSelf = self;
//    self.activity.ticket_id
    
    [MZSDKBusinessManager reqChatHistoryWith:self.activity.ticket_id offset:self.dataArray.count limit:20 last_id:nil success:^(NSMutableArray *responseObject) {
        [weakSelf afterLoadData:responseObject isMore:isMore];
    } failure:^(NSError *error) {
        
    }];
}

-(void)afterLoadData:(NSMutableArray *)result isMore:(BOOL)isMore
{
    if (![result isKindOfClass:[NSArray class]] || [result isKindOfClass:[NSNull class]] || result == nil) {
        return;
    }
    _tempArr = result;
    _chatTable.userInteractionEnabled = YES;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _tempArr.count)];
    [self.dataArray insertObjects:_tempArr atIndexes:indexSet];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatTable reloadData];
        [self scrollViewToBottom];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.chatTable reloadData];
        [self scrollViewToBottom];
    });
}

-(NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)scrollViewToBottom
{
    if (_chatTable.contentSize.height > _chatTable.height)
    {
        CGPoint offset = CGPointMake(0, _chatTable.contentSize.height -_chatTable.height);
        [_chatTable setContentOffset:offset animated:YES];
    }
    if(_dataArray.count > 0){
        NSInteger totleIndex = [_chatTable numberOfRowsInSection:0];
        if(totleIndex > 0){
            NSInteger lastRowIndex = totleIndex - 1;
            [_chatTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRowIndex inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

-(MZOnlineTipView *)onlineIconBtn
{
    if(!_onlineIconBtn){
        _onlineIconBtn = [[[MZOnlineTipView alloc]initWithFrame:CGRectMake(0, 0, 110*MZ_RATE, 25*MZ_RATE)] roundChangeWithRadius:4*MZ_RATE];
        [_onlineIconBtn addTarget:self action:@selector(iconCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_onlineIconBtn];
    }
    return _onlineIconBtn;
}


-(void)reloadData
{
    [_chatTable reloadData];
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MZChatTableViewCell getCellHeight:_dataArray[indexPath.row] cellWidth:MZ_SW];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MZ_SW, 10*MZ_RATE)];
    
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeaklySelf(weakSelf);
    if(_dataArray.count > 0 && _dataArray.count > indexPath.row){
        //        取出当前cell需要的model
        MZLongPollDataModel *msg = _dataArray[indexPath.row];
        NSString *identitystr = [NSString string];
        
        if(msg.event == MsgTypeMeChat)
        {
            identitystr = MZMsgTypeMeChat;
        }else if (msg.event == MsgTypeOtherChat){
            identitystr = MZMsgTypeOtherChat;
        }
        MZChatTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identitystr];
        if (cell ==nil){
            cell = [[MZChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identitystr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.pollingDate = msg;
        
        cell.headerViewAction = ^(MZLongPollDataModel *msgModel){
            [weakSelf.chatDelegate historyChatViewUserHeaderClick:msgModel];
        };
        return cell;
    }else{
        MZChatTableViewCell *cell = [[MZChatTableViewCell alloc]init];
        return cell;
    }
    
}




@end