//
//  SamiMessageDetailsTableViewController.h
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/18/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SamiNormalizedMessage.h"

@interface SamiMessageDetailsTableViewController : UITableViewController
@property (nonatomic) SamiNormalizedMessage *normalizedMessage;
@end
