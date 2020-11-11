//
//  MZAnimationView_Compat.h
//  MZtie
//
//  Created by Oleksii Pavlovskyi on 2/2/17.
//  Copyright (c) 2017 Airbnb. All rights reserved.
//

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR

#import <UIKit/UIKit.h>
@compatibility_alias MZView UIView;

#else

#import <AppKit/AppKit.h>
@compatibility_alias MZView NSView;

typedef NS_ENUM(NSInteger, MZViewContentMode) {
    MZViewContentModeScaleToFill,
    MZViewContentModeScaleAspectFit,
    MZViewContentModeScaleAspectFill,
    MZViewContentModeRedraw,
    MZViewContentModeCenter,
    MZViewContentModeTop,
    MZViewContentModeBottom,
    MZViewContentModeLeft,
    MZViewContentModeRight,
    MZViewContentModeTopLeft,
    MZViewContentModeTopRight,
    MZViewContentModeBottomLeft,
    MZViewContentModeBottomRight,
};

#endif

