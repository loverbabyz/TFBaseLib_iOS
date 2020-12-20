//
//  TFViewController.m
//  TFBaseLib_iOS
//
//  Created by SunXiaofei on 07/19/2020.
//  Copyright (c) 2020 SunXiaofei. All rights reserved.
//

#import "TFViewController.h"
#import <TFBaseLib_iOS/TFBaseLib_iOS.h>

@interface TFViewController ()

@end

@implementation TFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURLSessionDataTask *task = [TFHTTPRequestManager doTaskWithURL:@"https://www.baidu.com" httpHeader:nil parameters:nil success:^(id data) {
        NSLog(@"%@", data);
    } failure:^(int errorCode, NSString *errorMessage) {
        NSLog(@"%@", errorMessage);
    } error:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    [task cancel];
    
    NSString *base64String = @"abcdef";
    NSLog(@"%@", [base64String base64Encoding]);
    
    TFGCDTimer *timer = [[TFGCDTimer alloc] init];
    [timer event:^{
        NSString *base64String = @"111111111";
        NSLog(@"%@", [base64String base64Encoding]);
    } timeInterval:3];
    
    [timer start];
    [timer destroy];
    
    STR(@"%@", @"DD");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
