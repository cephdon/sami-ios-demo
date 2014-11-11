//
//  SamiUserSession.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/22/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import "SamiUserSession.h"

@interface SamiUserSession()
@property (strong, nonatomic) NSString *currentDeviceName;
@end

@implementation SamiUserSession

static SamiUserSession *sharedInstance = nil;

+ (SamiUserSession *) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (id) init {
    self = [super init];
    return self;
}

- (void) setAccessToken:(NSString *)accessToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:ACCESS_TOKEN];
    [defaults synchronize];
}

- (NSString *) accessToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:ACCESS_TOKEN];
}

- (NSString *) bearerToken {
    return [NSString stringWithFormat:OAUTH_BEARER_TOKEN_FORMAT, self.accessToken ];
}

- (void) setIPhoneDeviceType:(NSString *)iPhoneDeviceType {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:iPhoneDeviceType forKey:SAMI_IPHONE_DEVICE_TYPE];
    [defaults synchronize];
}

- (NSString *) iPhoneDeviceType {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:SAMI_IPHONE_DEVICE_TYPE];
}

- (void) setCurrentDeviceId:(NSString *)currentDeviceId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentDeviceId forKey:SAMI_DEVICE_ID];
    [defaults synchronize];
}

- (NSString *) currentDeviceId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:SAMI_DEVICE_ID];
}

- (NSString *) currentDeviceName {
    if (!_currentDeviceName) {
        _currentDeviceName = [[UIDevice currentDevice].identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return _currentDeviceName;
}

- (void) addAuthorizationHeader:(id)api {
    SEL addHeaderSelector = sel_registerName("addHeader:forKey:");
 
    if ([api respondsToSelector:addHeaderSelector]) {
        //     [api addHeader:self.bearerToken forKey:OAUTH_AUTHORIZATION_HEADER];
        [api performSelector:addHeaderSelector withObject:self.bearerToken withObject:OAUTH_AUTHORIZATION_HEADER];
    }
}

- (void) logout {
    // Explicitly logout
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:ACCESS_TOKEN];
    [defaults synchronize];
    
    self.user = nil;
}

@end
