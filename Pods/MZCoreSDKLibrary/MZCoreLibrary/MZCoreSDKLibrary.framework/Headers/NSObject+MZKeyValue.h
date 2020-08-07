//
//  NSObject+MZKeyValue.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/8/6.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MZKeyValue)

+ (instancetype)mz_objectWithKeyValues:(id)keyValues;

@end

NS_ASSUME_NONNULL_END
