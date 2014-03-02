//
//  DKZoomImageView.h
//  WhiteWall
//
//  Created by Kévin Delord on 10/8/13.
//  Copyright (c) 2013 DK enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKImageOverlayView.h"

#define K_ZOOM_IMAGE_VIEW_DEBUG_STATE       NO
#define K_ZOOM_IMAGE_VIEW_MAX_ZOOM          10.0
#define K_ZOOM_IMAGE_VIEW_MIN_ZOOM          1.0

@protocol DKImageViewDelegate <NSObject>
@required
- (BOOL)overZoomed;
- (void)didEndUpdateOverlay;
@end

@interface DKImageView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) id<DKImageViewDelegate>   delegate;

// setter
- (void)setImage:(UIImage *)image;
- (void)setRatioForType:(DKRatioType)type;

// cropping
- (UIImage *)croppedImage;
- (NSDictionary *)croppingCoordinates;

// getter
- (CGRect)insideFitImageSize;
- (DKRatio *)ratio;

@end
