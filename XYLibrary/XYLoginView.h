//
//  XYLoginView.h
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)(NSString *name);

@interface XYLoginView : UIView
{
    @private
    UITextField *_idTextField;
    UITextField *_passwdTextField;
    CompleteBlock _completeBlock;
    UIActivityIndicatorView *_activityIndicator;
}

- (void)showLoginViewInView:(UIView *)view withComplete:(CompleteBlock)block;

@end
