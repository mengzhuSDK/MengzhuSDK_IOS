//
//  MZUser.h
//  MengZhu
//
//  Created by vhall on 16/6/25.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MZUser : NSObject

/*!
 用户ID
 */
@property (nonatomic,strong)NSString * userId;
/*!
 用户名字
 */
//@property (nonatomic,strong)NSString * userName;
/*!
 用户昵称
 */
@property (nonatomic,strong)NSString * nickName;
/*!
 用户头像
 */
@property (nonatomic,strong)NSString * avatar;

@property (nonatomic,strong)NSString * appID;
@property (nonatomic,strong)NSString * secretKey;

@property (nonatomic,strong)NSString * uniqueID;//用户传过来的唯一id

+ (instancetype)currentUserLoginDictionary:(NSDictionary *)dic;


@end
