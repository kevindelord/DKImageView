//
//  DKImageOverlayView.m
//  WhiteWall
//
//  Created by Kévin Delord on 10/9/13.
//  Copyright (c) 2013 DK enterprise. All rights reserved.
//

#import "DKImageOverlayView.h"

#define K_TOUCH_DELTA       10

@interface DKImageOverlayView () {
    CGRect          _croppedFrame;
    UIScrollView *  _scrollView;
    UIImageView *   _imageView;
}

@end

@implementation DKImageOverlayView

@synthesize overlay = _overlay;
@synthesize dkImageView;

#pragma mark - Init methods

- (instancetype)initWithFrame:(CGRect)frame {
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView imageView:(UIImageView *)imageView {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = K_OVERLAY_INTERACTION;
        if (K_VERBOSE_OVERLAY)
            self.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2];
        
        _imageView = imageView;
        _scrollView = scrollView;
        _overlay = [[DKOverlayView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5, 0, 0)];
        [self addSubview:_overlay];
        _croppedFrame = CGRectMake(0, 0, 0, 0);
    }
    return self;
}

#pragma mark - Touch methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect frame = _overlay.frame;
    
    // top horizontal touch
    if (((int)frame.origin.y + K_TOUCH_DELTA) > point.y && (frame.origin.y - K_TOUCH_DELTA) < point.y)
        return true;
    // bottom horizontal touch
    if (((int)frame.origin.y + frame.size.height + K_TOUCH_DELTA) > point.y && (frame.origin.y + frame.size.height - K_TOUCH_DELTA) < point.y)
        return true;
    // left vertical touch
    if (((int)frame.origin.x + K_TOUCH_DELTA) > point.x && (frame.origin.x - K_TOUCH_DELTA) < point.x)
        return true;
    // right vertical touch
    if (((int)frame.origin.x + frame.size.width + K_TOUCH_DELTA) > point.x && (frame.origin.x + frame.size.width - K_TOUCH_DELTA) < point.x)
        return true;
    
    return false;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint start = [touch previousLocationInView:self];
    CGPoint end = [touch locationInView:self];
    
    CGRect container = [self containerFrame];
    CGRect f = _overlay.frame;
    
    if (f.origin.x + (end.x - start.x) + f.size.width < (container.size.width + container.origin.x))
        f.origin.x += (end.x - start.x);
    if (f.origin.y + (end.y - start.y) + f.size.height < (container.size.height + container.origin.y))
        f.origin.y += (end.y - start.y);
    
    // inside the view frame
    if ([self isFrame:f insideOfContainer:self.frame]) {
        // inside the image frame
        if ([self isFrame:f insideOfContainer:container]) {
            _overlay.frame = CGRectMake((int)f.origin.x, (int)f.origin.y, (int)f.size.width, (int)f.size.height);
        }
    }
}

#pragma mark - Getter

- (CGRect)overlayFrame {
    return _overlay.frame;
}

- (CGRect)croppedFrame {
    return _croppedFrame;
}

- (CGRect)containerFrame {
    return CGRectMake(// image.x - offset.x
                      // has to be superior than 0
                      MAX(_imageView.frame.origin.x - _scrollView.contentOffset.x, 0.0f),
                      MAX(_imageView.frame.origin.y - _scrollView.contentOffset.y, 0.0f),
                      // (image.width + image.x) - MAX(image.x, offset.x)
                      // has to be inferior than self.frame.width
                      MIN((_imageView.frame.size.width  + _imageView.frame.origin.x) - MAX(_imageView.frame.origin.x, _scrollView.contentOffset.x), self.frame.size.width),
                      MIN((_imageView.frame.size.height + _imageView.frame.origin.y) - MAX(_imageView.frame.origin.y, _scrollView.contentOffset.y), self.frame.size.height));
}

- (CGRect)insideImageFrame {
    CGRect insideView = [self.dkImageView insideFitImageSize];
    CGRect container = _imageView.frame;
    
    return CGRectMake((int)(container.origin.x + insideView.origin.x * 2),
                      (int)(container.origin.y + insideView.origin.y),
                      (int)(container.size.width - (insideView.origin.x * 2)),
                      (int)(container.size.height - insideView.origin.y));
}

#pragma mark - drawing methods

- (void)updateOverlayWithOverZoomedVerification:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    BOOL overZoomed = NO;
    if (self.dkImageView.delegate && [self.dkImageView.delegate respondsToSelector:@selector(imageView:overZoomedAtScale:)])
        overZoomed = [self.dkImageView.delegate imageView:self.dkImageView overZoomedAtScale:self.dkImageView.zoomScale];
    [_overlay updateWithFrame:_croppedFrame animated:animated overZoomed:overZoomed completion:completion];
}

- (void)updateOverlayAfterDragging:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    
    if (K_OVERLAY_INTERACTION == NO)
        return ;

    // Warning: this method is not working absolutely perfectly
    // If this feature has to be re-enable again someone should work on it
    // Cases: after moving the overlay and then scrolling, the overlay has to be replaced on the picture
    
    CGRect container = [self containerFrame];
    CGRect f = _overlay.frame;

    // inside the view frame
    if ([self isFrame:f insideOfContainer:self.frame]) {
        // inside the image frame
        if ([self isFrame:f insideOfContainer:container] == false) {
            _croppedFrame = [self setFrame:f insideOfContainer:container];
            [self updateOverlayWithOverZoomedVerification:animated completion:completion];
        }
    }
}

