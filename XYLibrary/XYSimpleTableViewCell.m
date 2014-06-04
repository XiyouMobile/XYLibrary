//
//  XYSimpleTableViewCell.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-26.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYSimpleTableViewCell.h"

#import "XYPublic.h"

@interface XYSimpleTableViewCell ()
@property (nonatomic, readwrite, strong) UILabel *nameLabel;
@property (nonatomic, readwrite, strong) UILabel *detail1Label;
@property (nonatomic, readwrite, strong) UILabel *detail2Label;
@property (nonatomic, readwrite, strong) UILabel *detail3Label;
@end

@implementation XYSimpleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _nameLabel = [self createLabel];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        _nameLabel.numberOfLines = 0;
        [self.contentView addSubview:_nameLabel];
        
        _detail1Label = [self createLabel];
        [self.contentView addSubview:_detail1Label];
        
        _detail2Label = [self createLabel];
        [self.contentView addSubview:_detail2Label];
        
        _detail3Label = [self createLabel];
        [self.contentView addSubview:_detail3Label];
    }
    return self;
}


#pragma mark - Private Methods
- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    return label;
}


#pragma mark - Public Methods
- (void)configCell:(NSDictionary *)dict
{
    NSString *bookName = [dict objectForKey:@"Name"];
    self.nameLabel.frame = CGRectMake(20, 5, 280, [XYPublic heightOfStr:bookName limitWidth:280]);
    self.nameLabel.text = bookName;
    
    NSString *bookBarcode = [dict objectForKey:@"Author"];
    self.detail1Label.frame = CGRectMake(20, CGRectGetMaxY(self.nameLabel.frame), 280, 30);
    self.detail1Label.text = [NSString stringWithFormat:@"责任人：%@",bookBarcode];
    
    NSString *bookState = [dict objectForKey:@"Pub"];
    self.detail2Label.frame = CGRectMake(20, CGRectGetMaxY(self.detail1Label.frame), 280, 30);
    self.detail2Label.text = [NSString stringWithFormat:@"出版社：%@", bookState];
    
    NSString *bookDate = [dict objectForKey:@"Year"];
    self.detail3Label.frame = CGRectMake(20, CGRectGetMaxY(self.detail2Label.frame), 280, 30);
    self.detail3Label.text = [NSString stringWithFormat:@"出版年：%@", bookDate];
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.detail3Label.frame);
    self.frame = frame;
}

@end
