//
//  MZValueCallback.h
//  MZtie
//
//  Created by brandon_withrow on 12/15/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MZValueDelegate.h"

/*!
 @brief MZColorValueCallback is a container for a CGColorRef. This container is a MZColorValueDelegate that always returns the colorValue property to its animation delegate.
 @discussion MZColorValueCallback is used in conjunction with MZAnimationView setValueDelegate:forKeypath to set a color value of an animation property.
 */

@interface MZColorValueCallback : NSObject <MZColorValueDelegate>

+ (instancetype _Nonnull)withCGColor:(CGColorRef _Nonnull)color NS_SWIFT_NAME(init(color:));

@property (nonatomic, nonnull) CGColorRef colorValue;

@end

/*!
 @brief MZNumberValueCallback is a container for a CGFloat value. This container is a MZNumberValueDelegate that always returns the numberValue property to its animation delegate.
 @discussion MZNumberValueCallback is used in conjunction with MZAnimationView setValueDelegate:forKeypath to set a number value of an animation property.
 */

@interface MZNumberValueCallback : NSObject <MZNumberValueDelegate>

+ (instancetype _Nonnull)withFloatValue:(CGFloat)numberValue NS_SWIFT_NAME(init(number:));

@property (nonatomic, assign) CGFloat numberValue;

@end

/*!
 @brief MZPointValueCallback is a container for a CGPoint value. This container is a MZPointValueDelegate that always returns the pointValue property to its animation delegate.
 @discussion MZPointValueCallback is used in conjunction with MZAnimationView setValueDelegate:forKeypath to set a point value of an animation property.
 */

@interface MZPointValueCallback : NSObject <MZPointValueDelegate>

+ (instancetype _Nonnull)withPointValue:(CGPoint)pointValue;

@property (nonatomic, assign) CGPoint pointValue;

@end

/*!
 @brief MZSizeValueCallback is a container for a CGSize value. This container is a MZSizeValueDelegate that always returns the sizeValue property to its animation delegate.
 @discussion MZSizeValueCallback is used in conjunction with MZAnimationView setValueDelegate:forKeypath to set a size value of an animation property.
 */

@interface MZSizeValueCallback : NSObject <MZSizeValueDelegate>

+ (instancetype _Nonnull)withPointValue:(CGSize)sizeValue NS_SWIFT_NAME(init(size:));

@property (nonatomic, assign) CGSize sizeValue;

@end

/*!
 @brief MZPathValueCallback is a container for a CGPathRef value. This container is a MZPathValueDelegate that always returns the pathValue property to its animation delegate.
 @discussion MZPathValueCallback is used in conjunction with MZAnimationView setValueDelegate:forKeypath to set a path value of an animation property.
 */

@interface MZPathValueCallback : NSObject <MZPathValueDelegate>

+ (instancetype _Nonnull)withCGPath:(CGPathRef _Nonnull)path NS_SWIFT_NAME(init(path:));

@property (nonatomic, nonnull) CGPathRef pathValue;

@end
