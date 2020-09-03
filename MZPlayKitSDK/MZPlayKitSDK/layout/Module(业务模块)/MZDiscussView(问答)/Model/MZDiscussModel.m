//
//  MZDiscussModel.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZDiscussModel.h"

@implementation MZDiscussReplyModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

@implementation MZDiscussModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"replys":[MZDiscussReplyModel class],
             
    };
}

@end
