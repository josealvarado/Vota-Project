//
//  RegisterToVoteWebpageViewController.m
//  Vota
//
//  Created by Jose Alvarado on 5/31/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "RegisterToVoteWebpageViewController.h"
#import "VTSettings.h"

@interface RegisterToVoteWebpageViewController ()

@end

@implementation RegisterToVoteWebpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *urlAddress = [[VTSettings instance] getRegisterURL];
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [_webView loadRequest:requestObj];
    
    self.navigationController.navigationBar.hidden=NO;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
