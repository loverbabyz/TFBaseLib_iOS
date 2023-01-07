//
//  TFBaseUtil+Degrees.h
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  把角度转弧度
 *
 *  @param degree 角度值
 *
 *  @return 转换好的弧度
 */
CGFloat tf_degreesToRadian(CGFloat degree);

/**
 *  把弧度转角度
 *
 *  @param radian 弧度值
 *
 *  @return 转换好的角度值
 */
CGFloat tf_randianToDegrees(CGFloat radian);

@interface TFBaseUtil (Degrees)

/**
 *  把角度转弧度
 *
 *  @param degree 角度值
 *
 *  @return 转换好的弧度
 */
+(CGFloat)degreesToRadian:(CGFloat)degree;

/**
 *  把弧度转角度
 *
 *  @param radian 弧度值
 *
 *  @return 转换好的角度值
 */
+(CGFloat)randianToDegrees:(CGFloat)radian;


@end
