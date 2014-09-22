//
//  VTStartViewController.h
//  Vota
//
//  Created by Jose Alvarado on 8/30/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTStartViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
- (IBAction)buttonSignUpAction:(id)sender;
- (IBAction)buttonSignInAction:(id)sender;
- (IBAction)buttonResetPassword:(id)sender;


@end
