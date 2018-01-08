// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCard.h"

NS_ASSUME_NONNULL_BEGIN

@class UIColor;
@interface LTSetCard : LTCard

typedef NS_ENUM(NSInteger, LTSetCardShade) {
  LTSetCardShadeOpen = 0,
  LTSetCardShadeStriped = 1,
  LTSetCardShadeSolid = 2
};

+(NSUInteger)maxNumber;
+(NSSet<NSString *> *)validShapes;
+(NSSet<UIColor *> *)validColors;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithShape:(NSString *)shape color:(UIColor *)color shade:(LTSetCardShade)shade
    number:(NSUInteger) number NS_DESIGNATED_INITIALIZER;

@property (readonly, nonatomic) NSInteger number;
@property (readonly, nonatomic) LTSetCardShade shade;
@property (readonly, nonatomic) NSString *shape;
@property (readonly, nonatomic) UIColor *color;

@end


NS_ASSUME_NONNULL_END
