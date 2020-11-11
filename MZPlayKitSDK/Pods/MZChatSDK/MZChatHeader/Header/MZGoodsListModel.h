//
//  MZGoosListModel.h
//  MZKitDemo
//
//  Created by LiWei on 2019/9/27.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <MZCoreSDKLibrary/MZBaseModel.h>
#import <Foundation/Foundation.h>
#import "MZLongPollDataModel.h"

@interface MZGoodsListModel : MZBaseModel
@property (nonatomic ,strong)NSString *id;//商品ID
@property (nonatomic ,strong)NSString *name;//商品名称
@property (nonatomic ,assign)int type;//商品类型
@property (nonatomic ,strong)NSString *uid;//用户uid
@property (nonatomic ,strong)NSString *price;//商品价格
@property (nonatomic ,strong)NSString *pic;//商品图标
@property (nonatomic ,strong)NSString *buy_url;//商品链接

+ (MZGoodsListModel *)creatModelFromMsg:(MZLongPollDataModel *)msg;

@end
