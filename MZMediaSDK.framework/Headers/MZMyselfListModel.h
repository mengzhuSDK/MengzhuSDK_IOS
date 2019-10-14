//
//  MZMyselfListModel.h
//  MengZhu
//
//  Created by vhall on 16/7/9.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZMyselfListModel : NSObject
@property (nonatomic,strong) NSString * uid;
@property (nonatomic,strong) NSString * nickname;
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * level;
@property (nonatomic,strong) NSString * followes_at;
@property (nonatomic,strong) NSString * is_followed;
@property (nonatomic,strong) NSString * relation;
@property (nonatomic,strong) NSString * fans_uid;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int product_level;
@property (nonatomic,assign) int is_personal_auth;
@property (nonatomic,assign) int is_company_auth;
@end
