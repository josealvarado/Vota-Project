//
//  VTStartViewController.h
//  Vota
//
//  Created by Jose Alvarado on 8/30/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@interface VTStartViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (strong, nonatomic) KeychainItemWrapper *keychain;

- (IBAction)buttonSignUpAction:(id)sender;
- (IBAction)buttonSignInAction:(id)sender;
- (IBAction)buttonResetPassword:(id)sender;
- (IBAction)buttonSkipLogin:(id)sender;


@end
