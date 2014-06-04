//
//  XYBorrowViewController.h
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYViewViewController.h"
#import "RefreshView.h"
#import "XYCustomTableViewCell.h"
@interface XYBorrowViewController : XYViewViewController<UITableViewDataSource, UITableViewDelegate, RefreshViewDelegate, XYCustomTableViewCellDelegate>

@end
