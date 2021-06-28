//
//  MZRedRecodeTableViewCell.h
//  MengZhu
//
//  Created by vhall.com on 16/11/23.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZRedBagReceiverListModel.h"

@interface MZRedRecodeTableViewCell : UITableViewCell
@property (nonatomic ,strong) MZRedBagReceiverListModel *listModel;
@property (nonatomic ,copy) NSString *money_type;
@property (nonatomic,assign) BOOL isLast;
@end
