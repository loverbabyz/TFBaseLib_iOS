//
//  TFUserDefaults.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/21.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//  from https://github.com/gangverk/GVUserDefaults
//

#import <Foundation/Foundation.h>

@interface TFUserDefaults : NSObject

#define kTFUserDefaults  ([TFUserDefaults standardUserDefaults])

/**
 *  构造UserDefaults
 *
 */
+ (instancetype)standardUserDefaults;

@end

