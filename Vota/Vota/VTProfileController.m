//
//  VTProfileController.m
//  Vota
//
//  Created by Jose Alvarado on 9/11/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTProfileController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface VTProfileController ()

@end

@implementation VTProfileController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"verify if anything has been modified");
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([VTSettings instance].profileUpdated) {
        PFUser *user = [PFUser currentUser];
        if ([VTSettings instance].gender) {
            user[@"gender"] = [VTSettings instance].gender;
        }
        if ([VTSettings instance].state) {
            user[@"state"] = [VTSettings instance].state;
        }
        if ([VTSettings instance].party) {
            user[@"party"] = [VTSettings instance].party;
        }
        if ([VTSettings instance].phoneNumber) {
            user[@"phone"] = [VTSettings instance].phoneNumber;
        }
        if ([VTSettings instance].city) {
            user[@"city"] = [VTSettings instance].city;
        }
        if ([VTSettings instance].zipCode) {
            user[@"zipcode"] = [VTSettings instance].zipCode;
        }
        [user save];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
