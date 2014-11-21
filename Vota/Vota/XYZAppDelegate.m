//
//  XYZAppDelegate.m
//  Vota
//
//  Created by Jose Alvarado on 7/12/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "XYZAppDelegate.h"
#import <Parse/Parse.h>

@implementation XYZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Parse SDK
    [Parse setApplicationId:@"XdTzS20SHEjOxlgpbNMxVcXvqPyx1QJjwNdP7T0D"
                  clientKey:@"FPbRloG5HItY7Fs6XYSDNsSTsGdd1tosbNkp0vg1"];
    
    // Track statistics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    [PFTwitterUtils initializeWithConsumerKey:@"zgX21inKVOCUlY3pTt6eynx7B"
                               consumerSecret:@"7Ye2osmxWpRB5gKjVw5GV65ur2AnLZO5CTvZmPPDcttDllosZ3"];

    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    

//    [self insertNewCandidate];
    
    
//    [self testPushNotification];
    
    
    // INSERT NEW CANDIDATES
//    [self insertPollCandidates];
    
    return YES;
}

- (void)insertNewCandidate{
    PFObject *gameScore = [PFObject objectWithClassName:@"Candidates"];
    gameScore[@"personelWebsite"] = @" https://leticiavandeputte.com";
    gameScore[@"donateWebsite"] = @"https://leticiavandeputte.com/donate/";
    gameScore[@"active"] = @NO;
    [gameScore saveInBackground];
}

- (void)testPushNotification{
    NSString *toObjectID = @"v8nRBzIOSE";
//
//    // Build a query to match users with a birthday today
//    PFQuery *innerQuery = [PFUser query];
//    
//    // Use hasPrefix: to only match against the month/date
//    [innerQuery whereKey:@"objectId" equalTo:toObjectID];
//    
//    // Build the actual push notification target query
//    PFQuery *outerQuery = [PFInstallation query];
//    
//    // only return Installations that belong to a User that
//    // matches the innerQuery
//    //            [outerQuery whereKey:@"user" matchesQuery:innerQuery];
//    [outerQuery whereKey:@"user" equalTo:innerQuery];
//    
//    // Send the notification.
//    PFPush *push = [[PFPush alloc] init];
//    [push setQuery:outerQuery];
//    [push setMessage:@"Hey Jose!"];
//    [push sendPushInBackground];
    
    ///////////////////////////////////////
    
//    // Create our Installation query
//    PFQuery *pushQuery = [PFInstallation query];
//    [pushQuery whereKey:@"user" equalTo:@"5ekaTMbCJU"];
//    
//    // Send push notification to query
//    [PFPush sendPushMessageToQueryInBackground:pushQuery
//                                   withMessage:@"Hello World!"];

    ///////////////////////      WORKS  /////////////////////////
    
//    // Create our Installation query
//    PFQuery *pushQuery = [PFInstallation query];
//    [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
//    
//    // Send push notification to query
//    [PFPush sendPushMessageToQueryInBackground:pushQuery
//                                   withMessage:@"Hello World!"];
//    
    ////////////////////////////////////////////////////////////
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:toObjectID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            // Found UserStats
            
            NSLog(@"found you");
            
            // Create our Installation query
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"user" equalTo:userStats];
            
            
            // Send push notification to query
            [PFPush sendPushMessageToQueryInBackground:pushQuery
                                           withMessage:@"Hey Rey! Does this work!"];
        } else {
            // Did not find any UserStats for the current user
            NSLog(@"Error2: %@", error);
        }
    }];
    
    [[[UIAlertView alloc] initWithTitle:@"Success"
                                message:@"Message Sent"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil, nil] show];
}

- (void) insertPollCandidates{
    UIImage *image = [UIImage imageNamed:@"ruben_kihuen.png"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    PFFile *imageFile = [PFFile fileWithName:@"ruben_kihuen.png" data:imageData];
    
    //HUD creation here (see example for code)
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"Candidates"];
            [userPhoto setObject:imageFile forKey:@"image"];
            [userPhoto setObject:@"Ruben Kihuen" forKey:@"name"];
            [userPhoto setObject:@"https://act.myngp.com/Forms/2829113078081455872" forKey:@"donateWebsite"];
            [userPhoto setObject:@"http://www.rubenkihuen.com" forKey:@"personalWebsite"];
            [userPhoto setObject:@"Democrat" forKey:@"party"];
            [userPhoto setObject:@"This is a short description" forKey:@"description"];
            [userPhoto setObject:@NO forKey:@"active"];
            [userPhoto setObject:@3 forKey:@"order"];
            
            //            // Set the access control list to current user for security purposes
            //            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            //
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //                    [self refresh:nil];
                    NSLog(@"Successfully Uploaded");
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            //            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        //        HUD.progress = (float)percentDone/100;
    }];
}

// orignial working command
//- (void) insertPollCandidates{
//    UIImage *image = [UIImage imageNamed:@"Lucy_Flores.jpeg"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
//    PFFile *imageFile = [PFFile fileWithName:@"Lucy_Flores.jpeg" data:imageData];
//    
//    //HUD creation here (see example for code)
//    
//    // Save PFFile
//    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // Hide old HUD, show completed HUD (see example for code)
//            
//            // Create a PFObject around a PFFile and associate it with the current user
//            PFObject *userPhoto = [PFObject objectWithClassName:@"Candidates"];
//            [userPhoto setObject:imageFile forKey:@"image"];
//            [userPhoto setObject:@"Lucy Flores" forKey:@"name"];
//            [userPhoto setObject:@"https://act.myngp.com/Forms/-5717882676900265984" forKey:@"donateWebsite"];
//            [userPhoto setObject:@"http://www.lucyflores.com/" forKey:@"personalWebsite"];
//            [userPhoto setObject:@"Democrat" forKey:@"party"];
//            [userPhoto setObject:@"This is a short description" forKey:@"description"];
//            [userPhoto setObject:@NO forKey:@"active"];
//            [userPhoto setObject:@1 forKey:@"order"];
//            
//            //            // Set the access control list to current user for security purposes
//            //            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
//            //
//            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (!error) {
//                    //                    [self refresh:nil];
//                    NSLog(@"Successfully Uploaded");
//                }
//                else{
//                    // Log details of the failure
//                    NSLog(@"Error: %@ %@", error, [error userInfo]);
//                }
//            }];
//        }
//        else{
//            //            [HUD hide:YES];
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    } progressBlock:^(int percentDone) {
//        // Update your progress spinner here. percentDone will be between 0 and 100.
//        //        HUD.progress = (float)percentDone/100;
//    }];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
