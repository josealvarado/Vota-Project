//
//  NotificationsTableViewController.h
//  Vota
//
//  Created by Jose Alvarado on 6/15/15.
//  Copyright (c) 2015 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NotificationsTableViewController : UITableViewController{
    
    NSArray *data;
    PFObject *selectedObject;
    BOOL displayAlert;
}

@end
