//
//  VTZipCodeController.m
//  Vota
//
//  Created by Jose Alvarado on 9/4/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTZipCodeController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface VTZipCodeController ()

@end

@implementation VTZipCodeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    [user refresh];
    _textFieldZipCode.text =user[@"zipcode"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 5) ? NO : YES;
}

- (IBAction)buttonSaveAction:(id)sender {
    if (_textFieldZipCode.text.length != 5) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Incorrect zip code" message: @"Must be 5 digits long" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    [VTSettings instance].zipCode = _textFieldZipCode.text;
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ziptasticapi.com/%@", _textFieldZipCode.text]]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        // Parse data here
//        NSLog(@"data %@", data);
        
        NSError *error = nil;
//        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSDictionary *jsonDict =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (error != nil) {
//            NSLog(@"Error parsing JSON.");
        }
        else {
//            NSLog(@"Array: %@", jsonArray);
            //            NSLog(@"Array: %@", jsonArray[0]);
//            NSLog(@"Array: %@", [jsonDict objectForKey:@"city"]);
//            NSLog(@"Array: %@", [jsonDict objectForKey:@"country"]);
//            NSLog(@"Array: %@", [jsonDict objectForKey:@"state"]);
            
            NSString *city = [jsonDict objectForKey:@"city"];
            NSString *state = [jsonDict objectForKey:@"state"];
            
            [VTSettings instance].city = city;
            [VTSettings instance].state = state;
            [VTSettings instance].profileUpdated = YES;
            
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:[NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"state"]] forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}
@end
