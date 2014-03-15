//
//  DKZoomImageView.m
//  WhiteWall
//
//  Created by Kévin Delord on 10/8/13.
//  Copyright (c) 2013 DK enterprise. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "DKImageView.h"
#import "DKBlackOverlayView.h"
#import "DKRatio.h"

@interface DKImageView () {
    DKBlackOverlayView *    _blackOverlay;
    DKImageOverlayView *    _overlayView;
    DKRatio *               _ratio;
    
    UIScrollView *          _scrollView;
//    UIImageView *           _imageView;
}

@end

@implementation DKImageView

@synthesize minimumZoomScale = _minimumZoomScale;
@synthesize maximumZoomScale = _maximumZoomScale;
@synthesize bounces = _bounces;
@synthesize bouncesZoom = _bouncesZoom;
@synthesize contentMode = _contentMode;

static CGRect GKScaleRect(CGRect rect, CGFloat scaleX, CGFloat scaleY) {
	return CGRectMake(rect.origin.x * scaleX, rect.origin.y * scaleY, rect.size.width * scaleX, rect.size.height * scaleY);
}

#pragma mark - Init methods

- (void)setup {
    // init self.view
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    _ratio = nil;
    self.maximumZoomScale = K_ZOOM_IMAGE_VIEW_MAX_ZOOM;
    self.minimumZoomScale = K_ZOOM_IMAGE_VIEW_MIN_ZOOM;
    self.bouncesZoom = self.bounces = NO;
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    // init scroll view
    {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = self.maximumZoomScale;
    _scrollView.minimumZoomScale = self.minimumZoomScale;
    _scrollView.bouncesZoom = self.bouncesZoom;
    _scrollView.bounces = self.bounces;
    _scrollView.showsHorizontalScrollIndicator = K_ZOOM_IMAGE_VIEW_DEBUG_STATE;
    _scrollView.showsVerticalScrollIndicator = K_ZOOM_IMAGE_VIEW_DEBUG_STATE;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_scrollView];
    }
    
    // init self.imageView
    {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageView.multipleTouchEnabled = YES;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.contentMode = self.contentMode;
    self.imageView.clipsToBounds = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight;
    self.imageView.image = nil;
    [_scrollView addSubview:self.imageView];
    }
    
    CGRect frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    _blackOverlay = [[DKBlackOverlayView alloc] initWithFrame:frame];
    [self.imageView addSubview:_blackOverlay];
    
    _overlayView = [[DKImageOverlayView alloc] initWithFrame:frame scrollView:_scrollView];
    _overlayView.imageView = self;
    [self addSubview:_overlayView];
    
    self.ratio = [DKRatio ratioForType:DKRatioTypeNone];
}

- (void)awakeFromNib {
    // init method called from a nib file
    // only called when the view is instantiated in a nib file.
    // some setup could be useless BUT useful in case of the user instantiate the view from code
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

- (void)resetContainers {
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.imageView.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _blackOverlay.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _blackOverlay.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView.zoomScale = 1.0;
    _overlayView.alpha = 0.0;
    _blackOverlay.alpha = 0.0;
}

#pragma mark - getter / setter

- (void)layoutSubviews {
    [super layoutSubviews];
    // this is called after the auto-resizing methods have been by called by the xib file.

    // reset imageView and ScrollView frames. Useful after the user select another picture
    [self resetContainers];
    if (self.imageView.image == nil)
        return ;
    
    // upate the image frame and scrollview
    CGRect contentFrame = [self insideFitImageSize];
    self.imageView.frame = CGRectMake(_scrollView.frame.size.width * 0.5 - contentFrame.size.width * 0.5,
                                      _scrollView.frame.size.height * 0.5 - contentFrame.size.height * 0.5,
                                      contentFrame.size.width, contentFrame.size.height);
    _scrollView.contentSize = contentFrame.size;
    
    // update the overlay without animation
    _overlayView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_overlayView updateOverlay:NO];
    [self updateBlackOverlay];
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self resetContainers];
}

- (CGRect)insideFitImageSize {
    return AVMakeRectWithAspectRatioInsideRect(self.imageView.image.size, self.imageView.bounds);
}

