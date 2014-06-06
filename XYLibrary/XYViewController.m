//
//  XYViewController.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-21.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYViewController.h"
#import "XYBorrowViewController.h"
#import "XYSettingViewController.h"
#import "XYSearchViewController.h"
#import "XYCollectViewController.h"

#import "XYPublic.h"
#import "XYLoginView.h"

@interface XYViewController ()

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation XYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backImageView];
    if (iPhone5) {
        backImageView.image = [UIImage imageNamed:@"background-568"];
    }else{
        backImageView.image = [UIImage imageNamed:@"background"];
    }
    
    
    CGFloat offset = 40;
    if (iPhone5) {
        offset = 60.0f;
    }
    if (!iOS7_OR_ABOVE) {
        offset -= 10;
    }
    
    //头像
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, offset, 94, 94)];
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.borderWidth = 3.0f;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    UIImage *headImage = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/head.png"]];
    if (nil == headImage) {
        headImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"holdplace" ofType:@"png"]];
    }
    self.headImageView.image = headImage;
    [self.view addSubview:self.headImageView];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerHeadImage)];
    [self.headImageView addGestureRecognizer:tap];
    
    //名字
    NSString *nameStr = [XYPublic userName];
    CGFloat width = [XYPublic widthOfStr:nameStr];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(139, offset + 60, width, 20)];
    nameLabel.tag = 101;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = nameStr;
    [self.view addSubview:nameLabel];
    //编辑按钮
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.tag = 102;
    [editButton setFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), offset + 55, 34, 27)];
    [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateHighlighted];
    [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    offset = 184;
    if (iPhone5) {
        offset = 244;
    }
    if (!iOS7_OR_ABOVE) {
        offset -= 20;
    }
    [self addButtonWithFrame:CGRectMake(20, offset, 122, 122) image:@"borrow" action:@selector(borrowButtonClicked:)];
    [self addButtonWithFrame:CGRectMake(178, offset, 122, 122) image:@"collect" action:@selector(collectButtonClicked:)];
    
    offset += 152;
    [self addButtonWithFrame:CGRectMake(20, offset, 122, 122) image:@"search" action:@selector(searchButtonClicked:)];
    [self addButtonWithFrame:CGRectMake(178, offset, 122, 122) image:@"setting" action:@selector(settingButtonClicked:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)addButtonWithFrame:(CGRect)frame image:(NSString *)imageName action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)editButtonClicked:(UIButton *)button
{
    XYLoginView *loginView = [[XYLoginView alloc] init];
    
    __weak XYViewController *weakSelf = self;
    [loginView showLoginViewInView:self.view withComplete:^(NSString *name) {
        //
        UILabel *label = (UILabel *)[weakSelf.view viewWithTag:101];
        CGFloat width = [XYPublic widthOfStr:name];
        label.text = name;
        CGRect labelFrame = label.frame;
        labelFrame.size.width = width;
        label.frame = labelFrame;
        UIButton *editButton = (UIButton *)[weakSelf.view viewWithTag:102];
        CGRect editButtonFrame = editButton.frame;
        editButtonFrame.origin.x = CGRectGetMaxX(label.frame);
        editButton.frame = editButtonFrame;
        NSLog(@"%@", name);
        if (!button) {
            [self borrowButtonClicked:nil];
        }
    }];
}

- (void)borrowButtonClicked:(UIButton *)sender
{
    if (![[XYPublic Id] length]) {
        [self editButtonClicked:nil];
        return;
    }
    XYBorrowViewController *borrowViewController = [[XYBorrowViewController alloc] init];
    [self.navigationController pushViewController:borrowViewController animated:YES];
}

- (void)collectButtonClicked:(UIButton *)sender
{
    XYCollectViewController *collectViewController = [[XYCollectViewController alloc] init];
    [self.navigationController pushViewController:collectViewController animated:YES];
}

- (void)searchButtonClicked:(UIButton *)sender
{
    XYSearchViewController *searchViewController = [[XYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
    }

- (void)settingButtonClicked:(UIButton *)sender
{
    XYSettingViewController *settingViewController = [[XYSettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)pickerHeadImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从图库中选择", @"拍照选取", nil];
    [actionSheet showInView:self.view];
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if (0 == buttonIndex) {
        //
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    }else if (1 == buttonIndex){
        //
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headImageView.image = image;
    [self saveImage:image withFileName:@"head" ofType:@"png" inDirectory:[NSHomeDirectory() stringByAppendingString:@"/Documents"]];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
