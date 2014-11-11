//
//  SamiUserSession.h
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/22/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SamiUser.h"


@interface SamiUserSession : NSObject

+ (SamiUserSession *) sharedInstance;

@property (nonatomic, weak) NSString * accessToken;
@property (nonatomic, weak) NSString * iPhoneDeviceType;
@property (nonatomic, strong) NSString * currentDeviceId;
@property (readonly, nonatomic, strong) NSString *currentDeviceName;
@property (readonly, nonatomic, strong) NSString * bearerToken;
@property (nonatomic, strong) SamiUser * user;

- (void) addAuthorizationHeader: (id) api;
- (void) logout;

@end
