//
//  MZUser.h
//  MengZhu
//
//  Created by vhall on 16/6/25.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MZUser : NSObject

@property (nonatomic,strong)NSString * nickName;//用户昵称
@property (nonatomic,strong)NSString * avatar;//用户头像

@property (nonatomic,strong)NSString * appID;//appID
@property (nonatomic,strong)NSString * secretKey;//secretKey

@property (nonatomic,strong)NSString * uniqueID;//用户传过来的唯一id

@property (nonatomic,strong)NSString * userId;//用户传过来的唯一id,为了兼容旧版本
@property (nonatomic,strong)NSString * accountNo;//用户传过来的唯一id，为了兼容旧版本

/// 通过json转换成用户模型
+ (instancetype)currentUserLoginDictionary:(NSDictionary *)dic;

@end
