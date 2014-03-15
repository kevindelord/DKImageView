//
//  DKImageOverlayView.h
//  WhiteWall
//
//  Created by Kévin Delord on 10/9/13.
//  Copyright (c) 2013 DK enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKRatio.h"
#import "DKOverlayView.h"
#import "DKImageView.h"

@class DKImageView;

@interface DKImageOverlayView : UIView

@property (nonatomic, retain) DKOverlayView *   overlay;
@property (nonatomic, retain) DKImageView *     imageView;

- (id)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView;

- (CGRect)overlayFrame;
- (CGRect)croppedFrame;
- (CGRect)overlayFrameInsideContainer;

- (void)updateOverlay:(BOOL)animated;
- (void)updateOverlayAfterDragging:(BOOL)animated;

+ (CGRect)frameForRatio:(DKRatio *)ratio imageCGSize:(CGSize)sz;
+ (CGSize)adjustSize:(CGSize)size withSize:(CGSize)rSize;
+ (CGSize)adjustSize:(CGSize)size toCGRect:(CGRect)rect;

@end
