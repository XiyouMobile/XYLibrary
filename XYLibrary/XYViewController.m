//
//  XYViewController.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-21.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYViewController.h"
#import "XYBorrowViewController.h"
#import "XYSettingViewController.h"
#import "XYSearchViewController.h"
#import "XYCollectViewController.h"

#import "XYPublic.h"
#import "XYLoginView.h"

@interface XYViewController ()

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation XYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backImageView];
    if (iPhone5) {
        backImageView.image = [UIImage imageNamed:@"background-568"];
    }else{
        backImageView.image = [UIImage imageNamed:@"background"];
    }
    
    
    CGFloat offset = 40;
    if (iPhone5) {
        offset = 60.0f;
    }
    if (!iOS7_OR_ABOVE) {
        offset -= 10;
    }
    
    //头像
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, offset, 94, 94)];
    self.headImageView.layer.borderWidth = 3.0f;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageView.image = [UIImage imageNamed:@"holdplace"];
    [self.view addSubview:self.headImageView];
    
    //名字
    NSString *nameStr = [XYPublic userName];
    CGFloat width = [XYPublic widthOfStr:nameStr];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(139, offset + 60, width, 20)];
    nameLabel.tag = 101;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = nameStr;
    [self.view addSubview:nameLabel];
    //编辑按钮
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.tag = 102;
    [editButton setFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), offset + 55, 34, 27)];
    [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateHighlighted];
    [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    offset = 184;
    if (iPhone5) {
        offset = 244;
    }
    if (!iOS7_OR_ABOVE) {
        offset -= 20;
    }
    [self addButtonWithFrame:CGRectMake(20, offset, 122, 122) image:@"borrow" action:@selector(borrowButtonClicked:)];
    [self addButtonWithFrame:CGRectMake(178, offset, 122, 122) image:@"collect" action:@selector(collectButtonClicked:)];
    
    offset += 152;
    [self addButtonWithFrame:CGRectMake(20, offset, 122, 122) image:@"search" action:@selector(searchButtonClicked:)];
    [self addButtonWithFrame:CGRectMake(178, offset, 122, 122) image:@"setting" action:@selector(settingButtonClicked:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)addButtonWithFrame:(CGRect)frame image:(NSString *)imageName action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)editButtonClicked:(UIButton *)button
{
    XYLoginView *loginView = [[XYLoginView alloc] init];
    
    __weak XYViewController *weakSelf = self;
    [loginView showLoginViewInView:self.view withComplete:^(NSString *name) {
        //
        UILabel *label = (UILabel *)[weakSelf.view viewWithTag:101];
        CGFloat width = [XYPublic widthOfStr:name];
        label.text = name;
        CGRect labelFrame = label.frame;
        labelFrame.size.width = width;
        label.frame = labelFrame;
        UIButton *editButton = (UIButton *)[weakSelf.view viewWithTag:102];
        CGRect editButtonFrame = editButton.frame;
        editButtonFrame.origin.x = CGRectGetMaxX(label.frame);
        editButton.frame = editButtonFrame;
        NSLog(@"%@", name);
        if (!button) {
            [self borrowButtonClicked:nil];
        }
    }];
}

- (void)borrowButtonClicked:(UIButton *)sender
{
    if (![[XYPublic Id] length]) {
        [self editButtonClicked:nil];
        return;
    }
    XYBorrowViewController *borrowViewController = [[XYBorrowViewController alloc] init];
    [self.navigationController pushViewController:borrowViewController animated:YES];
}

- (void)collectButtonClicked:(UIButton *)sender
{
    XYCollectViewController *collectViewController = [[XYCollectViewController alloc] init];
    [self.navigationController pushViewController:collectViewController animated:YES];
}

- (void)searchButtonClicked:(UIButton *)sender
{
    XYSearchViewController *searchViewController = [[XYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
    }

- (void)settingButtonClicked:(UIButton *)sender
{
    XYSettingViewController *settingViewController = [[XYSettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

@end
