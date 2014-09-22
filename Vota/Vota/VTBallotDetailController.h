//
//  VTBallotDetailController.h
//  Vota
//
//  Created by Jose Alvarado on 9/3/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface VTBallotDetailController : UIViewController

@property (copy, nonatomic) PFObject *candidate;
@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) IBOutlet UIWebView *webViewBallotWebsite;

@end
