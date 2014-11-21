//
//  VTBallotController.m
//  Vota
//
//  Created by Jose Alvarado on 9/3/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTBallotController.h"
#import <Parse/Parse.h>
#import "VTSettings.h"

@interface VTBallotController ()

@end

@implementation VTBallotController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([[VTSettings instance].ballots count] == 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"Ballots"];
        [query whereKey:@"active" equalTo:@YES];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [VTSettings instance].ballots = [NSMutableArray arrayWithArray:objects];
                [self.tableView reloadData];
            } else {
                NSLog(@"Error pulling ballots from server");
            }
        }];
    }
    
    
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
    return [[VTSettings instance].ballots count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeasureCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    PFObject *ballots = [VTSettings instance].ballots[indexPath.row];
    
    cell.textLabel.text = [ballots objectForKey:@"name"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *ballot = [VTSettings instance].ballots[indexPath.row];
    NSLog(@"website %@", [ballot objectForKey:@"url"]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ballot objectForKey:@"url"]]];
}

//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
//    
//    UIViewController *destination = segue.destinationViewController;
//    if ([destination respondsToSelector:@selector(setDelegate:)]) {
//        [destination setValue:self forKey:@"delegate"];
//    }
//    
//    //    [segue.destinationViewController setValue:[VTSettings instance].candidates[selectedIndexPath.row] forKey:@"candidate"];
//    
//    if ([destination respondsToSelector:@selector(setSelection:)]) {
//        NSDictionary *selection = @{@"Ballot": [VTSettings instance].ballots[selectedIndexPath.row]};
//        
//        [segue.destinationViewController setValue:selection forKey:@"selection"];
//        
//    }
//}

@end
