//
//  VTTestingThis.m
//  Vota
//
//  Created by Jose Alvarado on 8/31/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTTestingThis.h"
#import "URLItemSource.h"
#import <Parse/Parse.h>

@interface VTTestingThis ()

@end

@implementation VTTestingThis

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
  
        NSString *text = @"Download the iOS app Vota at www.jose-alvarado.com/vota.html!";
        NSURL *url = [NSURL URLWithString:@"www.jose-alvarado.com/vota.html"];
        
        UIActivityViewController *controller =
        [[UIActivityViewController alloc]
         initWithActivityItems:@[text, url]
         applicationActivities:nil];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)buttonLogout:(id)sender {
//    [self removeFromParentViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
    [PFUser logOut];
}
@end
