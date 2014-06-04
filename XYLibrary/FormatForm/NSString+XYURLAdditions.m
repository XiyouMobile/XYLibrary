//
//  NSString+XYURLAdditions.m
//  Library
//
//  Created by myBook on 13-6-1.
//  Copyright (c) 2013年 myBook. All rights reserved.
//

#import "NSString+XYURLAdditions.h"

@implementation NSString (XYURLAdditions)

- (NSString *)URLEncodedFormStringUsingEncoding:(NSStringEncoding)enc{
    NSString *escapedStringWithSpaces = [self percentEscapedStringWithEncoding:enc additionalCharacters:@"&=+" ignoredCharacters:nil];
    return escapedStringWithSpaces;
}

- (NSString *)percentEscapedStringWithEncoding:(NSStringEncoding)enc additionalCharacters:(NSString *)add ignoredCharacters:(NSString *)ignore{
    
    CFStringEncoding convertedEncoding = CFStringConvertNSStringEncodingToEncoding(enc);
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)ignore, (CFStringRef)add, convertedEncoding));
}

@end
