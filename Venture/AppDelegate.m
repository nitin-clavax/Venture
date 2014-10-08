//
//  AppDelegate.m
//  Venture
//
//  Created by Deepak Tomar on 25/08/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
//    view.backgroundColor=[UIColor colorWithRed:(18.0/255.0) green:(62.0/255.0) blue:(24.0/255.0) alpha:1] ;
//    [self.window.rootViewController.view addSubview:view];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UIStoryboard *storyBoard;
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
//        CGFloat scale = [UIScreen mainScreen].scale;
//        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 480){
            storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone4" bundle:nil];
            UIViewController *initViewController = [storyBoard instantiateInitialViewController];
            [self.window setRootViewController:initViewController];
        }
        else
        {
            storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *initViewController = [storyBoard instantiateInitialViewController];
            [self.window setRootViewController:initViewController];

        
        }
    }
    //Change the textfield tint color
//    UIColor *myColor = [UIColor colorWithRed:0.0/255.0 green:184.0/255.0 blue:99.0/255.0 alpha:1.0];
    [[UITextField appearance] setTintColor: [UIColor whiteColor]];//[UIColor colorWithRed:0.0/255.0 green:184.0/255.0 blue:99.0/255.0 alpha:1.0]];
    [[UITextView appearance] setTintColor: [UIColor whiteColor]];
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
    
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    return [FBSession.activeSession handleOpenURL:url];
}


@end
