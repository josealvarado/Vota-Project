//
//  GetFriendsToVoteViewController.m
//  Vota
//
//  Created by Jose Alvarado on 5/31/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "GetFriendsToVoteViewController.h"

@interface GetFriendsToVoteViewController ()

@end

@implementation GetFriendsToVoteViewController

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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareVotaButtoPressed:(id)sender {
        
    NSString *text = @"Have you registered to vote? Have you voted? Do both with the VOTA app! VOTAapp.com";
    NSURL *url = [NSURL URLWithString:@"www.votaapp.com"];
//    
//    UIActivityViewController *controller =
//    [[UIActivityViewController alloc]
//     initWithActivityItems:@[text, url]
//     applicationActivities:nil];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url] applicationActivities:nil];
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)askRegisterButtonPressed:(id)sender {
    
}

- (IBAction)askVotedButtonPressed:(id)sender {
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
