//
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZCLUPnPDevice;
@protocol MZCLUPnPServerDelegate <NSObject>
@required
/**
 搜索结果

 @param devices 设备数组
 */
- (void)upnpSearchChangeWithResults:(NSArray <MZCLUPnPDevice *>*)devices;

@optional
/**
 搜索失败

 @param error error
 */
- (void)upnpSearchErrorWithError:(NSError *)error;

@end

@interface MZCLUPnPServer : NSObject

@property (nonatomic, weak) id<MZCLUPnPServerDelegate>delegate;

@property (nonatomic,assign) NSInteger searchTime;

+ (instancetype)shareServer;

/**
 启动Server并搜索
 */
- (void)start;

/**
 停止
 */
- (void)stop;

/**
 搜索
 */
- (void)search;

/**
 获取已经发现的设备
 
 @return Device Array
 */
- (NSArray<MZCLUPnPDevice *> *)getDeviceList;

@end
