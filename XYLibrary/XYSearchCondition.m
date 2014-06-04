//
//  XYSearchCondition.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-6-4.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYSearchCondition.h"

@implementation XYSearchCondition

+ (NSArray *)searchConditionArr
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/searchCondition.plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
    if (nil == array) {
        NSMutableArray *tem = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 6; i++) {
            [tem addObject:@0];
        }
        array = [[NSArray alloc] initWithArray:tem];
    }
    return array;
}

+ (void)saveSearchCondition:(NSArray *)arr
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/searchCondition.plist"];
    [arr writeToFile:filePath atomically:YES];
}


+ (void)setValue:(NSUInteger)value withIndex:(NSUInteger)index
{
    NSMutableArray *mutableArr = [[XYSearchCondition searchConditionArr] mutableCopy];
    [mutableArr replaceObjectAtIndex:index withObject:@(value)];
    [XYSearchCondition saveSearchCondition:mutableArr];
}

+ (NSUInteger)getSearchConditionValueWithIndex:(NSUInteger)index
{
    return [[[XYSearchCondition searchConditionArr] objectAtIndex:index] intValue];
}

@end
