//
//  TFSAMKeychain.m
//  TFSAMKeychain
//
//  Created by Sam Soffes on 5/19/10.
//  Copyright (c) 2010-2014 Sam Soffes. All rights reserved.
//

#import "TFSAMKeychain.h"
#import "TFSAMKeychainQuery.h"

NSString *const kTFSAMKeychainErrorDomain = @"com.tfbaselib.samsoffes.samkeychain";
NSString *const kTFSAMKeychainAccountKey = @"acct";
NSString *const kTFSAMKeychainCreatedAtKey = @"cdat";
NSString *const kTFSAMKeychainClassKey = @"labl";
NSString *const kTFSAMKeychainDescriptionKey = @"desc";
NSString *const kTFSAMKeychainLabelKey = @"labl";
NSString *const kTFSAMKeychainLastModifiedKey = @"mdat";
NSString *const kTFSAMKeychainWhereKey = @"svce";

#if __IPHONE_4_0 && TARGET_OS_IPHONE
	static CFTypeRef TFSAMKeychainAccessibilityType = NULL;
#endif

@implementation TFSAMKeychain

+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account {
	return [self passwordForService:serviceName account:account error:nil];
}


+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
	TFSAMKeychainQuery *query = [[TFSAMKeychainQuery alloc] init];
	query.service = serviceName;
	query.account = account;
	[query fetch:error];
	return query.password;
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account {
	return [self passwordDataForService:serviceName account:account error:nil];
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    TFSAMKeychainQuery *query = [[TFSAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    [query fetch:error];

    return query.passwordData;
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account {
	return [self deletePasswordForService:serviceName account:account error:nil];
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
	TFSAMKeychainQuery *query = [[TFSAMKeychainQuery alloc] init];
	query.service = serviceName;
	query.account = account;
	return [query deleteItem:error];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account {
	return [self setPassword:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
	TFSAMKeychainQuery *query = [[TFSAMKeychainQuery alloc] init];
	query.service = serviceName;
	query.account = account;
	query.password = password;
	return [query save:error];
}

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account {
	return [self setPasswordData:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    TFSAMKeychainQuery *query = [[TFSAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.passwordData = password;
    return [query save:error];
}

+ (nullable NSArray *)allAccounts {
	return [self allAccounts:nil];
}


+ (nullable NSArray *)allAccounts:(NSError *__autoreleasing *)error {
    return [self accountsForService:nil error:error];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName {
	return [self accountsForService:serviceName error:nil];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName error:(NSError *__autoreleasing *)error {
    TFSAMKeychainQuery *query = [[TFSAMKeychainQuery alloc] init];
    query.service = serviceName;
    return [query fetchAll:error];
}


#if __IPHONE_4_0 && TARGET_OS_IPHONE
+ (CFTypeRef)accessibilityType {
	return TFSAMKeychainAccessibilityType;
}


+ (void)setAccessibilityType:(CFTypeRef)accessibilityType {
	CFRetain(accessibilityType);
	if (TFSAMKeychainAccessibilityType) {
		CFRelease(TFSAMKeychainAccessibilityType);
	}
	TFSAMKeychainAccessibilityType = accessibilityType;
}
#endif

@end
