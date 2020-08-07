//
//  MZVoteView.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZVoteView.h"

typedef void(^CloseHandler)(void);

@interface MZVoteView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,   copy) NSString *channelID;//频道ID
@property (nonatomic,   copy) NSString *ticketID;//活动ID

@property (nonatomic, assign) CGRect showFrame;//展示的frame
@property (nonatomic, assign) CGRect hideFrame;//隐藏的frame

@property (nonatomic,   copy) CloseHandler closeHandler;//关闭的回调

@property (nonatomic, strong) MZVoteInfoModel *voteInfoModel;//投票的信息数据源
@property (nonatomic, strong) NSMutableArray *dataArray;//投票的选项数据源

@property (nonatomic, strong) NSMutableSet *voteSelectedIds;//投票选中的ID

@end

@implementation MZVoteView

- (void)dealloc {
    NSLog(@"投票界面释放");
}

- (instancetype)initWithCloseHander:(void(^)(void))closeHandler {
    self = [super init];
    if (self) {
        self.closeHandler = closeHandler;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.showFrame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    self.hideFrame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    self.frame = self.hideFrame;
    
    CGFloat bottomEmptyH = 0;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            bottomEmptyH = 34.0;
        }
    }
        
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - bottomEmptyH - 422*MZ_RATE - 44*MZ_RATE, self.frame.size.width, 422*MZ_RATE+44*MZ_RATE+bottomEmptyH)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.userInteractionEnabled = YES;
    [self addSubview:self.bgView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.bgView.layer.mask = maskLayer;
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 422*MZ_RATE-44*MZ_RATE-bottomEmptyH)];
    tapView.backgroundColor = [UIColor clearColor];
    [self addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonClick)];
    [tapView addGestureRecognizer:tap];

    [self.bgView addSubview:self.topMenuView];
    [self.bgView addSubview:self.voteButton];
    [self.bgView addSubview:self.collectionView];
}

/// 根据请求投票的信息，来更新界面
- (void)updateVoteAllView {
    CGFloat bottomEmptyH = 0;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            bottomEmptyH = 34.0;
        }
    }
    
    if (self.voteInfoModel.is_vote || self.voteInfoModel.is_expired) {//已经投过票了或者过期了
        self.voteButton.hidden = YES;
        self.voteButton.frame = CGRectZero;
        self.collectionView.frame = CGRectMake(16*MZ_RATE, 44*MZ_RATE, self.bgView.frame.size.width - 32*MZ_RATE, self.bgView.frame.size.height - 44*MZ_RATE);
    } else {//还没有进行投票
        self.voteButton.hidden = NO;
        self.voteButton.frame = CGRectMake(16*MZ_RATE, self.bgView.frame.size.height - bottomEmptyH - 20*MZ_RATE - 40*MZ_RATE, self.bgView.frame.size.width - 32*MZ_RATE, 40*MZ_RATE);
        self.collectionView.frame = CGRectMake(16*MZ_RATE, 44*MZ_RATE, self.bgView.frame.size.width - 32*MZ_RATE, self.bgView.frame.size.height - bottomEmptyH - 20*MZ_RATE - 40*MZ_RATE - 10*MZ_RATE - 44*MZ_RATE);
        [self updateVoteButtonStatus];
    }
    // 获取headerView的高度，设置collectionView的contentInset
    if (!self.voteHeaderView) {//这里不用懒加载，如果还没有实例化才去创建。
        self.voteHeaderView = [[MZVoteHeaderView alloc] initWithVoteInfo:self.voteInfoModel];
        [self.collectionView addSubview:self.voteHeaderView];
    }
    
    self.collectionView.contentInset = UIEdgeInsetsMake(self.voteHeaderView.frame.size.height, 0, 0, 0);
    [self.collectionView reloadData];
}

/// 展示自己
- (void)showWithChannelId:(NSString *)channelId ticketId:(NSString *)ticketId {
    self.channelID = channelId;
    self.ticketID = ticketId;

    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
        self.frame = self.showFrame;
    } completion:^(BOOL finished) {
        [self loadVoteInfo];
    }];
}

/// 关闭按钮点击
- (void)closeButtonClick {
    [self hide];
    if (self.closeHandler) {
        self.closeHandler();
    }
}

/// 隐藏自己
- (void)hide {
    [UIView animateWithDuration:0.33 animations:^{
        self.frame = self.hideFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/// 设置投票按钮状态
- (void)updateVoteButtonStatus {
    self.voteButton.selected = self.voteSelectedIds.count;
    self.voteButton.userInteractionEnabled = self.voteSelectedIds.count;
    
    if (self.voteSelectedIds.count) {
        [self.voteButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:33/255.0 blue:69/255.0 alpha:1]];
    } else {
        [self.voteButton setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]];
    }
}

/// 选中/取消了某个选项
- (void)selectOrUnselectOption:(NSIndexPath *)indexPath optionModel:(MZVoteOptionModel *)optionModel {
    if (self.voteInfoModel.is_expired) return;// 过期不响应
    if (self.voteInfoModel.is_vote) return;// 已投不响应
    if (self.voteInfoModel.is_deleted) return;// 已删除不响应
    
    if (self.voteInfoModel.select_type == 0) {//单选
        if ([self.voteSelectedIds containsObject:optionModel.id]) {//单选-取消选择
            [self.voteSelectedIds removeAllObjects];
        } else {//单选-选中新的
            [self.voteSelectedIds removeAllObjects];
            [self.voteSelectedIds addObject:optionModel.id];
            [self.collectionView reloadData];
            [self updateVoteButtonStatus];
            return;
        }
    } else if (self.voteInfoModel.select_type == 1) {//多选
        if ([self.voteSelectedIds containsObject:optionModel.id]) {//多选-取消某一个选择
            [self.voteSelectedIds removeObject:optionModel.id];
        } else {//多选-添加新的选择
            if (self.voteSelectedIds.count >= self.voteInfoModel.max_select) {
                [self.bgView show:[NSString stringWithFormat:@"最多选择%d项",self.voteInfoModel.max_select]];
                return;
            } else {
                [self.voteSelectedIds addObject:optionModel.id];
            }
        }
    }
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self updateVoteButtonStatus];
}

