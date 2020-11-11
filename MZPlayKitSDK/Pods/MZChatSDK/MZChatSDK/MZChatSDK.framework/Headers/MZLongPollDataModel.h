//
//  MZLongPollDataModel.h
//  MengZhu
//
//  Created by vhall on 16/7/11.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZActMsg.h"
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>
#import "MZChatCommen.h"

@interface MZLongPollDataModel : NSObject
@property (nonatomic,copy) NSString *id ;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * accountId;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * userAvatar;
@property (nonatomic,copy) NSString * room;
@property (nonatomic,assign) MsgType    event;
@property (nonatomic,copy) NSString * time;
@property (nonatomic,copy) NSString * app;
@property (nonatomic,copy) NSString * realRoom;
@property (nonatomic,assign) UserRoleType role;
@property (nonatomic,strong) MZActMsg * data;
@property (nonatomic,strong)NSString    *goods_name;
@property (nonatomic,assign)int         goods_id;
@property (nonatomic,strong)NSString    *goods_pic;
@property (nonatomic,assign)int         buy_num;
@property (nonatomic,strong) NSString * imgSrc;
@property (nonatomic,assign) float    cellHeight;//cell的缓存高度
+(MZLongPollDataModel *)initWithDict:(NSDictionary *)data;

//历史聊天
+ (MZLongPollDataModel *)initWithChatHistoryDict:(NSDictionary *)dictionary;

@end

