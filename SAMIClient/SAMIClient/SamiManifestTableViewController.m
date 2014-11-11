//
//  SamiManifestTableViewController.m
//  SAMIClient
//
//  Created by Maneesh Sahu-SSI on 9/19/14.
//  Copyright (c) 2014 SSIC. All rights reserved.
//

#import "SamiManifestTableViewController.h"
#import "SamiDeviceTypesApi.h"
#import "SamiUserSession.h"

@interface SamiManifestTableViewController ()
@property (nonatomic) NSArray *sections;
@property (nonatomic) NSDictionary *sectionDictionary;

@end

@implementation SamiManifestTableViewController

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
    
    [self refreshManifest];
}

- (void) refreshManifest {
    NSString* authorizationHeader = [SamiUserSession sharedInstance].bearerToken;
    
    SamiDeviceTypesApi * api = [[SamiDeviceTypesApi alloc] init];
    [api addHeader:authorizationHeader forKey:OAUTH_AUTHORIZATION_HEADER];
    
    [api getLatestManifestPropertiesWithCompletionBlock:self.device.dtid completionHandler:^(SamiManifestPropertiesEnvelope *output, NSError *error) {
        NSLog(@"%@ %@", output, error);
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        // Add the first default
        [sections addObject:@"data"];
        
        NSMutableDictionary *sectionDictionary = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *rootDictionary = [[NSMutableDictionary alloc] init];
        
        NSDictionary *dict = [output.data.properties objectForKey:@"fields"];
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
    ];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManifestPropertyCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ManifestPropertyCell"];
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
                    
                    if ([value2 isKindOfClass:dict.class]) {
                        cell.detailTextLabel.text = [(NSDictionary *)value2 objectForKey:@"type"];
                    } else {
                        cell.detailTextLabel.text = [value2 description];
                    }
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
