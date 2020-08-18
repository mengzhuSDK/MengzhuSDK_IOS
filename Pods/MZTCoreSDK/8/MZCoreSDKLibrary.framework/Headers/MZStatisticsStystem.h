//
//  MZStatisticsStystem.h
//  MengZhu
//
//  Created by sunxianhao on 2020/7/23.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZBaseStatisticsStystem.h"

@interface MZStatisticsStystem : MZBaseStatisticsStystem
//需要传token给这里面
@property(nonatomic,strong)NSString *token;
+ (MZBaseStatisticsStystem *)sharedManager;
@end
