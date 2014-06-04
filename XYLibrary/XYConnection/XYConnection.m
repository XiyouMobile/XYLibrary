//
//  XYConnection.m
//  Library
//
//  Created by myBook on 13-6-1.
//  Copyright (c) 2013年 myBook. All rights reserved.
//

#import "XYConnection.h"

@interface XYConnection ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSURLRequest *urlRequest;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, assign) NSInteger contentLength;

@property (nonatomic, assign) float previousMilestone;

@property (nonatomic, copy) XYConnectionProgressBlock progressBlock;
@property (nonatomic, copy) XYConnectionCompletionBlock completionBlock;

@end

@implementation XYConnection
@synthesize url = _url;
@synthesize urlRequest = _urlRequest;
@synthesize connection = _connection;
@synthesize contentLength = _contentLength;
@synthesize downloadData = _downloadData;
@synthesize progressThreshold = _progressThreshold;
@synthesize previousMilestone = _previousMilestone;

@synthesize progressBlock = _progressBlock;
@synthesize completionBlock = _completionBlock;

+ (id)connectionWithRequest:(NSURLRequest *)request progressBlock:(XYConnectionProgressBlock)progress completionBlock:(XYConnectionCompletionBlock)completion{
    return [[self alloc] initWithRequest:request progressBlock:progress completionBlock:completion];
}

+ (id)connectionWithURL:(NSURL *)requestURL progressBlock:(XYConnectionProgressBlock)progress completionBlock:(XYConnectionCompletionBlock)completion{
    return [[self alloc] initWithURL:requestURL progressBlock:progress completionBlock:completion];
}

- (id)initWithURL:(NSURL *)requestURL progressBlock:(XYConnectionProgressBlock)progress completionBlock:(XYConnectionCompletionBlock)completion{
    return [self initWithRequest:[NSURLRequest requestWithURL:requestURL] progressBlock:progress completionBlock:completion];
}

- (id)initWithRequest:(NSURLRequest *)request progressBlock:(XYConnectionProgressBlock)progress completionBlock:(XYConnectionCompletionBlock)completion{
    
    self = [super init];
    if (self){
        _urlRequest = [request copy];
        _progressBlock = [progress copy];
        _completionBlock = [completion copy];
        _url = [[request URL] copy];
        _progressThreshold = 1.0;
    }
    return self;
}

#pragma mark -
#pragma mark

- (void)start{
    self.connection = [NSURLConnection connectionWithRequest:self.urlRequest delegate:self];
}

- (void)stop{
    [self.connection cancel];
    self.connection = nil;
    self.downloadData = nil;
    self.contentLength = 0;
    self.progressBlock = nil;
    self.completionBlock = nil;
}

- (float)percentComplete{
    if (self.contentLength <= 0) return 0;
    return (([self.downloadData length] * 1.0f) / self.contentLength) * 100;
}


#pragma mark
#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.downloadData appendData:data];
    float pctComplete = floorf([self percentComplete]);
    if ((pctComplete - self.previousMilestone) >= self.progressThreshold){
        self.previousMilestone = pctComplete;
        if  (self.progressBlock) self.progressBlock(self);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] == 200){
            NSDictionary *header = [httpResponse allHeaderFields];
            NSString *contentLen = [header valueForKey:@"Content-Lenght"];
            NSInteger length = self.contentLength = [contentLen integerValue];
            self.downloadData = [NSMutableData dataWithCapacity:length];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"Connection failed");
    if (self.completionBlock){
        self.completionBlock(self, error);
    }
    self.connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (self.completionBlock) {
        self.completionBlock(self, nil);
    }
    self.connection = nil;
}
@end
