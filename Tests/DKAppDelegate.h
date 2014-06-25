//
//  DKAppDelegate.h
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "DKViewController.h"
#import "DKSideViewController.h"

@interface DKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IIViewDeckController *viewDeckController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DKViewController *centralViewController;
@property (strong, nonatomic) DKSideViewController *sideViewController;

@end
