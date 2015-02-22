//
//  VTPhoneNumberController.h
//  Vota
//
//  Created by Jose Alvarado on 2/22/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPhoneNumberController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;

- (IBAction)buttonSaveAction:(id)sender;


@end
