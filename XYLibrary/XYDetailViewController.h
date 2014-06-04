//
//  XYDetailViewController.h
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-27.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYViewViewController.h"
#import <MessageUI/MessageUI.h>

@interface XYDetailViewController : XYViewViewController<MFMessageComposeViewControllerDelegate, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSString *bookId;
@end
