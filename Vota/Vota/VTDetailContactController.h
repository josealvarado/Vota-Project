//
//  VTDetailContactController.h
//  Vota
//
//  Created by Jose Alvarado on 9/9/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTDetailContactController : UITableViewController<UIAlertViewDelegate>

@property (copy, nonatomic) NSDictionary *selection;
@property (copy, nonatomic) NSDictionary *contact;
@property (nonatomic) NSString *questionNumber;
@property (nonatomic) NSString *pushText;


@end
