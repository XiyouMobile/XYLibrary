//
//  XYSettingViewController.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYSettingViewController.h"

#import "XYSearchCondition.h"

#import "XYPublic.h"

#import "XYAboutViewController.h"

@interface XYSettingViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchArr;

@property (nonatomic, strong) NSArray *conditionArr;

@property (nonatomic, assign) NSUInteger insertFlag;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UITableViewCell *insertTableViewCell;

@end

@implementation XYSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navItem.title = @"设置";
    
    self.searchArr = [[NSMutableArray alloc] initWithObjects:@"检索关键词类型", @"匹配方式", @"资料类型", @"分馆名称", @"排序依据", @"排序类型", nil];
    
    self.conditionArr = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search" ofType:@"plist"]];
    
    self.insertTableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"insertTableViewCell"];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 162)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.tag = 100;
    [self.insertTableViewCell.contentView addSubview:pickerView];
    
    CGFloat offset = 44;
    if (iOS7_OR_ABOVE) {
        offset = 64;
    }
    CGRect tableViewFrame = CGRectMake(0, offset, ScreenWidth, CGRectGetHeight(self.view.frame)-offset);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;
    }else if (1 == section){
        return self.searchArr.count + self.insertFlag;
    }else if (2 == section){
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.indexPath) {
        NSIndexPath *temIndex = [NSIndexPath indexPathForRow:self.indexPath.row + 1 inSection:self.indexPath.section];
        if ([indexPath isEqual:temIndex]) {
            UIPickerView *picker = (UIPickerView *)[self.insertTableViewCell.contentView viewWithTag:100];
            [picker reloadAllComponents];
            [picker selectRow:[XYSearchCondition getSearchConditionValueWithIndex:self.indexPath.row] inComponent:0 animated:YES];
            return self.insertTableViewCell;
        }
    }
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            cell.textLabel.text = @"清除搜索历史缓存";
            cell.detailTextLabel.text = @"";
        }
    }else if (1 == indexPath.section){
        if (self.indexPath && indexPath.row > self.indexPath.row) {
            cell.textLabel.text = [self.searchArr objectAtIndex:indexPath.row - 1];
            cell.detailTextLabel.text = [[[self.conditionArr objectAtIndex:indexPath.row - 1] firstObject] objectAtIndex:[XYSearchCondition getSearchConditionValueWithIndex:indexPath.row-1]];
        }else{
            cell.textLabel.text = [self.searchArr objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[[self.conditionArr objectAtIndex:indexPath.row] firstObject] objectAtIndex:[XYSearchCondition getSearchConditionValueWithIndex:indexPath.row]];
        }
    }else if (2 == indexPath.section){
        NSArray *temArr = @[@"关于开发者", @"去AppStore评分"];
        cell.textLabel.text = [temArr objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

#pragma mark - TableView Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return @"搜索条件设置";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSIndexPath *selectedIndexPath = self.indexPath;
    
    if (self.indexPath) {

        
        UIPickerView *picker = (UIPickerView *)[self.insertTableViewCell.contentView viewWithTag:100];
        NSUInteger selectedRow = [picker selectedRowInComponent:0];
        [XYSearchCondition setValue:selectedRow withIndex:self.indexPath.row];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
        cell.detailTextLabel.text = [[[self.conditionArr objectAtIndex:self.indexPath.row] firstObject] objectAtIndex:[XYSearchCondition getSearchConditionValueWithIndex:self.indexPath.row]];
        
        self.insertFlag = 0;
        self.indexPath = nil;
        
        NSIndexPath *temIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row+1 inSection:selectedIndexPath.section];
        [self.tableView deleteRowsAtIndexPaths:@[temIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (0 != indexPath.section && 2 != indexPath.section && ![selectedIndexPath isEqual:indexPath]){
        self.insertFlag = 1;
        if (selectedIndexPath && selectedIndexPath.row < indexPath.row) {
            self.indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        }else{
            self.indexPath = indexPath;
        }
        
        NSIndexPath *temIndexPath = [NSIndexPath indexPathForRow:self.indexPath.row + 1 inSection:self.indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[temIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView scrollToRowAtIndexPath:temIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
    //处理其他section的点击事件
    
    if (0 == indexPath.section && 0 == indexPath.row) {
        [XYPublic clearHistory];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"搜索记录已清除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (2 == indexPath.section) {
        if (0 == indexPath.row) {
            XYAboutViewController *aboutViewController = [[XYAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.indexPath) {
        NSIndexPath *temIndex = [NSIndexPath indexPathForRow:self.indexPath.row + 1 inSection:self.indexPath.section];
        if ([indexPath isEqual:temIndex]) {
            return 162;
        }
    }
    return 44;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.indexPath) {
        NSArray *arr = [self.conditionArr objectAtIndex:self.indexPath.row];
        NSArray *typeArr = [arr firstObject];
        return typeArr.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.indexPath) {
        NSArray *arr = [self.conditionArr objectAtIndex:self.indexPath.row];
        NSArray *typeArr = [arr firstObject];
        return [typeArr objectAtIndex:row];
    }
    return nil;
}
@end
