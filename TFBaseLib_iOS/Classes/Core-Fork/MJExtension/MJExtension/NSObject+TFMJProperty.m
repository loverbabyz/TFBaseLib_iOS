//
//  NSObject+TFMJProperty.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/4/17.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "NSObject+TFMJProperty.h"
#import "NSObject+TFMJKeyValue.h"
#import "NSObject+TFMJCoding.h"
#import "NSObject+TFMJClass.h"
#import "TFMJProperty.h"
#import "TFMJFoundation.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

static const char TFMJReplacedKeyFromPropertyNameKey = '\0';
static const char TFMJReplacedKeyFromPropertyName121Key = '\0';
static const char TFMJNewValueFromOldValueKey = '\0';
static const char TFMJObjectClassInArrayKey = '\0';

static const char TFMJCachedPropertiesKey = '\0';

dispatch_semaphore_t tf_mje_signalSemaphore;
dispatch_once_t tf_mje_onceTokenSemaphore;

@implementation NSObject (TFMJProperty)

+ (NSMutableDictionary *)tf_mj_propertyDictForKey:(const void *)key
{
    static NSMutableDictionary *replacedKeyFromPropertyNameDict;
    static NSMutableDictionary *replacedKeyFromPropertyName121Dict;
    static NSMutableDictionary *newValueFromOldValueDict;
    static NSMutableDictionary *objectClassInArrayDict;
    static NSMutableDictionary *cachedPropertiesDict;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        replacedKeyFromPropertyNameDict = [NSMutableDictionary dictionary];
        replacedKeyFromPropertyName121Dict = [NSMutableDictionary dictionary];
        newValueFromOldValueDict = [NSMutableDictionary dictionary];
        objectClassInArrayDict = [NSMutableDictionary dictionary];
        cachedPropertiesDict = [NSMutableDictionary dictionary];
    });
    
    if (key == &TFMJReplacedKeyFromPropertyNameKey) return replacedKeyFromPropertyNameDict;
    if (key == &TFMJReplacedKeyFromPropertyName121Key) return replacedKeyFromPropertyName121Dict;
    if (key == &TFMJNewValueFromOldValueKey) return newValueFromOldValueDict;
    if (key == &TFMJObjectClassInArrayKey) return objectClassInArrayDict;
    if (key == &TFMJCachedPropertiesKey) return cachedPropertiesDict;
    return nil;
}

#pragma mark - --私有方法--
+ (id)tf_mj_propertyKey:(NSString *)propertyName
{
    TFMJExtensionAssertParamNotNil2(propertyName, nil);
    
    __block id key = nil;
    // 查看有没有需要替换的key
    if ([self respondsToSelector:@selector(mj_replacedKeyFromPropertyName121:)]) {
        key = [self mj_replacedKeyFromPropertyName121:propertyName];
    }
    
    // 调用block
    if (!key) {
        [self tf_mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            TFMJReplacedKeyFromPropertyName121 block = objc_getAssociatedObject(c, &TFMJReplacedKeyFromPropertyName121Key);
            if (block) {
                key = block(propertyName);
            }
            if (key) *stop = YES;
        }];
    }
    
    // 查看有没有需要替换的key
    if ((!key || [key isEqual:propertyName]) && [self respondsToSelector:@selector(mj_replacedKeyFromPropertyName)]) {
        key = [self mj_replacedKeyFromPropertyName][propertyName];
    }
    
    if (!key || [key isEqual:propertyName]) {
        [self tf_mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &TFMJReplacedKeyFromPropertyNameKey);
            if (dict) {
                key = dict[propertyName];
            }
            if (key && ![key isEqual:propertyName]) *stop = YES;
        }];
    }
    
    // 2.用属性名作为key
    if (!key) key = propertyName;
    
    return key;
}

+ (Class)tf_mj_propertyObjectClassInArray:(NSString *)propertyName
{
    __block id clazz = nil;
    if ([self respondsToSelector:@selector(mj_objectClassInArray)]) {
        clazz = [self mj_objectClassInArray][propertyName];
    }
    
    if (!clazz) {
        [self tf_mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &TFMJObjectClassInArrayKey);
            if (dict) {
                clazz = dict[propertyName];
            }
            if (clazz) *stop = YES;
        }];
    }
    
    // 如果是NSString类型
    if ([clazz isKindOfClass:[NSString class]]) {
        clazz = NSClassFromString(clazz);
    }
    return clazz;
}

