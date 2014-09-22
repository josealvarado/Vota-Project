//
//  VTNotificationController.m
//  Vota
//
//  Created by Jose Alvarado on 9/10/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTNotificationController.h"
#import <Parse/Parse.h>

@interface VTNotificationController ()

@end

@implementation VTNotificationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    if ([_notifications count] == 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"Request"];
        [query whereKey:@"to" equalTo:[PFUser currentUser]];
        [query whereKey:@"responded" equalTo:@NO];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                if ([objects count] > 0) {
                    _notifications = [[NSMutableArray alloc] initWithArray:objects];
                    
//                    NSLog(@"not empty %lu", (unsigned long)[_notifications count]);
                    [self.tableView reloadData];
                } else {
//                    NSLog(@"empty response");
                }
                
                
                
                
                
                [self.tableView reloadData];
            } else {
//                NSLog(@"Error pulling candidates from server");
            }
        }];
//    } else {
//        [self.tableView reloadData];
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
    
//    NSLog(@"herer size - %lu", (unsigned long)[_notifications count]);
    
    return [_notifications count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    PFObject *request = [_notifications objectAtIndex:indexPath.row];
    
    NSString *type = [request objectForKey:@"question"];
    NSString *text;
    if ([type isEqualToString:@"1"]) {
        text = @"Have you registered to vote / Te registraste para votar?";
    } else {
        text = @"Did you vote / Ha votado?";
    }
    
//    NSLog(@"object found");
    
    cell.textLabel.text = text;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"index - %ld", (long)indexPath.row);
    PFObject *request = [_notifications objectAtIndex:indexPath.row];
    self.row = indexPath.row;
//    _row = [NSNumber numberWithInteger:indexPath.row];
    
    NSString *title;
    NSString *message;
    _question = [request objectForKey:@"question"];
    if ([_question isEqualToString:@"1"]) {
        title = @"Have you registered to vote?";
        message = @"Te registraste para votar?";
    } else {
        title = @"Did you vote?";
        message = @"Has votado?";
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title message: message delegate:self cancelButtonTitle: @"No" otherButtonTitles: @"Yes", nil];
        [alertView show];
    
//    NSLog(@"make sure to remove it from the list");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
//    NSLog(@"row selected %d", self.row);
    
    PFObject *request = [_notifications objectAtIndex:self.row];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];

    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:request.objectId block:^(PFObject *reqObject, NSError *error) {
        
        
                if (!reqObject) {
            NSLog(@"The getFirstObject request failed.");
                } else {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved the object.");
                    reqObject[@"responded"] = @YES;
                    
                    NSLog(@"question %@", [reqObject objectForKey:@"question"]);

                    [reqObject saveInBackground];
                }
        
    }];
    
    
    
    
    NSString *text;
    
    if ([_question isEqualToString:@"1"]) {
        
        if([title isEqualToString:@"Yes"])
        {
            text = @"Yes I registred / Sí me registré!";
        } else {
            text = @"No I didn't register / No me registré!";
        }
    } else {
        if([title isEqualToString:@"Yes"])
        {
            text = @"Yes I voted / Sí vote!";
        } else {
            text = @"No I didn't vote / No vote!";
        }
    }
    
    PFUser *user = [request objectForKey:@"from"];
//    NSLog(@"objectid %@", user.objectId);
    
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" equalTo:user];
    
    // Send push notification to query
    [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:text];
}

@end
