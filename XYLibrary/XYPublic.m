//
//  XYPublic.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYPublic.h"

@implementation XYPublic


#pragma mark - User Actions
+ (NSString *)userName
{
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    if (!nameStr) {
        nameStr = @"请登录";
    }
    return nameStr;
}

+ (NSString *)Id
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
}
+ (NSString *)userPassword
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"UserPasswd"];
}
+ (void)saveUserName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)saveUserID:(NSString *)Id
{
    [[NSUserDefaults standardUserDefaults] setObject:Id forKey:@"UserId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)savePassword:(NSString *)passwd
{
    [[NSUserDefaults standardUserDefaults] setObject:passwd forKey:@"UserPasswd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Width

+ (CGFloat)widthOfStr:(NSString *)str
{
    CGRect finishRect;
    CGSize size = CGSizeMake(320, 20);
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    if (iOS7_OR_ABOVE) {
        NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        finishRect = [str boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:NULL];
    }else
        finishRect.size = [str sizeWithFont:font constrainedToSize:size];
    
    return finishRect.size.width;
}

+ (CGFloat)heightOfStr:(NSString *)str limitWidth:(CGFloat)width
{
    CGRect finishRect;
    CGSize size = CGSizeMake(width, 100);
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    if (iOS7_OR_ABOVE) {
        NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        finishRect = [str boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:NULL];
    }else
        finishRect.size = [str sizeWithFont:font constrainedToSize:size];
    
    return finishRect.size.height;
}


#pragma mark - Color Methods
+ (UIColor *)blueOfTheme
{
    return [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1.0f];
}

+ (UIColor *)redOfTheme
{
    return [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1.0f];
}


#pragma mark - Path
+ (NSString *)documentsDirectory
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

#pragma mark - Store Data
+ (NSMutableArray *)historyArr
{
    
    NSMutableArray *historyArray = [[NSMutableArray alloc] initWithContentsOfFile:[[XYPublic documentsDirectory] stringByAppendingPathComponent:@"searchHistory.plist"]];
    if (!historyArray) {
        historyArray = [[NSMutableArray alloc] init];
    }
    return historyArray;
}
+ (void)storeHistoryArr:(NSArray *)histroyArr
{
    [histroyArr writeToFile:[[XYPublic documentsDirectory] stringByAppendingPathComponent:@"searchHistory.plist"] atomically:YES];
}

+ (void)clearHistory
{
    NSString *historyFilePath = [[XYPublic documentsDirectory] stringByAppendingPathComponent:@"searchHistory.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:historyFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:historyFilePath error:NULL];
    }
}

+ (NSArray *)borrowBooks
{
    NSArray *books = [[NSArray alloc] initWithContentsOfFile:[[XYPublic documentsDirectory] stringByAppendingPathComponent:@"borrowBooks.plist"]];
    if (!books) {
        books = [[NSArray alloc] init];
    }
    return books;
}
+ (void)storeBorrowBooks:(NSArray *)borrowBooks
{
    [borrowBooks writeToFile:[[XYPublic documentsDirectory] stringByAppendingPathComponent:@"borrowBooks.plist"] atomically:YES];
}


#pragma mark - Collect Book
+ (NSString *)collectBookPath
{
    return [[XYPublic documentsDirectory] stringByAppendingPathComponent:@"collectBooks.plist"];
}

+ (BOOL)isCollect:(NSDictionary *)dict
{
    NSMutableArray *books = [[NSMutableArray alloc] initWithContentsOfFile:[XYPublic collectBookPath]];
    if (nil == books) {
        books = [[NSMutableArray alloc] init];
    }
    return [books containsObject:dict];
}

+ (void)collectBook:(NSDictionary *)dict
{
    NSMutableArray *books = [[NSMutableArray alloc] initWithContentsOfFile:[XYPublic collectBookPath]];
    if (nil == books) {
        books = [[NSMutableArray alloc] init];
    }
    if (![books containsObject:dict]) {
        [books addObject:dict];
    }
    [books writeToFile:[self collectBookPath] atomically:YES];
}
+ (void)unCollectBook:(NSDictionary *)dict
{
    NSMutableArray *books = [[NSMutableArray alloc] initWithContentsOfFile:[XYPublic collectBookPath]];
    if (nil == books) {
        books = [[NSMutableArray alloc] init];
    }
    if ([books containsObject:dict]) {
        [books removeObject:dict];
    }
    [books writeToFile:[self collectBookPath] atomically:YES];
}
@end
