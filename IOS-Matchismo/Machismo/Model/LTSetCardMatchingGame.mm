// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardMatchingGame.h"
#import "LTSetCardDeck.h"
#import "LTSetCard.h"
#import "UIKit/UiKit.h"
NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardMatchingGame

#define INITIAL_CARD_COUNT 12

- (instancetype)init {
  
  if (self = [super initWithCardCount:INITIAL_CARD_COUNT usingDeck: [[LTSetCardDeck alloc] init]])
  {
    return self;
  }
  return nil;
}

- (LTDeck *)createDeck {
  return [[LTSetCardDeck alloc] init];
}

- (int)match:(NSArray *)cards {
  int score = 0;
  if (cards && cards.count > 0) {
    BOOL matchByShade = [LTSetCardMatchingGame colorMatch:cards];
    BOOL matchByShape = [LTSetCardMatchingGame shadeMatch:cards];
    BOOL matchByNumber = [LTSetCardMatchingGame shapeMatch:cards];
    BOOL matchByColor =  [LTSetCardMatchingGame numberMatch:cards];
    score =  matchByShade && matchByShape && matchByNumber && matchByColor ? 5 :0;
  }
  return score;
}

+ (BOOL)colorMatch:(NSArray *)cards {
  auto *colorMatches = [[NSMutableDictionary alloc]init];
  for (UIColor *color in  LTSetCard.validColors) {
    colorMatches[color] = @0;
  }
  for (LTSetCard *card in cards) {
    int currentValue = (int)[colorMatches[card.colorHexString] integerValue];
    colorMatches[card.colorHexString] =  [NSNumber numberWithInt:(currentValue + 1)];
  }
  return [LTSetCardMatchingGame validateMatchOnDictionary:colorMatches];
}

+ (BOOL)shadeMatch:(NSArray *)cards {
  auto *shadeMatches = [[NSMutableDictionary alloc] initWithDictionary: @{
      [NSNumber numberWithInt:LTSetCardShadeUnfilled]:@0,
      [NSNumber numberWithInt:LTSetCardShadeStriped]:@0,
      [NSNumber numberWithInt:LTSetCardShadeSolid]:@0
      }];
  for (LTSetCard *card in cards) {
    int currentValue = (int)[shadeMatches[@((int)card.shade)] integerValue];
    shadeMatches[@((int)card.shade)] =  [NSNumber numberWithInt:(currentValue + 1)];
  }
  return [LTSetCardMatchingGame validateMatchOnDictionary:shadeMatches];
}

+ (BOOL)shapeMatch:(NSArray *)cards {
  auto *shapeMatches = [[NSMutableDictionary alloc]init];
  for (NSString *shape in  LTSetCard.validShapes) {
    shapeMatches[shape] = @0;
  }
  for (LTSetCard *card in cards) {
    int currentValue = (int)[shapeMatches[card.shape] integerValue];
    shapeMatches[card.shape] =  [NSNumber numberWithInt:(currentValue + 1)];
  }
  return [LTSetCardMatchingGame validateMatchOnDictionary:shapeMatches];
}

+ (BOOL)numberMatch:(NSArray *)cards {
  auto *numberMatches = [[NSMutableDictionary alloc]init];
  for (int i = 1; i<=LTSetCard.maxNumber; i++) {
    numberMatches[@(i)] = @0;
  }
  for (LTSetCard *card in cards) {
    int currentValue = (int)[numberMatches[@(card.number)] integerValue];
    numberMatches[@(card.number)] =  [NSNumber numberWithInt:(currentValue + 1)];
  }
  return [LTSetCardMatchingGame validateMatchOnDictionary:numberMatches];
}

+ (BOOL)validateMatchOnDictionary:(NSDictionary *)dictionary {
  for (id key in dictionary) {
    if ([dictionary[key] integerValue] == 2) {
      return NO;
    }
  }
  return YES;
}

- (NSUInteger)allowedNumberOfChosenCards {
  return 3;
}

@end

NS_ASSUME_NONNULL_END
