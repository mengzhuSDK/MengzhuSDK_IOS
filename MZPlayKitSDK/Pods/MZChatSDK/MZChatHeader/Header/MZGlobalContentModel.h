//
//  MZGlobalContentModel.h
//  MZChatSDK
//
//  Created by LiWei on 2020/8/4.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZGlobalContentModel : NSObject
@property (nonatomic ,strong)NSString *config_type;
@property (nonatomic,assign) BOOL config_value;// 1:是 0:否
@end

NS_ASSUME_NONNULL_END
