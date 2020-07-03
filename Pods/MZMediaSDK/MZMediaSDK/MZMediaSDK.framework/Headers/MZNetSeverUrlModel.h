//
//  MZNetSeverUrlModel.h
//  MengZhu
//
//  Created by vhall on 16/6/30.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

@class MZupdateModel;

@interface MZNetSeverUrlModel : MZBaseNetModel<NSCoding>

@property (nonatomic,strong) NSString * app_api;
@property (nonatomic,strong) NSString * web;
@property (nonatomic,strong) NSString * user;
@property (nonatomic,strong) NSString * business;
@property (nonatomic,strong) NSString * relation;
@property (nonatomic,strong) NSString * quan;
@property (nonatomic,strong) NSString * pay;
@property (nonatomic,strong) NSString * web_root;
@property (nonatomic,strong) NSString * upload;
@property (nonatomic,strong) NSString * customer;
@property (nonatomic,strong) NSString * timestamp;
@property (nonatomic,strong) NSString * h5;
@property (nonatomic,strong) NSString * settlement;
@property (nonatomic,strong) MZupdateModel * updateModel;
@property (nonatomic,strong) NSString * audit_status;//审核期间隐藏某些功能
@property (nonatomic,strong) NSString   *patch;   //补丁包的地址
@property (nonatomic,assign) int   is_open_wechat_login;//是否开启微信登录
@property (nonatomic,assign) int    is_open_withdrawal;// 是否开启提现
@property (nonatomic,strong) NSString   *theme;//UI主题
-(MZNetSeverUrlModel *)initDict:(NSDictionary *)dic;

+(void)setDefaulModel;

@end

@interface MZupdateModel :MZBaseNetModel<NSCoding>

@property (nonatomic,strong) NSString * version;
@property (nonatomic,strong) NSString * version_code;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * change_log;
@property (nonatomic,strong) NSString * download_url;
-(MZupdateModel *)initUpdateDict:(NSDictionary *)subDict;
@end
