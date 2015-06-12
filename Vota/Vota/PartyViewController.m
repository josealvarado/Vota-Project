//
//  PartyViewController.m
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "PartyViewController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface PartyViewController ()

@end

@implementation PartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedParty = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *party = [PFUser currentUser][@"party"];
    
    if ([party isEqualToString:@"Democrat"]) {
        self.democratButton.selected = YES;
    } else if ([party isEqualToString:@"Republican"]) {
        self.republicanButton.selected = YES;
    } else if ([party isEqualToString:@"Independent"]) {
        self.independentButton.selected = YES;
    }
    
    previousParty = party;
    selectedParty = party;
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
    if (![previousParty isEqualToString:selectedParty]) {
        [PFUser currentUser][@"party"] = selectedParty;
        [VTSettings instance].profileUpdated = YES;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)partyButtonPressed:(UIButton*)sender {
    self.democratButton.selected = NO;
    self.republicanButton.selected = NO;
    self.independentButton.selected = NO;
    
    sender.selected = YES;
    
    selectedParty = sender.titleLabel.text;
}
@end
