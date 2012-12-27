//
//  S3JiraAuthentication.m
//  S3JiraTalk
//
//  Created by Michael Herring on 12/24/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3JiraAuthentication.h"
#import "AFNetworking.h"

#define kDefaultJiraAPIPrefix @"/rest/api/latest/"
static const UInt8 kKeychainItemIdentifier[]    = "com.sunseaskyfactory.S3JiraTalk\0";

@implementation S3JiraAuthentication {
}

+(S3JiraAuthentication*)sharedInstance {
    static dispatch_once_t onceToken;
    static S3JiraAuthentication * authSingleton = nil;
    dispatch_once(&onceToken, ^{
        authSingleton = [[S3JiraAuthentication alloc] init];
    });
    return authSingleton;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        [self setApiPrefix:kDefaultJiraAPIPrefix];
    }
    return self;
}

-(OSStatus)setData:(NSString*)dataString {
    if (dataString == nil || self.server == nil || self.username == nil || self.apiPrefix == nil) {
        return errSecParam;
    }
    
    //the common options needed for deletion
    //we delete to clear out any old keychain info
    NSMutableDictionary * options = [@{
    (id)kSecClass:(id)kSecClassInternetPassword,
    (id)kSecAttrServer:self.server,
    (id)kSecAttrAccount:self.username,
    //(id)kSecAttrSecurityDomain??
    } mutableCopy];
    
    //first clear out the saved password.
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef)(options));
    
    //okay new dictionary, use it in an add operation.
    NSData * pwData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [options setValue:pwData forKey:(id)kSecValueData];
    [options setValue:self.apiPrefix forKey:(id)kSecAttrPath];

    result = SecItemAdd((__bridge CFMutableDictionaryRef)(options), NULL);
    return result;
}

@end
