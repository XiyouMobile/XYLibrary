//
//  XYCustomTableViewCell.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-25.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYCustomTableViewCell.h"
#import "XYPublic.h"

@interface XYCustomTableViewCell ()
@property (nonatomic, readwrite, strong) UILabel *nameLabel;
@property (nonatomic, readwrite, strong) UILabel *detail1Label;
@property (nonatomic, readwrite, strong) UILabel *detail2Label;
@property (nonatomic, readwrite, strong) UILabel *detail3Label;

@property (nonatomic, strong) UIButton *reBookButton;

@end

@implementation XYCustomTableViewCell

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
        
        _reBookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reBookButton addTarget:self action:@selector(reBookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_reBookButton];

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


- (void)reBookButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reBookButtonClicked:)]) {
        [self.delegate reBookButtonClicked:self];
    }
}

#pragma mark - Public Methods
- (void)configCell:(NSDictionary *)dict
{
    NSString *bookName = [dict objectForKey:@"name"];
    self.nameLabel.frame = CGRectMake(20, 5, 280, [XYPublic heightOfStr:bookName limitWidth:280]);
    self.nameLabel.text = bookName;
    
    NSString *bookBarcode = [dict objectForKey:@"barcode"];
    self.detail1Label.frame = CGRectMake(20, CGRectGetMaxY(self.nameLabel.frame), 280, 30);
    self.detail1Label.text = [NSString stringWithFormat:@"图书条码：%@",bookBarcode];
    
    NSString *bookState = [dict objectForKey:@"state"];
    self.detail2Label.frame = CGRectMake(20, CGRectGetMaxY(self.detail1Label.frame), 280, 30);
    self.detail2Label.text = [NSString stringWithFormat:@"流通状态：%@", bookState];
    
    NSString *bookDate = [dict objectForKey:@"date"];
    self.detail3Label.frame = CGRectMake(20, CGRectGetMaxY(self.detail2Label.frame), 280, 30);
    self.detail3Label.text = [NSString stringWithFormat:@"应还日期：%@", bookDate];
    
    BOOL isNew = [[dict objectForKey:@"isRenew"] boolValue];
    CGFloat height;
    if (isNew) {
        self.reBookButton.frame = CGRectMake(20, CGRectGetMaxY(self.detail3Label.frame), 280, 30);
        [self.reBookButton setImage:[UIImage imageNamed:@"cell_rebook"] forState:UIControlStateNormal];
        [self.reBookButton setImage:[UIImage imageNamed:@"cell_rebook"] forState:UIControlStateHighlighted];
        height = CGRectGetMaxY(self.reBookButton.frame);
    }else{
        self.reBookButton.frame = CGRectZero;
        height = CGRectGetMaxY(self.detail3Label.frame);
    }
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
}
@end
