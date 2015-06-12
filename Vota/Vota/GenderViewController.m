//
//  GenderViewController.m
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "GenderViewController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface GenderViewController ()

@end

@implementation GenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedGender = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    NSString *gender = [PFUser currentUser][@"gender"];
    
    if ([gender isEqualToString:@"Female"]) {
        self.femaleButton.selected = YES;
    } else if ([gender isEqualToString:@"Male"]) {
        self.maleButton.selected = YES;
    } else if ([gender isEqualToString:@"Transgender"]) {
        self.transgenderButton.selected = YES;
    }
    
    previousGender = gender;
    selectedGender = gender;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)genderButtonPressed:(UIButton*)sender {
    
    self.femaleButton.selected = NO;
    self.maleButton.selected = NO;
    self.transgenderButton.selected = NO;
    
    sender.selected = YES;
    
    selectedGender = sender.titleLabel.text;
}

- (IBAction)backButtonPressed:(id)sender {
    
    // save Gender
    if (![previousGender isEqualToString:selectedGender]) {
//        [VTSettings instance].gender = selectedGender;
        [VTSettings instance].profileUpdated = YES;
        
        [PFUser currentUser][@"gender"] = selectedGender;        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
