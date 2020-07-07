//
//  NSObject+MZProperty.h
//  MZExtensionExample
//
//  Created by MZ Lee on 15/4/17.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZExtensionConst.h"

@class MZProperty;

/**
 *  遍历成员变量用的block
 *
 *  @param property 成员的包装对象
 *  @param stop   YES代表停止遍历，NO代表继续遍历
 */
typedef void (^MZPropertiesEnumeration)(MZProperty *property, BOOL *stop);

/** 将属性名换为其他key去字典中取值 */
typedef NSDictionary * (^MZReplacedKeyFromPropertyName)(void);
typedef id (^MZReplacedKeyFromPropertyName121)(NSString *propertyName);
/** 数组中需要转换的模型类 */
typedef NSDictionary * (^MZObjectClassInArray)(void);
/** 用于过滤字典中的值 */
typedef id (^MZNewValueFromOldValue)(id object, id oldValue, MZProperty *property);

/**
 * 成员属性相关的扩展
 */
@interface NSObject (MZProperty)
#pragma mark - 遍历
/**
 *  遍历所有的成员
 */
+ (void)mz_enumerateProperties:(MZPropertiesEnumeration)enumeration;

#pragma mark - 新值配置
/**
 *  用于过滤字典中的值
 *
 *  @param newValueFormOldValue 用于过滤字典中的值
 */
+ (void)mz_setupNewValueFromOldValue:(MZNewValueFromOldValue)newValueFormOldValue;
+ (id)mz_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained MZProperty *)property;

#pragma mark - key配置
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName 将属性名换为其他key去字典中取值
 */
+ (void)mz_setupReplacedKeyFromPropertyName:(MZReplacedKeyFromPropertyName)replacedKeyFromPropertyName;
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName121 将属性名换为其他key去字典中取值
 */
+ (void)mz_setupReplacedKeyFromPropertyName121:(MZReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121;

#pragma mark - array model class配置
/**
 *  数组中需要转换的模型类
 *
 *  @param objectClassInArray          数组中需要转换的模型类
 */
+ (void)mz_setupObjectClassInArray:(MZObjectClassInArray)objectClassInArray;
@end

@interface NSObject (MZPropertyDeprecated_v_2_5_16)
+ (void)enumerateProperties:(MZPropertiesEnumeration)enumeration MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
+ (void)setupNewValueFromOldValue:(MZNewValueFromOldValue)newValueFormOldValue MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
+ (id)getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained MZProperty *)property MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
+ (void)setupReplacedKeyFromPropertyName:(MZReplacedKeyFromPropertyName)replacedKeyFromPropertyName MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
+ (void)setupReplacedKeyFromPropertyName121:(MZReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121 MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
+ (void)setupObjectClassInArray:(MZObjectClassInArray)objectClassInArray MZExtensionDeprecated("请在方法名前面加上mz_前缀，使用mz_***");
@end
