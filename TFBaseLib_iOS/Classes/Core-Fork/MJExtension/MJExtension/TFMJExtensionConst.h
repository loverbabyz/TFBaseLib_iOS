
#ifndef __TFMJExtensionConst__H__
#define __TFMJExtensionConst__H__

#import <Foundation/Foundation.h>

#ifndef TF_MJ_LOCK
#define TF_MJ_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef TF_MJ_UNLOCK
#define TF_MJ_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

// 信号量
#define TFMJExtensionSemaphoreCreate \
extern dispatch_semaphore_t tf_mje_signalSemaphore; \
extern dispatch_once_t tf_mje_onceTokenSemaphore; \
dispatch_once(&tf_mje_onceTokenSemaphore, ^{ \
    tf_mje_signalSemaphore = dispatch_semaphore_create(1); \
});

// 过期
#define TFMJExtensionDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 构建错误
#define TFMJExtensionBuildError(clazz, msg) \
NSError *error = [NSError errorWithDomain:msg code:250 userInfo:nil]; \
[clazz setMj_error:error];

// 日志输出
#ifdef DEBUG
#define TFMJExtensionLog(...) NSLog(__VA_ARGS__)
#else
#define TFMJExtensionLog(...)
#endif

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define TFMJExtensionAssertError(condition, returnValue, clazz, msg) \
[clazz setMj_error:nil]; \
if ((condition) == NO) { \
    TFMJExtensionBuildError(clazz, msg); \
    return returnValue;\
}

#define TFMJExtensionAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define TFMJExtensionAssert(condition) TFMJExtensionAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define TFMJExtensionAssertParamNotNil2(param, returnValue) \
TFMJExtensionAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define TFMJExtensionAssertParamNotNil(param) TFMJExtensionAssertParamNotNil2(param, )

/**
 * 打印所有的属性
 */
#define TFMJLogAllIvars \
- (NSString *)description \
{ \
    return [self tf_mj_keyValues].description; \
}
#define TFMJExtensionLogAllProperties TFMJLogAllIvars

/** 仅在 Debugger 展示所有的属性 */
#define TFMJImplementDebugDescription \
- (NSString *)debugDescription \
{ \
return [self tf_mj_keyValues].debugDescription; \
}

/**
 *  类型（属性类型）
 */
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeInt;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeShort;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeFloat;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeDouble;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeLong;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeLongLong;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeChar;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeBOOL1;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeBOOL2;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypePointer;

FOUNDATION_EXPORT NSString *const TFMJPropertyTypeIvar;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeMethod;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeBlock;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeClass;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeSEL;
FOUNDATION_EXPORT NSString *const TFMJPropertyTypeId;

#endif
