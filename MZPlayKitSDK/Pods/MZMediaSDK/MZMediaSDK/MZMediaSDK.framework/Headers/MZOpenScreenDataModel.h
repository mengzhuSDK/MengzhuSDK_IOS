//
//  MZOpenScreenDataModel.h
//  MZMediaSDK
//
//  Created by LiWei on 2020/9/23.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZFullScreenAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZOpenScreenDataModel : NSObject

@property (nonatomic ,strong)NSArray <MZFullScreenAdModel *>*content;
@property (nonatomic ,assign)NSInteger stay_duration;//倒计时停留时间

@end

NS_ASSUME_NONNULL_END
