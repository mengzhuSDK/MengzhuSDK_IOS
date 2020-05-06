//
//  MZFoundation.h
//  MZExtensionExample
//
//  Created by MZ Lee on 14/7/16.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZFoundation : NSObject

+ (BOOL)isClassFromFoundation:(Class)c;
+ (BOOL)isFromNSObjectProtocolProperty:(NSString *)propertyName;

@end
