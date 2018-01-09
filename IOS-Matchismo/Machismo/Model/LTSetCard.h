// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCard.h"

NS_ASSUME_NONNULL_BEGIN

@class UIColor;

///Object that represents a card in Set card matching game.
@interface LTSetCard : LTCard

///An enum that repreasnts different shade options for the card.
typedef NS_ENUM(NSInteger, LTSetCardShade) {
  LTSetCardShadeOpen = 0,
  LTSetCardShadeStriped = 1,
  LTSetCardShadeSolid = 2
};

- (instancetype)init NS_UNAVAILABLE;

///Initializes a card with \c shape, \c color, \c shade and \c number.
- (instancetype)initWithShape:(NSString *)shape color:(UIColor *)color shade:(LTSetCardShade)shade
    number:(NSUInteger) number NS_DESIGNATED_INITIALIZER;

///Returns maximum number of shapes that could apper on the card.
+(NSUInteger)maxNumber;

///Returns a set of valid shapes for the card.
+(NSSet<NSString *> *)validShapes;

///Returns a set of valid colors for the card.
+(NSSet<UIColor *> *)validColors;

///Represents a number of shapes on the card.
@property (readonly, nonatomic) NSInteger number;

///Represents a shade of objects on the card.
@property (readonly, nonatomic) LTSetCardShade shade;

///Represents a shape of objects on the card.
@property (readonly, nonatomic) NSString *shape;

///Represents a color of objects on the card.
@property (readonly, nonatomic) UIColor *color;

@end


NS_ASSUME_NONNULL_END