- (CGFloat)zoomScale {
    return _scrollView.zoomScale;
}

- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale {
    _maximumZoomScale = maximumZoomScale;
    _scrollView.maximumZoomScale = maximumZoomScale;
}

- (void)setMinimumZoomScale:(CGFloat)minimumZoomScale {
    _minimumZoomScale = minimumZoomScale;
    _scrollView.minimumZoomScale = minimumZoomScale;
}

- (void)setBounces:(BOOL)bounces {
    _bounces = bounces;
    _scrollView.bounces = bounces;
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    _contentMode = contentMode;
    self.imageView.contentMode = contentMode;
#warning TODO
}

- (UIColor *)croppingFrameColor {
    return _overlayView.overlay.color;
}

- (void)setCroppingFrameColor:(UIColor *)croppingFrameColor {
    _overlayView.overlay.color = croppingFrameColor;
    [_overlayView updateOverlay:NO];
}

- (UIColor *)overZoomedColor {
    return _overlayView.overlay.overZoomedColor;
}

- (void)setOverZoomedColor:(UIColor *)overZoomedColor {
    _overlayView.overlay.overZoomedColor = overZoomedColor;
    [_overlayView updateOverlay:NO];
}

#pragma mark - rotatin & zooming methods

- (void)updateBlackOverlay {
    _blackOverlay.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    [_blackOverlay updateWithFrame:[_overlayView overlayFrameInsideContainer]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateBlackOverlay];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // readapt the overlay frame
    [_overlayView updateOverlayAfterDragging:YES];
//    [self updateBlackOverlay];
}

- (CGSize)updatedScrollViewContentSize {
    CGSize contentSize = _scrollView.contentSize;
    // add delta
    CGRect overlayFrame = [_overlayView overlayFrame];
    
    contentSize.width = self.imageView.frame.size.width + (_scrollView.frame.size.width - overlayFrame.size.width);
    contentSize.height = self.imageView.frame.size.height + (_scrollView.frame.size.height - overlayFrame.size.height);
    
    // for small picture AND/OR extreme zoom out
    contentSize.width = MAX(contentSize.width, self.frame.size.width);
    contentSize.height = MAX(contentSize.height, self.frame.size.height);

    return contentSize;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    // readapt the overlay frame
    [_overlayView updateOverlay:YES];

    // make the change
    [_scrollView setContentSize:[self updatedScrollViewContentSize]];
    self.imageView.center = CGPointMake(_scrollView.contentSize.width * 0.5, _scrollView.contentSize.height * 0.5);
    [self updateBlackOverlay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewDidEndZooming:atScale:)])
        [self.delegate imageViewDidEndZooming:self atScale:self.zoomScale];
}

#pragma mark - Set ratio

- (DKRatio *)ratio {
    return _ratio;
}

- (void)setRatioForType:(DKRatioType)type {
    [self setRatio:[DKRatio ratioForType:type]];
}

- (void)setRatio:(DKRatio *)ratio {
    _ratio = ratio;
    // set the overlay to its new position
    [_overlayView updateOverlay:YES];
    
    // make it smooth
    [UIView animateWithDuration:0.3 animations:^{
        _overlayView.alpha = 1.0;
        _blackOverlay.alpha = 1.0;
        [_scrollView setContentSize:[self updatedScrollViewContentSize]];
        self.imageView.center = CGPointMake(_scrollView.contentSize.width * 0.5, _scrollView.contentSize.height * 0.5);
        [self updateBlackOverlay];
    } completion:^(BOOL finished) {
        _overlayView.alpha = 1.0;
        _blackOverlay.alpha = 1.0;
    }];
}

#pragma mark - Crop Image

