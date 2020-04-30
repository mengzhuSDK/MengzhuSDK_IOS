//
//  NSString+MZExtension.h
//  MZExtensionExample
//
//  Created by MZ Lee on 15/6/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZExtensionConst.h"

@interface NSString (MZExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)mz_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)mz_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)mz_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)mz_firstCharLower;

- (BOOL)mz_isPureInt;

- (NSURL *)mz_url;
@end

@interface NSString (MZExtensionDeprecated_v_2_5_16)
- (NSString *)underlineFromCamel MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
- (NSString *)camelFromUnderline MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
- (NSString *)firstCharUpper MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
- (NSString *)firstCharLower MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
- (BOOL)isPureInt MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
- (NSURL *)url MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
@end
