//
//  XYFormEncodedPOSTRequest.m
//  Library
//
//  Created by myBook on 13-6-1.
//  Copyright (c) 2013年 myBook. All rights reserved.
//

#import "XYFormEncodedPOSTRequest.h"
#import "NSString+XYURLAdditions.h"

@implementation XYFormEncodedPOSTRequest

+ (id)requestWithURL:(NSURL *)url formParameters:(NSDictionary *)params{
    return [[self alloc] initWithURL:url formParameters:params];
}

- (id)initWithURL:(NSURL *)url formParameters:(NSDictionary *)params{
    if (self = [super initWithURL:url]) {
        [self setHTTPMethod:@"POST"];
        [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [self setFormParameters:params];
    }
    return self;
}

- (void)setFormParameters:(NSDictionary *)params{
    NSStringEncoding enc = NSUTF8StringEncoding;
    NSMutableString *postBody = [NSMutableString string];
    for (NSString *paramKey in params) {
        if ([paramKey length] > 0) {
            NSString *value = [params objectForKey:paramKey];
            NSString *encodeValue = [value URLEncodedFormStringUsingEncoding:enc];
            NSUInteger length = [postBody length];
            NSString *paramFormat = (length == 0? @"%@=%@" : @"&%@=%@");
            [postBody appendFormat:paramFormat, paramKey,encodeValue];
        }
    }
    
    NSLog(@"postBody is now %@", postBody);
    [self setHTTPBody:[postBody dataUsingEncoding:enc]];
}

@end
