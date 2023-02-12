//
//  TFNetworkManager.h
//  Treasure
//
//  Created by Daniel on 15/9/6.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseMacro+Singleton.h"

typedef NS_ENUM(NSInteger, TFNetworkReachabilityStatus) {
    TFNetworkReachabilityStatusUnknown          = -1,
    TFNetworkReachabilityStatusNotReachable     = 0,
    TFNetworkReachabilityStatusReachableViaWWAN = 1,
    TFNetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface TFNetworkManager : NSObject

#define kTFNetworkManager  ([TFNetworkManager sharedManager])

TFSingletonH(Manager)

/**
 *  判断网络状态
 */
- (void)setReachabilityStatusChangeBlock:(void (^)(TFNetworkReachabilityStatus status))block;

/**
 *  停止网络监控
 */
- (void)stopMonitoring;

/**
 *  网络状态
 */
@property (readonly, nonatomic, assign) TFNetworkReachabilityStatus networkReachabilityStatus;

@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

/**
 *  获取当前连接wifi的SSID名称
 */
@property (readonly, nonatomic, strong) NSString *currentWifiSSID;



@end
