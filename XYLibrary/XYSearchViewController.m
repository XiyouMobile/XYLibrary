//
//  XYSearchViewController.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYSearchViewController.h"

#import "XYSimpleTableViewCell.h"

#import "XYConnection.h"
#import "XYFormEncodedPOSTRequest.h"

#import "XYDetailViewController.h"

#import "XYSearchCondition.h"

@interface XYSearchViewController ()

@property (nonatomic, strong) UISearchDisplayController *searchDC;
@property (nonatomic, strong) XYSearchHistory *searchHistory;

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, copy) NSString *keWord;
@property (nonatomic, strong) NSMutableArray *books;

@property (nonatomic, strong) NSDictionary *errorDict;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation XYSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navItem.title = @"搜索";
    
    self.books = [[NSMutableArray alloc] init];
    self.errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                  @"服务器错误,西邮图书馆响应超时",@"Server_Error",
                  @"参数错误,缺少关键词",@"Param_Error",
                  @"没有查询到相关的信息记录",@"null",
                  @"没有更多了",@"Out_Of_Range",
                  @"处理错误,服务器在处理返回的 HTML 字符串时发生错误",@"Process_Error",
                  @"搜索的关键词过短,最少需要 2 个字(中、英文都占 1 位)",@"Keyword_Too_Short",
                  nil];
    
    self.searchHistory = [[XYSearchHistory alloc] init];
    self.searchHistory.delegate = self;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, (iOS7_OR_ABOVE?64:44), ScreenWidth, 44)];
    searchBar.delegate = self.searchHistory;
    [self.view addSubview:searchBar];
    
    
    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDC.delegate = self.searchHistory;
    self.searchDC.searchResultsDataSource = self.searchHistory;
    self.searchDC.searchResultsDelegate = self.searchHistory;
    
    
    CGFloat offset = 88;
    if (iOS7_OR_ABOVE) {
        offset = 108;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offset, ScreenWidth, CGRectGetHeight(self.view.frame)-offset) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - Private

- (void)searchStart
{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicatorView setFrame:self.view.bounds];
    [self.view addSubview:activityIndicatorView];
    
    NSArray *keyArr = @[@"type", @"match", @"record", @"lib", @"orderby", @"ordersc"];
    NSArray *searchArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search" ofType:@"plist"]];
    
    NSMutableDictionary *temDict = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < 6; i++) {
        [temDict setObject:[[[searchArr objectAtIndex:i] lastObject] objectAtIndex:[XYSearchCondition getSearchConditionValueWithIndex:i]] forKey:[keyArr objectAtIndex:i]];
    }
    NSLog(@"%@", temDict);
    
    NSMutableDictionary *formDict = [[NSMutableDictionary alloc] initWithDictionary:temDict];
    [formDict setObject:self.keWord forKey:@"word"];
    [formDict setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"page"];
    
    NSLog(@"%@", formDict);
    
    //[NSDictionary dictionaryWithObjectsAndKeys:self.keWord, @"word", [NSString stringWithFormat:@"%d",self.currentPage], @"page", nil];
    NSString *searchURLString = @"http://222.24.63.109/lib/default.aspx";
    XYFormEncodedPOSTRequest *request = [XYFormEncodedPOSTRequest requestWithURL:[NSURL URLWithString:searchURLString] formParameters:formDict];
    
    __weak XYSearchViewController *weakSelf = self;
    
    XYConnection *connection = [XYConnection connectionWithRequest:request progressBlock:nil completionBlock:^(XYConnection *connection, NSError *error) {
        weakSelf.isLoading = NO;
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不稳定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            weakSelf.currentPage--;
            return;
        }
        NSString *string = [[NSString alloc] initWithData:connection.downloadData encoding:NSUTF8StringEncoding];
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"提示"];
        [alert addButtonWithTitle:@"确定"];
        for (NSString *key  in weakSelf.errorDict) {
            if ([key isEqualToString:string]) {
                [alert setMessage:[weakSelf.errorDict objectForKey:key]];
                [alert show];
                weakSelf.currentPage--;
                return;
            }
        }
    
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:connection.downloadData options:NSJSONReadingMutableLeaves error:NULL];
        //
        NSArray *requestBooks = [resultDict objectForKey:@"BookData"];
        if (requestBooks.count > 0) {
            [weakSelf.books addObjectsFromArray:requestBooks];
            [weakSelf.tableView reloadData];
            if ([weakSelf.tableView visibleCells].count && weakSelf.books.count <= 20) {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有更多了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            weakSelf.currentPage--;

            [alert show];
        }
    }];
    [connection start];
    [activityIndicatorView startAnimating];
}


#pragma mark - XYSearchHistoryDelegate
- (void)searchButtonClicked:(NSString *)searchText
{
    
    self.currentPage = 1;
    [self.books removeAllObjects];
    self.keWord = searchText;
    [self searchStart];

    [self.searchDC setActive:NO animated:YES];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    XYSimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XYSimpleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell configCell:[self.books objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYDetailViewController *detailViewController = [[XYDetailViewController alloc] init];
    detailViewController.bookId = [[self.books objectAtIndex:indexPath.row] objectForKey:@"ID"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYSimpleTableViewCell *cell = (XYSimpleTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == (self.books.count - 1) && !self.isLoading) {
        self.currentPage ++;
        self.isLoading = YES;
        [self searchStart];
        
    }
}
@end
