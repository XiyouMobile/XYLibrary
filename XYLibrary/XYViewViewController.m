//
//  XYViewViewController.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYViewViewController.h"
#import "XYPublic.h"

@interface XYViewViewController ()

@end

@implementation XYViewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)initNavigationBar
{
    CGFloat offset = 0;
    if (iOS7_OR_ABOVE) {
        offset = 20;
    }
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44 + offset)];
    self.navItem = [[UINavigationItem alloc] init];
    [navigationBar pushNavigationItem:self.navItem animated:NO];
    [self.view addSubview:navigationBar];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 55, 23)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    if (iOS7_OR_ABOVE) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navItem.leftBarButtonItem = barbuttonItem;
}

- (void)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
