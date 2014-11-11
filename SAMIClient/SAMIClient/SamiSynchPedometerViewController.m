//
//  SamiSynchPedometerViewController.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/25/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import "SamiSynchPedometerViewController.h"
#import "SamiUserSession.h"
#import "SamiMessagesApi.h"
#import "SamiNormalizedMessagesEnvelope.h"
#import <CoreMotion/CoreMotion.h>

@interface SamiSynchPedometerViewController()
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (strong, nonatomic) CMPedometer *pedometer;
@end

@implementation SamiSynchPedometerViewController



/*
- (void) synchPedometer {
    // Get the start time
    // Either the timestamp of the last recorded message for the device
    // ...or if a new device 7 days from the current
 
    NSString* authorizationHeader = [SamiUserSession sharedInstance].bearerToken;
    SamiHistoricalApi * api = [SamiHistoricalApi apiWithHeader:authorizationHeader key:OAUTH_AUTHORIZATION_HEADER];

//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(concurrentQueue, ^{
        NSString *sid = [SamiUserSession sharedInstance].currentDeviceId;
        [api getNormalizedMessagesLastWithCompletionBlock:sid fieldPresence:nil count:@(1) completionHandler:^(SamiNormalizedMessagesEnvelope *output, NSError *error) {
            if (!error) {
                NSDate *end = [NSDate date];
                NSDate *start = nil;
                if ([output.data count] > 0) {
                    SamiNormalizedMessage *message = (SamiNormalizedMessage *)[output.data objectAtIndex:0];
                    start = [NSDate dateWithTimeIntervalSince1970:([message.ts doubleValue]/1000)];
                } else {
                    start = [end dateByAddingTimeInterval:(-1*60*60*24*1)];
                }

                float numItems = ([end timeIntervalSinceDate:start]/(60*15));
                NSLog(@"# of items to process: %0.02f", numItems);

                CMPedometer *pedometer = [[CMPedometer alloc] init];
                while ([end timeIntervalSinceDate:start] > 0.f) {
                    // 15 minutes
                    NSDate *endTime = [start dateByAddingTimeInterval:60*15];
                    [pedometer queryPedometerDataFromDate:start toDate:endTime withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                        SamiRawMessageIn *rawMessage = [[SamiRawMessageIn alloc] init];
                        rawMessage.ts = @([start timeIntervalSince1970]*1000);
                        rawMessage.sdid = sid;
                        
                        if (pedometerData) {
                        rawMessage.data = @{ @"numberOfSteps": pedometerData.numberOfSteps,
                                          @"floorsAscended": pedometerData.floorsAscended,
                                          @"floorsDescended": pedometerData.floorsDescended,
                                          @"distance": pedometerData.distance};
                        }

                        [api postMessageWithCompletionBlock:rawMessage completionHandler:^(SamiMessageIDEnvelope *output, NSError *error) {
                            if (!error) {
                                self.progressView.progress = self.progressView.progress + (1/numItems);
                                self.progressLabel.text = [[NSString stringWithFormat:@"%.2f", (self.progressView.progress)] stringByAppendingString:@"%"];
                                NSLog(@"Success: %@", output);
                            } else {
                                NSLog(@"Error: %@", error);
                            }
                        }];
                    }];
                    start = endTime;
                }
                
                //dispatch_sync(dispatch_get_main_queue(), ^{
                    //self.progressView.progress = 1.0;
                    //self.progressLabel.text = @"100 %";
                //});
            }
        }];
//    });
}
 */

- (void) showPedometer {
    self.label.text = [NSString stringWithFormat:@"StepCounting: %d\nDistance: %d\nFloorCounting: %d", [CMPedometer isStepCountingAvailable], [CMPedometer isDistanceAvailable], [CMPedometer isFloorCountingAvailable]];
    NSLog(@"Something");
    
    self.pedometer = [[CMPedometer alloc] init];
    
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
        dispatch_async( dispatch_get_main_queue(), ^{
            NSString* authorizationHeader = [SamiUserSession sharedInstance].bearerToken;
            SamiMessagesApi * api = [SamiMessagesApi apiWithHeader:authorizationHeader key:OAUTH_AUTHORIZATION_HEADER];
            
            SamiMessage *message = [[SamiMessage alloc] init];
            message.ts = @([pedometerData.startDate timeIntervalSince1970]*1000);
            message.sdid = [SamiUserSession sharedInstance].currentDeviceId;
            
            if (pedometerData) {
                message.data = @{ @"numberOfSteps": pedometerData.numberOfSteps,
                                     @"floorsAscended": pedometerData.floorsAscended,
                                     @"floorsDescended": pedometerData.floorsDescended,
                                     @"distance": pedometerData.distance};
            }
            
            [api postMessageWithCompletionBlock:message completionHandler:^(SamiMessageIDEnvelope *output, NSError *error) {
                self.lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", pedometerData.startDate];
                if (error) {
                    self.label.text = [error localizedDescription];
                } else {
                    self.label.text = [NSString stringWithFormat:@"Steps: %d\nDistance: %.2f\nfloorsAscended: %.2f\nfloorsDescended: %.2f", pedometerData.numberOfSteps.intValue, pedometerData.distance.floatValue, pedometerData.floorsAscended.floatValue, pedometerData.floorsDescended.floatValue];
                }
            }];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showPedometer];
}




@end
