//
//  NSObject+TFMJClass.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "NSObject+TFMJClass.h"
#import "NSObject+TFMJCoding.h"
#import "NSObject+TFMJKeyValue.h"
#import "TFMJFoundation.h"
#import <objc/runtime.h>

static const char TFMJAllowedPropertyNamesKey = '\0';
static const char TFMJIgnoredPropertyNamesKey = '\0';
static const char TFMJAllowedCodingPropertyNamesKey = '\0';
static const char TFMJIgnoredCodingPropertyNamesKey = '\0';

@implementation NSObject (TFMJClass)

+ (NSMutableDictionary *)mj_classDictForKey:(const void *)key
{
    static NSMutableDictionary *allowedPropertyNamesDict;
    static NSMutableDictionary *ignoredPropertyNamesDict;
    static NSMutableDictionary *allowedCodingPropertyNamesDict;
    static NSMutableDictionary *ignoredCodingPropertyNamesDict;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allowedPropertyNamesDict = [NSMutableDictionary dictionary];
        ignoredPropertyNamesDict = [NSMutableDictionary dictionary];
        allowedCodingPropertyNamesDict = [NSMutableDictionary dictionary];
        ignoredCodingPropertyNamesDict = [NSMutableDictionary dictionary];
    });
    
    if (key == &TFMJAllowedPropertyNamesKey) return allowedPropertyNamesDict;
    if (key == &TFMJIgnoredPropertyNamesKey) return ignoredPropertyNamesDict;
    if (key == &TFMJAllowedCodingPropertyNamesKey) return allowedCodingPropertyNamesDict;
    if (key == &TFMJIgnoredCodingPropertyNamesKey) return ignoredCodingPropertyNamesDict;
    return nil;
}

+ (void)tf_mj_enumerateClasses:(TFMJClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if ([TFMJFoundation isClassFromFoundation:c]) break;
    }
}

+ (void)tf_mj_enumerateAllClasses:(TFMJClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}

#pragma mark - 属性黑名单配置
+ (void)tf_mj_setupIgnoredPropertyNames:(TFMJIgnoredPropertyNames)ignoredPropertyNames
{
    [self tf_mj_setupBlockReturnValue:ignoredPropertyNames key:&TFMJIgnoredPropertyNamesKey];
}

+ (NSMutableArray *)tf_mj_totalIgnoredPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_ignoredPropertyNames) key:&TFMJIgnoredPropertyNamesKey];
}

#pragma mark - 归档属性黑名单配置
+ (void)tf_mj_setupIgnoredCodingPropertyNames:(TFMJIgnoredCodingPropertyNames)ignoredCodingPropertyNames
{
    [self tf_mj_setupBlockReturnValue:ignoredCodingPropertyNames key:&TFMJIgnoredCodingPropertyNamesKey];
}

+ (NSMutableArray *)tf_mj_totalIgnoredCodingPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_ignoredCodingPropertyNames) key:&TFMJIgnoredCodingPropertyNamesKey];
}

#pragma mark - 属性白名单配置
+ (void)tf_mj_setupAllowedPropertyNames:(TFMJAllowedPropertyNames)allowedPropertyNames;
{
    [self tf_mj_setupBlockReturnValue:allowedPropertyNames key:&TFMJAllowedPropertyNamesKey];
}

+ (NSMutableArray *)tf_mj_totalAllowedPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_allowedPropertyNames) key:&TFMJAllowedPropertyNamesKey];
}

#pragma mark - 归档属性白名单配置
+ (void)tf_mj_setupAllowedCodingPropertyNames:(TFMJAllowedCodingPropertyNames)allowedCodingPropertyNames
{
    [self tf_mj_setupBlockReturnValue:allowedCodingPropertyNames key:&TFMJAllowedCodingPropertyNamesKey];
}

+ (NSMutableArray *)tf_mj_totalAllowedCodingPropertyNames
{
    return [self mj_totalObjectsWithSelector:@selector(mj_allowedCodingPropertyNames) key:&TFMJAllowedCodingPropertyNamesKey];
}

#pragma mark - block和方法处理:存储block的返回值
+ (void)tf_mj_setupBlockReturnValue:(id (^)(void))block key:(const char *)key {
    TFMJExtensionSemaphoreCreate
    TF_MJ_LOCK(tf_mje_signalSemaphore);
    if (block) {
        objc_setAssociatedObject(self, key, block(), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 清空数据
    [[self mj_classDictForKey:key] removeAllObjects];
    TF_MJ_UNLOCK(tf_mje_signalSemaphore);
}

+ (NSMutableArray *)mj_totalObjectsWithSelector:(SEL)selector key:(const char *)key
{
    TFMJExtensionSemaphoreCreate
    TF_MJ_LOCK(tf_mje_signalSemaphore);
    NSMutableArray *array = [self mj_classDictForKey:key][NSStringFromClass(self)];
    if (array == nil) {
        // 创建、存储
        [self mj_classDictForKey:key][NSStringFromClass(self)] = array = [NSMutableArray array];
        
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSArray *subArray = [self performSelector:selector];
#pragma clang diagnostic pop
            if (subArray) {
                [array addObjectsFromArray:subArray];
            }
        }
        
        [self tf_mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSArray *subArray = objc_getAssociatedObject(c, key);
            [array addObjectsFromArray:subArray];
        }];
    }
    TF_MJ_UNLOCK(tf_mje_signalSemaphore);
    return array;
}
@end
