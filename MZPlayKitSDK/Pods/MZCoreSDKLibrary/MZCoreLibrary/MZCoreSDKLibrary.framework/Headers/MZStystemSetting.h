//
//  VHStystemSetting.h
//  VhallIphone
//
//  Created by vhall on 15/7/30.
//  Copyright (c) 2015年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MZPrivacy.h"


@interface MZStystemSetting : NSObject
+ (MZStystemSetting *)sharedSetting;
@property(nonatomic)BOOL isPushMsg;
@property(nonatomic)BOOL isOnlyWIFIPlay;
@property(nonatomic)BOOL isNotifyFans;
@property(nonatomic)int  videoResolution;
@property(nonatomic)int  bitRate;
@property(nonatomic)BOOL isUpdateUserInfo;
@property(nonatomic)int  netStatus;
@property(nonatomic)BOOL isCheckFlag; // 
@property(nonatomic)BOOL isStrongUpdate;
@property(nonatomic)BOOL isUploadSys;
@property(nonatomic,copy) NSString * lastActivityTipTime;
@property (nonatomic ,strong)NSString *posterUrl;
@property(nonatomic)int  tag;
@property(nonatomic)BOOL    openWechatLogin;
@property(nonatomic)BOOL isNewYear;
@property(nonatomic)BOOL    is_open_withdrawal;
@property (nonatomic)BOOL  need_fluxTip;//需要流量提示
@property(nonatomic,assign)BOOL needShowAlert;//需要弹窗
@property(nonatomic,assign)BOOL needNotShowVisitCardRule;//需要弹名片红包规则

//提现需知提示内容
@property(nonatomic,strong)NSString *withDrawRemind;

@property(nonatomic,strong)NSMutableDictionary  *privacies;

@property(nonatomic,assign)BOOL hasNewMsg;

//会员须知
@property(nonatomic,strong)NSString *memberNotice;

//产品推广规则
@property(nonatomic,strong)NSString *productExtenNotice;

//商品代销须知
@property(nonatomic,strong)NSString *saleAgentNotice;

//企业版代销须知
@property(nonatomic,strong)NSString *enterPriseSaleAgentNotice;

//转播须知
@property(nonatomic,strong)NSString *transmissionNotice;

//银两抵扣须知
@property(nonatomic,strong)NSString *sliverDeducteNotice;

//邀约大赛须知
@property(nonatomic,strong)NSString *inviteCompetetionNotice;

//名片红包须知
@property(nonatomic,strong)NSString *visitCardRuleNotice;
//我的钱包须知货币规则
@property(nonatomic,strong)NSString *myWalletRuleNotice;

//商品定金规则
@property(nonatomic,strong)NSString *goodsDownPaymentNotice;
//主题风格
@property(nonatomic,strong)NSString *theme;

@end
