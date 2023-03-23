//
//  TFBaseLibCategory.h
//  Treasure
//
//  Created by Daniel on 15/7/1.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//


#ifndef TFBaseLibCategory_h
#define TFBaseLibCategory_h

/**
 * Add this macro before each category implementation, so we don't have to use
 * -all_load or -force_load to load object files from static libraries that only contain
 * categories and no classes.
 * See http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html for more info.
 */

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name: NSObject @end \
                                  @implementation TT_FIX_CATEGORY_BUG_##name @end

#import "NSArray+Category.h"
#import "NSData+Category.h"
#import "NSDate+Category.h"
#import "NSDictionary+Category.h"
#import "NSObject+Category.h"
#import "NSString+Category.h"

#import "NSError+Category.h"
#import "NSFileManager+Category.h"
#import "NSRegularExpression+Category.h"
#import "NSURL+Category.h"

#endif
