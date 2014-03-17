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
    
    // init the image view
    self.imageView.image = [UIImage imageNamed:@"picture.png"];
    self.imageView.delegate = self;

    // save original colors
    _defaultCroppingFrameColor = self.imageView.croppingFrameColor;
    _defaultOverZoomedColor = self.imageView.overZoomedColor;
    
    // init default buttons
    self.bouncesNO.selected = YES;
    self.bouncesZoomNO.selected = YES;
    self.overZoomColorDefault.selected = YES;
    self.croppingColorDefault.selected = YES;
    self.ratioNone.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DKImageView *)imageView {
    return ((DKAppDelegate *)[[UIApplication sharedApplication] delegate]).centralViewController.imageView;
}

#pragma mark - DKImageView delegate methods

- (BOOL)imageView:(DKImageView *)imageView overZoomedAtScale:(CGFloat)scale {
    return (imageView.zoomScale > 3);
}

- (void)imageViewDidEndZooming:(DKImageView *)imageView atScale:(CGFloat)scale {
    // do whatever you want now
}

#pragma mark - Action methods

- (IBAction)changeRatioToNone {
    [self.imageView setRatioForType:DKRatioTypeNone];
    
    self.ratioNone.selected = YES;
    self.ratio4_3.selected = NO;
    self.ratio16_9.selected = NO;
}

- (IBAction)changeRatioTo16_9 {
    [self.imageView setRatioForType:DKRatioType16_9];

    self.ratioNone.selected = NO;
    self.ratio4_3.selected = NO;
    self.ratio16_9.selected = YES;
}

- (IBAction)changeRatioTo4_3 {
    [self.imageView setRatioForType:DKRatioType4_3];

    self.ratioNone.selected = NO;
    self.ratio4_3.selected = YES;
    self.ratio16_9.selected = NO;
}

- (IBAction)croppingFrameGreenColor {
    self.imageView.croppingFrameColor = [UIColor greenColor];

    self.croppingColorGreen.selected = YES;
    self.croppingColorDefault.selected = NO;
}

- (IBAction)croppingFrameDefaultColor {
    self.imageView.croppingFrameColor = _defaultCroppingFrameColor;

    self.croppingColorGreen.selected = NO;
    self.croppingColorDefault.selected = YES;
}

- (IBAction)overZoomedBlueColor {
    self.imageView.overZoomedColor = [UIColor blueColor];

    self.overZoomColorDefault.selected = NO;
    self.overZoomColorBlue.selected = YES;
}

- (IBAction)overZoomedDefaultColor {
    self.imageView.overZoomedColor = _defaultOverZoomedColor;

    self.overZoomColorDefault.selected = YES;
    self.overZoomColorBlue.selected = NO;
}

- (IBAction)bouncesYESPressed {
    self.imageView.bounces = YES;

    self.bouncesYES.selected = YES;
    self.bouncesNO.selected = NO;
}

- (IBAction)bouncesNOPressed {
    self.imageView.bounces = NO;
    
    self.bouncesYES.selected = NO;
    self.bouncesNO.selected = YES;
}

- (IBAction)bouncesZoomYESPressed {
    self.imageView.bouncesZoom = YES;

    self.bouncesZoomYES.selected = YES;
    self.bouncesZoomNO.selected = NO;
}

- (IBAction)bouncesZoomNOPressed {
    self.imageView.bouncesZoom = NO;

    self.bouncesZoomYES.selected = NO;
    self.bouncesZoomNO.selected = YES;
}

@end
