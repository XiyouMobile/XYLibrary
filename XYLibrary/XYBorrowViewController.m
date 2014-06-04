//
//  XYBorrowViewController.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYBorrowViewController.h"
#import "XYPublic.h"

#import "XYConnection/XYConnection.h"
#import "FormatForm/XYFormEncodedPOSTRequest.h"


@interface XYBorrowViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RefreshView *refreshView;

@property (nonatomic, strong) NSArray *books;

@end

@implementation XYBorrowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navItem.title = @"我的借阅";
    
    self.books = [XYPublic borrowBooks];
    
    CGFloat offset = 44;
    if (iOS7_OR_ABOVE) {
        offset = 64;
    }
    CGRect tableViewFrame = CGRectMake(0, offset, ScreenWidth, CGRectGetHeight(self.view.frame)-offset);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.refreshView = [[RefreshView alloc] initWithScrollView:self.tableView delegate:self];
    
    if (![self.books count]) {
        [self refresh];
    }
}

#pragma mark - Private Methods

- (void)refresh{
    [self.refreshView startLoading];
    
    NSDictionary *formDict = [NSDictionary dictionaryWithObjectsAndKeys:[XYPublic Id], @"userNumber", [XYPublic userPassword], @"password", nil];
    NSString *searchURLString = @"http://xiyoumobile.com/xiyoulib/login";
    XYFormEncodedPOSTRequest *request = [XYFormEncodedPOSTRequest requestWithURL:[NSURL URLWithString:searchURLString] formParameters:formDict];
    
    __weak XYBorrowViewController *weakSelf = self;
    
    XYConnection *connection = [XYConnection connectionWithRequest:request progressBlock:nil completionBlock:^(XYConnection *connection, NSError *error) {
        [weakSelf.refreshView stopLoading];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不稳定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSMutableArray *temBooks = [NSJSONSerialization JSONObjectWithData:connection.downloadData options:NSJSONReadingMutableContainers error:NULL];
        if ([temBooks count]) {
            //
            [temBooks removeObject:[temBooks lastObject]];
            [XYPublic storeBorrowBooks:temBooks];
            weakSelf.books = temBooks;
            [weakSelf.tableView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有借书" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    [connection start];

}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    XYCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XYCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell configCell:[self.books objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYCustomTableViewCell *cell = (XYCustomTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UIScrollView
// 刚拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.refreshView scrollViewWillBeginDragging:scrollView];
}
// 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshView scrollViewDidScroll:scrollView];
}
// 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - RefreshViewDelegate
- (void)refreshViewDidCallBack {
    [self refresh];
}

#pragma mark - XYCustomTableViewCellDelegate
- (void)reBookButtonClicked:(XYCustomTableViewCell *)cell
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = [self.books objectAtIndex:path.row];
    NSString *urlStr = [NSString stringWithFormat:@"http://xiyoumobile.com/xiyoulib/renew?barcode=%@&department_id=%@&library_id=%@", [dict objectForKey:@"barcode"], [dict objectForKey:@"department_id"], [dict objectForKey:@"library_id"]];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:NULL];
    if (result && [result isEqualToString:@"true"]) {
        [self refresh];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"续借失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
@end
