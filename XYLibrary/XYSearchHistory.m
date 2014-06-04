//
//  XYSearchHistory.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-23.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYSearchHistory.h"
#import "XYPublic.h"

@implementation XYSearchHistory

- (id)init
{
    self = [super init];
    if (self) {
        //
        _historyArray = [XYPublic historyArr];
        _resultArray = [_historyArray copy];
    }
    return self;
}

#pragma mark - Private
- (void)startSearch:(NSString *)searchText
{
    if (![_historyArray containsObject:searchText]) {
        [_historyArray addObject:searchText];
        [XYPublic storeHistoryArr:_historyArray];
    }
    [self.delegate searchButtonClicked:searchText];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    NSArray *array = [NSArray arrayWithArray:_historyArray];
    _resultArray = [array filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"history"];
    cell.textLabel.text = [_resultArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;

    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];

    [self startSearch:[_resultArray objectAtIndex:indexPath.row]];

}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self startSearch:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
}

#pragma mark - UISearchDisplayDelegate

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    _resultArray = [_historyArray copy];
}
@end
