//
//  VTStartViewController.m
//  Vota
//
//  Created by Jose Alvarado on 8/30/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTStartViewController.h"
#import "VTSettings.h"
#import <Parse/Parse.h>

@interface VTStartViewController ()

@end

@implementation VTStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSString *backGroundImage = [[VTSettings instance] getBackGroundImage];
        NSLog(@"background image - %@", backGroundImage);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    [_backgroundImage setImage:[UIImage imageNamed:[[VTSettings instance] getBackGroundImage]]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    if ([PFUser currentUser]) { // No user logged in
        [self performSegueWithIdentifier:@"PushMenuController" sender:nil];
    }
    
}

-(void)dismissKeyboard {
    [_textFieldPassword resignFirstResponder];
    [_textFieldUsername resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonSignUpAction:(id)sender {
    
    if (_textFieldUsername.text.length == 0 || _textFieldPassword.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Fields can't be empty"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    
    PFUser *user = [PFUser user];
    user.username = _textFieldUsername.text;
    user.password = _textFieldPassword.text;
    user.email = _textFieldUsername.text;
    
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
            
            [self performSegueWithIdentifier:@"PushMenuController" sender:sender];
        } else {
            NSString *errorString = [error userInfo][@"error"];

            // The login failed. Check error to see why.
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:errorString
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil] show];
        }
    }];
}

- (IBAction)buttonSignInAction:(id)sender {
    if (_textFieldUsername.text.length == 0 || _textFieldPassword.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Fields can't be empty"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:_textFieldUsername.text password:_textFieldPassword.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            
                                            // Associate the device with a user
                                            PFInstallation *installation = [PFInstallation currentInstallation];
                                            installation[@"user"] = [PFUser currentUser];
                                            [installation saveInBackground];
                                            
                                            [self performSegueWithIdentifier:@"PushMenuController" sender:sender];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSString *errorString = [error userInfo][@"error"];
                                            
                                            [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:errorString
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil, nil] show];
                                        }
                                    }];
}

- (IBAction)buttonResetPassword:(id)sender {
    if (_textFieldUsername.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Include username when resetting password"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    [PFUser requestPasswordResetForEmailInBackground:_textFieldUsername.text];
    
    [[[UIAlertView alloc] initWithTitle:@"Password Reset Iniated"
                                message:@"Please check your email to reset password"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil, nil] show];
}
@end
