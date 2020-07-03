//
//  NSObject+MZCoding.h
//  MZExtension
//
//  Created by MZ on 14-1-15.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZExtensionConst.h"

/**
 *  Codeing协议
 */
@protocol MZCoding <NSObject>
@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)mz_allowedCodingPropertyNames;
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)mz_ignoredCodingPropertyNames;
@end

@interface NSObject (MZCoding) <MZCoding>
/**
 *  解码（从文件中解析对象）
 */
- (void)mz_decode:(NSCoder *)decoder;
/**
 *  编码（将对象写入文件中）
 */
- (void)mz_encode:(NSCoder *)encoder;
@end

/**
 归档的实现
 */
#define MZCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self mz_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self mz_encode:encoder]; \
}

#define MZExtensionCodingImplementation MZCodingImplementation
