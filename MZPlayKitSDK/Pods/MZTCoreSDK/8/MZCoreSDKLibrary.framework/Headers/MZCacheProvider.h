//
//  MZCacheProvider.h
//  MZtie
//
//  Created by punmy on 2017/7/8.
//
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR

#import <UIKit/UIKit.h>
@compatibility_alias MZImage UIImage;

@protocol MZImageCache;

#pragma mark - MZCacheProvider

@interface MZCacheProvider : NSObject

+ (id<MZImageCache>)imageCache;
+ (void)setImageCache:(id<MZImageCache>)cache;

@end

#pragma mark - MZImageCache

/**
 This protocol represent the interface of a image cache which MZtie can use.
 */
@protocol MZImageCache <NSObject>

@required
- (MZImage *)imageForKey:(NSString *)key;
- (void)setImage:(MZImage *)image forKey:(NSString *)key;

@end

#endif
