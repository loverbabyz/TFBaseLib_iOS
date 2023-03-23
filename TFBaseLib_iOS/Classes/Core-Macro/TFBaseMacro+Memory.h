//
//  TFMacro+Memory.h
//  Treasure
//
//  Created by Daniel on 15/9/14.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#ifndef TF_WEAK_OBJECT
#define TF_WEAK_OBJECT(object) __weak typeof(object) weakObject = object;
#endif

#ifndef TF_STRONG_OBJECT
#define TF_STRONG_OBJECT(object) __strong typedef(object) strongObject = object;
#endif

#ifndef TF_WEAK_SELF
#define TF_WEAK_SELF __weak __typeof(&*self)weakSelf = self;
#endif

#ifndef TF_STRONG_SELF
#define TF_STRONG_SELF __strong __typeof(&*self)strongSelf = self;
#endif
