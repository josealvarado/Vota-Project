//
//  ZipCodeViewController.m
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "ZipCodeViewController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface ZipCodeViewController ()

@end

@implementation ZipCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    previousZipCode = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *zipCode = [PFUser currentUser][@"zipcode"];
    self.zipCodeTextField.text = zipCode;
    previousZipCode = zipCode;
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
    
    NSString *zipCode = self.zipCodeTextField.text;
    
    if (![previousZipCode isEqualToString:zipCode]) {
        [PFUser currentUser][@"zipcode"] = zipCode;
        [VTSettings instance].profileUpdated = YES;
        
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ziptasticapi.com/%@", zipCode]]];
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
                
                [PFUser currentUser][@"city"] = city;
                [PFUser currentUser][@"state"] = state;

                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation addUniqueObject:[NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"state"]] forKey:@"channels"];
                [currentInstallation saveInBackground];
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
