//
//  DKBlackOverlayView.m
//  WhiteWall
//
//  Created by Kévin Delord on 11/13/13.
//  Copyright (c) 2013 DK enterprise. All rights reserved.
//

#import "DKBlackOverlayView.h"

@interface DKBlackOverlayView () {
    UIView *_top;
    UIView *_left;
    UIView *_right;
    UIView *_bottom;
}
@end

@implementation DKBlackOverlayView

- (void)configureSubview:(UIView *)v {
    v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:v];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight;
        
        _top = [[UIView alloc] init];
        _left = [[UIView alloc] init];
        _right = [[UIView alloc] init];
        _bottom = [[UIView alloc] init];
        
        [self configureSubview:_top];
        [self configureSubview:_bottom];
        [self configureSubview:_left];
        [self configureSubview:_right];
        
        if (K_OVER_COLORED) {
            _top.backgroundColor = [UIColor redColor];
            _left.backgroundColor = [UIColor blueColor];
            _right.backgroundColor = [UIColor greenColor];
            _bottom.backgroundColor = [UIColor yellowColor];
        }
    }
    return self;
}

- (void)updateWithFrame:(CGRect)frame {
    _top.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.origin.y);
    _left.frame = CGRectMake(0, 0, frame.origin.x, self.frame.size.height);
    _right.frame = CGRectMake(frame.origin.x + frame.size.width, 0, self.frame.size.width - (frame.origin.x + frame.size.width), self.frame.size.height);
    _bottom.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, self.frame.size.height - (frame.origin.y + frame.size.height));
}

@end
