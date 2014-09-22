//
//  VTNotificationController.h
//  Vota
//
//  Created by Jose Alvarado on 9/10/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTNotificationController : UITableViewController

@property (strong, nonatomic) NSMutableArray *notifications;
@property (nonatomic) NSString *question;
@property (nonatomic) NSInteger *row;

@end
