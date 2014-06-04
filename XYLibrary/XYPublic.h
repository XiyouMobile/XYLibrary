//
//  XYPublic.h
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYPublic : NSObject

//user
+ (NSString *)userName;
+ (NSString *)Id;
+ (NSString *)userPassword;
+ (void)saveUserName:(NSString *)name;
+ (void)saveUserID:(NSString *)Id;
+ (void)savePassword:(NSString *)passwd;

//str width
+ (CGFloat)widthOfStr:(NSString *)str;
+ (CGFloat)heightOfStr:(NSString *)str limitWidth:(CGFloat)width;

//color

+ (UIColor *)redOfTheme;
+ (UIColor *)blueOfTheme;

//Documnets path
+ (NSString *)documentsDirectory;


//Store Data
+ (NSMutableArray *)historyArr;
+ (void)storeHistoryArr:(NSArray *)histroyArr;

+ (NSArray *)borrowBooks;
+ (void)storeBorrowBooks:(NSArray *)borrowBooks;


//Collect Book
+ (NSString *)collectBookPath;
+ (BOOL)isCollect:(NSDictionary *)dict;
+ (void)collectBook:(NSDictionary *)dict;
+ (void)unCollectBook:(NSDictionary *)dict;

@end
