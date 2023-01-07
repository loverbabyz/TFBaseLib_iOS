//
//  TFNetworkManager.m
//  Treasure
//
//  Created by Daniel on 15/9/6.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFNetworkManager.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@implementation TFNetworkManager

+ (instancetype)sharedManager
{
    static TFNetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFNetworkManager alloc] init];
    });
    return sharedInstance;
}

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
        void(^afBlock)(AFNetworkReachabilityStatus status) = ^(AFNetworkReachabilityStatus status){
            block((TFNetworkReachabilityStatus)status);
        };
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:afBlock];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
}

- (void)stopMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark -

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

- (TFNetworkReachabilityStatus)networkReachabilityStatus {
    return (TFNetworkReachabilityStatus)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
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
