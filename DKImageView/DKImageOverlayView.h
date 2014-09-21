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
@property (nonatomic, retain) DKImageView *     dkImageView;

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView imageView:(UIImageView *)imageView;

@property (nonatomic, readonly) CGRect overlayFrame;
@property (nonatomic, readonly) CGRect croppedFrame;
@property (nonatomic, readonly) CGRect overlayFrameInsideContainer;

- (void)updateOverlay:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)updateOverlayAfterDragging:(BOOL)animated completion:(void (^)(BOOL finished))completion;

+ (CGRect)frameForRatio:(DKRatio *)ratio imageCGSize:(CGSize)sz;
+ (CGSize)adjustSize:(CGSize)size withSize:(CGSize)rSize;
+ (CGSize)adjustSize:(CGSize)size toCGRect:(CGRect)rect;

@end
