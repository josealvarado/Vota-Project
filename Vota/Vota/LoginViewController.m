//
//  LoginViewController.m
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "KeychainItemWrapper.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    if ([PFUser currentUser]) { // No user logged in
        [self performSegueWithIdentifier:@"MainMenu" sender:nil];
    }
    
    _keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestUDID" accessGroup:nil];
    
    
//    NSArray *states = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
//    
//    for (NSString *state in states) {
//        PFObject *ballotCandidate = [PFObject objectWithClassName:@"BallotCandidate"];
//        ballotCandidate[@"active"] = @YES;
//        ballotCandidate[@"name"] = @"Hillary Clinton";
//        ballotCandidate[@"state"] = state;
//        ballotCandidate[@"url"] = @"https://www.hillaryclinton.com/";
//        [ballotCandidate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                // The object has been saved.
//            } else {
//                // There was a problem, check error.description
//            }
//        }];
//
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    NSString *username = [_keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [_keychain objectForKey:(__bridge id)(kSecValueData)];
    
    NSLog(@"%@, %@", username, password);
    
    if (!(username == (id)[NSNull null] || username.length == 0 || password == (id)[NSNull null] || password.length == 0)){
        self.emailTextField.text = username;
        self.passwordTextField.text = password;
    }
}

-(void)dismissKeyboard {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)forgotPasswordButtonPressed:(id)sender {
    NSString *email = self.emailTextField.text;
    if (email.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Include username when resetting password"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    [PFUser requestPasswordResetForEmailInBackground:email];
    
    [[[UIAlertView alloc] initWithTitle:@"Password Reset Initiated"
                                message:@"Please check your email to reset password"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil, nil] show];
}

- (IBAction)signUpButtonPressed:(id)sender {
    
    if (self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Fields can't be empty"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    [self.indicatorView startAnimating];
    
    PFUser *user = [PFUser user];
    user.username = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    user[@"phone"] = @"";
    user[@"gender"] = @"";
    user[@"party"] = @"";
    user[@"city"] = @"";
    user[@"state"] = @"";
    user[@"zipcode"] = @"";
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            
            // Associate the device with a user
            PFInstallation *installation = [PFInstallation currentInstallation];
            installation[@"user"] = [PFUser currentUser];
            [installation saveInBackground];
            
            [self performSegueWithIdentifier:@"MainMenu" sender:sender];
            
            
            //            KeychainItemWrapper *keychain =
            //            [[KeychainItemWrapper alloc] initWithIdentifier:@"MyAppLoginData" accessGroup:nil];
            //            [keychain setObject:_textFieldUsername forKey:(__bridge id)kSecAttrAccount];
            //            [keychain setObject:_textFieldPassword forKey:(__bridge id)kSecValueData];
            
            [_keychain setObject:self.emailTextField.text forKey:(__bridge id)kSecAttrAccount];
            [_keychain setObject:self.passwordTextField.text forKey:(__bridge id)kSecValueData];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            
            // The login failed. Check error to see why.
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:errorString
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil] show];
        }
        
        [self.indicatorView stopAnimating];
    }];
}
- (IBAction)signInButtonPressed:(id)sender {
    if (self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Fields can't be empty"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    [self.indicatorView startAnimating];
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.
                                            
            // Associate the device with a user
            PFInstallation *installation = [PFInstallation currentInstallation];
            installation[@"user"] = [PFUser currentUser];
            [installation saveInBackground];
                                            
            [self performSegueWithIdentifier:@"MainMenu" sender:sender];
                                            
            [_keychain setObject:self.emailTextField.text forKey:(__bridge id)kSecAttrAccount];
            [_keychain setObject:self.passwordTextField.text forKey:(__bridge id)kSecValueData];
                                            
        } else {
            // The login failed. Check error to see why.
            NSString *errorString = [error userInfo][@"error"];
                                            
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:errorString
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil] show];
        }
        [self.indicatorView stopAnimating];
    }];
}
@end
