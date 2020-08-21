//
//  MZActivityConfig.h
//  MZPlayKitSDK
//
//  Created by sunxianhao on 2020/6/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#ifndef MZActivityConfig_h
#define MZActivityConfig_h

#pragma mark 用户身份
typedef NS_ENUM(NSUInteger, UserRoleType) {
    UserRoleTypeUser,      //普通用户
    UserRoleTypeHost,      //主播
    UserRoleTypeSub_account,//子账号
    
    UserRoleTypeGuest,     //嘉宾
    UserRoleTypeAssistant, //助理
    
    UserRoleTypeSystem,     //系统
    UserRoleTypeRobot,    //机器人
    UserRoleTypeAnonymous//游客
};



#endif /* MZActivityConfig_h */
