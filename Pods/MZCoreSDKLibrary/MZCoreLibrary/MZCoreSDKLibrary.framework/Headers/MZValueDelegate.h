//
//  MZValueDelegate.h
//  MZtie
//
//  Created by brandon_withrow on 1/5/18.
//  Copyright © 2018 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/*!
 @brief MZValueDelegate is not intended to be used directly. It is used for type safety.
 @discussion MZValueDelegates are used to dynamically change animation data at runtime. A delegate is set for a keypath, defined by MZKeypath. While the animation is running the delegate is asked for the value for the keypath at each frame of the animation. The delegate is given the computed animation value for the the current frame. See MZKeypath and the setValueDelegate:forKeypath method on MZAnimationView.

 Prebuild delegates can be found in MZBlockCallback, MZInterpolatorCallback, and MZValueCallback. These delegates allow direct setting and driving of an animated value.
 See MZColorValueDelegate, MZNumberValueDelegate, MZPointValueDelegate, MZSizeValueDelegate, MZPathValueDelegate.
 */

@protocol MZValueDelegate <NSObject>

@end

@protocol MZColorValueDelegate <MZValueDelegate>
@required
/*!
 @brief MZColorValueDelegate is called at runtime to override the color value of a property in a MZAnimation. The property is defined by at MZKeypath. The delegate is set via setValueDelegate:forKeypath on MZAnimationView.
 @discussion MZValueDelegates are used to dynamically change animation data at runtime. A delegate is set for a keypath, defined by MZKeypath. While the animation is running the delegate is asked for the value for the keypath at each frame of the animation. The delegate is given the computed animation value for the the current frame. See MZKeypath and the setValueDelegate:forKeypath method on MZAnimationView.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyframe When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyframe When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startColor The color from the previous keyframe in relation to the current time.
 @param endColor The color from the next keyframe in relation to the current time.
 @param interpolatedColor The color interpolated at the current time between startColor and endColor. This represents the keypaths current color for the current time.
 @return CGColorRef the color to set the keypath node for the current frame
 */

- (CGColorRef)colorForFrame:(CGFloat)currentFrame
              startKeyframe:(CGFloat)startKeyframe
                endKeyframe:(CGFloat)endKeyframe
       interpolatedProgress:(CGFloat)interpolatedProgress
                 startColor:(CGColorRef)startColor
                   endColor:(CGColorRef)endColor
               currentColor:(CGColorRef)interpolatedColor;


@end

@protocol MZNumberValueDelegate <MZValueDelegate>
@required
/*!
 @brief MZNumberValueDelegate is called at runtime to override the number value of a property in a MZAnimation. The property is defined by at MZKeypath. The delegate is set via setValueDelegate:forKeypath on MZAnimationView.
 @discussion MZValueDelegates are used to dynamically change animation data at runtime. A delegate is set for a keypath, defined by MZKeypath. While the animation is running the delegate is asked for the value for the keypath at each frame of the animation. The delegate is given the computed animation value for the the current frame. See MZKeypath and the setValueDelegate:forKeypath method on MZAnimationView.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyframe When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyframe When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startValue The number from the previous keyframe in relation to the current time.
 @param endValue The number from the next keyframe in relation to the current time.
 @param interpolatedValue The number interpolated at the current time between startNumber and endNumber. This represents the keypaths current number for the current time.
 @return CGFloat the number to set the keypath node for the current frame
 */

- (CGFloat)floatValueForFrame:(CGFloat)currentFrame
                startKeyframe:(CGFloat)startKeyframe
                  endKeyframe:(CGFloat)endKeyframe
         interpolatedProgress:(CGFloat)interpolatedProgress
                   startValue:(CGFloat)startValue
                     endValue:(CGFloat)endValue
                 currentValue:(CGFloat)interpolatedValue;

@end

