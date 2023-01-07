//
//  TFBaseUtil+Float.m
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil+Float.h"

CGFloat tf_randomFloat(void)
{
    return [TFBaseUtil randomFloat];
}

CGFloat tf_randomFloatBetweenMin(CGFloat minValue, CGFloat maxValue)
{
    return [TFBaseUtil randomFloatBetweenMin:minValue andMax:maxValue];
}

CGFloat tf_randomIntBetweenMin(NSInteger minValue, NSInteger maxValue)
{
    return [TFBaseUtil randomIntBetweenMin:minValue andMax:maxValue];
}

@implementation TFBaseUtil (Float)

+ (CGFloat)randomFloat {
    return (float) arc4random() / UINT_MAX;
}

+ (CGFloat)randomFloatBetweenMin:(CGFloat)minValue andMax:(CGFloat)maxValue {
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (maxValue - minValue)) + minValue;
}

+ (NSInteger)randomIntBetweenMin:(NSInteger)minValue andMax:(NSInteger)maxValue {
    return (NSInteger)(minValue + [self randomFloat] * (maxValue - minValue));
}

@end
