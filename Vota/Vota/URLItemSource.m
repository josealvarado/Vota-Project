//
//  URLItemSource.m
//  Vota
//
//  Created by Jose Alvarado on 9/1/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "URLItemSource.h"

@implementation URLItemSource

- (id)initWithURL:(NSURL *)url subject:(NSString *)subject;
{
    self = [super init];
    if (self != nil) {
        self.url = url;
        self.subject = subject;
    }
    return self;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return self.url;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    // If the user wants to share the URL through twitter, email, etc, we'll
    // just share the URL we were passed at construction time. This should be a
    // http[s] URL so that normal apps can open it.
    if (![activityType isEqualToString:UIActivityTypeAirDrop]) {
        return self.url;
    }
    
    // This is the clever bit. We'll write the URL as a string to a file on disk,
    // and name the file after the subject we want to share with, then return the
    // path to that file on disk. The receiving device will see the filename in
    // the Airdrop accept dialog, rather than the raw URL.
    
    // Use a dedicated folder so cleanup is easy. This is lazier than it should be
    // to keep the demo small.
    NSURL *cache = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                          inDomain:NSUserDomainMask
                                                 appropriateForURL:nil
                                                            create:YES
                                                             error:nil];
    NSURL *scratchFolder = [cache URLByAppendingPathComponent:@"airdrop_scratch"];
    [[NSFileManager defaultManager] removeItemAtURL:scratchFolder error:nil];
    [[NSFileManager defaultManager] createDirectoryAtURL:scratchFolder withIntermediateDirectories:YES attributes:@{} error:nil];
    
    // You can't put '/' in a filename. Replace it with a unicode character
    // that looks quite a lot like a /.
    NSString *safeFilename = [self.subject stringByReplacingOccurrencesOfString:@"/" withString:@"\u2215"];
    
    // The file on disk has to end with a custom file extension that we have defined.
    // Check "Document Types" and "Exported UTIs" in the project settings to see
    // where this file extension is defined.
    NSURL *tempPath = [scratchFolder URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.PSAirdrop", safeFilename]];
    
    // write the URL into the file, and return the file for the share.
    NSData *data = [self.url.absoluteString dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToURL:tempPath atomically:YES];
    return tempPath;
}


- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType
{
    // This will be the subject of the email, if the user chooses to send an email.
    return self.subject;
}


- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size
{
    if ([activityType isEqualToString:UIActivityTypeAirDrop]) {
        // this is the preview image in the "Accept airdrop" dialog. We're using the
        // app icon here (there is no app icon in this bundle, so it will still be
        // blank) but you can use anything, even customize to the content.
        return [UIImage imageNamed:@"airdrop_logo.png"];
    }
    return nil;
}

@end
