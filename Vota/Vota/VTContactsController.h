//
//  VTContactsController.h
//  Vota
//
//  Created by Jose Alvarado on 9/4/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTContactsController : UITableViewController

//@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorLoading;

@property (strong, nonatomic) UILabel *labelStatus;

@property int contactSize;

@end
