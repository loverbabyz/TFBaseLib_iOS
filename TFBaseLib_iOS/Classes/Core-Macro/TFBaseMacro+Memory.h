//
//  TFMacro+Memory.h
//  Treasure
//
//  Created by xiayiyong on 15/9/14.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#define WEAK_OBJECT(object) __weak typeof(object) weakObject = object;
#define STRONG_OBJECT(object) __strong typedef(object) strongObject = object;

#define WEAK_SELF __weak __typeof(&*self)weakSelf = self;
#define STRONG_SELF __strong __typeof(&*self)strongSelf = self;

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
