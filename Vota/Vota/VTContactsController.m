//
//  VTContactsController.m
//  Vota
//
//  Created by Jose Alvarado on 9/4/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTContactsController.h"
#import <Parse/Parse.h>
#import "VTSettings.h"

@import AddressBook;

@interface VTContactsController ()

@end

@implementation VTContactsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _activityIndicatorLoading.hidden = NO;
    [_activityIndicatorLoading startAnimating];
    
    
    _labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 20)];
    _labelStatus.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _labelStatus.textAlignment = NSTextAlignmentCenter;
    _labelStatus.font = [UIFont boldSystemFontOfSize:12.0f];
    _labelStatus.numberOfLines = 1;
    
    _labelStatus.backgroundColor = [UIColor clearColor];
    _labelStatus.textColor = [UIColor blackColor];
    
    
    [self loadContacts];
//    NSLog(@"load");
    
    
//    [PFCloud callFunctionInBackground:@"hasApp"
//                       withParameters:@{@"movie": @"The Matrix"}
//                                block:^(NSString *ratings, NSError *error) {
//                                    if (!error) {
//                                        NSLog(@"response %@", ratings);
//                                    } else {
//                                        NSLog(@"error %@", error);
//                                    }
//                                }];
}

- (void)loadContacts
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
//        NSLog(@"Denied");
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [cantAddContactAlert show];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
//        NSLog(@"2 Authorized");
        
        NSMutableArray *contacts2 = [self getContacts];
        
//        NSLog(@"2 count %lu", (unsigned long)[contacts2 count]);
        
//        [VTStorage instance].listOfContacts = contacts2;
//        [self.contactsController loadContacts];
        [VTSettings instance].contacts = contacts2;
        
        int count = 0;
        for (int i = 0; i < [contacts2 count]; i++) {
//            NSLog(@"count = %d", i);
            NSDictionary *contact = [contacts2 objectAtIndex:i];
            
            NSMutableArray *contactNumbers = [contact objectForKey:@"phone_numbers"];
            if ([contactNumbers count] > 0) {
                count++;
            }
        }
//        NSLog(@"valid count - %d", count);
        _contactSize = count;
        
//        [PFCloud callFunctionInBackground:@"hasApp"
//                           withParameters:@{@"contacts": contacts2}
//                                    block:^(NSString *ratings, NSError *error) {
//                                        if (!error) {
//                                            NSLog(@"response %@", ratings);
//                                        } else {
//                                            NSLog(@"error %@", error);
//                                        }
//                                    }];

        
        [self loadContactsWithApp:contacts2];
        
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
//        NSLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted){
                    //4
                    UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    [cantAddContactAlert show];
                    return;
                }
                //5
//                NSLog(@"5 Just Authorized");
                
                NSMutableArray *contacts2 = [self getContacts];
                
//                NSLog(@"5 count %lu", (unsigned long)[contacts2 count]);
                
//                [VTStorage instance].listOfContacts = contacts2
//                [self.contactsController loadContacts];
                
                [VTSettings instance].contacts = contacts2;
                
                int count = 0;
                for (int i = 0; i < [contacts2 count]; i++) {
//                    NSLog(@"count = %d", i);
                    NSDictionary *contact = [contacts2 objectAtIndex:i];
                    
                    NSMutableArray *contactNumbers = [contact objectForKey:@"phone_numbers"];
                    if ([contactNumbers count] > 0) {
                        count++;
                    }
                }
                
                NSLog(@"valid count - %d", count);
                _contactSize = count;
                
                [self loadContactsWithApp:contacts2];
            });
        });
    }
    
//    [self.tableView reloadData];
}

