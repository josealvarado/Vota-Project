//
//  VTPhoneNumberController.h
//  Vota
//
//  Created by Jose Alvarado on 9/3/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPhoneNumberController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
- (IBAction)buttonSaveAction:(id)sender;

@end
