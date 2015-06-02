//
//  SettingsViewController.h
//  Vota
//
//  Created by Jose Alvarado on 6/1/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsDelegate

- (void) close;

@end

@interface SettingsViewController : UIViewController

@property (nonatomic, assign) id delegate;


- (IBAction)logOutButtonPressed:(id)sender;

- (IBAction)backButtonPressed:(id)sender;
@end
