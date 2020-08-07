#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MZSIOSocket.h"
#import "mzsocket.io.js.h"
#import "MZSocketIOClient.h"

FOUNDATION_EXPORT double MZSocketIOVersionNumber;
FOUNDATION_EXPORT const unsigned char MZSocketIOVersionString[];

