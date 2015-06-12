//
//  RegisterToVoteViewController.m
//  Vota
//
//  Created by Jose Alvarado on 5/31/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "RegisterToVoteViewController.h"

@interface RegisterToVoteViewController ()

@end

@implementation RegisterToVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.scrollView.contentSize =CGSizeMake(320, 1000);
    
//    self.scrollView.frame = CGRectMake(0, 0, 320, 400);
    
    //---set the viewable frame of the scroll view---
//    self.scrollView.frame = CGRectMake(0, 146, 320, 1000);
    //---set the content size of the scroll view---
    [self.scrollView setContentSize:CGSizeMake(320, 1000)];
    //-- See more at: http://www.devx.com/wireless/Article/45113#sthash.5gX3haMJ.dpuf
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
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
    
    [self.navigationController popViewControllerAnimated:true];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
