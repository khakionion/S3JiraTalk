//
//  S3JiraAuthentication.h
//  S3JiraTalk
//
//  Created by Michael Herring on 12/24/12.
//  Copyright (c) 2012 Sun, Sea and Sky Factory. All rights reserved.
//

@interface S3JiraAuthentication : NSObject

@property (strong, nonatomic) NSString * username;
@property (strong, nonatomic) NSString * server;
//defaults to "/rest/api/latest/"
@property (strong, nonatomic) NSString * apiPrefix;

//singleton
+(S3JiraAuthentication*)sharedInstance;

//saves password via Keychain Services
-(OSStatus)setData:(NSString*)dataString;

//

@end
