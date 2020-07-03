//
//  VHStatisticsStystem.h
//  vhallIphone
//
//  Created by vhallrd01 on 14-8-5.
//  Copyright (c) 2014年 zhangxingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZStatisticsStystem : NSObject

@property (nonatomic,strong)NSString *iphoneIp;
@property (nonatomic,strong)NSMutableDictionary* stystemInfo;

+ (MZStatisticsStystem *)sharedManager;

- (NSString *)onlyID;           //唯一串号
- (NSString *)OS;               //操作系统
- (NSString *)OSversion;        //操作系统版本
- (NSString *)deviceType;       //设备类型
- (NSString *)deviceID;         //设备号
- (NSString *)devideIP;         //ip地址
- (NSNumber *)deviceResolution; //设备分辨率
- (BOOL)isBreak;                //是否越狱  yes表示越狱机型
- (NSString *)netWorkStatus;    //网络状态
- (NSString *)netWork;          //网络
- (NSString *)mobileModel;      //机型
- (NSString *)mobileModelString;//机型string
- (NSString *)time;             //获取手机时间
- (NSString *)token;            //deviceToken
- (NSString *)version;          //APP版本

- (NSMutableDictionary*)getAtomDic;


#ifdef DEBUG
- (NSArray *)getDataCounters;
- (float) cpu_usage;
- (double)availableMemory;
- (double)usedMemory;
#endif
@end
