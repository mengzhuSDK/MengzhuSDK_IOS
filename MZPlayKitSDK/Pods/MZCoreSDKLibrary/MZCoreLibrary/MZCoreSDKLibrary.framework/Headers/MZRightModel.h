//
//  MZRightModel.h
//  MZChatSDK
//
//  Created by LiWei on 2020/8/4.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZRightContenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZRightModel : NSObject
@property (nonatomic ,strong)NSString *type;
@property (nonatomic,assign) BOOL is_open;
@property (nonatomic ,strong)MZRightContenModel *content;
@end

NS_ASSUME_NONNULL_END
