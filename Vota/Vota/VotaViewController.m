//
//  VotaViewController.m
//  Vota
//
//  Created by Jose Alvarado on 6/1/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "VotaViewController.h"
#import "SettingsViewController.h"
#import "VTSettings.h"

@interface VotaViewController ()

@end

@implementation VotaViewController

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
    
    if ([VTSettings instance].logOut){
        [VTSettings instance].logOut = NO;
        
        [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)votaButtonPressed:(id)sender {
    
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    
    settings.delegate = self;
    
    [self presentViewController:settings animated:YES completion:nil];
    
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
