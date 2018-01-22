// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTPLayingCardMatcher.h"
#import "LTPlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTPLayingCardMatcher

- (int)match:(NSArray<LTPlayingCard *> *)cards{
  int matchScore = 0;
  NSUInteger numberOfOtherChosenCards = [cards count];
  for (int i = 0; i < numberOfOtherChosenCards - 1; i++) {
    NSRange range = NSMakeRange(i + 1, numberOfOtherChosenCards - 1 - i);
    matchScore += [LTPLayingCardMatcher matchSingleCard:cards[i]
                                                 toOthers:[cards subarrayWithRange:range]];
  }
  return matchScore;
}

+ (int)matchSingleCard:(LTPlayingCard *)card toOthers:(NSArray<LTPlayingCard *> *) otherCards
{
  int score  = 0;
  for (LTPlayingCard *otherCard in otherCards) {
    if(card.rank == otherCard.rank) {
      score += 4;
    }
    if([card.suit isEqualToString:otherCard.suit]) {
      score += 1;
    }
  }
  return score;
}
@end

NS_ASSUME_NONNULL_END
