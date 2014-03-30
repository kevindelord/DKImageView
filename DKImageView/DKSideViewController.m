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
    self.imageView.zoomEnabled = YES;
    
    // save original colors
    _defaultCroppingFrameColor = self.imageView.croppingFrameColor;
    _defaultOverZoomedColor = self.imageView.overZoomedColor;
    
    // init default buttons
    self.bouncesNO.selected = YES;
    self.bouncesZoomNO.selected = YES;
    self.overZoomColorDefault.selected = YES;
    self.croppingColorDefault.selected = YES;
    self.zoomEnabledYES.selected = YES;

    for (UIButton *btn in self.ratioScrollView.subviews) {
        btn.selected = (btn.tag == DKRatioTypeNone);
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.ratioScrollView.contentSize = CGSizeMake(self.ratioScrollView.subviews.count * 46 + 20, 0);
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

- (IBAction)changeRatio:(id)sender {
    // Tag 0: DKRatioTypeNone
    // Tag 1: DKRatioType16_9
    // Tag 2: DKRatioType4_3
    // Tag 3: DKRatioType3_4
    // Tag 4: DKRatioType3_2
    // Tag 5: DKRatioType3_1
    // Tag 6: DKRatioType2_3
    // Tag 7: DKRatioType1_1
    // Tag 8: DKRatioType5_1

    [self.imageView setRatioForType:((UIButton *)sender).tag];

    for (UIButton *btn in self.ratioScrollView.subviews) {
        btn.selected = NO;
    }
    ((UIButton *)sender).selected = YES;
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

#pragma mark - Enabling bounce, zoom, frame.

- (IBAction)bouncesPressed:(id)sender {
    BOOL active = !!((UIButton *)sender).tag;

    if (active) {
        self.imageView.bounces = YES;

        self.bouncesYES.selected = YES;
        self.bouncesNO.selected = NO;
        
    } else {
        self.imageView.bounces = NO;

        self.bouncesYES.selected = NO;
        self.bouncesNO.selected = YES;
    }
}

- (IBAction)bouncesZoomPressed:(id)sender {
    BOOL active = !!((UIButton *)sender).tag;
    
    if (active) {
        self.imageView.bouncesZoom = YES;

        self.bouncesZoomYES.selected = YES;
        self.bouncesZoomNO.selected = NO;
        
    } else {
        self.imageView.bouncesZoom = NO;

        self.bouncesZoomYES.selected = NO;
        self.bouncesZoomNO.selected = YES;
    }
}

- (IBAction)zoomEnabledPressed:(id)sender {
    BOOL active = !!((UIButton *)sender).tag;
    
    if (active) {
        self.imageView.zoomEnabled = YES;
        
        self.zoomEnabledYES.selected = YES;
        self.zoomEnabledNO.selected = NO;
        
    } else {
        self.imageView.zoomEnabled = NO;
        
        self.zoomEnabledYES.selected = NO;
        self.zoomEnabledNO.selected = YES;
    }
}

@end
