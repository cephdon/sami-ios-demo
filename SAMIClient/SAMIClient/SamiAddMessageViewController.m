//
//  SamiAddMessageViewController.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/23/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import "SamiAddMessageViewController.h"
#import "SamiUserSession.h"
#import "SamiMessagesApi.h"

@interface SamiAddMessageViewController()
@property (weak, nonatomic) IBOutlet UITextField *stepsField;
@property (weak, nonatomic) IBOutlet UITextField *floorsAscField;
@property (weak, nonatomic) IBOutlet UITextField *floorsDescField;
@property (weak, nonatomic) IBOutlet UITextField *distanceField;
@end

@implementation SamiAddMessageViewController
- (IBAction)addMessage:(id)sender {
    NSString *deviceId = [SamiUserSession sharedInstance].currentDeviceId;
    NSString* authorizationHeader = [SamiUserSession sharedInstance].bearerToken;
    
    SamiMessagesApi * api2 = [SamiMessagesApi apiWithHeader:authorizationHeader key:OAUTH_AUTHORIZATION_HEADER];
    
    SamiMessage *message = [[SamiMessage alloc] init];
    message.sdid = deviceId;
    message.data = @{ @"numberOfSteps": @([self.stepsField.text integerValue]),
                            @"floorsAscended": @([self.floorsAscField.text integerValue]),
                            @"floorsDescended": @([self.floorsDescField.text integerValue]),
                            @"distance": @([self.distanceField.text floatValue])};
    
    [api2 postMessageWithCompletionBlock:message completionHandler:^(SamiMessageIDEnvelope *output, NSError *error) {
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:[@"Message added " stringByAppendingString:output.data.mid]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            NSLog(@"%@", error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
