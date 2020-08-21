//
//  VHStatisticsStystem.h
//  vhallIphone
//
//  Created by vhallrd01 on 14-8-5.
//  Copyright (c) 2014年 zhangxingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZBaseStatisticsStystem : NSObject

@property (nonatomic,strong)NSString *iphoneIp;
@property (nonatomic,strong)NSMutableDictionary* stystemInfo;

@property (nonatomic ,strong)NSString *onlyID;//唯一串号
@property (nonatomic ,strong)NSString *OS;//操作系统
@property (nonatomic ,strong)NSString *OSversion;//操作系统版本
@property (nonatomic ,strong)NSString *deviceType;//设备类型
@property (nonatomic ,strong)NSString *deviceID;//设备号
@property (nonatomic ,strong)NSString *devideIP;//ip地址
@property (nonatomic ,strong)NSString *deviceResolution;//设备分辨率
@property (nonatomic ,assign)BOOL isBreak;//是否越狱  yes表示越狱机型
@property (nonatomic ,strong)NSString *netWorkStatus;//网络状态
@property (nonatomic ,strong)NSString *netWork;//网络
@property (nonatomic ,strong)NSString *mobileModel;//机型
@property (nonatomic ,strong)NSString *mobileModelString;//机型string
@property (nonatomic ,strong)NSString *atom_CV;
@property (nonatomic ,strong)NSString *time;//获取手机时间
@property (nonatomic ,strong)NSString *version;//APP版本
@property (nonatomic ,strong)NSString * publicOnlyID;
@property (nonatomic ,strong)NSString * publicMobileString;
@property (nonatomic ,strong)NSString * publicNetStatus;
+ (MZBaseStatisticsStystem *)sharedManager;

- (NSMutableDictionary*)getAtomDic;


#ifdef DEBUG
- (NSArray *)getDataCounters;
- (float) cpu_usage;
- (double)availableMemory;
- (double)usedMemory;
#endif
@end
