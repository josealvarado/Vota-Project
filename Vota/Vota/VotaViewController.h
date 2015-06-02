//
//  VotaViewController.h
//  Vota
//
//  Created by Jose Alvarado on 6/1/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface VotaViewController : UIViewController<SettingsDelegate>

- (IBAction)votaButtonPressed:(id)sender;

@end
