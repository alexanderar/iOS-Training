// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardMatcher.h"
#import "LTSetCardDeck.h"
#import "LTSetCard.h"
#import "UIKit/UiKit.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardMatcher

- (int)match:(NSArray *)cards {
  int score = 0;
  if (cards && cards.count > 0) {
    BOOL matchByShade = [LTSetCardMatcher colorMatch:cards];
    BOOL matchByShape = [LTSetCardMatcher shadeMatch:cards];
    BOOL matchByNumber = [LTSetCardMatcher shapeMatch:cards];
    BOOL matchByColor =  [LTSetCardMatcher numberMatch:cards];
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
  return [LTSetCardMatcher validateMatchOnDictionary:colorMatches];
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
  return [LTSetCardMatcher validateMatchOnDictionary:shadeMatches];
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
  return [LTSetCardMatcher validateMatchOnDictionary:shapeMatches];
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
  return [LTSetCardMatcher validateMatchOnDictionary:numberMatches];
}

+ (BOOL)validateMatchOnDictionary:(NSDictionary *)dictionary {
  for (id key in dictionary) {
    if ([dictionary[key] integerValue] == 2) {
      return NO;
    }
  }
  return YES;
}

@end

NS_ASSUME_NONNULL_END
