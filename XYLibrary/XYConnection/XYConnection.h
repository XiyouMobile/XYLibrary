//
//  XYConnection.h
//  Library
//
//  Created by myBook on 13-6-1.
//  Copyright (c) 2013年 myBook. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XYConnection;
typedef void (^XYConnectionProgressBlock)(XYConnection *connection);
typedef void (^XYConnectionCompletionBlock)(XYConnection *connection, NSError *error);

@interface XYConnection : NSURLConnection<NSURLConnectionDataDelegate>

@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSURLRequest *urlRequest;
@property (nonatomic, assign, readonly) NSInteger contentLength;
@property (nonatomic, retain, readonly) NSMutableData *downloadData;
@property (nonatomic, assign, readonly) float percentComplete;
@property (nonatomic, assign) NSUInteger progressThreshold;

+ (id)connectionWithURL:(NSURL *)requestURL progressBlock:(XYConnectionProgressBlock)progress completionBlock:(XYConnectionCompletionBlock)completion;
+ (id)connectionWithRequest:(NSURLRequest *)request progressBlock:(XYConnectionProgressBlock)progress completionBlock:(XYConnectionCompletionBlock)completion;

- (id)initWithURL:(NSURL *)requestURL progressBlock:(XYConnectionProgressBlock)progress completionBlock:(XYConnectionCompletionBlock)completion;

- (id)initWithRequest:(NSURLRequest *)request progressBlock:(XYConnectionProgressBlock)progress completionBlock:(XYConnectionCompletionBlock)completion;

- (void)start;
- (void)stop;

@end
