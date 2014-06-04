//
//  XYSearchHistory.h
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-23.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYSearchHistoryDelegate <NSObject>

- (void)searchButtonClicked:(NSString *)searchText;

@end

@interface XYSearchHistory : NSObject<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    @private
    NSMutableArray *_historyArray;
    NSArray *_resultArray;
}
@property (nonatomic, weak) id<XYSearchHistoryDelegate> delegate;
@end


