//
//  SamiDevicesTableViewController.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/18/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import "SamiDevicesTableViewController.h"
#import "SamiUsersApi.h"
#import "SamiDevicesApi.h"
#import "SamiDevice.h"
#import "SamiUserSession.h"


@interface SamiDevicesTableViewController ()
@property (nonatomic) NSArray *devices;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@end

@implementation SamiDevicesTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshDevices];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
}

- (void) refreshDevices {
    NSString* authorizationHeader = [SamiUserSession sharedInstance].bearerToken;
    
    SamiUsersApi * api = [[SamiUsersApi alloc] init];
    [api addHeader:authorizationHeader forKey:OAUTH_AUTHORIZATION_HEADER];
    
    [api getUserDevicesWithCompletionBlock:@(0) count:@(100) includeProperties:@(YES) userId:[SamiUserSession sharedInstance].user._id completionHandler:^(SamiDevicesEnvelope *output, NSError *error) {
        NSLog(@"%@", output.data.devices);
        self.devices = output.data.devices;
        [self enableRegisterButton];

        [self.tableView reloadData];
    }];
}

- (void) enableRegisterButton {
    NSPredicate *predicateMatch = [NSPredicate predicateWithFormat:@"name == %@", [SamiUserSession sharedInstance].currentDeviceName];
    NSArray *currentDevice = [self.devices filteredArrayUsingPredicate:predicateMatch];
    self.registerButton.enabled = (currentDevice.count == 0);
}

- (IBAction)registerPhoneAsDevice:(id)sender {
    SamiUserSession *session = [SamiUserSession sharedInstance];
    
    NSString* authorizationHeader = session.bearerToken;
    
    SamiDevicesApi * api = [[SamiDevicesApi alloc] init];
    [api addHeader:authorizationHeader forKey:OAUTH_AUTHORIZATION_HEADER];
    
    SamiDevice* device = [[SamiDevice alloc] init];
    //device._id = session.currentDeviceId;
    device.name = session.currentDeviceName;
    device.uid = session.user._id;
    device.dtid = session.iPhoneDeviceType;
    
    [api addDeviceWithCompletionBlock:device completionHandler:^(SamiDeviceEnvelope *output, NSError *error) {
        if (!error) {
            session.currentDeviceId = output.data._id;
            
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.devices];
            [newArray insertObject:output.data atIndex:0];
            self.devices = newArray;
            [self enableRegisterButton];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error %@", error);
        }
    }];
}

- (void) removeDevice: (SamiDevice *) device {
    NSString* authorizationHeader = [SamiUserSession sharedInstance].bearerToken;
    
    SamiDevicesApi * api = [[SamiDevicesApi alloc] init];
    [api addHeader:authorizationHeader forKey:OAUTH_AUTHORIZATION_HEADER];
    
    [api deleteDeviceWithCompletionBlock:device._id completionHandler:^(SamiDeviceEnvelope *output, NSError *error) {
        if (!error) {
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.devices];
            [newArray removeObject:device];
            self.devices = newArray;
            NSLog(@"Device deleted %@", output.data);
            [self enableRegisterButton];
            [self.tableView reloadData];
        } else {
            // Launch error message
            NSLog(@"Error %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.devices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeviceCell"];
    }
    // Configure the cell...
    
    SamiDevice * device = (SamiDevice *)[self.devices objectAtIndex:indexPath.row];
    cell.textLabel.text = device.name;
    cell.detailTextLabel.text = device.dtid;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    SamiDevice *device = (SamiDevice *) [self.devices objectAtIndex:indexPath.row];
    
    if ([device.dtid isEqualToString:[SamiUserSession sharedInstance].iPhoneDeviceType]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SamiDevice* device = (SamiDevice *)[self.devices objectAtIndex:indexPath.row];
    [self removeDevice:device];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMessages"]) {
        //NSLog(@"index: %d", [self.tableView indexPathForSelectedRow].row);
        SamiDevice *device = (SamiDevice *) [self.devices objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        NSLog(@"Show messages");
        [segue.destinationViewController performSelector:@selector(setSid:) withObject:device._id];
    } else if ([segue.identifier isEqualToString:@"showManifest"]) {
        
        ;
        //NSLog(@"index: %d", [self.tableView indexPathForCell:sender].row);
        SamiDevice *device = (SamiDevice *) [self.devices objectAtIndex:[self.tableView indexPathForCell:sender].row];
        
        NSLog(@"Show manifest");
        [segue.destinationViewController performSelector:@selector(setDevice:) withObject:device];
    }
}


@end
