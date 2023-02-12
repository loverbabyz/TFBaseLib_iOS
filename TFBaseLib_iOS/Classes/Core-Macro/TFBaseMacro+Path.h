//
//  TFMacro+Path.h
//  Treasure
//
//  Created by Daniel on 15/9/14.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

/**
 *  沙盒home地址
 */
#define TF_APP_HOME_PATH        NSHomeDirectory()

/**
 *  沙盒CACH地址
 */
#define TF_APP_CACHE_PATH      [TF_APP_HOME_PATH stringByAppendingPathComponent:@"Library/Caches"]

/**
 *  沙盒DOCUMENT地址
 */
#define TF_APP_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
/**
 *  沙盒DOCUMENT地址
 */
#define TF_APP_DOCUMENT_PATH2 [TF_APP_HOME_PATH stringByAppendingPathComponent:@"Documents"]
/**
 *  沙盒LIBRARY地址
 */
#define TF_APP_LIBRARY_PATH [TF_APP_HOME_PATH stringByAppendingPathComponent:@"Library"]

/**
 *  沙盒TMP地址
 */
#define TF_APP_TMP_PATH    NSTemporaryDirectory()

/**
 *  main bundle
 */
#define TF_MAIN_BUNDLE [NSBundle mainBundle]

/**
*  main bundle地址
*/
#define TF_MAIN_BUNDLE_PATH [TF_MAIN_BUNDLE bundlePath]

/**
 *  main bundle resource地址
 */
#define TF_MAIN_BUNDLE_RESOURCE  [TF_MAIN_BUNDLE resourcePath]

/**
 *  main bundle executable地址
 */
#define TF_MAIN_BUNDLE_EXECUTABLE [TF_MAIN_BUNDLE executablePath]

