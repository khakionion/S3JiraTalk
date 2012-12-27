//
//  S3JiraTalkTests.m
//  S3JiraTalkTests
//
//  Created by Michael Herring on 12/19/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3JiraTalkTests.h"
#import "S3JiraTalk.h"

@implementation S3JiraTalkTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testObjectCategory {
    NSObject * exampleObject = [[NSObject alloc] init];
    NSString * myIssueID = [exampleObject jiraIssue];
    STAssertTrue([myIssueID isEqualToString:@"ID-42"], @"Default issue must be ID-42");    
}

- (void)testAuthorization {
    S3JiraAuthentication * authSingleton = [S3JiraAuthentication sharedInstance];
    STAssertNotNil(authSingleton, @"shared auth object must not be nil after being implicitly created.");
    NSString * apiPrefix = [[S3JiraAuthentication sharedInstance] apiPrefix];
    STAssertEqualObjects(@"/rest/api/latest/", apiPrefix, @"API prefix must default to '/rest/api/latest/'.");
    
    NSString * username = @"luser";
    NSString * server = @"not-jira.khakionion.com";
    NSString * password = @"p4ssw3rd";
    [[S3JiraAuthentication sharedInstance] setUsername:username];
    [[S3JiraAuthentication sharedInstance] setServer:server];
    OSStatus retval = [[S3JiraAuthentication sharedInstance] setData:password];
    STAssertEquals(retval, 0, @"Saving password to the keychain must return success.");
}

@end
