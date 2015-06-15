//
//  NotificationsTableViewController.m
//  Vota
//
//  Created by Jose Alvarado on 6/15/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface NotificationsTableViewController ()

@end

@implementation NotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];
    [query whereKey:@"responded" equalTo:@NO];
    [query whereKey:@"to" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            
            data = objects;
            
            //            for (PFObject *object in objects) {
            //                NSLog(@"%@", object);
            //                NSLog(@"%@", object.objectId);
            //            }
            
            //            [VTSettings instance].contactsWithApp = objects;
            
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *info = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = [info objectForKey:@"message"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //0 -  Have you registered to vote / Te registraste para votar?
    //1 - Did you vote / Ha votado?
    
    PFObject *info = data[indexPath.row];
    
    NSString *question = [info objectForKey:@"questions"];
    NSString *message;
    if ([question isEqualToString:@"0"]) {
        message = @"Have you registered to vote / Te registraste para votar?";
    } else {
        message = @"Did you vote / Ha votado?";
    }
    
    PFUser *from = [info objectForKey:@"from"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[from username]
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                        otherButtonTitles:@"No",nil];
    [alert show];

    [info setObject:@YES forKey:@"responded"];
    
    [info saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
        } else {
            NSLog(@"failed to save response");
        }
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
