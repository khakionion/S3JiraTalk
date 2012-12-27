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

@interface S3JiraAuthentication ()

-(id)initSingleton;
-(NSString*)grabPassword;
-(void)defrostFromKeychain;
-(NSDictionary*)basicKeychainDictionary;

@end

@implementation S3JiraAuthentication {
}


+(S3JiraAuthentication*)sharedInstance {
    static dispatch_once_t onceToken;
    static S3JiraAuthentication * authSingleton = nil;
    dispatch_once(&onceToken, ^{
        authSingleton = [[S3JiraAuthentication alloc] initSingleton];
    });
    return authSingleton;
}

-(id)init {
    return nil;
}

-(id)initSingleton {
    self = [super init];
    if (self != nil) {
        [self setApiPrefix:kDefaultJiraAPIPrefix];
    }
    return self;
}

-(NSURL*)createURLWithAPISuffix:(NSString *)suffix {
    NSString * password = [self grabPassword];
    NSString * urlString = [NSString stringWithFormat:@"https://%@:%@@%@%@%@",
                            self.username,password,self.server,self.apiPrefix,suffix];
    return [NSURL URLWithString:urlString];
}

-(NSDictionary*)basicKeychainDictionary {
    return @{
    (id)kSecClass:(id)kSecClassInternetPassword,
    (id)kSecAttrServer:self.server,
    (id)kSecAttrAccount:self.username,
    //(id)kSecAttrSecurityDomain??
    };
}

-(OSStatus)setPassword:(NSString*)password {
    if (password == nil || self.server == nil || self.username == nil || self.apiPrefix == nil) {
        return errSecParam;
    }
    
    //the common options needed for deletion
    //we delete to clear out any old keychain info
    NSMutableDictionary * options = [[self basicKeychainDictionary] mutableCopy];
    
    //first clear out the saved password.
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef)(options));
    
    //okay new dictionary, use it in an add operation.
    NSData * pwData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [options setValue:pwData forKey:(id)kSecValueData];
    [options setValue:self.apiPrefix forKey:(id)kSecAttrPath];

    result = SecItemAdd((__bridge CFMutableDictionaryRef)(options), NULL);
    return result;
}

-(void)defrostFromKeychain {
    NSDictionary * options = [[self basicKeychainDictionary] mutableCopy];
    [options setValue:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    NSDictionary * retVal = nil;
    OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)options, (CFTypeRef)&retVal);
    [self setUsername: [retVal valueForKey:(id)kSecAttrAccount]];
    [self setApiPrefix:[retVal valueForKey:(id)kSecAttrPath]];
    [self setServer:[retVal valueForKey:(id)kSecAttrServer]];
}

-(NSString*)grabPassword {
    NSDictionary * options = [[self basicKeychainDictionary] mutableCopy];
    [options setValue:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    NSData * retVal = nil;
    OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)options, (CFTypeRef)&retVal);
    if (result != 0) {
        return nil;
    }
    NSString * password = [[NSString alloc] initWithData:retVal encoding:NSUTF8StringEncoding];
    return password;
}

@end
