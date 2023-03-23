#ifndef __TFMJExtensionConst__M__
#define __TFMJExtensionConst__M__

#import <Foundation/Foundation.h>

/**
 *  成员变量类型（属性类型）
 */
NSString *const TFMJPropertyTypeInt = @"i";
NSString *const TFMJPropertyTypeShort = @"s";
NSString *const TFMJPropertyTypeFloat = @"f";
NSString *const TFMJPropertyTypeDouble = @"d";
NSString *const TFMJPropertyTypeLong = @"l";
NSString *const TFMJPropertyTypeLongLong = @"q";
NSString *const TFMJPropertyTypeChar = @"c";
NSString *const TFMJPropertyTypeBOOL1 = @"c";
NSString *const TFMJPropertyTypeBOOL2 = @"b";
NSString *const TFMJPropertyTypePointer = @"*";

NSString *const TFMJPropertyTypeIvar = @"^{objc_ivar=}";
NSString *const TFMJPropertyTypeMethod = @"^{objc_method=}";
NSString *const TFMJPropertyTypeBlock = @"@?";
NSString *const TFMJPropertyTypeClass = @"#";
NSString *const TFMJPropertyTypeSEL = @":";
NSString *const TFMJPropertyTypeId = @"@";

#endif