- (void)updateOverlay:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    _croppedFrame = [self frameForCurrentRatio];
    [self updateOverlayWithOverZoomedVerification:animated completion:completion];
}

- (CGRect)overlayFrameInsideContainer {
    CGFloat zoomScale = _scrollView.zoomScale;
    
    CGFloat x = _scrollView.contentOffset.x / zoomScale;
    CGFloat y = _scrollView.contentOffset.y / zoomScale;
    CGFloat h = self.overlayFrame.size.height / zoomScale;
    CGFloat w = self.overlayFrame.size.width / zoomScale;

    return CGRectMake(x, y, w, h);
}

#pragma mark - CGRect Methods 

- (void)log:(CGRect)f cont:(CGRect)container {
    DKLog(K_VERBOSE_OVERLAY, @"    frame: %0.f %0.f %0.f %0.f", f.origin.x, f.origin.y, f.size.width, f.size.height);
    DKLog(K_VERBOSE_OVERLAY, @"container: %0.f %0.f %0.f %0.f", container.origin.x, container.origin.y, container.size.width, container.size.height);
    DKLog(K_VERBOSE_OVERLAY, @"---- %d %d %d %d ----",
          (int)f.origin.x >= (int)container.origin.x,
          ((int)f.origin.x + (int)f.size.width) <= ((int)container.origin.x + (int)container.size.width),
          (int)f.origin.y >= (int)container.origin.y,
          ((int)f.origin.y + (int)f.size.height) <= ((int)container.origin.y + (int)container.size.height));
}

- (BOOL)isFrame:(CGRect)frame insideOfContainer:(CGRect)container {
    return (
            (int)frame.origin.x >= (int)container.origin.x
            && ((int)frame.origin.x + (int)frame.size.width) <= ((int)container.size.width + (int)container.origin.x)
            && (int)frame.origin.y >= (int)container.origin.y
            && ((int)frame.origin.y + (int)frame.size.height) <= ((int)container.size.height + (int)container.origin.y)
            );
}

- (CGRect)setFrame:(CGRect)frame insideOfContainer:(CGRect)container {
    
    if (frame.origin.x < container.origin.x)
        frame.origin.x = container.origin.x;
    else if ((frame.origin.x + frame.size.width) > (container.origin.x + container.size.width))
        frame.origin.x = (container.origin.x + container.size.width) - frame.size.width;
    
    if (frame.origin.y < container.origin.y)
        frame.origin.y = container.origin.y;
    else if ((frame.origin.y + frame.size.height) > (container.origin.y + container.size.height))
        frame.origin.y = (container.origin.y + container.size.height) - frame.size.height;
    
    return frame;
}

+ (CGSize)adjustSize:(CGSize)size toCGRect:(CGRect)rect {
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    if (w > rect.size.width) {
        h = h / (w / rect.size.width);
        w = rect.size.width;
    }
    if (h > rect.size.height) {
        w = w / (h / rect.size.height);
        h = rect.size.height;
    }
    return CGSizeMake(w, h);
}

+ (CGSize)adjustSize:(CGSize)size withSize:(CGSize)rSize {
    CGFloat w = size.width / rSize.width;
    CGFloat h = rSize.height * w;
    w *= rSize.width;

    return CGSizeMake(w, h);
}

+ (CGSize)adjustSize:(CGSize)size toRatio:(DKRatio *)ratio {

    if (ratio && ratio.type != DKRatioTypeNone) {
        return [self adjustSize:size withSize:ratio.values];
    } else {
        // optionId == K_RATIO_ID_NO_FORMAT -> No specific Format
        //      OR
        // No ratio selected => self.dkImageView.ratio == null;
        //
        // then return the original size
    }
    return size;
}

#pragma mark - Overlay methods

// useless
+ (CGRect)frameForRatio:(DKRatio *)ratio imageCGSize:(CGSize)sz {
    CGRect insideImageFrame = CGRectMake(0, 0, sz.width, sz.height);
    
    // size for the current ratio
    sz = [DKImageOverlayView adjustSize:sz toRatio:ratio];
    
    // adjust the frame to the inside image in case of small picture
    sz = [DKImageOverlayView adjustSize:sz toCGRect:insideImageFrame];
    
    CGRect f = CGRectMake(0, 0, sz.width, sz.height);
    DKLog(K_VERBOSE_OVERLAY, @"ratioRect: %0.f %0.f %0.f %0.f", f.origin.x, f.origin.y, f.size.width, f.size.height);
    return f;
}

- (CGRect)frameForCurrentRatio {
    
    // draw a new overlay for the current ratio
    CGRect insideImageFrame = [self insideImageFrame];
    CGSize sz = insideImageFrame.size;
    
    // size for the current ratio
    sz = [DKImageOverlayView adjustSize:sz toRatio:self.dkImageView.ratio];

    // adjust the frame to the inside image in case of small picture
    sz = [DKImageOverlayView adjustSize:sz toCGRect:insideImageFrame];

    // adjust the maximum size as the size of the view
    sz = [DKImageOverlayView adjustSize:sz toCGRect:self.frame];

    CGRect f = CGRectMake(self.frame.size.width * 0.5 - sz.width * 0.5 - self.frame.origin.x,
                          self.frame.size.height * 0.5 - sz.height * 0.5 - self.frame.origin.y,
                          sz.width, sz.height);
    DKLog(K_VERBOSE_OVERLAY, @"ratioRect: %0.f %0.f %0.f %0.f", f.origin.x, f.origin.y, f.size.width, f.size.height);
    return f;
}

@end
