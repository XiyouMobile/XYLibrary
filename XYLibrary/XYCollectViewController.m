//
//  XYCollectViewController.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYCollectViewController.h"
#import "XYDetailViewController.h"

#import "XYPublic.h"

@interface XYCollectViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *books;

@end

@implementation XYCollectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navItem.title = @"收藏";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewReload) name:@"CollectChange" object:nil];
    
    CGFloat offset = 44;
    if (iOS7_OR_ABOVE) {
        offset = 64;
    }
    CGRect tableViewFrame = CGRectMake(0, offset, ScreenWidth, CGRectGetHeight(self.view.frame)-offset);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    [self tableViewReload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Method
- (void)tableViewReload
{
    NSArray *temBooks = [[NSArray alloc] initWithContentsOfFile:[XYPublic collectBookPath]];
    if (nil == temBooks) {
        temBooks = [[NSArray alloc] init];
    }
    self.books = temBooks;
    [self.tableView reloadData];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    }
    NSDictionary *dict = [self.books objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [dict objectForKey:@"bookName"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"索书号：%@",[dict objectForKey:@"bookNum"]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.books objectAtIndex:indexPath.row];
    return [XYPublic heightOfStr:[dict objectForKey:@"bookName"] limitWidth:300]+30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *dict = [self.books objectAtIndex:indexPath.row];
    XYDetailViewController *detailViewController = [[XYDetailViewController alloc] init];
    detailViewController.bookId = [dict objectForKey:@"bookId"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
@end
