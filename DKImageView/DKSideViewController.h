//
//  DKSideViewController.h
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKSideViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *bouncesYES;
@property (nonatomic, retain) IBOutlet UIButton *bouncesNO;
@property (nonatomic, retain) IBOutlet UIButton *bouncesZoomYES;
@property (nonatomic, retain) IBOutlet UIButton *bouncesZoomNO;
@property (nonatomic, retain) IBOutlet UIButton *overZoomColorBlue;
@property (nonatomic, retain) IBOutlet UIButton *overZoomColorDefault;
@property (nonatomic, retain) IBOutlet UIButton *croppingColorGreen;
@property (nonatomic, retain) IBOutlet UIButton *croppingColorDefault;
@property (nonatomic, retain) IBOutlet UIButton *ratioNone;
@property (nonatomic, retain) IBOutlet UIButton *ratio16_9;
@property (nonatomic, retain) IBOutlet UIButton *ratio4_3;

@end
