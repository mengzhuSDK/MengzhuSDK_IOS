//
//  MZGiftView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZGiftView.h"
#import "MZGiftModel.h"
#import "MZGiftCell.h"
#import "MZGiftPresenter.h"

typedef void(^SelectHandler)(NSString *giftId, int quantity);
static int pageControlHeight = 14;

@interface MZGiftView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (nonatomic,   copy) SelectHandler handler;
@property (nonatomic,   copy) NSString *ticketId;

@property (nonatomic, strong) UIView *bgView;//背景View
@property (nonatomic, strong) UIView *noTopBgView;//没有顶部的背景View

@property (nonatomic, strong) UIButton *sendButton;//发送礼物按钮

@property (nonatomic, strong) UIView *tapView;//点击取消界面的事件View
@property (nonatomic, strong) UIButton *giftButton;//礼物标题button
@property (nonatomic, strong) UIPageControl *pageConrol;//指示点

@property (nonatomic, assign) CGRect showFrame;//展示的frame
@property (nonatomic, assign) CGRect hideFrame;//隐藏的frame

@property (nonatomic,   copy) NSString *selectGiftId;//选中的礼物ID

@property (nonatomic, assign) BOOL isLoadAll;//是否所有数据全部加在完毕

@end

@implementation MZGiftView

- (void)dealloc {
    NSLog(@"礼物界面释放了");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat bottomEmptyH = 0;
    CGFloat space = MZ_RATE;
    
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {//横屏
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                bottomEmptyH = 8.0;
            }
        }
        space = MZ_FULL_RATE;
        self.bgView.frame = CGRectMake(0, self.frame.size.height - bottomEmptyH - 170*space-44, self.frame.size.width, 170*space+bottomEmptyH+44);
        self.giftButton.frame = CGRectMake(bottomEmptyH > 0 ? 44.0 : 0, 0, 94, 44);
        self.collectionView.frame = CGRectMake((bottomEmptyH > 0 ? 44.0 : 0), 44, self.bgView.frame.size.width - (bottomEmptyH > 0 ? 44.0 : 0), self.bgView.frame.size.height - 44*space - 44 - bottomEmptyH);
        self.pageConrol.hidden = YES;
        self.sendButton.frame = CGRectMake(self.bgView.frame.size.width - 64*space - (bottomEmptyH > 0 ? 30*space : 16*space), self.bgView.frame.size.height - 37*space - bottomEmptyH, 64*space, 30*space);
    } else {//竖屏
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                bottomEmptyH = 34.0;
            }
        }
        self.bgView.frame = CGRectMake(0, self.frame.size.height - bottomEmptyH - 296*space - 44, self.frame.size.width, 296*space+bottomEmptyH+44);
        self.giftButton.frame = CGRectMake(0, 0, 94, 44);
        self.collectionView.frame = CGRectMake(0, 44, self.frame.size.width, self.bgView.frame.size.height - 44*space - 44 - pageControlHeight - bottomEmptyH);
        self.pageConrol.hidden = NO;
        self.pageConrol.frame = CGRectMake(0, self.collectionView.frame.size.height+self.collectionView.frame.origin.y+7, self.frame.size.width, pageControlHeight);
        self.sendButton.frame = CGRectMake(self.bgView.frame.size.width - 64*space - 16*space, self.bgView.frame.size.height - 37*space - bottomEmptyH, 64*space, 30*space);
    }
    
    self.noTopBgView.frame = CGRectMake(0, 44, self.bgView.frame.size.width, self.bgView.frame.size.height-44);
    self.tapView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.bgView.frame.size.height);
}

- (instancetype)initWithTicketId:(NSString *)ticketId selectHandler:(void(^)(NSString *giftId, int quantity))handler {
    self = [super init];
    if (self) {
        self.ticketId = ticketId;
        self.handler = handler;
        [self makeView];
    }
    return self;
}

