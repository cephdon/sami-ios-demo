//
//  SamiMessagesTableViewController.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/18/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import "SamiMessagesTableViewController.h"
#import "SamiMessagesApi.h"
#import "SamiUserSession.h"

@interface SamiMessagesTableViewController ()
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSArray * messages;
@property (nonatomic) NSDateFormatter *dateFormat;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@end

@implementation SamiMessagesTableViewController

- (void)setSid:(NSString *)sid {
    _sid = sid;
    
    NSLog(@"Set sid %@", sid);
}

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
    self.dateFormat = [[NSDateFormatter alloc] init];
    [self.dateFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshMessages) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.testButton.enabled = [self.sid isEqualToString:[SamiUserSession sharedInstance].currentDeviceId];

    [self refreshMessages];
}

- (void) refreshMessages {
    NSString* authorizationHeader = [SamiUserSession sharedInstance].bearerToken;
    
    SamiMessagesApi * api2 = [SamiMessagesApi apiWithHeader:authorizationHeader key:OAUTH_AUTHORIZATION_HEADER];
    [api2 getLastNormalizedMessagesWithCompletionBlock:@(20) sdids:self.sid fieldPresence:nil completionHandler:^(SamiNormalizedMessagesEnvelope *output, NSError *error) {
        self.messages = output.data;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)createTestMessage:(id)sender {
    [self performSegueWithIdentifier:@"addMessage" sender:self];
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
    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
    }
    // Configure the cell...
    
    SamiNormalizedMessage *message = (SamiNormalizedMessage *)[self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = message.mid;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([message.ts doubleValue]/1000)];
    cell.detailTextLabel.text = [self.dateFormat stringFromDate:date];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showMessageDetails"]) {
        NSLog(@"index: %d", [self.tableView indexPathForSelectedRow].row);
        SamiNormalizedMessage *message = (SamiNormalizedMessage *) [self.messages objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        NSLog(@"Show message details");
        [segue.destinationViewController performSelector:@selector(setNormalizedMessage:) withObject:message];
    } else if ([segue.identifier isEqualToString:@"addMessage"]) {
        NSLog(@"Add Test Message");
    }
     
}


@end
