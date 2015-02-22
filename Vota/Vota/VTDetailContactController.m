//
//  VTDetailContactController.m
//  Vota
//
//  Created by Jose Alvarado on 9/9/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTDetailContactController.h"
#import <Parse/Parse.h>

@interface VTDetailContactController ()

@end

@implementation VTDetailContactController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _contact = [_selection objectForKey:@"Contact"];
    
    NSString *first_name = [_contact objectForKey:@"first_name"];
    NSString *last_name = [_contact objectForKey:@"last_name"];
    self.title = [NSString stringWithFormat:@"%@ %@", first_name, last_name];
    
    
//    NSMutableArray *contactNumbers = [_contact objectForKey:@"phone_numbers"];
    
//    NSString *contactNumber = [contactNumbers objectAtIndex:0];
    
        
//    NSString * strippedNumber = [contactNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [contactNumber length])];
    
//    NSLog(@"%@", strippedNumber);
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
    return 2;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"index - %ld", (long)indexPath.row);
    
    if (indexPath.row == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Send Register Notification?" message: @"Envia notificación de registro?" delegate:self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Send", nil];
        [alertView show];
        _pushText = @"Have you registered to vote / Te registraste para votar?";
        _questionNumber = @"1";
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Send Vote Notification?" message: @"Envia notificación de voto?" delegate:self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Send", nil ];
        [alertView show];
        _pushText = @"Did you vote / Ha votado?";
        _questionNumber = @"2";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Send"])
    {
        
//        NSLog(@"send message");
        NSArray *pfusers = [_contact objectForKey:@"PFUsers"];
        for (int i = 0; i < [pfusers count]; i++) {
            PFUser *user = [pfusers objectAtIndex:i];
//            NSLog(@"objectid %@", user.objectId);
        
            // Create our Installation query
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"user" equalTo:user];
        
            // Send push notification to query
            _pushText = [NSString stringWithFormat:@"%@:%@",[PFUser currentUser].username, _pushText];
            [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:_pushText];
        
    
            // Saves the request
            PFObject *testObject = [PFObject objectWithClassName:@"Request"];
            //    NSLog(@"User_ID %@", [PFUser currentUser].objectId);
            testObject[@"from"] = [PFUser currentUser];
            testObject[@"to"] = user;
            testObject[@"question"] = _questionNumber;
            testObject[@"responded"] = @NO;
            
            PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [postACL setPublicReadAccess:YES];
            [postACL setPublicWriteAccess:YES];
            testObject.ACL = postACL;
            
            [testObject saveInBackground];
        }
    }
}


@end
