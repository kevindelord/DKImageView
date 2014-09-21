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
    DKBlackOverlayView *    _blackOverlayView;
    DKImageOverlayView *    _overlayView;
    DKRatio *               _ratio;
    
    UIScrollView *          _scrollView;
    UIImageView *           _imageView;
}

@end

@implementation DKImageView

@synthesize minimumZoomScale = _minimumZoomScale;
@synthesize maximumZoomScale = _maximumZoomScale;
@synthesize bounces = _bounces;
@synthesize bouncesZoom = _bouncesZoom;
@synthesize contentMode = _contentMode;
@synthesize zoomEnabled = _zoomEnabled;
@synthesize croppingFrameEnabled = _croppingFrameEnabled;

static CGRect GKScaleRect(CGRect rect, CGFloat scaleX, CGFloat scaleY) {
	return CGRectMake(rect.origin.x * scaleX, rect.origin.y * scaleY, rect.size.width * scaleX, rect.size.height * scaleY);
}

#pragma mark - Init methods

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 1.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.bouncesZoom = NO;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = K_ZOOM_IMAGE_VIEW_DEBUG_STATE;
    _scrollView.showsVerticalScrollIndicator = K_ZOOM_IMAGE_VIEW_DEBUG_STATE;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_scrollView];
}

- (void)initImageView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imageView.multipleTouchEnabled = YES;
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = self.contentMode;
    _imageView.clipsToBounds = YES;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight;
    _imageView.image = nil;
    [_scrollView addSubview:_imageView];
}

- (void)initOverlayViews {
    // black Overlay
    CGRect frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
    _blackOverlayView = [[DKBlackOverlayView alloc] initWithFrame:frame];
    _blackOverlayView.alpha = 0.0;
    [_imageView addSubview:_blackOverlayView];

    // cropping Frame
    _overlayView = [[DKImageOverlayView alloc] initWithFrame:frame scrollView:_scrollView imageView:_imageView];
    _overlayView.dkImageView = self;
    _overlayView.alpha = 0.0;
    [self addSubview:_overlayView];
}

- (void)setup {
    // init self.view
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;

    _ratio = nil;
    _maximumZoomScale = K_ZOOM_IMAGE_VIEW_MAX_ZOOM;
    _minimumZoomScale = K_ZOOM_IMAGE_VIEW_MIN_ZOOM;
    _contentMode = UIViewContentModeScaleAspectFit;
    _zoomEnabled = NO;
    _bounces = NO;
    _bouncesZoom = NO;
    _croppingFrameEnabled = NO;
    
    // init scroll view
    [self initScrollView];

    // init _imageView
    [self initImageView];

    // init _overlayView and _blackOverlay
    [self initOverlayViews];

    self.ratio = [DKRatio ratioForType:DKRatioTypeNone];
}

- (void)awakeFromNib {
    // init method called from a nib file
    // only called when the view is instantiated in a nib file.
    // some setup could be useless BUT useful in case of the user instantiate the view from code
    [self setup];
}

#warning TODO: create method initWithImage:(UIImage*)
#warning TODO: create method initWithFrame:(CGRect)frame image:(UIImage*)
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
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _imageView.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _blackOverlayView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _blackOverlayView.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView.zoomScale = 1.0;
    _overlayView.alpha = 0.0;
    _blackOverlayView.alpha = 0.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // this is called after the auto-resizing methods have been by called by the xib file.

    // reset imageView and ScrollView frames. Useful after the user select another picture
    [self resetContainers];
    if (_imageView.image == nil)
        return ;
    
    // upate the image frame and scrollview
    CGRect contentFrame = [self insideFitImageSize];
    _imageView.frame = CGRectMake(_scrollView.frame.size.width * 0.5 - contentFrame.size.width * 0.5,
                                  _scrollView.frame.size.height * 0.5 - contentFrame.size.height * 0.5,
                                  contentFrame.size.width, contentFrame.size.height);
    _scrollView.contentSize = contentFrame.size;
    
    // update the overlay without animation
    [self updateOverlay:NO];
    [self updateBlackOverlay];
}

- (CGRect)insideFitImageSize {
    return AVMakeRectWithAspectRatioInsideRect(_imageView.image.size, _imageView.bounds);
}

#pragma mark - getter / setter

- (UIImage *)image {
    return _imageView.image;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    [self resetContainers];
}

- (void)setZoomEnabled:(BOOL)zoomEnabled {
    _zoomEnabled = zoomEnabled;
    if (zoomEnabled) {
        _scrollView.maximumZoomScale = _maximumZoomScale;
        _scrollView.minimumZoomScale = _minimumZoomScale;
    } else {
        _scrollView.maximumZoomScale = _scrollView.zoomScale;
        _scrollView.minimumZoomScale = _scrollView.zoomScale;
    }
}

