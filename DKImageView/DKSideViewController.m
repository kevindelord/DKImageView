//
//  DKSideViewController.m
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DKSideViewController.h"
#import "DKImageView.h"
#import "DKAppDelegate.h"

@interface DKSideViewController ()

@end

@implementation DKSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DKImageView *)imageView {
    return ((DKAppDelegate *)[[UIApplication sharedApplication] delegate]).centralViewController.imageView;
}

- (IBAction)changeRatioTo16_9 {
    [self.imageView setRatioForType:DKRatioType16_9];
}

- (IBAction)changeRatioTo4_3 {
    [self.imageView setRatioForType:DKRatioType4_3];
}


@end
