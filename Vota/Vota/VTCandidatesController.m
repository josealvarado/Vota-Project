//
//  VTCandidatesController.m
//  Vota
//
//  Created by Jose Alvarado on 8/31/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTCandidatesController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface VTCandidatesController ()

@end

@implementation VTCandidatesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([[VTSettings instance].candidates count] == 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"Candidates"];
        [query whereKey:@"active" equalTo:@YES];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [VTSettings instance].candidates = [NSMutableArray arrayWithArray:objects];
                [self.tableView reloadData];
            } else {
//                NSLog(@"Error pulling candidates from server");
            }
        }];
//    }
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
    return [[VTSettings instance].candidates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandidateCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    PFObject *candidate = [VTSettings instance].candidates[indexPath.row];
    
    cell.textLabel.text = [candidate objectForKey:@"name"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *candidate = [VTSettings instance].candidates[indexPath.row];
    NSLog(@"website %@", [candidate objectForKey:@"personalWebsite"]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[candidate objectForKey:@"personalWebsite"]]];
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
//    if ([destination respondsToSelector:@selector(setSelection:)]) {
//        NSDictionary *selection = @{@"PFUser": [VTSettings instance].candidates[selectedIndexPath.row]};
//        
//        [segue.destinationViewController setValue:selection forKey:@"selection"];
//    }
//}


@end
