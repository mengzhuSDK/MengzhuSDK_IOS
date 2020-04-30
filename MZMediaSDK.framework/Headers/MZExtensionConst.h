
#ifndef __MZExtensionConst__H__
#define __MZExtensionConst__H__

#import <Foundation/Foundation.h>

#ifndef mz_LOCK
#define mz_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef mz_UNLOCK
#define mz_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

// 信号量
#define MZExtensionSemaphoreCreate \
static dispatch_semaphore_t signalSemaphore; \
static dispatch_once_t onceTokenSemaphore; \
dispatch_once(&onceTokenSemaphore, ^{ \
    signalSemaphore = dispatch_semaphore_create(1); \
});

#define MZExtensionSemaphoreWait mz_LOCK(signalSemaphore)
#define MZExtensionSemaphoreSignal mz_UNLOCK(signalSemaphore)

// 过期
#define MZExtensionDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 构建错误
#define MZExtensionBuildError(clazz, msg) \
NSError *error = [NSError errorWithDomain:msg code:250 userInfo:nil]; \
[clazz setmz_error:error];

// 日志输出
#ifdef DEBUG
#define MZExtensionLog(...) NSLog(__VA_ARGS__)
#else
#define MZExtensionLog(...)
#endif

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define MZExtensionAssertError(condition, returnValue, clazz, msg) \
[clazz setmz_error:nil]; \
if ((condition) == NO) { \
    MZExtensionBuildError(clazz, msg); \
    return returnValue;\
}

#define MZExtensionAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define MZExtensionAssert(condition) MZExtensionAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define MZExtensionAssertParamNotNil2(param, returnValue) \
MZExtensionAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define MZExtensionAssertParamNotNil(param) MZExtensionAssertParamNotNil2(param, )

/**
 * 打印所有的属性
 */
#define MZLogAllIvars \
-(NSString *)description \
{ \
    return [self mz_keyValues].description; \
}
#define MZExtensionLogAllProperties MZLogAllIvars

/** 仅在 Debugger 展示所有的属性 */
#define MZImplementDebugDescription \
-(NSString *)debugDescription \
{ \
return [self mz_keyValues].debugDescription; \
}

/**
 *  类型（属性类型）
 */
FOUNDATION_EXPORT NSString *const MZPropertyTypeInt;
FOUNDATION_EXPORT NSString *const MZPropertyTypeShort;
FOUNDATION_EXPORT NSString *const MZPropertyTypeFloat;
FOUNDATION_EXPORT NSString *const MZPropertyTypeDouble;
FOUNDATION_EXPORT NSString *const MZPropertyTypeLong;
FOUNDATION_EXPORT NSString *const MZPropertyTypeLongLong;
FOUNDATION_EXPORT NSString *const MZPropertyTypeChar;
FOUNDATION_EXPORT NSString *const MZPropertyTypeBOOL1;
FOUNDATION_EXPORT NSString *const MZPropertyTypeBOOL2;
FOUNDATION_EXPORT NSString *const MZPropertyTypePointer;

FOUNDATION_EXPORT NSString *const MZPropertyTypeIvar;
FOUNDATION_EXPORT NSString *const MZPropertyTypeMethod;
FOUNDATION_EXPORT NSString *const MZPropertyTypeBlock;
FOUNDATION_EXPORT NSString *const MZPropertyTypeClass;
FOUNDATION_EXPORT NSString *const MZPropertyTypeSEL;
FOUNDATION_EXPORT NSString *const MZPropertyTypeId;

#endif
