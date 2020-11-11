//
//  MZURL.h
//  MengZhu
//
//  Created by LiWei on 2019/9/3.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZURL : NSURL
//自定义的 NSString转NSURL方法，防止str中有中文或者\导致转为nil的问题
+(NSURL *)customUrlWithStr:(NSString *)str;

// 字符串特殊字符转义，如果遇到中文或者特殊字符串在URL访问出问题，可用此方法进行URL转义，再访问
+ (NSString *)urlStringEncodeUTF8String:(NSString *)input;
@end

NS_ASSUME_NONNULL_END
