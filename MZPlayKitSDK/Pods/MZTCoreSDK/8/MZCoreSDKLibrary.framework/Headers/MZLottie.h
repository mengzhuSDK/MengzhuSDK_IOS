//
//  MZtie.h
//  Pods
//
//  Created by brandon_withrow on 1/27/17.
//
//  Dream Big.

#if __has_feature(modules)
@import Foundation;
#else
#import <Foundation/Foundation.h>
#endif

#ifndef MZtie_h
#define MZtie_h

//! Project version number for MZtie.
FOUNDATION_EXPORT double MZtieVersionNumber;

//! Project version string for MZtie.
FOUNDATION_EXPORT const unsigned char MZtieVersionString[];

#include <TargetConditionals.h>

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
#import "MZAnimationTransitionController.h"
#import "MZAnimatedSwitch.h"
#import "MZAnimatedControl.h"
#endif

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
#import "MZCacheProvider.h"
#endif

#import "MZAnimationView.h"
#import "MZAnimationCache.h"
#import "MZComposition.h"
#import "MZBlockCallback.h"
#import "MZInterpolatorCallback.h"
#import "MZValueCallback.h"
#import "MZValueDelegate.h"

#endif /* MZtie_h */
