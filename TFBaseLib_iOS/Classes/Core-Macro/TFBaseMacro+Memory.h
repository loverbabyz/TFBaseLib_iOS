//
//  TFMacro+Memory.h
//  Treasure
//
//  Created by Daniel on 15/9/14.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#define TF_WEAK_OBJECT(object) __weak typeof(object) weakObject = object;
#define TF_STRONG_OBJECT(object) __strong typedef(object) strongObject = object;

#define TF_WEAK_SELF __weak __typeof(&*self)weakSelf = self;
#define TF_STRONG_SELF __strong __typeof(&*self)strongSelf = self;
