// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardMatchingGame.h"
#import "LTSetCardDeck.h"
#import "LTSetCard.h"
#import "UIKit/UiKit.h"
NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardMatchingGame


-(instancetype)initWithCardCount:(NSUInteger)count {
  
  if(self = [super initWithCardCount:count usingDeck: [[LTSetCardDeck alloc] init]])
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
  if(cards && cards.count > 0)
  {
    LTSetCard *firstCard = cards[0];
    BOOL matchByShade = [LTSetCardMatchingGame matchCards:cards
                                              byPredicate:[LTSetCardMatchingGame shadeMatchPredicateForCard:firstCard]];
    BOOL matchByShape = [LTSetCardMatchingGame matchCards:cards
                                              byPredicate:[LTSetCardMatchingGame shapeMatchPredicateForCard:firstCard]];
    BOOL matchByNumber = [LTSetCardMatchingGame matchCards:cards
                                               byPredicate:[LTSetCardMatchingGame numberMatchPredicateForCard:firstCard]];
    BOOL matchByColor =  [LTSetCardMatchingGame matchCards:cards
                                               byPredicate:[LTSetCardMatchingGame colorMatchPredicateForCard:firstCard]];
    score =  matchByShade && matchByShape && matchByNumber && matchByColor ? 5 :0;

  }
  return score;
}

+ (NSPredicate *)shapeMatchPredicateForCard:(LTSetCard *)card {

  return [NSPredicate predicateWithBlock:
          ^BOOL(LTSetCard *otherCard, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [card.shape isEqualToString:otherCard.shape];
          }];;
}

+ (NSPredicate *)shadeMatchPredicateForCard:(LTSetCard *)card {
  return  [NSPredicate predicateWithBlock:
           ^BOOL(LTSetCard *otherCard, NSDictionary<NSString *,id> * _Nullable bindings) {
             return (int)card.shade == (int)otherCard.shade;
           }];
}

+ (NSPredicate *)numberMatchPredicateForCard:(LTSetCard *)card {
  return [NSPredicate predicateWithBlock:
          ^BOOL(LTSetCard *otherCard, NSDictionary<NSString *,id> * _Nullable bindings) {
            return card.number == otherCard.number;
          }];
}

+ (NSPredicate *)colorMatchPredicateForCard:(LTSetCard *)card {
  return [NSPredicate predicateWithBlock:
          ^BOOL(LTSetCard *otherCard, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [card.color isEqual:otherCard.color];
          }];
}

+ (BOOL)matchCards:(NSArray *)cards byPredicate:(NSPredicate *) predicate{
  NSArray *filteredArray = [cards filteredArrayUsingPredicate:predicate];
  return filteredArray.count == 1 || filteredArray.count == cards.count;
}

- (NSUInteger)allowedNumberOfChosenCards {
  return 3;
}

@end

NS_ASSUME_NONNULL_END
