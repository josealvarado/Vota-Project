//
//  VotaViewController.h
//  Vota
//
//  Created by Jose Alvarado on 6/1/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface VotaViewController : UIViewController<SettingsDelegate>{
    
    int numberOfContacts;
    NSMutableArray *allPhoneNumbers;
}
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

//- (IBAction)votaButtonPressed:(id)sender;

@end
