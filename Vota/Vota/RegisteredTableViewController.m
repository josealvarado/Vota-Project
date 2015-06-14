//
//  RegisteredTableViewController.m
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "RegisteredTableViewController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface RegisteredTableViewController ()

@end

@implementation RegisteredTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    selectedFriends = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[VTSettings instance].contactsWithApp count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactWithAppCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    PFObject *user = [[VTSettings instance].contactsWithApp objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [user objectForKey:@"email"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        
        cell .accessoryType = UITableViewCellAccessoryNone;

        [selectedFriends removeObject:[[VTSettings instance].contactsWithApp objectAtIndex:indexPath.row]];

    } else {
        
        cell .accessoryType = UITableViewCellAccessoryCheckmark;

        [selectedFriends addObject:[[VTSettings instance].contactsWithApp objectAtIndex:indexPath.row]];
        
    }

    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

- (IBAction)sendButtonPressed:(id)sender {
    
    NSLog(@"sending %lu push notifications", (unsigned long)[selectedFriends count]);
    
    for (int i = 0; i < [selectedFriends count]; i++) {
        PFUser *user = [selectedFriends objectAtIndex:i];
        //            NSLog(@"objectid %@", user.objectId);
        
        NSLog(@"User %@", user);
        
        // Create our Installation query
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"user" equalTo:user];
        
        // Send push notification to query
        NSString *message = [NSString stringWithFormat:@"%@: Have you registered to vote / Te registraste para votar?",[PFUser currentUser].username];
        
        [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:message];
        
        
        // Saves the request
        PFObject *testObject = [PFObject objectWithClassName:@"Request"];
        NSLog(@"CurrentUser %@", [PFUser currentUser]);
        testObject[@"from"] = [PFUser currentUser];
        testObject[@"to"] = user;
        testObject[@"question"] = @"0";
        testObject[@"responded"] = @NO;
        
        PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [postACL setPublicReadAccess:YES];
        [postACL setPublicWriteAccess:YES];
        testObject.ACL = postACL;
        
        [testObject saveInBackground];
        
        [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    
            if (succeeded) {
                NSLog(@"successfully sent push");
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
    
    NSString *alertMessage = [NSString stringWithFormat:@"Successfully sent %lu notification(s)", (unsigned long)[selectedFriends count]];
    [[[UIAlertView alloc] initWithTitle:@"Success"
                                message:alertMessage
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil, nil] show];
}
@end
