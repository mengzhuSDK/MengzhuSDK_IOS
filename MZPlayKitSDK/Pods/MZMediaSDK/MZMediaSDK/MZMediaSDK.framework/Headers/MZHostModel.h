//
//  MZHostModel.h
//  MZMediaSDK
//
//  Created by Cage  on 2019/10/11.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZHostModel : NSObject
//uid: 2991454,
//nickname: "aikangguobin",
//avatar: "h
//"unique_id" = 1000109198213;
@property (nonatomic ,copy) NSString *uid;//用户内部的id
@property (nonatomic ,copy) NSString *nickname;//用户名字
@property (nonatomic ,copy) NSString *avatar;//用户头像地址
@property (nonatomic ,copy) NSString *unique_id;//用户唯一id
@end

NS_ASSUME_NONNULL_END
