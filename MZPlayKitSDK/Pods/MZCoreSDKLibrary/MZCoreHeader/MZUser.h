//
//  MZUser.h
//  MengZhu
//
//  Created by vhall on 16/6/25.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UserInfoStatus) {
    UserInfoUnperfect = 0,  //信息未完善
    UserInfoPerfect,        //信息已完善
    UserStopLogin,          //禁止用户登录
};

typedef NS_ENUM(NSUInteger, UserGender) {
    UserGenderUnkown,//未知
    UserGenderMale ,  //男
    UserGenderFemale  //女
};

typedef NS_ENUM(NSUInteger, UserLevel) {
    UserLevel1 = 1,//学徒
    UserLevel2,    //弟子
    UserLevel3,    //执事
    UserLevel4,    //舵主
    UserLevel5,    //堂主
    UserLevel6,    //盟主
};

typedef NS_ENUM(NSUInteger, UserIsExtend) {
    UserUnextend,  //未完善
    UserExtend     //已完善
};

typedef NS_ENUM(NSUInteger, VerifyType) {
    unVerify ,
    verified,
    verifing,
    verifiedFailure
};
typedef NS_ENUM(NSUInteger, RelationType) {
    RelationTypeSelf    ,//自己
    RelationTypeFans    ,//我的粉丝
    RelationTypeFollows ,//我关注的
    RelationTypeFriend  ,//相互关注
    RelationTypeStranger,//陌生人
    RelationTypeUnsign   //为注册用户
};

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


@property (nonatomic,strong)NSString * appID;//appID
@property (nonatomic,strong)NSString * secretKey;//secretKey

@property (nonatomic,strong)NSString * uniqueID;//用户传过来的唯一id

@property (nonatomic,strong)NSString * accountNo;//用户传过来的唯一id，为了兼容旧版本

#pragma mark 登录基本用户信息

//用户类型  0免费版  1基础版  2企业版
@property (nonatomic,assign)int product_level;

//购买产品过期时间，免费版没有过期时间
@property (nonatomic,strong)NSString * expireAt;

//是否过期时间
@property (nonatomic,assign)BOOL isExpire;

/*!
 用户sid
 */
@property (nonatomic,strong)NSString * userSid;
/*!
 用户名字
 */
@property (nonatomic,strong)NSString * userName;
/*!
 是否完善信息以及禁止登录
 */
@property (nonatomic) UserInfoStatus status;
/*!
 个人等级
 */
@property (nonatomic,strong)NSString * level;
/*!
 性别
 */
@property (assign) NSInteger sex;
/*!
 盟主号
 */
@property (nonatomic,strong)NSString * mengzhuNO;
/*!
 电话
 */
@property (nonatomic,strong)NSString * phone;
/*!
 是否绑定微信
 */
@property (nonatomic,assign)BOOL isBindWechat;

#pragma mark 个人详细信息
/*!
 用户头像大图
 */
@property (nonatomic,strong)NSString * bigIcon;
/*!
 邮箱
 */
@property (nonatomic,strong)NSString * email;
/*!
 所在城市
 */
@property (nonatomic,strong)NSString * city;
/*!
籍贯
 */
@property (nonatomic,strong)NSString * native_place;



/*!
 微信号
 */
@property (nonatomic,strong)NSString * weChatNO;
/*!
 粉丝数
 */
@property (nonatomic,strong)NSString * fanNum;
/*!
 关注数
 */
@property (nonatomic,strong)NSString * followNum;
/*!
 个人分享网址
 */
@property (nonatomic,strong)NSString * shareUrl;
/*!
  推荐盟主号
 */
@property (nonatomic,strong)NSString * recommendMengzhuNO;
/*!
 总余额
 */
@property (nonatomic,strong)NSString * balance;
/*!
 总银两
 */
@property (nonatomic,strong)NSString * silver;
/*!
 我的频道数
 */
@property (nonatomic,strong)NSString * myChannelNum;
/*!
 订阅频道数
 */
@property (nonatomic,strong)NSString * subscribeChannelNum;
/*!
 产品级别
 */
@property (nonatomic,strong)NSString * productId;
/*!
 用户状态
 */
@property (nonatomic,strong)NSString * userStatus;
/*!
 用户生日
 */
@property (nonatomic,strong)NSString * birthday;
/**
 *  民族
 */
@property (nonatomic,strong)NSString * nation;
/*!
 身份证号
 */
@property (nonatomic,strong)NSString * personID;
/*!
 固话
 */
@property (nonatomic,strong)NSString * telPhone;
/**
 *  身份证照片
 */
@property (nonatomic,strong)NSString * idcard_photos;
/**
 *  手持开户照片
 */
@property (nonatomic,strong)NSString * open_protocol;

/**
 阿里百川即时通讯 密码
 */
@property (nonatomic,strong)NSString * token;

@property (nonatomic,assign)int  is_personal_auth;//是否用户实名认证 : 0否 1是

@property (nonatomic,assign)int  is_company_auth;//是否企业认证: 0否 1是

@property (nonatomic ,assign)int personal_verify_status;//认证状态 0:审核中 1:认证失败 2:认证通过 9 未提交认证信息
@property (nonatomic ,assign)int company_verify_status;//认证状态 0未审核 1审核失败 2审核通过 9未提交认证信息

/// 通过json转换成用户模型
+ (instancetype)currentUserLoginDictionary:(NSDictionary *)dic;
/*!
 个人信息
 */
+ (instancetype)currentUserWithDictionary:(NSDictionary *)dic;

@end
