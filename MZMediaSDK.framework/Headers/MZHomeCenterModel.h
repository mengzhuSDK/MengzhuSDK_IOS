//
//  MZHomeCenterModel.h
//  MengZhu
//
//  Created by vhall.com on 16/7/6.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZHomeCenterModel : NSObject
@property (nonatomic ,copy) NSString *uid ;//盟主号
@property (nonatomic ,copy) NSString *alias_id ;//别名ID，优先显示
@property (nonatomic ,copy) NSString *nickname ;//"昵称",
@property (nonatomic ,copy) NSString *avatar ;// 头像地址,
@property (nonatomic ,copy) NSString *level ;// 等级
@property (nonatomic ,copy) NSString *watch_num ;// 关注数
@property (nonatomic ,copy) NSString *fans_num ;// 粉丝数
@property (nonatomic ,copy) NSString *balance ;// 帐号总银两
@property (nonatomic ,copy) NSString *coin ;// 帐号总铜钱
@property (nonatomic ,copy) NSString *channel_num ;// 我的频道数
@property (nonatomic,copy) NSString *collect_num;//收藏数
@property (nonatomic ,copy) NSString *sub_num ;// 订阅频道数
@property (nonatomic ,copy) NSString *post_num;//动态数
@property (nonatomic ,copy) NSString *is_opened_product; //是否开通过产品
@property (nonatomic ,copy) NSString *realname ;//用户姓名
@property (nonatomic ,copy) NSString *phone ;//手机
@property (nonatomic ,copy) NSString *province ;//省
@property (nonatomic ,copy) NSString *city ;//市
@property (nonatomic ,copy) NSString *area ;//区
@property (nonatomic ,copy) NSString *wechat_id ;//微信号
@property (nonatomic ,copy) NSString *email ;
@property (nonatomic ,copy) NSString *status; //用户状态
@property (nonatomic ,copy) NSString *share_url; //分享url
@property (nonatomic ,copy) NSString * sex;
@property (nonatomic ,assign)int is_bind_wechat;    //是否已绑定微信
@property (nonatomic ,assign)int is_auth; //是否认证
@property (nonatomic ,copy) NSString * product_level;//0免费版；1基础版；2企业版
@property (nonatomic ,copy) NSString * expire_at;//购买产品过期时间，免费版没有过期时间
@property (nonatomic ,copy) NSString * is_expire;//会员等级是否过期：1未过期；2已过期
@property (nonatomic ,copy) NSString * signature;

@property (nonatomic ,assign)int personal_verify_status;//认证状态 1:未审核 2:认证失败 3:认证通过 4:认证失效 9 未提交认证信息
@property (nonatomic ,assign)int company_verify_status;//认证状态 0未审核 1审核失败 2审核通过 9未提交认证信息

@property (nonatomic ,assign) int is_new_cards;//是否有新名片


@end
