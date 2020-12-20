//
//  TFGCD.h
//  TFGCD
//
//  from https://github.com/YouXianMing
//
//  TFBaseLib
//
//  Created by xiayiyong on 16/3/3.
//  Copyright © 2016年 daniel.xiaofei@gmail.com All rights reserved.
//

#import <TFBaseLib_iOS/TFGCDQueue.h>
#import <TFBaseLib_iOS/TFGCDGroup.h>
#import <TFBaseLib_iOS/TFGCDSemaphore.h>
#import <TFBaseLib_iOS/TFGCDTimer.h>

/*
 
 [GCDQueue executeInGlobalQueue:^{
 
 // download task, etc
 
 [GCDQueue executeInMainQueue:^{
 
 // update UI
 }];
 }];
 
 
 
 
 // init group
 GCDGroup *group = [GCDGroup new];
 
 // add to group
 [[GCDQueue globalQueue] execute:^{
 
 // task one
 
 } inGroup:group];
 
 // add to group
 [[GCDQueue globalQueue] execute:^{
 
 // task two
 
 } inGroup:group];
 
 // notify in mainQueue
 [[GCDQueue mainQueue] notify:^{
 
 // task three
 
 } inGroup:group];
 
 
 
 
 // init timer
 self.timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
 
 // timer event
 [self.timer event:^{
 
 // task
 
 } timeInterval:NSEC_PER_SEC * 3 delay:NSEC_PER_SEC * 3];
 
 // start timer
 [self.timer start];
 
 
 
 
 // init semaphore
 GCDSemaphore *semaphore = [GCDSemaphore new];
 
 // wait
 [GCDQueue executeInGlobalQueue:^{
 
 [semaphore wait];
 
 // todo sth else
 }];
 
 // signal
 [GCDQueue executeInGlobalQueue:^{
 
 // do sth
 [semaphore signal];
 }];

 */


