//
//  DKOverlayView.h
//  WhiteWall
//
//  Created by Kévin Delord on 10/31/13.
//  Copyright (c) 2013 DK enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKOverlayView : UIView

- (void)updateWithFrame:(CGRect)newFrame animated:(BOOL)animated overZoomed:(BOOL)overZoomed;

@end
