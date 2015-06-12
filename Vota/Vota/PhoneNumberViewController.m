//
//  PhoneNumberViewController.m
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface PhoneNumberViewController ()

@end

@implementation PhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    previousPhoneNumber = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *phoneNumber = [PFUser currentUser][@"phone"];
    
    self.phoneNumberTextField.text = phoneNumber;
    
    previousPhoneNumber = phoneNumber;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPressed:(id)sender {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    if (![previousPhoneNumber isEqualToString:phoneNumber]) {
        if ([previousPhoneNumber length] >= 10) {
            [PFUser currentUser][@"phone"] = phoneNumber;
        } else {
            [PFUser currentUser][@"phone"] =[NSString stringWithFormat:@"1%@", phoneNumber];
        }
        [VTSettings instance].profileUpdated = YES;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
