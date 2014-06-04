//
//  XYStateTableViewCell.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-27.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYStateTableViewCell.h"

@implementation XYStateTableViewCell

- (void)configCell:(NSDictionary *)dict
{
    NSString *bookDepart = [dict objectForKey:@"Department"];
    self.detail1Label.font = [UIFont systemFontOfSize:18];
    self.detail1Label.frame = CGRectMake(0, 5, ScreenWidth, 30);
    self.detail1Label.text = [NSString stringWithFormat:@"书库：%@",bookDepart];
    
    NSString *bookBarcode = [dict objectForKey:@"Barcode"];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.detail1Label.frame), ScreenWidth, 30);
    self.nameLabel.text = [NSString stringWithFormat:@"图书条码：%@", bookBarcode];
    
    NSString *bookState = [dict objectForKey:@"State"];
    self.detail2Label.font = [UIFont systemFontOfSize:18];
    self.detail2Label.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), ScreenWidth, 30);
    self.detail2Label.text = [NSString stringWithFormat:@"流通状态：%@", bookState];
    
    NSString *bookDate = [dict objectForKey:@"Date"];
    CGFloat height = 0;
    if ([bookDate length]) {
        self.detail3Label.font = [UIFont systemFontOfSize:18];
        self.detail3Label.frame = CGRectMake(0, CGRectGetMaxY(self.detail2Label.frame), ScreenWidth, 30);
        self.detail3Label.text = [NSString stringWithFormat:@"应还日期：%@", bookDate];
        height = CGRectGetMaxY(self.detail3Label.frame);
    }else{
        self.detail3Label.frame = CGRectZero;
        height = CGRectGetMaxY(self.detail2Label.frame);
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end
