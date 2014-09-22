//
//  VTGenderController.m
//  Vota
//
//  Created by Jose Alvarado on 8/31/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTGenderController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface VTGenderController ()

@property (strong, nonatomic) NSArray *genders;


@end

@implementation VTGenderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    _genders = @[@"Male", @"Female", @"Transgender"];
    dict =  @{@"Male": [NSNumber numberWithInt:0], @"Female":[NSNumber numberWithInt:1], @"Transgender":[NSNumber numberWithInt:2]};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    [user refresh];
    NSString *gender = user[@"gender"];
    if (gender.length != 0) {
        selectedGender = [[dict objectForKey:gender] integerValue];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:selectedGender inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        selectedGender = NSNotFound;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_genders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenderCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [_genders objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != selectedGender) {
        if (selectedGender != NSNotFound) {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:selectedGender inSection:0];
            
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedGender = indexPath.row;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSLog(@"selected gender - %ld", (long)selectedGender);
}

- (IBAction)barButtonItemSave:(id)sender {
    [VTSettings instance].gender = [_genders objectAtIndex:selectedGender];
    [VTSettings instance].profileUpdated = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
