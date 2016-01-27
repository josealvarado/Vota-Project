//
//  SettingsViewController.m
//  Vota
//
//  Created by Jose Alvarado on 6/1/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "SettingsViewController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>
@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    
    NSLog(@"%@", [PFUser currentUser]);
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([VTSettings instance].profileUpdated) {
        PFUser *user = [PFUser currentUser];
        
//        if ([VTSettings instance].gender) {
//            user[@"gender"] = [VTSettings instance].gender;
//        }
//        if ([VTSettings instance].state) {
//            user[@"state"] = [VTSettings instance].state;
//        }
//        if ([VTSettings instance].party) {
//            user[@"party"] = [VTSettings instance].party;
//        }
//        if ([VTSettings instance].phoneNumber) {
//            user[@"phone"] = [VTSettings instance].phoneNumber;
//        }
//        if ([VTSettings instance].city) {
//            user[@"city"] = [VTSettings instance].city;
//        }
//        if ([VTSettings instance].zipCode) {
//            user[@"zipcode"] = [VTSettings instance].zipCode;
//        }
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [VTSettings instance].profileUpdated = NO;
        }];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)EditProfileButtonPressed:(id)sender {
    
//    VTProfileController *controller = [[VTProfileController alloc] init];
    
//    [self.navigationController pushViewController:controller animated:YES];

    
    
}

- (IBAction)logOutButtonPressed:(id)sender {
    
//    [delegate close];
 
//    [VTSettings instance].logOut = YES;
    
//    [self.navigationController popViewControllerAnimated:YES];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