#pragma mark - --公共方法--
+ (void)tf_mj_enumerateProperties:(TFMJPropertiesEnumeration)enumeration
{
    // 获得成员变量
    NSArray *cachedProperties = [self tf_mj_properties];
    // 遍历成员变量
    BOOL stop = NO;
    for (TFMJProperty *property in cachedProperties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}

#pragma mark - 公共方法
+ (NSArray *)tf_mj_properties
{
    TFMJExtensionSemaphoreCreate
    TF_MJ_LOCK(tf_mje_signalSemaphore);
    NSMutableDictionary *cachedInfo = [self tf_mj_propertyDictForKey:&TFMJCachedPropertiesKey];
    NSMutableArray *cachedProperties = cachedInfo[NSStringFromClass(self)];
    if (cachedProperties == nil) {
        cachedProperties = [NSMutableArray array];
        
        [self tf_mj_enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            // 1.获得所有的成员变量
            unsigned int outCount = 0;
            objc_property_t *properties = class_copyPropertyList(c, &outCount);
            
            // 2.遍历每一个成员变量
            for (unsigned int i = 0; i<outCount; i++) {
                TFMJProperty *property = [TFMJProperty cachedPropertyWithProperty:properties[i]];
                // 过滤掉Foundation框架类里面的属性
                if ([TFMJFoundation isClassFromFoundation:property.srcClass]) continue;
                // 过滤掉`hash`, `superclass`, `description`, `debugDescription`
                if ([TFMJFoundation isFromNSObjectProtocolProperty:property.name]) continue;
                
                property.srcClass = c;
                [property setOriginKey:[self tf_mj_propertyKey:property.name] forClass:self];
                [property setObjectClassInArray:[self tf_mj_propertyObjectClassInArray:property.name] forClass:self];
                [cachedProperties addObject:property];
            }
            
            // 3.释放内存
            free(properties);
        }];
        
        cachedInfo[NSStringFromClass(self)] = cachedProperties;
    }
    NSArray *properties = [cachedProperties copy];
    TF_MJ_UNLOCK(tf_mje_signalSemaphore);
    
    return properties;
}

#pragma mark - 新值配置
+ (void)tf_mj_setupNewValueFromOldValue:(TFMJNewValueFromOldValue)newValueFormOldValue {
    TFMJExtensionSemaphoreCreate
    TF_MJ_LOCK(tf_mje_signalSemaphore);
    objc_setAssociatedObject(self, &TFMJNewValueFromOldValueKey, newValueFormOldValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
    TF_MJ_UNLOCK(tf_mje_signalSemaphore);
}

+ (id)tf_mj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(TFMJProperty *__unsafe_unretained)property{
    // 如果有实现方法
    if ([object respondsToSelector:@selector(mj_newValueFromOldValue:property:)]) {
        return [object mj_newValueFromOldValue:oldValue property:property];
    }
    
    TFMJExtensionSemaphoreCreate
    TF_MJ_LOCK(tf_mje_signalSemaphore);
    // 查看静态设置
    __block id newValue = oldValue;
    [self tf_mj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        TFMJNewValueFromOldValue block = objc_getAssociatedObject(c, &TFMJNewValueFromOldValueKey);
        if (block) {
            newValue = block(object, oldValue, property);
            *stop = YES;
        }
    }];
    TF_MJ_UNLOCK(tf_mje_signalSemaphore);
    return newValue;
}

+ (void)mj_removeCachedProperties {
    TFMJExtensionSemaphoreCreate
    TF_MJ_LOCK(tf_mje_signalSemaphore);
    [[self tf_mj_propertyDictForKey:&TFMJCachedPropertiesKey] removeAllObjects];
    TF_MJ_UNLOCK(tf_mje_signalSemaphore);
}

#pragma mark - array model class配置
+ (void)tf_mj_setupObjectClassInArray:(TFMJObjectClassInArray)objectClassInArray
{
    [self tf_mj_setupBlockReturnValue:objectClassInArray key:&TFMJObjectClassInArrayKey];
    
    [self mj_removeCachedProperties];
}

#pragma mark - key配置

+ (void)tf_mj_setupReplacedKeyFromPropertyName:(TFMJReplacedKeyFromPropertyName)replacedKeyFromPropertyName {
    [self tf_mj_setupBlockReturnValue:replacedKeyFromPropertyName key:&TFMJReplacedKeyFromPropertyNameKey];
    
    [self mj_removeCachedProperties];
}

+ (void)tf_mj_setupReplacedKeyFromPropertyName121:(TFMJReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121 {
    TFMJExtensionSemaphoreCreate
    TF_MJ_LOCK(tf_mje_signalSemaphore);
    objc_setAssociatedObject(self, &TFMJReplacedKeyFromPropertyName121Key, replacedKeyFromPropertyName121, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [[self tf_mj_propertyDictForKey:&TFMJCachedPropertiesKey] removeAllObjects];
    TF_MJ_UNLOCK(tf_mje_signalSemaphore);
}
@end
#pragma clang diagnostic pop
