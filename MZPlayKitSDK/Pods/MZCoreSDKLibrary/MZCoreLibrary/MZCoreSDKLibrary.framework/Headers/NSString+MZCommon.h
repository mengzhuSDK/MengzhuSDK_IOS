//
//  NSString+MZCommon.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/9/27.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 @brief 关于字符串一些常用的处理
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MZCommon)

/** 将str加密成本地保存的文件名 */
+ (NSString *)md5String:(NSString *)str;
- (NSString *)md5;

/** 第一个字母的拼音 */
- (NSString *)firstPinYin;

/** 是否为空,纯换行符或者空白字符也为空 */
- (BOOL)isEmpty;

/** 去除字符串前后的空白,不包含换行符 */
- (NSString *)trim;

/** 去除字符串中所有空白 */
- (NSString *)removeWhiteSpace;
- (NSString *)removeNewLine;

/** 手机号码添加****  */
+ (NSString *)replaceStringWithPhone:(NSString *)phone;

/** 是否是手机号 */
- (BOOL)isPhone;

/** 处理服务器返回number，使用string去接的时候，价钱返回8.000000，处理成8.00  */
- (NSString *)priceString;

/** 生成属性字符串 */
- (NSAttributedString *)stringWithAttr:(NSString *)string color:(UIColor *)color font:(UIFont *)font;


@end

NS_ASSUME_NONNULL_END
