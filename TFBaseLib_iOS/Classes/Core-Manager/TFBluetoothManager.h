//
//  TFBluetoothManager.h
//  Treasure
//
//  Created by Daniel on 15/9/2.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TFBaseMacro+Singleton.h"

/**
 *  蓝牙状态变化时的回调
 */
typedef void(^BluetoothStatusChangedBlock)(CBManagerState state);

@interface TFBluetoothManager : NSObject

/**
 *  蓝牙开的状态
 */
@property (nonatomic, assign, getter = isOpen) BOOL open;

/**
 *  蓝牙的状态
 */
@property (nonatomic, assign) CBManagerState bluetoothStatus;

/**
 *  蓝牙状态变化时的回调
 */
@property (nonatomic, copy) BluetoothStatusChangedBlock bluetoothStatusChangedBlock;

#define kTFBluetoothManager  ([TFBluetoothManager sharedManager])

TFSingletonH(Manager)

@end
