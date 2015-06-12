//
//  LoginViewController.h
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"


@interface LoginViewController : UIViewController


@property (strong, nonatomic) KeychainItemWrapper *keychain;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)forgotPasswordButtonPressed:(id)sender;
- (IBAction)signUpButtonPressed:(id)sender;

- (IBAction)signInButtonPressed:(id)sender;
@end