#pragma mark - 业务请求
/// 获取投票信息
- (void)loadVoteInfo {
    [self.bgView showHud];
        
    [MZSDKBusinessManager getVoteInfoWithChannelId:self.channelID ticketId:self.ticketID success:^(id responseObject) {
        NSLog(@"获取投票信息成功了");
        self.voteInfoModel = [MZVoteInfoModel mj_objectWithKeyValues:responseObject];
        [self updateVoteAllView];
        [self loadAllOptionOfVote];
    } failure:^(NSError *error) {
        [self.bgView hideHud];
        [self.bgView show:error.domain];
    }];
}

/// 获取该投票的所有选项
- (void)loadAllOptionOfVote {
    [MZSDKBusinessManager getVoteOptionWithVoteId:self.voteInfoModel.id success:^(id responseObject) {
        NSLog(@"获取该投票的所有选项成功");
        self.dataArray = [MZVoteOptionModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.collectionView reloadData];
        [self.bgView hideHud];
    } failure:^(NSError *error) {
        [self.bgView hideHud];
        [self.bgView show:error.domain];
    }];
}

/// 进行投票请求
- (void)toVote {
    NSLog(@"点击了投票按钮");
    [self.bgView showHud];
    
    NSString *optionIds = [self.voteSelectedIds.allObjects componentsJoinedByString:@","];
    NSLog(@"optionIds = %@",optionIds);
    
    [MZSDKBusinessManager goToVoteWithTicketId:self.ticketID voteId:self.voteInfoModel.id optionId:optionIds success:^(id responseObject) {
        NSLog(@"提交投票成功了");
        [self.bgView hideHud];
        [self loadVoteInfo];
    } failure:^(NSError *error) {
        [self.bgView hideHud];
        [self.bgView show:error.domain];
    }];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MZVoteBaseCell *cell = nil;
    
    MZVoteOptionModel *optionModel = self.dataArray[indexPath.row];
    if (self.voteInfoModel.type == 1) {//图文投票
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MZVoteImageCell" forIndexPath:indexPath];
    } else {//文字投票
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MZVoteTextCell" forIndexPath:indexPath];
    }
    [cell updateInfo:optionModel voteSelectedIds:self.voteSelectedIds voteInfo:self.voteInfoModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.voteInfoModel.is_vote || self.voteInfoModel.is_expired) {
        return;
    }
    MZVoteOptionModel *optionModel = self.dataArray[indexPath.row];
    [self selectOrUnselectOption:indexPath optionModel:optionModel];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.voteInfoModel.type == 1) {//图文投票
        CGFloat itemWidth = (self.collectionView.frame.size.width - 10)/2.0;
        return CGSizeMake(itemWidth, itemWidth+42*MZ_RATE);
    } else {
        return CGSizeMake(self.collectionView.frame.size.width, 56*MZ_RATE);
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (MZTopMenuView *)topMenuView {
    if (!_topMenuView) {
        _topMenuView = [[MZTopMenuView alloc] initWithFrame:CGRectMake(16*MZ_RATE, 0, self.frame.size.width - 32*MZ_RATE, 44*MZ_RATE)];
        _topMenuView.backgroundColor = [UIColor clearColor];
        WeaklySelf(weakSelf);
        _topMenuView.closeHandler = ^{
            [weakSelf closeButtonClick];
        };
    }
    return _topMenuView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 10*MZ_RATE;
        flowLayout.minimumInteritemSpacing = 5*MZ_RATE;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16*MZ_RATE, 44*MZ_RATE, self.frame.size.width - 32*MZ_RATE, self.bgView.frame.size.height - 44*MZ_RATE) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MZVoteTextCell class] forCellWithReuseIdentifier:@"MZVoteTextCell"];
        [_collectionView registerClass:[MZVoteImageCell class] forCellWithReuseIdentifier:@"MZVoteImageCell"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIButton *)voteButton {
    if (!_voteButton) {
        _voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voteButton.layer setCornerRadius:20*MZ_RATE];
        [_voteButton.layer setMasksToBounds:YES];
        [_voteButton setTitle:@"投 票" forState:UIControlStateNormal];
        _voteButton.titleLabel.font = [UIFont systemFontOfSize:16*MZ_RATE];
        [_voteButton addTarget:self action:@selector(toVote) forControlEvents:UIControlEventTouchUpInside];
        
        [_voteButton setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]];
        
        [_voteButton setTitleColor:[UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1] forState:UIControlStateNormal];
        [_voteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        _voteButton.userInteractionEnabled = NO;
    }
    return _voteButton;
}

- (NSMutableSet *)voteSelectedIds {
    if (!_voteSelectedIds) {
        _voteSelectedIds = [[NSMutableSet alloc] init];
    }
    return _voteSelectedIds;
}

@end
