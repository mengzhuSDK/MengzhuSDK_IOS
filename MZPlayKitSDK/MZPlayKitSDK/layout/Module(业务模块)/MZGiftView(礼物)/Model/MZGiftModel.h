//
//  MZGiftModel.h
//  MZKitDemo
//
//  Created by 李风 on 2020/8/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZGiftModel : NSObject
@property (nonatomic, copy) NSString *id;//礼物Id
@property (nonatomic, copy) NSString *name;//礼物名称
@property (nonatomic, copy) NSString *price;//礼物货币价格（自己的内部计价，如元宝，铜钱等）
@property (nonatomic, copy) NSString *icon;//礼物图片
@property (nonatomic, copy) NSString *type;//礼物type
@property (nonatomic, copy) NSString *sort;//礼物sort
@property (nonatomic, copy) NSString *status;//礼物状态
@property (nonatomic, copy) NSString *created_at;//礼物创建时间
@property (nonatomic, copy) NSString *pay_amount;//礼物需要支付的RMB
@end

NS_ASSUME_NONNULL_END