- (void)makeView {
    CGFloat space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {//横屏
        space = MZ_FULL_RATE;
    }
    
    self.isLoadAll = NO;
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
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - bottomEmptyH - 296*space - 44, self.frame.size.width, 296*space+bottomEmptyH+44)];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.userInteractionEnabled = YES;
    [self addSubview:self.bgView];
    
    self.noTopBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.bgView.frame.size.width, self.bgView.frame.size.height-44)];
    self.noTopBgView.backgroundColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.9];
    [self.bgView addSubview:self.noTopBgView];
    
    self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.giftButton setImage:[UIImage imageNamed:@"mz_gift_label_icon"] forState:UIControlStateNormal];
    [self.giftButton setTitle:@"礼物" forState:UIControlStateNormal];
    self.giftButton.userInteractionEnabled = NO;
    [self.giftButton setBackgroundImage:[UIImage imageNamed:@"mz_liwu_rectangle"] forState:UIControlStateNormal];
    [self.giftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.giftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.giftButton.frame = CGRectMake(0, 0, 94, 44);
    [self.bgView addSubview:self.giftButton];
        
    self.tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.bgView.frame.size.height)];
    self.tapView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonClick)];
    [self.tapView addGestureRecognizer:tap];
    
    [self.bgView addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, 44, self.frame.size.width, self.bgView.frame.size.height - 44*space - 44 - pageControlHeight - bottomEmptyH);
    
    self.pageConrol = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.collectionView.frame.size.height+self.collectionView.frame.origin.y + 7, self.frame.size.width, pageControlHeight)];
    self.pageConrol.numberOfPages = 1;
    self.pageConrol.currentPage = 0;
    self.pageConrol.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:27/255.0 blue:86/255.0 alpha:1];
    self.pageConrol.pageIndicatorTintColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self.bgView addSubview:self.pageConrol];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:27/255.0 blue:86/255.0 alpha:1];
    self.sendButton.frame = CGRectMake(self.bgView.frame.size.width - 64*space - 16*space, self.bgView.frame.size.height - 37*space - bottomEmptyH, 60*space, 30*space);
    [self.sendButton setTitle:@"赠送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.sendButton.layer.cornerRadius = 4;
    [self.bgView addSubview:self.sendButton];
    [self.sendButton addTarget:self action:@selector(giftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)giftButtonClick:(UIButton *)sender {
    if (self.selectGiftId.length) {
        if (self.handler) {
            self.handler(self.selectGiftId, 1);
            [self hide];
        }
    }
}

- (void)closeButtonClick {
    [self hide];
}

- (void)loadGiftList:(BOOL)isMore {
    NSInteger limit = 100;//默认一次100条数据
    NSInteger offset = 0;
    if (isMore) offset = self.dataArray.count;
    else {
        if (!self.dataArray.count) [self.bgView showHud];
    }
    
    [MZGiftPresenter getGiftListWithTicketId:self.ticketId offset:offset limit:limit success:^(id  _Nonnull responseObject) {
        [self.bgView hideHud];
        
        NSArray *tempArray = [MZGiftModel mj_objectArrayWithKeyValuesArray:responseObject];
        if (!isMore) [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:tempArray];
        [self.collectionView reloadData];
        
        self.pageConrol.numberOfPages = (self.dataArray.count % 8 > 0) ? self.dataArray.count/8 + 1 : self.dataArray.count/8;
        [self updatePageControl];
        
        self.isLoadAll = (tempArray.count < limit ? YES : NO);//返回的数据不够limit条，数据已经全部返回完毕

    } failure:^(NSError * _Nonnull error) {
        [self.bgView show:error.domain];
        [self.bgView hideHud];
    }];
}

- (void)show {
    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    self.showFrame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    self.hideFrame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    
    [UIView animateWithDuration:0.33 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
        self.frame = self.showFrame;
    } completion:^(BOOL finished) {
        [self loadGiftList:NO];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.33 animations:^{
        self.frame = self.hideFrame;
    } completion:^(BOOL finished) {
        self.pageConrol.currentPage = 0;
        [self.collectionView setContentOffset:CGPointZero];
        [self removeFromSuperview];
    }];
}

/// 礼物已经支付成功后，调用此方法通知消息服务器，礼物购买成功
- (void)pushGiftMessageWithGiftId:(NSString *)giftId quantity:(int)quantity {
    [MZGiftPresenter pushGiftWithTicketId:self.ticketId giftId:giftId quantity:quantity success:^(id  _Nonnull responseObject) {
        NSLog(@"礼物消息发送成功");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"礼物消息发送失败");
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MZGiftModel *gift = self.dataArray[indexPath.row];

    MZGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MZGiftCell" forIndexPath:indexPath];
    [cell update:gift];
    
    [cell.selectedView setHidden:YES];
    if ([self.selectGiftId isEqualToString:gift.id]) {
        [cell.selectedView setHidden:NO];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    MZGiftModel *gift = self.dataArray[indexPath.row];
    if ([self.selectGiftId isEqualToString:gift.id]) {
        self.selectGiftId = @"";
    } else {
        self.selectGiftId = gift.id;
    }
    
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {//横屏
        space = MZ_FULL_RATE;
    }
    return CGSizeMake(92*space, 118*space);
}

#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        [self updatePageControl];
        if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)) {
            if (!self.isLoadAll) {
                NSLog(@"到底部了，加下下一梭子数据吧");
                [self loadGiftList:YES];
            }
        }
    }
}

/// 计算pageController显示在第几页
- (void)updatePageControl {
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) return;

    NSLog(@"offset_x = %f",self.collectionView.contentOffset.x);
    NSInteger offsetX = (NSInteger)self.collectionView.contentOffset.x;
    NSInteger numberOfPages = self.pageConrol.numberOfPages;
    
    NSInteger currentPage = ((offsetX % (NSInteger)self.frame.size.width) > 0 ? (offsetX / (NSInteger)self.frame.size.width) + 1 : (offsetX / (NSInteger)self.frame.size.width));

    self.pageConrol.currentPage = currentPage >= numberOfPages ? numberOfPages - 1 : currentPage;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MZGiftCell class] forCellWithReuseIdentifier:@"MZGiftCell"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
    }
    return _collectionView;
}

@end
