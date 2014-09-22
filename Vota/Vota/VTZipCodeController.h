//
//  VTZipCodeController.h
//  Vota
//
//  Created by Jose Alvarado on 9/4/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTZipCodeController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldZipCode;
- (IBAction)buttonSaveAction:(id)sender;

@end
