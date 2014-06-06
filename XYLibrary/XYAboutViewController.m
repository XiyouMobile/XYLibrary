//
//  XYAboutViewController.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-6-5.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYAboutViewController.h"

@interface XYAboutViewController ()

@end

@implementation XYAboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navItem.title = @"关于开发者";
    
    CGFloat offset = 44;
    if (iOS7_OR_ABOVE) {
        offset = 64;
    }
    
    CGRect imageViewFrame = CGRectMake(0, offset, ScreenWidth, CGRectGetHeight(self.view.frame)-offset);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.contentMode = UIViewContentModeTop;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:@"about"];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