- (NSDictionary *)croppingCoordinates {
    if (!self.imageView.image) return nil;
    if (K_VERBOSE_CROPPING) {
        NSLog(@"----------------------------------");
        NSLog(@"orignal pricture: %@", [NSValue valueWithCGSize:self.imageView.image.size]);
    }
    
    CGRect ratioRect = [_overlayView croppedFrame];
    if (ratioRect.size.width == 0 || ratioRect.size.height == 0) return nil;
    CGRect visibleRect = GKScaleRect([self visibleRectForCGRect:ratioRect], [self scaleX], [self scaleY]);
    
    if (K_VERBOSE_CROPPING) {
        NSLog(@"cropped frame real size: %@", [NSValue valueWithCGRect:visibleRect]);
    }
    
    CGFloat top = (visibleRect.origin.y * 100) / self.imageView.image.size.height;
    CGFloat left = (visibleRect.origin.x * 100) / self.imageView.image.size.width;
    CGFloat width = (visibleRect.size.width * 100) / self.imageView.image.size.width;
    CGFloat height = (visibleRect.size.height * 100) / self.imageView.image.size.height;
    
    if (K_VERBOSE_CROPPING) {
        NSLog(@"TOP  : %f = (%f * 100) / %f", top, visibleRect.origin.y, self.imageView.image.size.height);
        NSLog(@"LEFT  : %f = (%f * 100) / %f", top, visibleRect.origin.x, self.imageView.image.size.width);
        NSLog(@"WIDTH  : %f = (%f * 100) / %f", top, visibleRect.size.width, self.imageView.image.size.width);
        NSLog(@"HEIGHT  : %f = (%f * 100) / %f", top, visibleRect.size.height, self.imageView.image.size.height);
        
        NSLog(@"percentage = top: %f, left: %f, width: %f, height: %f", top, left, width, height);
    }
    
    NSMutableDictionary * crop = [NSMutableDictionary new];
    [crop setObject:[NSString stringWithFormat:@"%f", top] forKey:@"top"];
    [crop setObject:[NSString stringWithFormat:@"%f", left] forKey:@"left"];
    [crop setObject:[NSString stringWithFormat:@"%f", width] forKey:@"width"];
    [crop setObject:[NSString stringWithFormat:@"%f", height] forKey:@"height"];
    [crop setObject:@"0" forKey:@"angle"];
    
    return crop;
}

- (CGRect)visibleRectForCGRect:(CGRect)rect {
    // get the position of the picture inside of the UIImageView
    CGRect margin = [self insideFitImageSize];
    CGFloat realXMargin = margin.origin.x * _scrollView.zoomScale;
    CGFloat realYMargin = margin.origin.y * _scrollView.zoomScale;
    
    // create the visible rect
    CGRect visibleRect = CGRectMake((_scrollView.contentOffset.x - self.imageView.frame.origin.x) + rect.origin.x - realXMargin,
                                    (_scrollView.contentOffset.y - self.imageView.frame.origin.y) + rect.origin.y - realYMargin,
                                    rect.size.width,
                                    rect.size.height);
    return visibleRect;
}

- (CGFloat)scaleY {
    
    // calculate the Y scale ratio for the image
    
    CGRect fitRect = [self insideFitImageSize];
    CGFloat displayedHeight =  fitRect.size.height * _scrollView.zoomScale;
    
    return self.imageView.image.size.height / displayedHeight;
}

- (CGFloat)scaleX {
    
    // calculate the X scale ratio for the image
    
    CGRect fitRect = [self insideFitImageSize];
    CGFloat displayedWidth = fitRect.size.width * _scrollView.zoomScale;
    
    return self.imageView.image.size.width / displayedWidth;
}

- (UIImage *)croppedImage {
    
    CGRect ratioRect = [_overlayView croppedFrame];
    CGRect visibleRect = [self visibleRectForCGRect:ratioRect];
    visibleRect = GKScaleRect(visibleRect, [self scaleX], [self scaleY]);
    
    // crop the image    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.imageView.image CGImage], visibleRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.imageView.image.scale orientation:self.imageView.image.imageOrientation];

//    NSLog(@"----------------------------------");
//    NSLog(@"visible rect: %@", [NSValue valueWithCGRect:visibleRect]);
//    NSLog(@"CGImageRef Size: %zu %zu", CGImageGetHeight(imageRef), CGImageGetWidth(imageRef));
//    NSLog(@"croppedImage size: { %.2f : %.2f }", result.size.width, result.size.height);
    
    CGImageRelease(imageRef);
    return result;
}

@end
