//
//  XYCustomTableViewCell.h
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-25.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYCustomTableViewCellDelegate;

@interface XYCustomTableViewCell : UITableViewCell

@property (nonatomic, readonly, strong) UILabel *nameLabel;
@property (nonatomic, readonly, strong) UILabel *detail1Label;
@property (nonatomic, readonly, strong) UILabel *detail2Label;
@property (nonatomic, readonly, strong) UILabel *detail3Label;

@property (nonatomic, weak) id<XYCustomTableViewCellDelegate> delegate;

- (void)configCell:(NSDictionary *)dict;

@end


@protocol XYCustomTableViewCellDelegate <NSObject>

- (void)reBookButtonClicked:(XYCustomTableViewCell *)cell;

@end