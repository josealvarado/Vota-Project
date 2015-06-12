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
#import <Parse/Parse.h>

@import AddressBook;


@interface VotaViewController ()

@end

@implementation VotaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    allPhoneNumbers = [[NSMutableArray alloc] init];
    
    [self loadContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    
//    if ([VTSettings instance].logOut){
//        [VTSettings instance].logOut = NO;
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    
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
        
        
        [self.activityView startAnimating];
        
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
        numberOfContacts = count;
        
        //        [PFCloud callFunctionInBackground:@"hasApp"
        //                           withParameters:@{@"contacts": contacts2}
        //                                    block:^(NSString *ratings, NSError *error) {
        //                                        if (!error) {
        //                                            NSLog(@"response %@", ratings);
        //                                        } else {
        //                                            NSLog(@"error %@", error);
        //                                        }
        //                                    }];
        
        
        [self compareContactsWithBackend:contacts2];
        
        [self.activityView stopAnimating];
        
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
                
                [self.activityView startAnimating];
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
                numberOfContacts = count;
                
                [self compareContactsWithBackend:contacts2];
                
                [self.activityView stopAnimating];
            });
        });
    }
    
    //    [self.tableView reloadData];
}

- (void)compareContactsWithBackend:(NSMutableArray *)contacts{
//    [VTSettings instance].contactsWithApp = [[NSMutableArray alloc] init];
    
    NSLog(@"total phoneNumbrs %lu", (unsigned long)[allPhoneNumbers count]);
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"phone" containedIn:allPhoneNumbers];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object);
                NSLog(@"%@", object.objectId);
            }
            
            [VTSettings instance].contactsWithApp = objects;
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
//    int totalContacts = numberOfContacts;
    
//    self.statusLabel.hidden = NO;
    
//    self.statusLabel.text = [NSString stringWithFormat:@"Loading 0 out of %d", totalContacts];
    
//    for (int i = 0; i < [contacts count]; i++) {
//        //        NSLog(@"count = %d", i);
//        NSDictionary *contact = [contacts objectAtIndex:i];
//        
//        NSMutableArray *contactNumbers = [contact objectForKey:@"phone_numbers"];
//        
//        
//        
//        if ([contactNumbers count] > 0) {
//            NSString *contactNumber = [contactNumbers objectAtIndex:0];
//            
//            
//            
//            NSString * strippedNumber = [contactNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [contactNumber length])];
//            
//            NSLog(@"strippedNumber = %@", strippedNumber);
//            
//            
//            
//            //            PFQuery *query = [PFQuery queryWithClassName:@"QuestionTable"];
//            //            [query whereKey:@"phone" equalTo:strippedNumber];
//            //            [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
//            
//            
//            PFQuery *q = [PFUser query];
//            [q whereKey:@"phone" equalTo:strippedNumber];
//            [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                if (!error) {
//                    // Found UserStats
//                    
//                    if ([objects count] > 0) {
//                        //                        NSLog(@"phone number exists = %@", strippedNumber);
//                        
//                        [contact setValue:objects forKeyPath:@"PFUsers"];
//                        
//                        [[VTSettings instance].contactsWithApp addObject:contact];
//                        
//                        //                        NSLog(@"size - %lu", (unsigned long)[[VTSettings instance].contactsWithApp count]);
////                        [self.tableView reloadData];
//                    }
//                    
//                    
//                } else {
//                    // Did not find any UserStats for the current user
//                    //            NSLog(@"Error 3 from number - %@", strippedNumber);
//                    //            NSLog(@"Error3: %@", error);
//                }
//                
//                numberOfContacts--;
//                //                NSLog(@"conactCountDown - %d", _contactSize);
//                
//                self.statusLabel.text = [NSString stringWithFormat:@"Loading %d out of %d", numberOfContacts, totalContacts];
//                
//                if (numberOfContacts <= 0) {
//                    
//                    
//                    //                    NSLog(@"final size - %lu", (unsigned long)[[VTSettings instance].contactsWithApp count]);
////                    [self.tableView reloadData];
//                    
////                    [[[UIAlertView alloc] initWithTitle:@"Success"
////                                                message:[NSString stringWithFormat:@"Found %lu friends", (unsigned long)[[VTSettings instance].contactsWithApp count]]
////                                               delegate:nil
////                                      cancelButtonTitle:@"Ok"
////                                      otherButtonTitles:nil, nil] show];
//                    
//                    
////                    [_labelStatus removeFromSuperview];
//                }
//                
//                
//            }];
//            
//        }
//        
//        
//    }
    
//    self.statusLabel.hidden = YES;
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
        
        NSLog(@"Name:%@ %@", firstName, lastName);
        
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
                
                if ([strippedNumber length] == 10) {
                    strippedNumber = [NSString stringWithFormat:@"1%@", strippedNumber];
                }
                
                
                if (strippedNumber.length >= 10) {
                    NSLog(@"stripped Number = %@", strippedNumber);
                    [contactNumbers2 addObject:strippedNumber];
                }
                
                [allPhoneNumbers addObject:strippedNumber];
            }
            
            if ([contactNumbers2 count] > 0) {
                [contact setObject:contactNumbers2 forKey:@"phone_numbers"];
                
                [contacts addObject:contact];
            }
        }
    }
    return contacts;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (IBAction)votaButtonPressed:(id)sender {
//    
//    SettingsViewController *settings = [[SettingsViewController alloc] init];
//    
//    settings.delegate = self;
//    
//    [self presentViewController:settings animated:YES completion:nil];
//    
//}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
