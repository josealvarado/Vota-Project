//
//  VTCandidateDetailController.m
//  Vota
//
//  Created by Jose Alvarado on 8/31/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.

#import "VTCandidateDetailController.h"

@interface VTCandidateDetailController ()

@end

@implementation VTCandidateDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFObject *user = [_selection objectForKey:@"PFUser"];
    
//    NSLog(@"candidate %@", [user objectForKey:@"name"]);
    
    self.title = [user objectForKey:@"name"];
    
    NSString *urlAddress = [user objectForKey:@"personalWebsite"];
    
//    NSLog(@"website - %@", urlAddress);
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [_webViewCandidateWebsite loadRequest:requestObj];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
