//
//  MZNetSeverUrlManager.h
//  MengZhu
//
//  Created by vhall on 16/7/1.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MZNetSeverUrlModel;
@interface MZNetSeverUrlManager : NSObject
@property (strong, nonatomic)MZNetSeverUrlModel * netSeverUrlItem;

+ (MZNetSeverUrlManager *)sharedManager;

@end
