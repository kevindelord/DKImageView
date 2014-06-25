//
//  DKRatio.m
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DKRatio.h"

@implementation DKRatio

NSInteger __gcd(NSInteger m, NSInteger n) {
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
        return __gcd(n, r);
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Ratio: { type: %ld, values: {%f ; %f} }", (long)self.type, self.values.width, self.values.height];
}

+ (DKRatioType)ratioTypeForWidth:(CGFloat)w height:(CGFloat)h {

    if (w == 16 && h == 9) return DKRatioType16_9;
    if (w == 4 && h == 3) return DKRatioType4_3;
    if (w == 3 && h == 4) return DKRatioType3_4;
    if (w == 3 && h == 2) return DKRatioType3_2;
    if (w == 3 && h == 1) return DKRatioType3_1;
    if (w == 2 && h == 3) return DKRatioType2_3;
    if (w == 1 && h == 1) return DKRatioType1_1;
    if (w == 5 && h == 1) return DKRatioType5_1;

    return DKRatioTypeNone;
}

+ (DKRatioType)ratioTypeForSize:(CGSize)size {
    if (size.height == 0 || size.width == 0)
        return DKRatioTypeNone;

    NSInteger delta = __gcd(size.width, size.height);
    CGFloat w = size.width / delta;
    CGFloat h = size.height / delta;

    return [DKRatio ratioTypeForWidth:w height:h];
}

+ (DKRatio *)ratioForWidth:(CGFloat)width height:(CGFloat)height {
    DKRatio *ratio = [DKRatio new];
    ratio.values = CGSizeMake(width, height);
    ratio.type = [DKRatio ratioTypeForWidth:width height:height];

    return ratio;
}

+ (DKRatio *)ratioForSize:(CGSize)size {
    if (size.height == 0 || size.width == 0)
        return nil;

    NSInteger delta = __gcd(size.width, size.height);
    CGFloat w = size.width / delta;
    CGFloat h = size.height / delta;

    return [DKRatio ratioForWidth:w height:h];
}

+ (DKRatio *)ratioForType:(DKRatioType)type {
    DKRatio *ratio = [DKRatio new];
    ratio.type = type;

    if (type == DKRatioType16_9)    ratio.values = CGSizeMake(16, 9);
    if (type == DKRatioType4_3)     ratio.values = CGSizeMake(4, 3);
    if (type == DKRatioType3_4)     ratio.values = CGSizeMake(3, 4);
    if (type == DKRatioType3_2)     ratio.values = CGSizeMake(3, 2);
    if (type == DKRatioType3_1)     ratio.values = CGSizeMake(3, 1);
    if (type == DKRatioType2_3)     ratio.values = CGSizeMake(2, 3);
    if (type == DKRatioType1_1)     ratio.values = CGSizeMake(1, 1);
    if (type == DKRatioType5_1)     ratio.values = CGSizeMake(5, 1);

    if (type == DKRatioTypeNone || type == DKRatioTypeTotal)
        ratio.values = CGSizeZero;

    return ratio;
}

+ (BOOL)isAvailableRatio:(NSInteger)_optionId {
    return (_optionId <= DKRatioTypeTotal);
}

@end
