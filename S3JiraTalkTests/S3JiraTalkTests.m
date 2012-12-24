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

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testExample
{
    NSObject * exampleObject = [[NSObject alloc] init];
    NSString * myIssueID = [exampleObject jiraIssue];
    STAssertTrue([myIssueID isEqualToString:@"ID-42"], @"Default issue must be ID-42");
    S3JiraAuthentication * authSingleton = [S3JiraAuthentication sharedInstance];
    STAssertNotNil(authSingleton, @"shared S3JiraAuthentication must not be nil after being accessed.");
    NSString * apiPrefix = [[S3JiraAuthentication sharedInstance] apiPrefix];
    STAssertEqualObjects(@"/rest/api/latest/", apiPrefix, @"API prefix must default to '/rest/api/latest/'.");
}

@end
