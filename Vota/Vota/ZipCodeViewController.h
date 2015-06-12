//
//  ZipCodeViewController.h
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZipCodeViewController : UIViewController{
    
    NSString *previousZipCode;
}

@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;

- (IBAction)backButtonPressed:(id)sender;

@end
