//
//  DKRatio.m
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DKRatio.h"

@implementation DKRatio

NSInteger gcd(NSInteger m, NSInteger n) {
    NSInteger t, r;
    
    if (m < n) {
        t = m;
        m = n;
        n = t;
    }
    
    r = m % n;
    
    if (r == 0) {
        return n;
    } else {
        return gcd(n, r);
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Ratio: { type: %d, values: {%f ; %f} }", self.type, self.values.width, self.values.height];
}

+ (DKRatio *)ratioForWidth:(CGFloat)width height:(CGFloat)height {
    DKRatio *ratio = [DKRatio new];
    ratio.values = CGSizeMake(width, height);
    ratio.type = DKRatioTypeNone;
    return ratio;
}

+ (DKRatio *)ratioForSize:(CGSize)size {
    NSInteger delta = gcd(size.width, size.height);
    CGFloat w = size.width / delta;
    CGFloat h = size.height / delta;
    
    return [DKRatio ratioForWidth:w height:h];
}

+ (DKRatio *)ratioForType:(DKRatioType)type {
    DKRatio *ratio = [DKRatio new];
    ratio.type = type;
    if (type == DKRatioType16_9) ratio.values = CGSizeMake(16, 9);
    if (type == DKRatioType4_3) ratio.values  = CGSizeMake(4, 3);
    if (type == DKRatioTypeNone) ratio.values = CGSizeZero;
    
    return ratio;
}

+ (BOOL)isAvailableRatio:(NSInteger)_optionId {
    return (_optionId <= DKRatioTypeNone);
}

@end
