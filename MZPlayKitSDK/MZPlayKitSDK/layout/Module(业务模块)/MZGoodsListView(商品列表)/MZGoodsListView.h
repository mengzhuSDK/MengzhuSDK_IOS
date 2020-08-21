//
//  MZGoodsListView.h
//  MZKitDemo
//
//  Created by LiWei on 2019/9/27.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^GoodsListViewCellClickBlock)(MZGoodsListModel *model);
typedef void(^GoodsDataResult)(NSMutableArray <MZGoodsListOuterModel *> *goods, int totalCount);
typedef void(^OutGoodsListView)(void);

@protocol MZGoodsRequestProtocol <NSObject>
/// 请求数据接口
-(void)requestGoodsList:(GoodsDataResult)block offset:(int)offset;
@end

@interface MZGoodsListView : UIView
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *goodTabView;
@property (nonatomic, assign) int totalNum;
@property (nonatomic, assign) int offset;
@property (nonatomic,   weak) id <MZGoodsRequestProtocol> requestDelegate;
@property (nonatomic,   copy) GoodsListViewCellClickBlock goodsListViewCellClickBlock;//某个商品点击block
@property (nonatomic,   copy) OutGoodsListView outGoodsListView;//退出block

- (void)loadDataWithIsMore:(BOOL)isMore;
@end

NS_ASSUME_NONNULL_END
