//
//  XYSimpleTableViewCell.h
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-26.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSimpleTableViewCell : UITableViewCell
@property (nonatomic, readonly, strong) UILabel *nameLabel;
@property (nonatomic, readonly, strong) UILabel *detail1Label;
@property (nonatomic, readonly, strong) UILabel *detail2Label;
@property (nonatomic, readonly, strong) UILabel *detail3Label;

- (void)configCell:(NSDictionary *)dict;
@end
