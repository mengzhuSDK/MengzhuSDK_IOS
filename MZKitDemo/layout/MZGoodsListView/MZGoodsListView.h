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

@interface MZGoodsListView : UIView
@property (nonatomic ,strong)NSMutableArray *dataArr;

@property (nonatomic,copy) GoodsListViewCellClickBlock goodsListViewCellClickBlock;
@end

NS_ASSUME_NONNULL_END
