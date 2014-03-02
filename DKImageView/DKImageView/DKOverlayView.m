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
}

@end

@implementation DKOverlayView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (K_VERBOSE_OVERLAY)
            self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
        
        UIColor *color = [UIColor whiteColor];

        top = [[UIView alloc] init];
        top.backgroundColor = color;
        [self addSubview:top];
        bottom = [[UIView alloc] init];
        bottom.backgroundColor = color;
        [self addSubview:bottom];
        left = [[UIView alloc] init];
        left.backgroundColor = color;
        [self addSubview:left];
        right = [[UIView alloc] init];
        right.backgroundColor = color;
        [self addSubview:right];
    }
    return self;
}

- (void)updateWithFrame:(CGRect)newFrame overZoomed:(BOOL)overZoomed {
    
    UIColor *color = overZoomed ? [UIColor colorWithRed:253./255. green:114./255. blue:1./255. alpha:1.0] : [UIColor whiteColor];
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
}

- (void)updateWithFrame:(CGRect)newFrame animated:(BOOL)animated overZoomed:(BOOL)overZoomed {
    if (animated)
        [UIView animateWithDuration:0.3 animations:^{ [self updateWithFrame:newFrame overZoomed:overZoomed]; }];
    else
        [self updateWithFrame:newFrame overZoomed:overZoomed];
}

@end
