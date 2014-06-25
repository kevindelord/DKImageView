//
//  DKAppDelegate.m
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DKAppDelegate.h"

@implementation DKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.centralViewController = (DKViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"centralVC"];
    self.sideViewController = (DKSideViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"sideVC"];
    
    [self initViewDeckController];
    return YES;
}

- (void)initViewDeckController {
    self.viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:self.centralViewController
                                                                      leftViewController:self.sideViewController
                                                                     rightViewController:nil
                                                                       topViewController:nil
                                                                    bottomViewController:nil];
    [self.viewDeckController setLeftSize:70];
    self.viewDeckController.panningMode = IIViewDeckPanningViewPanning;
    self.viewDeckController.panningView = self.centralViewController.view;
    self.viewDeckController.elastic = YES;
    self.viewDeckController.openSlideAnimationDuration = 0.3f;
    self.viewDeckController.bounceDurationFactor = 0.5;
    self.viewDeckController.closeSlideAnimationDuration = 0.3f;
    self.viewDeckController.centerhiddenInteractivity = IIViewDeckCenterHiddenUserInteractive;
    self.viewDeckController.delegate = nil;
    self.window.rootViewController = self.viewDeckController;
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

@end
