//
//  VTPartyController.m
//  Vota
//
//  Created by Jose Alvarado on 8/31/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTPartyController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface VTPartyController ()

@property (strong, nonatomic) NSArray *parties;


@end

@implementation VTPartyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _parties = @[@"Democrat", @"Republican", @"Independent"];
    dict =  @{@"Democrat": [NSNumber numberWithInt:0], @"Republican":[NSNumber numberWithInt:1], @"Independent":[NSNumber numberWithInt:2]};

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    [user refresh];
    NSString *party = user[@"party"];
    if (party.length != 0) {
        selectedParty = [[dict objectForKey:party] integerValue];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:selectedParty inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        selectedParty = NSNotFound;
    }
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
    return [_parties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [_parties objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != selectedParty) {
        if (selectedParty != NSNotFound) {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:selectedParty inSection:0];
            
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedParty = indexPath.row;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSLog(@"selected party - %ld", (long)selectedParty);
}

- (IBAction)barButtonItemSave:(id)sender {
    [VTSettings instance].party = [_parties objectAtIndex:selectedParty];
    [VTSettings instance].profileUpdated = YES;
    
    [self.navigationController popViewControllerAnimated:YES];

}
@end
