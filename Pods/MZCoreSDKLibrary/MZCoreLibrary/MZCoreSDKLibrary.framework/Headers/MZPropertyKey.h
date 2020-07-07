//
//  MZPropertyKey.h
//  MZExtensionExample
//
//  Created by MZ Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MZPropertyKeyTypeDictionary = 0, // 字典的key
    MZPropertyKeyTypeArray // 数组的key
} MZPropertyKeyType;

/**
 *  属性的key
 */
@interface MZPropertyKey : NSObject
/** key的名字 */
@property (copy,   nonatomic) NSString *name;
/** key的种类，可能是@"10"，可能是@"age" */
@property (assign, nonatomic) MZPropertyKeyType type;

/**
 *  根据当前的key，也就是name，从object（字典或者数组）中取值
 */
- (id)valueInObject:(id)object;

@end
