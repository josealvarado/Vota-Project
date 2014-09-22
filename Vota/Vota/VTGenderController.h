//
//  VTGenderController.h
//  Vota
//
//  Created by Jose Alvarado on 8/31/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTGenderController : UITableViewController{
    
    int selectedGender;
    NSDictionary *dict;
}

- (IBAction)barButtonItemSave:(id)sender;

@end
