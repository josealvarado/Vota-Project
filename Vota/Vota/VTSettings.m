//
//  VTSettings.m
//  Vota
//
//  Created by Jose Alvarado on 8/30/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "VTSettings.h"

@implementation VTSettings

+ (VTSettings *)instance {
    static VTSettings *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [VTSettings new];
    });
    
    return _sharedClient;
}

- (NSString *)getBackGroundImage{
    
    NSString *deviceType = [UIDevice currentDevice].model;
//    NSLog(@"device type - %@", deviceType);
    
    if([deviceType isEqualToString:@"iPhone"]){
        return @"iphone4_background.png";
    } else if ([deviceType isEqualToString:@"iPad"] || [deviceType isEqualToString:@"iPad Simulator"]){
        return @"ipad_background.png";
    } else {
        return @"iphone4_background.png";
    }
}

- (NSString *)getRegisterURL{
    
    if ([_state isEqualToString:@"Nevada"] || [_state isEqualToString:@"NV"]) {
        return @"https://nvsos.gov/sosvoterservices/Registration/step1.aspx";
    } else if ([_state isEqualToString:@"Oregon"] || [_state isEqualToString:@"OR"]){
        return @"https://secure.sos.state.or.us/orestar/vr/register.do?lang=eng&source=SOS";
    } else if ([_state isEqualToString:@"California"] || [_state isEqualToString:@"CA"]){
        return @"http://registertovote.ca.gov";
    } else if ([_state isEqualToString:@"Arizona"] || [_state isEqualToString:@"AZ"]){
        return @"https://servicearizona.com/webapp/evoter/selectLanguage";
    } else if ([_state isEqualToString:@"Colorado"] || [_state isEqualToString:@"CO"]){
        return @"http://registertovote.ca.gov/";
    } else if ([_state isEqualToString:@"Illinois"] || [_state isEqualToString:@"IL"]){
        return @"https://ova.elections.il.gov/";
    } else if ([_state isEqualToString:@"Washington"] || [_state isEqualToString:@"WA"]){
        return @"https://www.sos.wa.gov/elections/myvote/";
    } else {
        return @"http://www.usa.gov/Citizen/Topics/Voting/Register.shtml";
    }
}

@end
