//
//  VTPhoneNumberController.m
//  Vota
//
//  Created by Jose Alvarado on 2/22/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "VTPhoneNumberController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface VTPhoneNumberController ()

@end

@implementation VTPhoneNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    [user refresh];
    _textFieldPhoneNumber.text =user[@"phone"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 10) ? NO : YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonSaveAction:(id)sender {
    if (_textFieldPhoneNumber.text.length != 10) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Incorrect phone number" message: @"Must be 10 digits long" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    [VTSettings instance].phoneNumber = _textFieldPhoneNumber.text;
    [VTSettings instance].profileUpdated = YES;

    [self.navigationController popViewControllerAnimated:YES];
}
@end