- (void)setCroppingFrameEnabled:(BOOL)croppingFrameEnabled {
    // only change the cropping ratio to the default value when the frame is displayed and then hidden.
    // We need to do so in case the user wants to crop its picture after that.
#warning TODO: create a custom ratio. the frame has to be the same the 'inside' picture.
    if (_croppingFrameEnabled && croppingFrameEnabled)
        [self setRatioForType:DKRatioTypeNone];

    // set the boolean value
    _croppingFrameEnabled = croppingFrameEnabled;

    // show or not the overlay views
    _blackOverlayView.alpha = croppingFrameEnabled;
    _overlayView.alpha = croppingFrameEnabled;
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

- (BOOL)bounces {
    return _scrollView.bounces;
}

- (void)setBounces:(BOOL)bounces {
    _scrollView.bounces = bounces;
}

- (BOOL)bouncesZoom {
    return _scrollView.bouncesZoom;
}

- (void)setBouncesZoom:(BOOL)bouncesZoom {
    _scrollView.bouncesZoom = bouncesZoom;
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    _contentMode = contentMode;
    _imageView.contentMode = contentMode;
#warning TODO: implement any needed modification when the content mode changes.
}

- (UIColor *)croppingFrameColor {
    return _overlayView.overlay.color;
}

- (void)setCroppingFrameColor:(UIColor *)croppingFrameColor {
    _overlayView.overlay.color = croppingFrameColor;
    [_overlayView updateOverlay:NO completion:nil];
}

- (UIColor *)overZoomedColor {
    return _overlayView.overlay.overZoomedColor;
}

- (void)setOverZoomedColor:(UIColor *)overZoomedColor {
    _overlayView.overlay.overZoomedColor = overZoomedColor;
    [_overlayView updateOverlay:NO completion:nil];
}

- (UIFont *)overZoomedFont {
    return _overlayView.overlay.overZoomedFont;
}

- (void)setOverZoomedFont:(UIFont *)overZoomedFont {
    _overlayView.overlay.overZoomedFont = overZoomedFont;
    [_overlayView updateOverlay:NO completion:nil];
}

- (NSString *)overZoomedText {
    return _overlayView.overlay.overZoomedText;
}

- (void)setOverZoomedText:(NSString *)overZoomedText {
    _overlayView.overlay.overZoomedText = overZoomedText;
    [_overlayView updateOverlay:NO completion:nil];
}

- (UIColor *)overZoomedBackgroundColor {
    return _overlayView.overlay.overZoomedBackgroundColor;
}

- (void)setOverZoomedBackgroundColor:(UIColor *)overZoomedBackgroundColor {
    _overlayView.overlay.overZoomedBackgroundColor = overZoomedBackgroundColor;
    [_overlayView updateOverlay:NO completion:nil];
}

#pragma mark - rotatin & zooming methods

- (DKImageOverlayView *)overlayView {
    return _overlayView;
}

- (void)updateOverlay:(BOOL)animated {
    _overlayView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_overlayView updateOverlay:animated completion:nil];
}

- (void)updateBlackOverlay {
    _blackOverlayView.frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
    [_blackOverlayView updateWithFrame:[_overlayView overlayFrameInsideContainer]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateBlackOverlay];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // readapt the overlay frame
    [_overlayView updateOverlayAfterDragging:YES completion:nil];
//    [self updateBlackOverlay];
}

- (CGSize)updatedScrollViewContentSize {
    CGSize contentSize = _scrollView.contentSize;
    // add delta
    CGRect overlayFrame = [_overlayView overlayFrame];
    
    contentSize.width = _imageView.frame.size.width + (_scrollView.frame.size.width - overlayFrame.size.width);
    contentSize.height = _imageView.frame.size.height + (_scrollView.frame.size.height - overlayFrame.size.height);
    
    // for small picture AND/OR extreme zoom out
    contentSize.width = MAX(contentSize.width, self.frame.size.width);
    contentSize.height = MAX(contentSize.height, self.frame.size.height);

    return contentSize;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {

    // readapt the overlay frame
    [_overlayView updateOverlay:YES completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewDidEndZooming:atScale:)])
            [self.delegate imageViewDidEndZooming:self atScale:self.zoomScale];
    }];
    // make the change
    [_scrollView setContentSize:[self updatedScrollViewContentSize]];
    _imageView.center = CGPointMake(_scrollView.contentSize.width * 0.5, _scrollView.contentSize.height * 0.5);
    // update the black overlay
    [self updateBlackOverlay];
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

    // make it smooth
    [UIView animateWithDuration:0.3 animations:^{
        // set the overlay to its new position
        [_overlayView updateOverlay:NO completion:nil];

        _overlayView.alpha = _croppingFrameEnabled;
        _blackOverlayView.alpha = _croppingFrameEnabled;
        [_scrollView setContentSize:[self updatedScrollViewContentSize]];
        _imageView.center = CGPointMake(_scrollView.contentSize.width * 0.5, _scrollView.contentSize.height * 0.5);
        [self updateBlackOverlay];
    } completion:^(BOOL finished) {
        _overlayView.alpha = _croppingFrameEnabled;
        _blackOverlayView.alpha = _croppingFrameEnabled;
    }];
}

