//
//  MZGoodsListPresenter.m
//  MZKitDemo
//
//  Created by 李风 on 2020/7/14.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZGoodsListPresenter.h"

@implementation MZGoodsListPresenter

/// 获取商品总个数
+ (void)getGoodsListCountWithTicket_id:(NSString *)ticket_id
                              finished:(void(^)(MZGoodsListOuterModel * _Nullable goodsListOuterModel))finished {
    [MZSDKBusinessManager reqGoodsList:ticket_id offset:0 limit:50 success:^(id responseObject) {
        MZGoodsListOuterModel *goodsListOuterModel = [MZGoodsListOuterModel initModel:responseObject];
        
        finished(goodsListOuterModel);
    } failure:^(NSError *error) {
        
    }];
}

/// 获取商品列表
+ (void)getGoodsListWithOffset:(int)offset
                     ticket_id:(NSString *)ticket_id
                      finished:(void(^)(MZGoodsListOuterModel * _Nonnull goodsListOuterModel))finished
                        failed:(void(^)(NSString *errorString))failed {
    [MZSDKBusinessManager reqGoodsList:ticket_id offset:offset limit:50 success:^(id responseObject) {
        MZGoodsListOuterModel *goodsListOuterModel = [MZGoodsListOuterModel initModel:responseObject];
        
        finished(goodsListOuterModel);

    } failure:^(NSError *error) {
        failed(error.localizedDescription);
    }];
}

@end
