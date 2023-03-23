//
//  MJPropertyType.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "TFMJPropertyType.h"
#import "TFMJExtension.h"
#import "TFMJFoundation.h"
#import "TFMJExtensionConst.h"

@implementation TFMJPropertyType

+ (instancetype)cachedTypeWithCode:(NSString *)code
{
    TFMJExtensionAssertParamNotNil2(code, nil);
    
    static NSMutableDictionary *types;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        types = [NSMutableDictionary dictionary];
    });
    
    TFMJPropertyType *type = types[code];
    if (type == nil) {
        type = [[self alloc] init];
        type.code = code;
        types[code] = type;
    }
    return type;
}

#pragma mark - 公共方法
- (void)setCode:(NSString *)code
{
    _code = code;
    
    TFMJExtensionAssertParamNotNil(code);
    
    if ([code isEqualToString:TFMJPropertyTypeId]) {
        _idType = YES;
    } else if (code.length == 0) {
        _KVCDisabled = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _fromFoundation = [TFMJFoundation isClassFromFoundation:_typeClass];
        _numberType = [_typeClass isSubclassOfClass:[NSNumber class]];
        
    } else if ([code isEqualToString:TFMJPropertyTypeSEL] ||
               [code isEqualToString:TFMJPropertyTypeIvar] ||
               [code isEqualToString:TFMJPropertyTypeMethod]) {
        _KVCDisabled = YES;
    }
    
    // 是否为数字类型
    NSString *lowerCode = _code.lowercaseString;
    NSArray *numberTypes = @[TFMJPropertyTypeInt, TFMJPropertyTypeShort, TFMJPropertyTypeBOOL1, TFMJPropertyTypeBOOL2, TFMJPropertyTypeFloat, TFMJPropertyTypeDouble, TFMJPropertyTypeLong, TFMJPropertyTypeLongLong, TFMJPropertyTypeChar];
    if ([numberTypes containsObject:lowerCode]) {
        _numberType = YES;
        
        if ([lowerCode isEqualToString:TFMJPropertyTypeBOOL1]
            || [lowerCode isEqualToString:TFMJPropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}
@end
