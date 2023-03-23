//
//  TFNetworkManager.m
//  Treasure
//
//  Created by Daniel on 15/9/6.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFNetworkManager.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "TFAFNetworkReachabilityManager.h"

@implementation TFNetworkManager

TFSingletonM(Manager)

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)setReachabilityStatusChangeBlock:(void (^)(TFNetworkReachabilityStatus status))block
{
    if (block)
    {
        void(^afBlock)(TFAFNetworkReachabilityStatus status) = ^(TFAFNetworkReachabilityStatus status){
            block((TFNetworkReachabilityStatus)status);
        };
        
        [[TFAFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:afBlock];
        [[TFAFNetworkReachabilityManager sharedManager] startMonitoring];
    }
}

- (void)stopMonitoring
{
    [[TFAFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark -

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return self.networkReachabilityStatus == TFAFNetworkReachabilityStatusReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return self.networkReachabilityStatus == TFAFNetworkReachabilityStatusReachableViaWiFi;
}

- (TFNetworkReachabilityStatus)networkReachabilityStatus {
    return (TFNetworkReachabilityStatus)[TFAFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

- (NSString *)currentWifiSSID
{
    return [[TFNetworkManager fetchSSIDInfo] objectForKey:@"SSID"];
}

#pragma mark - private metod

+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    //NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        //NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

@end
