//
//  PhoneNumberViewController.h
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneNumberViewController : UIViewController{
    
    NSString *previousPhoneNumber;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
- (IBAction)backButtonPressed:(id)sender;

@end
