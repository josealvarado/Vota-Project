//
//  VTPartyController.h
//  Vota
//
//  Created by Jose Alvarado on 8/31/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPartyController : UITableViewController{
    
    int selectedParty;
    NSDictionary *dict;
}
- (IBAction)barButtonItemSave:(id)sender;

@end
