//
//  XYZAppDelegate.h
//  Vota
//
//  Created by Jose Alvarado on 7/12/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTStartViewController.h"

@interface XYZAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) VTStartViewController *startController;

@end
