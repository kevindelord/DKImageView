//
//  DKZoomImageView.h
//  WhiteWall
//
//  Created by Kévin Delord on 10/8/13.
//  Copyright (c) 2013 DK enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKImageOverlayView.h"

#define K_VERBOSE_OVERLAY                   NO
#define K_VERBOSE_CROPPING                  NO
#define K_OVER_COLORED                      NO
#define K_OVERLAY_INTERACTION               NO

#define K_ZOOM_IMAGE_VIEW_DEBUG_STATE       NO
#define K_ZOOM_IMAGE_VIEW_MAX_ZOOM          10.0
#define K_ZOOM_IMAGE_VIEW_MIN_ZOOM          1.0

@class DKImageView;
@class DKImageOverlayView;

@protocol DKImageViewDelegate <NSObject>
@optional
- (BOOL)imageView:(DKImageView *)imageView overZoomedAtScale:(CGFloat)scale;
- (void)imageViewDidEndZooming:(DKImageView *)imageView atScale:(CGFloat)scale;
@end

@interface DKImageView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) id<DKImageViewDelegate>   delegate;

@property (nonatomic) CGFloat                           maximumZoomScale;
@property (nonatomic) CGFloat                           minimumZoomScale;
@property (nonatomic) BOOL                              bounces;
@property (nonatomic) BOOL                              bouncesZoom;
@property (nonatomic) BOOL                              zoomEnabled;
@property (nonatomic) BOOL                              croppingFrameEnabled;
@property (nonatomic) UIViewContentMode                 contentMode;
@property (nonatomic, retain) UIImage *                 image;

@property (nonatomic, retain) UIColor *                 croppingFrameColor;
@property (nonatomic, retain) UIColor *                 overZoomedColor;
@property (nonatomic, retain) NSString *                overZoomedText;
@property (nonatomic, retain) UIFont *                  overZoomedFont;
@property (nonatomic, retain) UIColor *                 overZoomedBackgroundColor;

// setter
- (void)setRatioForType:(DKRatioType)type;
- (void)setRatio:(DKRatio *)ratio;

// cropping
- (UIImage *)croppedImage;
- (NSDictionary *)croppingCoordinates;

// getter
- (CGFloat)zoomScale;
- (CGRect)insideFitImageSize;
- (DKRatio *)ratio;
- (DKImageOverlayView *)overlayView;

// update
- (void)updateOverlay:(BOOL)animated;

@end
