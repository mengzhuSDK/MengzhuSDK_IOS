//
//  MZBlockCallback.h
//  MZtie
//
//  Created by brandon_withrow on 12/15/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MZValueDelegate.h"

/*!
 @brief A block that is used to change a Color value at keytime, the block is called continuously for a keypath while the animation plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startColor The color from the previous keyframe in relation to the current time.
 @param endColor The color from the next keyframe in relation to the current time.
 @param interpolatedColor The color interpolated at the current time between startColor and endColor. This represents the keypaths current color for the current time.
 @return CGColorRef the color to set the keypath node for the current frame
 */
typedef CGColorRef _Nonnull (^MZColorValueCallbackBlock)(CGFloat currentFrame,
                                                          CGFloat startKeyFrame,
                                                          CGFloat endKeyFrame,
                                                          CGFloat interpolatedProgress,
                                                          CGColorRef _Nullable startColor,
                                                          CGColorRef _Nullable endColor,
                                                          CGColorRef _Nullable interpolatedColor);

/*!
 @brief A block that is used to change a Number value at keytime, the block is called continuously for a keypath while the animation plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startValue The Number from the previous keyframe in relation to the current time.
 @param endValue The Number from the next keyframe in relation to the current time.
 @param interpolatedValue The Number interpolated at the current time between startValue and endValue. This represents the keypaths current Number for the current time.
 @return CGFloat the number to set the keypath node for the current frame
 */
typedef CGFloat (^MZNumberValueCallbackBlock)(CGFloat currentFrame,
                                               CGFloat startKeyFrame,
                                               CGFloat endKeyFrame,
                                               CGFloat interpolatedProgress,
                                               CGFloat startValue,
                                               CGFloat endValue,
                                               CGFloat interpolatedValue);
/*!
 @brief A block that is used to change a Point value at keytime, the block is called continuously for a keypath while the animation plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startPoint The Point from the previous keyframe in relation to the current time.
 @param endPoint The Point from the next keyframe in relation to the current time.
 @param interpolatedPoint The Point interpolated at the current time between startPoint and endPoint. This represents the keypaths current Point for the current time.
 @return CGPoint the point to set the keypath node for the current frame.
 */
typedef CGPoint (^MZPointValueCallbackBlock)(CGFloat currentFrame,
                                              CGFloat startKeyFrame,
                                              CGFloat endKeyFrame,
                                              CGFloat interpolatedProgress,
                                              CGPoint startPoint,
                                              CGPoint endPoint,
                                              CGPoint interpolatedPoint);

/*!
 @brief A block that is used to change a Size value at keytime, the block is called continuously for a keypath while the animation plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startSize The Size from the previous keyframe in relation to the current time.
 @param endSize The Size from the next keyframe in relation to the current time.
 @param interpolatedSize The Size interpolated at the current time between startSize and endSize. This represents the keypaths current Size for the current time.
 @return CGSize the size to set the keypath node for the current frame.
 */
typedef CGSize (^MZSizeValueCallbackBlock)(CGFloat currentFrame,
                                            CGFloat startKeyFrame,
                                            CGFloat endKeyFrame,
                                            CGFloat interpolatedProgress,
                                            CGSize startSize,
                                            CGSize endSize,
                                            CGSize interpolatedSize);

/*!
 @brief A block that is used to change a Path value at keytime, the block is called continuously for a keypath while the animation plays.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyFrame When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyFrame When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @return UIBezierPath the path to set the keypath node for the current frame.
 */
typedef CGPathRef  _Nonnull (^MZPathValueCallbackBlock)(CGFloat currentFrame,
                                                         CGFloat startKeyFrame,
                                                         CGFloat endKeyFrame,
                                                         CGFloat interpolatedProgress);

/*!
 @brief MZColorValueCallback is wrapper around a MZColorValueCallbackBlock. This block can be used in conjunction with MZAnimationView setValueDelegate:forKeypath to dynamically change an animation's color keypath at runtime.
 */

@interface MZColorBlockCallback : NSObject <MZColorValueDelegate>

+ (instancetype _Nonnull)withBlock:(MZColorValueCallbackBlock _Nonnull )block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) MZColorValueCallbackBlock callback;

@end

/*!
 @brief MZNumberValueCallback is wrapper around a MZNumberValueCallbackBlock. This block can be used in conjunction with MZAnimationView setValueDelegate:forKeypath to dynamically change an animation's number keypath at runtime.
 */

@interface MZNumberBlockCallback : NSObject <MZNumberValueDelegate>

+ (instancetype _Nonnull)withBlock:(MZNumberValueCallbackBlock _Nonnull)block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) MZNumberValueCallbackBlock callback;

@end

/*!
 @brief MZPointValueCallback is wrapper around a MZPointValueCallbackBlock. This block can be used in conjunction with MZAnimationView setValueDelegate:forKeypath to dynamically change an animation's point keypath at runtime.
 */

@interface MZPointBlockCallback : NSObject <MZPointValueDelegate>

+ (instancetype _Nonnull)withBlock:(MZPointValueCallbackBlock _Nonnull)block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) MZPointValueCallbackBlock callback;

@end

/*!
 @brief MZSizeValueCallback is wrapper around a MZSizeValueCallbackBlock. This block can be used in conjunction with MZAnimationView setValueDelegate:forKeypath to dynamically change an animation's size keypath at runtime.
 */

@interface MZSizeBlockCallback : NSObject <MZSizeValueDelegate>

+ (instancetype _Nonnull)withBlock:(MZSizeValueCallbackBlock _Nonnull)block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) MZSizeValueCallbackBlock callback;

@end

/*!
 @brief MZPathValueCallback is wrapper around a MZPathValueCallbackBlock. This block can be used in conjunction with MZAnimationView setValueDelegate:forKeypath to dynamically change an animation's path keypath at runtime.
 */

@interface MZPathBlockCallback : NSObject <MZPathValueDelegate>

+ (instancetype _Nonnull)withBlock:(MZPathValueCallbackBlock _Nonnull)block NS_SWIFT_NAME(init(block:));

@property (nonatomic, copy, nonnull) MZPathValueCallbackBlock callback;

@end

