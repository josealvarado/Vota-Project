//
//  VTSettings.h
//  Vota
//
//  Created by Jose Alvarado on 8/30/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTSettings : NSObject

@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *party;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSMutableArray *candidates;
@property (strong, nonatomic) NSMutableArray *ballots;
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) NSArray *contactsWithApp;
@property (strong, nonatomic) NSMutableDictionary *phoneNumberToName;
@property (nonatomic) BOOL profileUpdated;

@property (nonatomic) BOOL logOut;

+ (VTSettings *)instance;
- (NSString *)getBackGroundImage;
- (NSString *)getRegisterURL;

@end
