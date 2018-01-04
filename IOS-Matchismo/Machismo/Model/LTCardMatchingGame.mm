// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCardMatchingGame.h"
#import "LTDeck.h"
#import "LTCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;

@property (nonatomic,strong) NSMutableArray* cards; //of LTCard

// Contains result of last consideration triggered by choosing a card
@property (nonatomic, readwrite) NSInteger lastConsiderationResult;

@property (nonatomic, strong, readwrite) NSArray *lastConsiderationCards;

@end

@implementation LTCardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
static const int DEFAULT_ALLOWED_NUMBER_OF_CHOSEN_CARDS = 2;

- (NSMutableArray *) cards {
  if(!_cards)_cards = [[NSMutableArray alloc] init];
  return _cards;
}

- (NSArray *)lastConsiderationCards{
  if(!_lastConsiderationCards) {
    _lastConsiderationCards = [[NSArray alloc] init];
  }
  return _lastConsiderationCards;
}

- (instancetype) initWithCardCount:(NSUInteger)count usingDeck:(LTDeck *)deck
{
  self = [super init];
  if(self)
  {
    self.allowedNumberOfChosenCards = DEFAULT_ALLOWED_NUMBER_OF_CHOSEN_CARDS;
    for (int i = 0; i < count; i++) {
      LTCard *card = [deck drawRandomCard];
      if(card) {
        [self.cards addObject:card];
      } else {
        self = nil;
        break;
      }
    }
  }
  return self;
}

- (instancetype) initWithCardCount:(NSUInteger)count
                         usingDeck:(LTDeck *)deck
    withAllowedNumberOfChosenCards:(NSUInteger)number {
  self = [self initWithCardCount:count usingDeck:deck];
  if(self) {
    self.allowedNumberOfChosenCards = number;
  }
  return self;
}

- (LTCard *)cardAtIndex:(NSUInteger) index {
  return index < [self.cards count] ? self.cards[index] : nil;
}

- (int) matchCards:(NSMutableArray *) chosenCards{
  int matchScore = 0;
  NSUInteger numberOfOtherChosenCards = [chosenCards count];
  for (int i = 0; i < numberOfOtherChosenCards - 1; i++) {
    NSRange range = NSMakeRange(i + 1, numberOfOtherChosenCards - 1 - i);
    matchScore += [chosenCards[i] match: [chosenCards subarrayWithRange:range]];
  }
  return matchScore;
}

- (void) updateLastConsiderationResult:(NSInteger) result
                              forCards:(NSArray *) cards {
  self.lastConsiderationResult = result;
  self.lastConsiderationCards = [cards copy];
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
  LTCard *touchedCard = [self cardAtIndex:index];
  NSMutableArray* chosenCards = [[NSMutableArray alloc] init];
  int scoreChange = 0;
  if(!touchedCard.isMatched) {
    for (LTCard *card in self.cards) {
      if(card.isChosen && !card.isMatched) {
        [chosenCards addObject:card];
      }
    }
    if(touchedCard.isChosen) {
      touchedCard.chosen = NO;
      [chosenCards removeObject:touchedCard];
    } else {
      touchedCard.chosen = YES;
      [chosenCards insertObject:touchedCard atIndex:0];
      NSUInteger numberOfOtherChosenCards = [chosenCards count];
      
      if(numberOfOtherChosenCards == self.allowedNumberOfChosenCards)
      {
        int matchScore = [self matchCards: chosenCards];
        if(matchScore){
          scoreChange = matchScore * MATCH_BONUS;
          touchedCard.matched = YES;
          for (LTCard* chosenCard in chosenCards) {
            chosenCard.matched = YES;
          }
        } else {
          scoreChange = (int)-(MISMATCH_PENALTY * numberOfOtherChosenCards);
          for (LTCard* chosenCard in chosenCards) {
              chosenCard.chosen = NO;
          }
        }
        self.score += scoreChange;
      }
      self.score -= COST_TO_CHOOSE;
    }
    [self updateLastConsiderationResult:scoreChange forCards:[chosenCards copy]];
  }
}

@end

NS_ASSUME_NONNULL_END
