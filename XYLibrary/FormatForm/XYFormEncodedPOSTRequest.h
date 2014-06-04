//
//  XYFormEncodedPOSTRequest.h
//  Library
//
//  Created by myBook on 13-6-1.
//  Copyright (c) 2013年 myBook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYFormEncodedPOSTRequest : NSMutableURLRequest

+ (id)requestWithURL:(NSURL *)url formParameters:(NSDictionary *)params;
- (id)initWithURL:(NSURL *)url formParameters:(NSDictionary *)params;

- (void)setFormParameters:(NSDictionary *)params;

@end
