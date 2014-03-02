//
//  DKViewController.m
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DKAppDelegate.h"
#import "DKViewController.h"

@interface DKViewController ()

@end

@implementation DKViewController

- (IIViewDeckController *)viewDeckController {
    return ((DKAppDelegate *)[[UIApplication sharedApplication] delegate]).viewDeckController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = [UIImage imageNamed:@"picture.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
