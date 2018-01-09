// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCardMatchingGame.h"
#import "LTDeck.h"
#import "LTCard.h"
#import "LTGameIterationResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCardMatchingGame()

///Number of cards that are used in current game.
@property (readonly, nonatomic) NSUInteger cardCount;

///Array of cards that are used in current game.
@property (nonatomic,strong) NSMutableArray<LTCard *> *cards;

///Backing property for public readonly history property.
@property (nonatomic) NSMutableArray<LTGameIterationResult *> *gameStateHistory;

///Backing property for the public readonly score property.
@property (nonatomic, readwrite) NSInteger score;

@end

@implementation LTCardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(LTDeck *)deck {
  if (self = [super init]) {
    _cardCount = count;
    if(![self resetGame]) {
      return nil;
    }
  }
  return self;
}

- (BOOL)resetGame {
  _cards = [[NSMutableArray alloc] init];
  LTDeck *deck = [self createDeck];
  for (int i = 0; i < self.cardCount; i++) {
    LTCard *card = [deck drawRandomCard];
    if(card) {
      [self.cards addObject:card];
    } else {
      return NO;
    }
  }
  _gameStateHistory = [[NSMutableArray alloc] init];
  return YES;
}

-(LTDeck *)createDeck {
  return nil;
}

-(int)match:(NSArray<LTCard *> *)cards{
  return 0;
}

-(NSArray<LTGameIterationResult *> *)history {
  return self.gameStateHistory;
}


- (LTCard *)cardAtIndex:(NSUInteger)index {
  return index < [self.cards count] ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index {
  LTCard *touchedCard = [self cardAtIndex:index];
  auto chosenCards = [[NSMutableArray alloc] init];
  int scoreChange = 0;
  if(touchedCard.isMatched) {
    return;
  }
  
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
    
    if(numberOfOtherChosenCards == self.allowedNumberOfChosenCards) {
      int matchScore = [self match: chosenCards];
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
  [self updateHistory:scoreChange forCards:[chosenCards copy]];
}


- (void)updateHistory:(NSInteger)result forCards:(NSArray *)cards {
  [self.gameStateHistory addObject:[[LTGameIterationResult alloc]initWithCards:cards
    withScore:result]];
}

@end

NS_ASSUME_NONNULL_END
