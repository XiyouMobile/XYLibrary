//
//  NSString+XYURLAdditions.h
//  Library
//
//  Created by myBook on 13-6-1.
//  Copyright (c) 2013年 myBook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XYURLAdditions)

- (NSString *)URLEncodedFormStringUsingEncoding:(NSStringEncoding)enc;
- (NSString *)percentEscapedStringWithEncoding:(NSStringEncoding)enc additionalCharacters:(NSString *)add ignoredCharacters:(NSString *)ignore;
@end
