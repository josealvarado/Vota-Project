//
//  VTCandidateDetailController.h
//  Vota
//
//  Created by Jose Alvarado on 8/31/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface VTCandidateDetailController : UIViewController

@property (copy, nonatomic) PFObject *candidate;
@property (copy, nonatomic) NSDictionary *selection;

@property (weak, nonatomic) IBOutlet UIWebView *webViewCandidateWebsite;

@end
