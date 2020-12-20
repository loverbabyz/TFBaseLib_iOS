//
//  TFTouchIDManager.h
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

/**
 *  指纹识别touchId管理类
 */
@interface TFTouchIDManager : NSObject

/**
 *  TouchIdValidationFailureBack
 *  @param result LAError枚举
 */
typedef void(^TouchIdValidationFailureBack)(LAError result, NSString *errorMessage);

/**
 *  检查touchID是否可用
 */
+ (BOOL)checkTouch;

/**
 *  TouchId 验证
 *
 *  @param localizedReason TouchId信息
 *  @param fallbackTitle 验证错误按钮title
 *  @param successBlock 成功返回block
 *  @param failureBlock 失败返回block
 */
+ (void)startTouchIDWithMessage:(NSString *)localizedReason
                  fallbackTitle:(NSString *)fallbackTitle
                         succes:(void(^)(BOOL))successBlock
                        failure:(TouchIdValidationFailureBack)failureBlock;

@end
