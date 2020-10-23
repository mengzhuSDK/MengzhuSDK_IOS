//
//  MZTimeManager.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/9/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZTimeManager : NSObject

/**
 获取微信格式的时间字符串
 
 @param  timeInterval                       时间，秒（double类型）
 @return 时间字符串(固定格式，类似微信聊天时间)    #exmp. 星期六 / 12:40 / 2019年6月12日
 */
+ (NSString *)getWXTimeFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 获取微信格式的时间字符串
 
 @param  timeString                          时间，秒（字符串类型,格式是 YYYY-MM-dd HH:mm:ss ）
 @return 时间字符串(固定格式，类似微信聊天时间)     #exmp. 星期六/12:40/2019年6月12日
 */
+ (NSString *)getWXTimeFromTimeString:(NSString *)timeString;

/**
 获取自定义格式的时间字符串
 
 @param  timeInterval                        时间，秒（double类型）
 @param  dateFormatter                       自定义的返回格式
 @return 时间字符串(自定义格式)
 */
+ (NSString *)getTime:(NSTimeInterval)timeInterval dateFormatter:(NSString *)dateFormatter;

/**
 获取时间秒
 
 @param  detailDate                          时间 (NSDate）
 @return 秒
 */
+ (NSTimeInterval)getTimeSecond:(NSDate * _Nullable)detailDate;

/**
 获取dateFormatter
 
 @param  dateFormatterString                  formatter格式字符串
 @return NSDateFormatter
 */
+ (NSDateFormatter *)dateFormatter:(NSString *)dateFormatterString;

@end

NS_ASSUME_NONNULL_END
