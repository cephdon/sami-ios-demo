//
//  SamiViewController.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/17/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import "SamiDevicesApi.h"
#import "SamiDeviceTypesApi.h"
#import "SamiOAuth2ViewController.h"
#import "SamiUsersApi.h"
#import "SamiUserSession.h"
#import "SamiViewController.h"

#import <CoreMotion/CoreMotion.h>


@interface SamiViewController ()
@property (weak, nonatomic) IBOutlet UIButton *synchButton;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifiedLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *devicesButton;

@end

@implementation SamiViewController

- (void) validateAccessToken {
    NSString* authorizationHeader = [SamiUserSession sharedInstance].bearerToken;

    SamiUsersApi * usersApi = [[SamiUsersApi alloc] init];
    [usersApi addHeader:authorizationHeader forKey:OAUTH_AUTHORIZATION_HEADER];
    
    [usersApi selfWithCompletionBlock:^(SamiUserEnvelope *output, NSError *error) {
        
        NSLog(@"%@", error);
        if (error) {
            self.fullnameLabel.text = error.localizedFailureReason;
            self.devicesButton.enabled = NO;
            
        } else {
            SamiUserSession *session = [SamiUserSession sharedInstance];
            session.user = output.data;
            
            self.idLabel.text = output.data._id;
            self.nameLabel.text = output.data.name;
            self.fullnameLabel.text = output.data.fullName;
            self.emailLabel.text = output.data.email;
            
            NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
            
            NSDate *created = [NSDate dateWithTimeIntervalSince1970:([output.data.createdOn doubleValue])];
            self.createdLabel.text = [dateFormat stringFromDate:created];
            
            NSDate *modified = [NSDate dateWithTimeIntervalSince1970:([output.data.modifiedOn doubleValue])];
            self.modifiedLabel.text = [dateFormat stringFromDate:modified];
            
            if (!session.iPhoneDeviceType) {
                SamiDeviceTypesApi * deviceTypesApi = [[SamiDeviceTypesApi alloc] init];
                [deviceTypesApi addHeader:authorizationHeader forKey:OAUTH_AUTHORIZATION_HEADER];
                [deviceTypesApi getDeviceTypesWithCompletionBlock:SAMI_IPHONE_DEVICE_TYPE offset:@(0) count:@(1) completionHandler:^(SamiDeviceTypesEnvelope *output, NSError *error) {
                    session.iPhoneDeviceType = ((SamiDeviceType *)[output.data.deviceTypes objectAtIndex:0])._id;
                    NSLog(@"Got iPhone Device Type %@", session.iPhoneDeviceType);
                }];
            }
            
            if (!session.currentDeviceId) {
                [usersApi getUserDevicesWithCompletionBlock:@(0) count:@(100) includeProperties:@(NO) userId:session.user._id completionHandler:^(SamiDevicesEnvelope *output, NSError *error) {
                    for (SamiDevice *device in output.data.devices) {
                        if ([session.currentDeviceName isEqualToString:device.name]) {
                            session.currentDeviceId = device._id;
                            break;
                        }
                    }
                }];
            }
            self.devicesButton.enabled = YES;
        }        
    }];
}

- (IBAction)logout:(id)sender {
    [[SamiUserSession sharedInstance] logout ];
    
    [self performSegueWithIdentifier:@"showAuth" sender:self];
}

- (IBAction)showDevices:(id)sender {
     [self performSegueWithIdentifier: @"showDevices" sender: self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDevices"]) {
        NSLog(@"Show devices");
    } else if ([segue.identifier isEqualToString:@"showAuth"]) {
        NSLog(@"Show Auth");
    } else if ([segue.identifier isEqualToString:@"showPhone"]) {
        NSLog(@"Show Phone");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SamiUserSession *session = [SamiUserSession sharedInstance];
    if (!session.user) {
        [self validateAccessToken];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SamiUserSession *session = [SamiUserSession sharedInstance];
    if (!session.accessToken) {
        [self performSegueWithIdentifier:@"showAuth" sender:self];
    }
    
    if ([CMPedometer isStepCountingAvailable]) {
        self.synchButton.enabled = YES;
    } else {
        self.synchButton.enabled = NO;
    }
}

@end
