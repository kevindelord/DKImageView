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

@interface DKSideViewController () {
    UIColor *_defaultCroppingFrameColor;
    UIColor *_defaultOverZoomedColor;
}

@end

@implementation DKSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _defaultCroppingFrameColor = self.imageView.croppingFrameColor;
    _defaultOverZoomedColor = self.imageView.overZoomedColor;
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

- (IBAction)croppingFrameGreenColor {
    self.imageView.croppingFrameColor = [UIColor greenColor];
}

- (IBAction)croppingFrameDefaultColor {
    self.imageView.croppingFrameColor = _defaultCroppingFrameColor;
}

- (IBAction)overZoomedBlueColor {
    self.imageView.overZoomedColor = [UIColor blueColor];
}

- (IBAction)overZoomedDefaultColor {
    self.imageView.overZoomedColor = _defaultOverZoomedColor;
}

@end