- (void)loadContactsWithApp:(NSMutableArray *)contacts{
    [VTSettings instance].contactsWithApp = [[NSMutableArray alloc] init];
    
    int totalContacts = _contactSize;
    
    _labelStatus.text = [NSString stringWithFormat:@"Loading 0 out of %d", totalContacts];
    
    [self.view addSubview:_labelStatus];
    
    for (int i = 0; i < [contacts count]; i++) {
//        NSLog(@"count = %d", i);
        NSDictionary *contact = [contacts objectAtIndex:i];
        
        NSMutableArray *contactNumbers = [contact objectForKey:@"phone_numbers"];
        
        
        
        if ([contactNumbers count] > 0) {
            NSString *contactNumber = [contactNumbers objectAtIndex:0];
        
            
            
            NSString * strippedNumber = [contactNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [contactNumber length])];
            
            NSLog(@"strippedNumber = %@", strippedNumber);
            
            if ([strippedNumber length] == 10) {
                strippedNumber = [NSString stringWithFormat:@"1%@", strippedNumber];
            }
            
//            PFQuery *query = [PFQuery queryWithClassName:@"QuestionTable"];
//            [query whereKey:@"phone" equalTo:strippedNumber];
//            [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
            
                
            PFQuery *q = [PFUser query];
            [q whereKey:@"phone" equalTo:strippedNumber];
            [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // Found UserStats
                    
                    if ([objects count] > 0) {
//                        NSLog(@"phone number exists = %@", strippedNumber);
                        
                        [contact setValue:objects forKeyPath:@"PFUsers"];
                    
                        [[VTSettings instance].contactsWithApp addObject:contact];
                        
//                        NSLog(@"size - %lu", (unsigned long)[[VTSettings instance].contactsWithApp count]);
                        [self.tableView reloadData];
                    }
                    
                    
                } else {
                    // Did not find any UserStats for the current user
                    //            NSLog(@"Error 3 from number - %@", strippedNumber);
                    //            NSLog(@"Error3: %@", error);
                }
                
                _contactSize--;
//                NSLog(@"conactCountDown - %d", _contactSize);
                
                _labelStatus.text = [NSString stringWithFormat:@"Loading %d out of %d", _contactSize, totalContacts];
                
                if (_contactSize <= 0) {
                    _activityIndicatorLoading.hidden = YES;
                    [_activityIndicatorLoading stopAnimating];
//                    NSLog(@"final size - %lu", (unsigned long)[[VTSettings instance].contactsWithApp count]);
                    [self.tableView reloadData];
                    
                    [[[UIAlertView alloc] initWithTitle:@"Success"
                                                message:[NSString stringWithFormat:@"Found %lu friends", (unsigned long)[[VTSettings instance].contactsWithApp count]]
                                               delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil, nil] show];
                    [_labelStatus removeFromSuperview];
                }
                
                
            }];
            
        }
        
        
    }
    
}

- (NSMutableArray *)getContacts{
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    
    //    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    //    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
    
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    for(int i = 0; i < numberOfPeople; i++) {
        NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        //        NSLog(@"Name:%@ %@", firstName, lastName);
        
        if (!firstName) {
            firstName = @"";
        }
        if (!lastName) {
            lastName = @"";
        }
        
        [contact setObject:firstName forKey:@"first_name"];
        [contact setObject:lastName forKey:@"last_name"];
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSMutableArray *contactNumbers = [[NSMutableArray alloc] init];
        for (CFIndex j = 0; j < ABMultiValueGetCount(phoneNumbers); j++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, j);
            //            NSLog(@"phone:%@", phoneNumber);
            [contactNumbers addObject:phoneNumber];
        }
        
        if ([contactNumbers count] > 0) {
            NSMutableArray *contactNumbers2 = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [contactNumbers count]; i++) {
                NSString *contactNumber = [contactNumbers objectAtIndex:i];
                
                NSString * strippedNumber = [contactNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [contactNumber length])];
                
                if (strippedNumber.length >= 10) {
                    NSLog(@"stripped Number = %@", strippedNumber);
                    [contactNumbers2 addObject:strippedNumber];
                }
            }
            
            if ([contactNumbers2 count] > 0) {
                [contact setObject:contactNumbers2 forKey:@"phone_numbers"];
                
                [contacts addObject:contact];
            }
        }
    }
    return contacts;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    NSLog(@"attempting to update list - %lu", (unsigned long)[[VTSettings instance].contactsWithApp count]);
    return [[VTSettings instance].contactsWithApp count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSString *name;
    
    NSDictionary *contact = [VTSettings instance].contactsWithApp[indexPath.row];
    NSString *first_name = [contact objectForKey:@"first_name"];
    NSString *last_name = [contact objectForKey:@"last_name"];
        
    name = [NSString stringWithFormat:@"%@ %@", first_name, last_name];
    
    cell.textLabel.text = name;
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }

    if ([destination respondsToSelector:@selector(setSelection:)]) {
        NSDictionary *selection = @{@"Contact": [VTSettings instance].contactsWithApp[selectedIndexPath.row]};
        //        [segue.destinationViewController setValue:[VTSettings instance].candidates[selectedIndexPath.row] forKey:@"candidate"];
        
        [segue.destinationViewController setValue:selection forKey:@"selection"];
    }
}

@end
