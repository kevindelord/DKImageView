//
//  DKRatio.h
//  DKImageView
//
//  Created by Kévin Delord on 2/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DKRatioType {
    DKRatioType16_9,
    DKRatioType4_3,
    DKRatioTypeNone
    };

//(_optionId == K_RATIO_ID_NO_FORMAT
//        || _optionId == K_RATIO_ID_4_3
//        || _optionId == K_RATIO_ID_3_4
//        || _optionId == K_RATIO_ID_3_2
//        || _optionId == K_RATIO_ID_3_1
//        || _optionId == K_RATIO_ID_2_3
//        || _optionId == K_RATIO_ID_1_1
//        || _optionId == K_RATIO_ID_16_9
//        || _optionId == K_RATIO_ID_5_1
//        );

typedef NSInteger DKRatioType;

@interface DKRatio : NSObject

@property (nonatomic) DKRatioType   type;
@property (nonatomic) CGSize        values;

+ (DKRatio *)ratioForSize:(CGSize)size;
+ (DKRatio *)ratioForWidth:(CGFloat)width height:(CGFloat)height;
+ (DKRatio *)ratioForType:(DKRatioType)type;

@end
