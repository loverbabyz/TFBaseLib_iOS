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
#ifndef TF_APP_HOME_PATH
#define TF_APP_HOME_PATH NSHomeDirectory()
#endif

/**
 *  沙盒CACH地址
 */
#ifndef TF_APP_CACHE_PATH
#define TF_APP_CACHE_PATH [TF_APP_HOME_PATH stringByAppendingPathComponent:@"Library/Caches"]
#endif

/**
 *  沙盒DOCUMENT地址
 */
#ifndef TF_APP_DOCUMENT_PATH
#define TF_APP_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#endif

/**
 *  沙盒DOCUMENT地址
 */
#ifndef TF_APP_DOCUMENT_PATH2
#define TF_APP_DOCUMENT_PATH2 [TF_APP_HOME_PATH stringByAppendingPathComponent:@"Documents"]
#endif

/**
 *  沙盒LIBRARY地址
 */
#ifndef TF_APP_LIBRARY_PATH
#define TF_APP_LIBRARY_PATH [TF_APP_HOME_PATH stringByAppendingPathComponent:@"Library"]
#endif

/**
 *  沙盒TMP地址
 */
#ifndef TF_APP_TMP_PATH
#define TF_APP_TMP_PATH NSTemporaryDirectory()
#endif

/**
 *  main bundle
 */
#ifndef TF_MAIN_BUNDLE
#define TF_MAIN_BUNDLE [NSBundle mainBundle]
#endif

/**
*  main bundle地址
*/
#ifndef TF_MAIN_BUNDLE_PATH
#define TF_MAIN_BUNDLE_PATH [TF_MAIN_BUNDLE bundlePath]
#endif

/**
 *  main bundle resource地址
 */
#ifndef TF_MAIN_BUNDLE_RESOURCE
#define TF_MAIN_BUNDLE_RESOURCE [TF_MAIN_BUNDLE resourcePath]
#endif

/**
 *  main bundle executable地址
 */
#ifndef TF_MAIN_BUNDLE_EXECUTABLE
#define TF_MAIN_BUNDLE_EXECUTABLE [TF_MAIN_BUNDLE executablePath]
#endif
