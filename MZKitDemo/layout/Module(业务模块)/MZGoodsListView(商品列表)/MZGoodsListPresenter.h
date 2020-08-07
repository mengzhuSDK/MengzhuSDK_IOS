//
//  MZGoodsListPresenter.h
//  MZKitDemo
//
//  Created by 李风 on 2020/7/14.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZGoodsListPresenter : NSObject

/// 获取商品总个数
+ (void)getGoodsListCountWithTicket_id:(NSString *)ticket_id
                              finished:(void(^)(MZGoodsListOuterModel * _Nullable goodsListOuterModel))finished;

/// 获取商品列表
+ (void)getGoodsListWithOffset:(int)offset
                     ticket_id:(NSString *)ticket_id
                      finished:(void(^)(MZGoodsListOuterModel * _Nonnull goodsListOuterModel))finished
                        failed:(void(^)(NSString *errorString))failed;

@end

NS_ASSUME_NONNULL_END
