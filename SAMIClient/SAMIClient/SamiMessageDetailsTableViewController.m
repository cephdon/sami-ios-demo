//
//  SamiMessageDetailsTableViewController.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/18/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import "SamiMessageDetailsTableViewController.h"

@interface SamiMessageDetailsTableViewController ()
@property (nonatomic) NSArray *sections;
@property (nonatomic) NSDictionary *sectionDictionary;
@end

@implementation SamiMessageDetailsTableViewController

- (void)setNormalizedMessage:(SamiNormalizedMessage *)normalizedMessage {
    _normalizedMessage = normalizedMessage;
    NSLog(@"%@", normalizedMessage);
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
    
    [self refreshMessageDetails];
}

- (void) refreshMessageDetails {
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    // Add the first default
    [sections addObject:@"data"];
    
    NSMutableDictionary *sectionDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *rootDictionary = [[NSMutableDictionary alloc] init];
    
    NSDictionary *dict = self.normalizedMessage.data;
    for(id key in dict) {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:dict.class]) {
            [sections addObject:key];
            [sectionDictionary setObject:value forKey:key];
        } else {
            [rootDictionary setObject:value forKey:key];
        }
    }
    
    if ([rootDictionary count] > 0) {
        [sectionDictionary setObject:rootDictionary forKey:@"data"];
    } else {
        [sections removeObjectAtIndex:0];
    }
    
    self.sections = sections;
    self.sectionDictionary = sectionDictionary;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int i = 0;
    for(id key in self.sectionDictionary) {
        if (i == section) {
            NSDictionary *dict = [self.sectionDictionary objectForKey:key];
            return [dict count];
        }
        i++;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageDetailsCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageDetailsCell"];
    }
    // Configure the cell...
    int i = 0;
    for(id key in self.sectionDictionary) {
        if (i == indexPath.section) {
            NSDictionary *dict = [self.sectionDictionary objectForKey:key];
            int j = 0;
            for (id key2 in dict) {
                if (j == indexPath.row) {
                    id value2 = [dict objectForKey:key2];
                    cell.textLabel.text = key2;
                    cell.detailTextLabel.text = [value2 description];
                }
                j++;
            }
        }
        i++;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sections objectAtIndex:section];
}

@end
