//
//  SamiUserApiTests.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/17/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "SamiUsersApi.h"

@interface SamiUsersApiTests : XCTestCase
@property (nonatomic) SamiUsersApi* api;
@end

@implementation SamiUsersApiTests

- (SamiUsersApi *)api {
    if (!_api) {
        [SamiUsersApi setBasePath:@"https://api-dev.samihub.com/v1.1"];
        _api = [SamiUsersApi apiWithHeader:@"Bearer 641bd0febf134370abec7633eedca929" key:OAUTH_AUTHORIZATION_HEADER];
    }
    
    return _api;
}

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSelf {
    [self.api selfWithCompletionBlock:^(SamiUserEnvelope *output, NSError *error) {
        NSLog(@"%@", output.data.fullName);
        XCTAssertEqualObjects(@"Simba Admin", output.data.fullName, @"Full Name");
    }];
}


@end
