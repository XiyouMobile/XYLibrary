//
//  XYSearchCondition.h
//  XYLibrary
//
//  Created by 冯凡华 on 14-6-4.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSearchCondition : NSObject


+ (void)setValue:(NSUInteger)value withIndex:(NSUInteger)index;

+ (NSUInteger)getSearchConditionValueWithIndex:(NSUInteger)index;

@end
