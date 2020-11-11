//
//  MZChatTool.h
//  MZChatSDK
//
//  Created by LiWei on 2020/8/4.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZChatTool : NSObject
//自定义的 NSString转NSURL方法，防止str中有中文或者\导致转为nil的问题
+(NSURL *)customUrlWithStr:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
