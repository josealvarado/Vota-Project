//
//  GenderViewController.h
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenderViewController : UIViewController{
    
    NSString *selectedGender;
    NSString *previousGender;
}


@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@property (weak, nonatomic) IBOutlet UIButton *maleButton;

@property (weak, nonatomic) IBOutlet UIButton *transgenderButton;

- (IBAction)genderButtonPressed:(UIButton *)sender;

- (IBAction)backButtonPressed:(id)sender;
@end
