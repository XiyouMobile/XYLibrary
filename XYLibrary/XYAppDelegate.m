//
//  XYAppDelegate.m
//  XYLibrary
//
//  Created by 冯凡华 on 14-4-21.
//  Copyright (c) 2014年 冯凡华. All rights reserved.
//

#import "XYAppDelegate.h"
#import "XYViewController.h"

@implementation XYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self initStyle];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    XYViewController *viewController = [[XYViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:viewController];
    rootNav.navigationBarHidden = YES;
    self.window.rootViewController = rootNav;
    
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private Methods

- (void)initStyle
{
    if (iOS7_OR_ABOVE) {
        //
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav2"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack"  size:20.0], NSFontAttributeName, nil];
        [[UINavigationBar appearance] setTitleTextAttributes: attributeDict];
    }else{
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav1"] forBarMetrics:UIBarMetricsDefault];
    }
    

}

@end
