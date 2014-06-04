//
//  XYLoginView.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-22.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYLoginView.h"
#import "XYPublic.h"

#import "XYConnection.h"
#import "XYFormEncodedPOSTRequest.h"

@implementation XYLoginView

- (id)init
{
    self = [super init];
    if (self) {
        //
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, ScreenWidth - 40, 130)];
        backView.layer.cornerRadius = 5.0f;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth - 40, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [XYPublic blueOfTheme];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.text = @"登陆";
        [backView addSubview:titleLabel];
        
        _idTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 35, ScreenWidth - 80, 25)];
        _idTextField.borderStyle = UITextBorderStyleRoundedRect;
        _idTextField.textAlignment = NSTextAlignmentCenter;
        _idTextField.font = [UIFont systemFontOfSize:18];
        _idTextField.placeholder = @"读者条码";
        [backView addSubview:_idTextField];
        
        _passwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 65, ScreenWidth - 80, 25)];
        _passwdTextField.borderStyle = UITextBorderStyleRoundedRect;
        _passwdTextField.secureTextEntry = YES;
        _passwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        _passwdTextField.textAlignment = NSTextAlignmentCenter;
        _passwdTextField.font = [UIFont systemFontOfSize:18];
        _passwdTextField.placeholder = @"读者口令";
        [backView addSubview:_passwdTextField];
        
        UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [dismissButton setBackgroundColor:[XYPublic blueOfTheme]];
        [dismissButton setFrame:CGRectMake(20, 95, 100, 30)];
        [dismissButton setTitle:@"取消" forState:UIControlStateNormal];
        [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        dismissButton.layer.cornerRadius = 2.0f;
        dismissButton.layer.masksToBounds = YES;
        [backView addSubview:dismissButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setBackgroundColor:[XYPublic blueOfTheme]];
        [confirmButton setFrame:CGRectMake(ScreenWidth-160, 95, 100, 30)];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.layer.cornerRadius = 2.0f;
        confirmButton.layer.masksToBounds = YES;
        [backView addSubview:confirmButton];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setFrame:backView.bounds];
        [_activityIndicator setHidesWhenStopped:YES];
        [backView addSubview:_activityIndicator];
        
    }
    return self;
}

- (void)showLoginViewInView:(UIView *)view withComplete:(CompleteBlock)block
{
    _completeBlock = block;
    [view addSubview:self];
    
    __weak XYLoginView *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            [_idTextField becomeFirstResponder];
        }
    }];
}


- (void)dismiss
{
    [_idTextField resignFirstResponder];
    [_passwdTextField resignFirstResponder];
    
    __weak XYLoginView *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf removeFromSuperview];
        }
    }];
}

- (void)confirmButtonClicked:(UIButton *)sender
{
    if (![_idTextField.text length] || ![_passwdTextField.text length]) {
        return;
    }
    
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    NSDictionary *formDict = [NSDictionary dictionaryWithObjectsAndKeys:_idTextField.text, @"id", _passwdTextField.text, @"password", nil];
    NSString *searchURLString = @"http://www.xiyoumobile.com/libusername/";
    XYFormEncodedPOSTRequest *request = [XYFormEncodedPOSTRequest requestWithURL:[NSURL URLWithString:searchURLString] formParameters:formDict];
    __weak XYLoginView *weakSelf = self;
    XYConnection *connection = [XYConnection connectionWithRequest:request progressBlock:NULL completionBlock:^(XYConnection *connection, NSError *error) {
        [_activityIndicator stopAnimating];
        [weakSelf dismiss];
        if (error) {
            _idTextField.text = @"";
            _passwdTextField.text = @"";
            return;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:connection.downloadData options:NSJSONReadingMutableContainers error:NULL];
        [XYPublic saveUserID:_idTextField.text];
        [XYPublic savePassword:_passwdTextField.text];
        [XYPublic saveUserName:[dict objectForKey:@"Name"]];
        _completeBlock([dict objectForKey:@"Name"]);
    }];
    [connection start];
}

@end
