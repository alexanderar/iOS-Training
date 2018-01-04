// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTPlayingCardDeck.h"
#import "LTPlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTPlayingCardDeck
- (instancetype)init{
  if (self = [super init])
  {
    for (NSString *suit in [LTPlayingCard validSuits]){
      for (NSUInteger rank = 1; rank <= [LTPlayingCard maxRank]; rank++){
        LTPlayingCard *card = [[LTPlayingCard alloc] init];
        card.suit = suit;
        card.rank = rank;
        [self addCard:card];
      }
    }
  }
  return self;
}
@end

NS_ASSUME_NONNULL_END
