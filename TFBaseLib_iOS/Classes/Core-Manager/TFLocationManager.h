//
//  LocationManager.h
//  Treasure
//
//  Created by Hu Dan 胡丹 on 15/8/27.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TFBaseMacro+Singleton.h"

@interface LocationModel : NSObject

/**
 *  经度
 */
@property (nonatomic, strong) NSString *longitude;

/**
 *  纬度
 */
@property (nonatomic, strong) NSString *latitude;

/**
 *  当前省份
 */
@property (nonatomic, strong) NSString *province;

/**
 *  当前城市
 */
@property (nonatomic, strong) NSString *city;
// 街道
@property (nonatomic, strong) NSString *thoroughfare;
// 街道相关信息，例如门牌等
@property (nonatomic, strong) NSString *subThoroughfare;
// 城市相关信息，例如标志性建筑
@property (nonatomic, strong) NSString *subLocality;
// 国家编码
@property (nonatomic, strong) NSString *ISOcountryCode;
// 国家
@property (nonatomic, strong) NSString *country;
// 街道地址
@property (nonatomic, strong) NSString *street;
// 完整地址
@property (nonatomic ,strong) NSString *address;


@end

#define kTFLocationManager ([TFLocationManager sharedManager])

@interface TFLocationManager : NSObject

@property (nonatomic, assign) BOOL servicesEnabled;
@property (nonatomic, assign) BOOL authorizeEnabled;

/**
 *  经度
 */
@property (nonatomic, strong) NSString *longitude;

/**
 *  纬度
 */
@property (nonatomic, strong) NSString *latitude;

/**
 *  当前省份
 */
@property (nonatomic, strong) NSString *province;

/**
 *  当前城市
 */
@property (nonatomic, strong) NSString *city;


TFSingletonH(Manager)

/**
 *  获取定位信息
 *
 *  @param successBlock successBlock
 *  @param failedBlock  failedBlock
 */
+ (void)startLocation:(void (^)(LocationModel* location))successBlock
               failed:(void (^)(NSString *errorMessage))failedBlock;
/**
 *  开启持续定位
 *
 *  @param timeInternal 时间间隔
 */
+ (void)startContinueLocation:(NSInteger)timeInternal;
/**
 *  开启默认持续定位 时间间隔600s
 *
 */
+ (void)startDefaultContinueLocation;
/**
 *  关闭持续定位
 */
+ (void)stopContinueLocation;


@end
