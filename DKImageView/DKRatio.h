//
//  DKRatio.h
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DKRatioType {
    DKRatioTypeNone,
    DKRatioType16_9,
    DKRatioType4_3,
    DKRatioType3_4,
    DKRatioType3_2,
    DKRatioType3_1,
    DKRatioType2_3,
    DKRatioType1_1,
    DKRatioType5_1,
    DKRatioTypeTotal
    };

typedef NSInteger DKRatioType;

@interface DKRatio : NSObject

@property (nonatomic) DKRatioType   type;
@property (nonatomic) CGSize        values;

+ (DKRatio *)ratioForSize:(CGSize)size;
+ (DKRatio *)ratioForWidth:(CGFloat)width height:(CGFloat)height;
+ (DKRatio *)ratioForType:(DKRatioType)type;

+ (DKRatioType)ratioTypeForSize:(CGSize)size;
+ (DKRatioType)ratioTypeForWidth:(CGFloat)width height:(CGFloat)height;

@end