@protocol MZPointValueDelegate <MZValueDelegate>
@required
/*!
 @brief MZPointValueDelegate is called at runtime to override the point value of a property in a MZAnimation. The property is defined by at MZKeypath. The delegate is set via setValueDelegate:forKeypath on MZAnimationView.
 @discussion MZValueDelegates are used to dynamically change animation data at runtime. A delegate is set for a keypath, defined by MZKeypath. While the animation is running the delegate is asked for the value for the keypath at each frame of the animation. The delegate is given the computed animation value for the the current frame. See MZKeypath and the setValueDelegate:forKeypath method on MZAnimationView.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyframe When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyframe When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startPoint The point from the previous keyframe in relation to the current time.
 @param endPoint The point from the next keyframe in relation to the current time.
 @param interpolatedPoint The point interpolated at the current time between startPoint and endPoint. This represents the keypaths current point for the current time.
 @return CGPoint the point to set the keypath node for the current frame
 */

- (CGPoint)pointForFrame:(CGFloat)currentFrame
           startKeyframe:(CGFloat)startKeyframe
             endKeyframe:(CGFloat)endKeyframe
    interpolatedProgress:(CGFloat)interpolatedProgress
              startPoint:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint
            currentPoint:(CGPoint)interpolatedPoint;

@end

@protocol MZSizeValueDelegate <MZValueDelegate>
@required
/*!
 @brief MZSizeValueDelegate is called at runtime to override the size value of a property in a MZAnimation. The property is defined by at MZKeypath. The delegate is set via setValueDelegate:forKeypath on MZAnimationView.
 @discussion MZValueDelegates are used to dynamically change animation data at runtime. A delegate is set for a keypath, defined by MZKeypath. While the animation is running the delegate is asked for the value for the keypath at each frame of the animation. The delegate is given the computed animation value for the the current frame. See MZKeypath and the setValueDelegate:forKeypath method on MZAnimationView.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyframe When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyframe When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @param startSize The size from the previous keyframe in relation to the current time.
 @param endSize The size from the next keyframe in relation to the current time.
 @param interpolatedSize The size interpolated at the current time between startSize and endSize. This represents the keypaths current size for the current time.
 @return CGSize the size to set the keypath node for the current frame
 */

- (CGSize)sizeForFrame:(CGFloat)currentFrame
         startKeyframe:(CGFloat)startKeyframe
           endKeyframe:(CGFloat)endKeyframe
  interpolatedProgress:(CGFloat)interpolatedProgress
             startSize:(CGSize)startSize
               endSize:(CGSize)endSize
           currentSize:(CGSize)interpolatedSize;


@end

@protocol MZPathValueDelegate <MZValueDelegate>
@required
/*!
 @brief MZPathValueDelegate is called at runtime to override the path value of a property in a MZAnimation. The property is defined by at MZKeypath. The delegate is set via setValueDelegate:forKeypath on MZAnimationView.
 @discussion MZValueDelegates are used to dynamically change animation data at runtime. A delegate is set for a keypath, defined by MZKeypath. While the animation is running the delegate is asked for the value for the keypath at each frame of the animation. The delegate is given the computed animation value for the the current frame. See MZKeypath and the setValueDelegate:forKeypath method on MZAnimationView.
 @param currentFrame The current frame of the animation in the parent compositions time space.
 @param startKeyframe When the block is called, startFrame is the most recent keyframe for the keypath in relation to the current time.
 @param endKeyframe When the block is called, endFrame is the next keyframe for the keypath in relation to the current time.
 @param interpolatedProgress A value from 0-1 that represents the current progress between keyframes. It respects the keyframes current easing curves.
 @return CGPathRef the path to set the keypath node for the current frame
 */

- (CGPathRef)pathForFrame:(CGFloat)currentFrame
            startKeyframe:(CGFloat)startKeyframe
              endKeyframe:(CGFloat)endKeyframe
     interpolatedProgress:(CGFloat)interpolatedProgress;


@end