#pragma mark - Crop Image

- (NSDictionary *)croppingCoordinates {
    if (!_imageView.image) return nil;
    DKLog(K_VERBOSE_CROPPING, @"----------------------------------");
    DKLog(K_VERBOSE_CROPPING, @"orignal pricture: %@", [NSValue valueWithCGSize:_imageView.image.size]);
    
    CGRect ratioRect = [_overlayView croppedFrame];
    if (ratioRect.size.width == 0 || ratioRect.size.height == 0) return nil;
    CGRect visibleRect = GKScaleRect([self visibleRectForCGRect:ratioRect], [self scaleX], [self scaleY]);

    DKLog(K_VERBOSE_CROPPING, @"cropped frame real size: %@", [NSValue valueWithCGRect:visibleRect]);

    CGFloat top = (visibleRect.origin.y * 100) / _imageView.image.size.height;
    CGFloat left = (visibleRect.origin.x * 100) / _imageView.image.size.width;
    CGFloat width = (visibleRect.size.width * 100) / _imageView.image.size.width;
    CGFloat height = (visibleRect.size.height * 100) / _imageView.image.size.height;

    DKLog(K_VERBOSE_CROPPING, @"TOP  : %f = (%f * 100) / %f", top, visibleRect.origin.y, _imageView.image.size.height);
    DKLog(K_VERBOSE_CROPPING, @"LEFT  : %f = (%f * 100) / %f", top, visibleRect.origin.x, _imageView.image.size.width);
    DKLog(K_VERBOSE_CROPPING, @"WIDTH  : %f = (%f * 100) / %f", top, visibleRect.size.width, _imageView.image.size.width);
    DKLog(K_VERBOSE_CROPPING, @"HEIGHT  : %f = (%f * 100) / %f", top, visibleRect.size.height, _imageView.image.size.height);
    DKLog(K_VERBOSE_CROPPING, @"percentage = top: %f, left: %f, width: %f, height: %f", top, left, width, height);

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
    CGRect visibleRect = CGRectMake((_scrollView.contentOffset.x - _imageView.frame.origin.x) + rect.origin.x - realXMargin,
                                    (_scrollView.contentOffset.y - _imageView.frame.origin.y) + rect.origin.y - realYMargin,
                                    rect.size.width,
                                    rect.size.height);
    return visibleRect;
}

- (CGFloat)scaleY {
    
    // calculate the Y scale ratio for the image
    
    CGRect fitRect = [self insideFitImageSize];
    CGFloat displayedHeight =  fitRect.size.height * _scrollView.zoomScale;
    
    return _imageView.image.size.height / displayedHeight;
}

- (CGFloat)scaleX {
    
    // calculate the X scale ratio for the image
    
    CGRect fitRect = [self insideFitImageSize];
    CGFloat displayedWidth = fitRect.size.width * _scrollView.zoomScale;
    
    return _imageView.image.size.width / displayedWidth;
}

- (UIImage *)croppedImage {
    
    CGRect ratioRect = [_overlayView croppedFrame];
    CGRect visibleRect = [self visibleRectForCGRect:ratioRect];
    visibleRect = GKScaleRect(visibleRect, [self scaleX], [self scaleY]);
    
    // crop the image    
    CGImageRef imageRef = CGImageCreateWithImageInRect([_imageView.image CGImage], visibleRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:_imageView.image.scale orientation:_imageView.image.imageOrientation];

//    DKLog(K_VERBOSE_CROPPING, @"----------------------------------");
//    DKLog(K_VERBOSE_CROPPING, @"visible rect: %@", [NSValue valueWithCGRect:visibleRect]);
//    DKLog(K_VERBOSE_CROPPING, @"CGImageRef Size: %zu %zu", CGImageGetHeight(imageRef), CGImageGetWidth(imageRef));
//    DKLog(K_VERBOSE_CROPPING, @"croppedImage size: { %.2f : %.2f }", result.size.width, result.size.height);
    
    CGImageRelease(imageRef);
    return result;
}

@end
