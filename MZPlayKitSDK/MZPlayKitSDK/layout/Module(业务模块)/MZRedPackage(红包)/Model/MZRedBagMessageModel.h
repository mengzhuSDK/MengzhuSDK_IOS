//
//  MZRedBagMessageModel.h
//  MengZhu
//
//  Created by vhall.com on 16/12/2.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZRedBagMessageModel : NSObject
@property (nonatomic ,copy) NSString *isEmpty;
@property (nonatomic ,copy) NSString *liveTime;
@property (nonatomic ,copy) NSString *remainQuantity;
@property (nonatomic ,copy) NSString *alreadyQuantity;
@property (nonatomic ,copy) NSString *quantity;
@property (nonatomic ,copy) NSString *slogan;
@property (nonatomic ,copy) NSString *money_type;
@property (nonatomic ,copy) NSString *amount;
@property (nonatomic ,copy) NSString *remainAmount;
@property (nonatomic,assign) BOOL is_expired;
@end
