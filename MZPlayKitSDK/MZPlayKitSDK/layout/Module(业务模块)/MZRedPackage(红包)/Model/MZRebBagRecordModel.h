//
//  MZRebBagRecordModel.h
//  MengZhu
//
//  Created by vhall.com on 16/12/2.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZRedBagReceiverListModel.h"
#import "MZRedBagMessageModel.h"
#import "MZRedBagSenderModel.h"
#import "MZRedBagUserReceiveModel.h"


@interface MZRebBagRecordModel : NSObject
@property (nonatomic ,strong) MZRedBagSenderModel *sendInfo ;
@property (nonatomic ,strong) NSArray<MZRedBagReceiverListModel *> *obtainList ;
@property (nonatomic ,strong) MZRedBagMessageModel *lotteryInfo ;
@property (nonatomic ,strong) MZRedBagUserReceiveModel *user_receive;
@end
