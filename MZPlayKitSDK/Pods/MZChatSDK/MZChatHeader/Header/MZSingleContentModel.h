//
//  MZSingleContentModel.h
//  MZChatSDK
//
//  Created by LiWei on 2020/8/4.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZSingleContentModel : NSObject
@property (nonatomic ,strong)NSString *type;
@property (nonatomic,assign) BOOL is_open;// 1:是 0:否
@property (nonatomic,strong) NSArray *content;
@end

NS_ASSUME_NONNULL_END
