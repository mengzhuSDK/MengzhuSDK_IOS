//
//  NSString+SafePrice.m
//  DaRen
//
//  Created by 李风 on 2020/3/12.
//  Copyright © 2020 DR. All rights reserved.
//

#import "NSString+SafePrice.h"

@implementation NSString (SafePrice)

- (NSString *)safePriceString {
    NSArray *array = [self componentsSeparatedByString:@"."];
    if (array.count > 1) {
        NSString *secondString = array[1];
        if (secondString.length > 2) {
            secondString = [secondString substringToIndex:2];
        }
        return [NSString stringWithFormat:@"%@.%@",array[0],secondString];
    }
    return self;
}

@end
