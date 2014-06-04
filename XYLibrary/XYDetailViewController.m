//
//  XYDetailViewController.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-27.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYDetailViewController.h"

#import "XYConnection.h"
#import "XYFormEncodedPOSTRequest.h"

#import "XYPublic.h"

#import "XYStateTableViewCell.h"

@interface XYDetailViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *books;

@property (nonatomic, copy)NSString *bookName;
@property (nonatomic, copy)NSString *bookNum;

@end

@implementation XYDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navItem.title = @"图书详情";
    
    
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
    
    [self requestBookDetail];
    
    NSLog(@"%@", self.bookId);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)setupRightBarButtonItems
{
    UIBarButtonItem *collectBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(collectBook)];
    UIBarButtonItem *unCollectBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(unCollectBook)];
    
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareWithMessage)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -10;
    
    NSDictionary *bookDict = [NSDictionary dictionaryWithObjectsAndKeys:self.bookName, @"bookName", self.bookNum, @"bookNum", self.bookId, @"bookId", nil];
    if (iOS7_OR_ABOVE) {
        if ([XYPublic isCollect:bookDict]) {
            self.navItem.rightBarButtonItems = @[space, shareBarButtonItem,unCollectBarButtonItem];
        }else{
            self.navItem.rightBarButtonItems = @[space, shareBarButtonItem,collectBarButtonItem];
        }
    }else{
        if ([XYPublic isCollect:bookDict]) {
            self.navItem.rightBarButtonItems = @[shareBarButtonItem, unCollectBarButtonItem];
        }else{
            self.navItem.rightBarButtonItems = @[shareBarButtonItem, collectBarButtonItem];
        }
    }
    
}

- (void)shareWithMessage
{
    if ([MFMessageComposeViewController canSendText]) {
        //
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];

        picker.messageComposeDelegate = self;
        picker.body = [NSString stringWithFormat:@"书名:%@\n索书号:%@", self.bookName, self.bookNum];
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        NSLog(@"cant");
    }
}


- (void)requestBookDetail
{
    NSDictionary *formDict = [NSDictionary dictionaryWithObjectsAndKeys:self.bookId, @"id", nil];
    NSString *searchURLString = @"http://www.xiyoumobile.com/lib/detail.aspx";
    XYFormEncodedPOSTRequest *request = [XYFormEncodedPOSTRequest requestWithURL:[NSURL URLWithString:searchURLString] formParameters:formDict];
    
    __weak XYDetailViewController *weakSelf = self;
    
    XYConnection *connection = [XYConnection connectionWithRequest:request progressBlock:nil completionBlock:^(XYConnection *connection, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不稳定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSDictionary *temBooks = [NSJSONSerialization JSONObjectWithData:connection.downloadData options:NSJSONReadingMutableContainers error:NULL];
        if (temBooks) {
            [weakSelf reloadUIWithDict:temBooks];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
    [connection start];
}

- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    return label;
}

- (void)reloadUIWithDict:(NSDictionary *)dict
{
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *nameLabel = [self createLabel];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    NSString *bookName = [dict objectForKey:@"Title"];
    self.bookName = bookName;
    nameLabel.frame = CGRectMake(5, 5, 310, [XYPublic heightOfStr:bookName limitWidth:310]);
    nameLabel.text = bookName;
    [view addSubview:nameLabel];
    
    UILabel *numberLabel = [self createLabel];
    NSString *bookNum = [dict objectForKey:@"ID"];
    self.bookNum = bookNum;
    numberLabel.frame = CGRectMake(5, CGRectGetMaxY(nameLabel.frame), 310, 30);
    numberLabel.text = [NSString stringWithFormat:@"索书号：%@",bookNum];
    [view addSubview:numberLabel];
    
    view.frame = CGRectMake(0, 0, 320, CGRectGetMaxY(numberLabel.frame));
    self.tableView.tableHeaderView = view;
    
    self.books = [dict objectForKey:@"Info"];
    [self.tableView reloadData];
    
    [self setupRightBarButtonItems];
}


- (void)collectBook
{
    NSDictionary *bookDict = [NSDictionary dictionaryWithObjectsAndKeys:self.bookName, @"bookName", self.bookNum, @"bookNum", self.bookId, @"bookId", nil];
    [XYPublic collectBook:bookDict];
    [self setupRightBarButtonItems];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectChange" object:nil];
}

- (void)unCollectBook
{
    NSDictionary *bookDict = [NSDictionary dictionaryWithObjectsAndKeys:self.bookName, @"bookName", self.bookNum, @"bookNum", self.bookId, @"bookId", nil];
    [XYPublic unCollectBook:bookDict];
    [self setupRightBarButtonItems];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectChange" object:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            //
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            break;
        default:
            NSLog(@"not send");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - RefreshViewDelegate
- (void)refreshViewDidCallBack {
    [self requestBookDetail];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    XYStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XYStateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell configCell:[self.books objectAtIndex:indexPath.row]];
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"图书情况：";
//}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYStateTableViewCell *cell = (XYStateTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    lable.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.textColor = [UIColor blackColor];
    lable.text = @"图书情况：";
    lable.font = [UIFont systemFontOfSize:18];
    return lable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

@end
