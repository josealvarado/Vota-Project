//
//  PartyViewController.h
//  Vota
//
//  Created by Jose Alvarado on 6/6/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartyViewController : UIViewController{
    
    NSString *selectedParty;
    NSString *previousParty;
}

@property (weak, nonatomic) IBOutlet UIButton *democratButton;
@property (weak, nonatomic) IBOutlet UIButton *republicanButton;
@property (weak, nonatomic) IBOutlet UIButton *independentButton;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)partyButtonPressed:(UIButton *)sender;
@end
