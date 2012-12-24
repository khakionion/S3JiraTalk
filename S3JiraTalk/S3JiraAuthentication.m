//
//  S3JiraAuthentication.m
//  S3JiraTalk
//
//  Created by Michael Herring on 12/24/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3JiraAuthentication.h"
#import "AFNetworking.h"

#define S3_DEFAULT_JIRA_API_PREFIX @"/rest/api/latest/"

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
        [self setApiPrefix:S3_DEFAULT_JIRA_API_PREFIX];
    }
    return self;
}

-(void)setPassword:(NSString *)newPassword {
    NSDictionary* addOptions = @{(id)kSecClass:(id)kSecClassInternetPassword};
    OSStatus retval = SecItemAdd((__bridge CFDictionaryRef)(addOptions), NULL);
    retval = retval;
}

@end
