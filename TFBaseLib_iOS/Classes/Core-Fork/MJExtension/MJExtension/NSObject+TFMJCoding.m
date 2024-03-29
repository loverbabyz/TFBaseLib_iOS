//
//  NSObject+TFMJCoding.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "NSObject+TFMJCoding.h"
#import "NSObject+TFMJClass.h"
#import "NSObject+TFMJProperty.h"
#import "TFMJProperty.h"

@implementation NSObject (TFMJCoding)

- (void)tf_mj_encode:(NSCoder *)encoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz tf_mj_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz tf_mj_totalIgnoredCodingPropertyNames];
    
    [clazz tf_mj_enumerateProperties:^(TFMJProperty *property, BOOL *stop) {
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [property valueForObject:self];
        if (value == nil) return;
        [encoder encodeObject:value forKey:property.name];
    }];
}

- (void)tf_mj_decode:(NSCoder *)decoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz tf_mj_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz tf_mj_totalIgnoredCodingPropertyNames];
    
    [clazz tf_mj_enumerateProperties:^(TFMJProperty *property, BOOL *stop) {
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        // fixed `-[NSKeyedUnarchiver validateAllowedClass:forKey:] allowed unarchiving safe plist type ''NSNumber'(This will be disallowed in the future.)` warning.
        Class genericClass = [property objectClassInArrayForClass:property.srcClass];
        // If genericClass exists, property.type.typeClass would be a collection type(Array, Set, Dictionary). This scenario([obj, nil, obj, nil]) would not happened.
        NSSet *classes = [NSSet setWithObjects:NSNumber.class,
                          property.type.typeClass, genericClass, nil];
        id value = [decoder decodeObjectOfClasses:classes forKey:property.name];
        if (value == nil) { // 兼容以前的MJExtension版本
            value = [decoder decodeObjectForKey:[@"_" stringByAppendingString:property.name]];
        }
        if (value == nil) return;
        [property setValue:value forObject:self];
    }];
}
@end
