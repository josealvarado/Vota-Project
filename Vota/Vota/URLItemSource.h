//
//  URLItemSource.h
//  Vota
//
//  Created by Jose Alvarado on 9/1/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

@interface URLItemSource : NSObject<UIActivityItemSource>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *subject;

- (id)initWithURL:(NSURL *)url subject:(NSString *)subject;

@end
