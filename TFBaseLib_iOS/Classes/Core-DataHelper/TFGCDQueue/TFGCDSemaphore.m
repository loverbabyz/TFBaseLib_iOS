//
//  TFGCDSemaphore.m
//  TFBaseLib
//
//  Created by Daniel on 16/3/3.
//  Copyright © 2016年 daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFGCDSemaphore.h"

@interface TFGCDSemaphore ()

@property (strong, readwrite, nonatomic) dispatch_semaphore_t dispatchSemaphore;

@end

@implementation TFGCDSemaphore

- (instancetype)init {
    
    return [self initWithValue:0];
    
}

- (instancetype)initWithValue:(long)value {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchSemaphore = dispatch_semaphore_create(value);
    }
    
    return self;
}

- (BOOL)signal {
    
    return dispatch_semaphore_signal(self.dispatchSemaphore) != 0;
}

- (void)wait {
    
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    
    return dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

@end
