//
//  DKOverlayView.m
//  WhiteWall
//
//  Created by Kévin Delord on 10/31/13.
//  Copyright (c) K_EDGE_WIDTH013 DK enterprise. All rights reserved.
//

#import "DKOverlayView.h"
#import "DKImageOverlayView.h"

#define K_EDGE_WIDTH    2.0

@interface DKOverlayView () {
    UIView *top;
    UIView *bottom;
    UIView *left;
    UIView *right;
    
    UILabel *text;
}

@end

@implementation DKOverlayView

@synthesize color = _color;
@synthesize overZoomedColor = _overZoomedColor;
@synthesize overZoomedText = _overZoomedText;
@synthesize overZoomedFont = _overZoomedFont;
@synthesize overZoomedBackgroundColor = _overZoomedBackgroundColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (K_VERBOSE_OVERLAY)
            self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
        
        // init attributes
        _color = [UIColor whiteColor];
        _overZoomedColor = [UIColor colorWithRed:253./255. green:114./255. blue:1./255. alpha:1.0];
        _overZoomedText = @"Over Zoomed";
        _overZoomedFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        _overZoomedBackgroundColor = [UIColor clearColor];
        
        // init edge views
        top = [[UIView alloc] init];
        top.backgroundColor = _color;
        [self addSubview:top];
        bottom = [[UIView alloc] init];
        bottom.backgroundColor = _color;
        [self addSubview:bottom];
        left = [[UIView alloc] init];
        left.backgroundColor = _color;
        [self addSubview:left];
        right = [[UIView alloc] init];
        right.backgroundColor = _color;
        [self addSubview:right];
        
        // init over zoom text
        text = [[UILabel alloc] initWithFrame:CGRectZero];
        text.textAlignment = NSTextAlignmentCenter;
        text.numberOfLines = 0;
        text.textColor = _overZoomedColor;
        text.font = _overZoomedFont;
        text.text = _overZoomedText;
        text.backgroundColor = _overZoomedBackgroundColor;
        text.alpha = 0;
        [self addSubview:text];
    }
    return self;
}

- (void)updateOverZoomedText:(BOOL)overZoomed {
    text.alpha = overZoomed;
    text.frame = CGRectMake(left.frame.origin.x + K_EDGE_WIDTH, top.frame.origin.y + K_EDGE_WIDTH,
                            right.frame.origin.x - left.frame.origin.x - K_EDGE_WIDTH,
                            bottom.frame.origin.y - top.frame.origin.y - K_EDGE_WIDTH);
    text.textColor = _overZoomedColor;
    text.font = _overZoomedFont;
    text.text = _overZoomedText;
    text.backgroundColor = (K_VERBOSE_OVERLAY ? [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5] : _overZoomedBackgroundColor);
}

- (void)updateWithFrame:(CGRect)newFrame overZoomed:(BOOL)overZoomed {
    
    UIColor *color = overZoomed ? _overZoomedColor : _color;
    top.backgroundColor = color;
    bottom.backgroundColor = color;
    left.backgroundColor = color;
    right.backgroundColor = color;
    
    CGSize superViewSize = [self superview].frame.size;

    BOOL biggerH = newFrame.size.height + newFrame.origin.y >= superViewSize.height - newFrame.origin.y;
    BOOL biggerW = newFrame.size.width + newFrame.origin.x >= superViewSize.width - newFrame.origin.x;

    CGFloat y = (biggerH ? 0 : K_EDGE_WIDTH);
    CGFloat x = (biggerW ? 0 : K_EDGE_WIDTH);
    
    top.frame = CGRectMake(0, -y, newFrame.size.width, K_EDGE_WIDTH);
    bottom.frame = CGRectMake(0, newFrame.size.height - (biggerH ? K_EDGE_WIDTH : 0), newFrame.size.width, K_EDGE_WIDTH);
    
    left.frame = CGRectMake(-x, -y, K_EDGE_WIDTH, newFrame.size.height + (2 * y));
    right.frame = CGRectMake(newFrame.size.width - (biggerW ? K_EDGE_WIDTH : 0), -y, K_EDGE_WIDTH, newFrame.size.height + (2 * y));

    self.frame = newFrame;

    [self updateOverZoomedText:overZoomed];
}

- (void)updateWithFrame:(CGRect)newFrame animated:(BOOL)animated overZoomed:(BOOL)overZoomed {
    if (animated)
        [UIView animateWithDuration:0.3 animations:^{ [self updateWithFrame:newFrame overZoomed:overZoomed]; }];
    else
        [self updateWithFrame:newFrame overZoomed:overZoomed];
}

@end
