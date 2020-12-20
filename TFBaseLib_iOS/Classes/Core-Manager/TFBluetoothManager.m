//
//  TFBluetoothManager.m
//  Treasure
//
//  Created by xiayiyong on 15/9/2.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBluetoothManager.h"

@interface TFBluetoothManager()<CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;

@end

@implementation TFBluetoothManager


+ (instancetype) sharedManager
{
    static TFBluetoothManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFBluetoothManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _open = NO;
        _bluetoothStatus= CBManagerStateUnknown;
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

//蓝牙回调状态
#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ((CBManagerState)central.state == _bluetoothStatus)
    {
        return;
    }
    
    _bluetoothStatus = (CBManagerState)central.state;
    _open = (central.state == CBManagerStatePoweredOn ? YES : NO);

    if (self.bluetoothStatusChangedBlock) {
        self.bluetoothStatusChangedBlock(_bluetoothStatus);
    }
}

@end
