//
//  NSBundle+MZRefresh.h
//  MZRefreshExample
//
//  Created by MZ Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (MZRefresh)
+ (instancetype)MZ_refreshBundle;
+ (UIImage *)MZ_arrowImage;
+ (NSString *)MZ_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)MZ_localizedStringForKey:(NSString *)key;
@end
