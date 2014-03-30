//
//  DKSideViewController.h
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKViewController.h"

@interface DKSideViewController : UIViewController <DKImageViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *bouncesYES;
@property (nonatomic, retain) IBOutlet UIButton *bouncesNO;
@property (nonatomic, retain) IBOutlet UIButton *bouncesZoomYES;
@property (nonatomic, retain) IBOutlet UIButton *bouncesZoomNO;
@property (nonatomic, retain) IBOutlet UIButton *zoomEnabledYES;
@property (nonatomic, retain) IBOutlet UIButton *zoomEnabledNO;
@property (nonatomic, retain) IBOutlet UIButton *croppingFrameEnabledNO;
@property (nonatomic, retain) IBOutlet UIButton *croppingFrameEnabledYES;

@property (nonatomic, retain) IBOutlet UIButton *overZoomColorBlue;
@property (nonatomic, retain) IBOutlet UIButton *overZoomColorDefault;
@property (nonatomic, retain) IBOutlet UIButton *croppingColorGreen;
@property (nonatomic, retain) IBOutlet UIButton *croppingColorDefault;

@property (nonatomic, retain) IBOutlet UIScrollView *ratioScrollView;

@end
