// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCardMatchingGame.h"
#import "LTDeck.h"
#import "LTCard.h"
#import "LTGameIterationResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTCardMatchingGame()

/// Array of cards that are used in current game.
@property (nonatomic,strong) NSMutableArray<LTCard *> *cards;

/// Backing property for public readonly history property.
@property (nonatomic) NSMutableArray<LTGameIterationResult *> *gameStateHistory;

/// Backing property for the public readonly score property.
@property (nonatomic, readwrite) NSInteger score;

@property (nonatomic) NSMutableArray <LTCard *> *chosenCards;

@end

@implementation LTCardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

# pragma mark -
# pragma mark Initialization
# pragma mark -

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(LTDeck *)deck {
  if (self = [super init]) {
    _cards = [[NSMutableArray alloc] init];
    _chosenCards = [[NSMutableArray alloc] init];
    _gameStateHistory = [[NSMutableArray alloc] init];
     _cardCount = count;
    if(![self resetGame]) {
      return nil;
    }
  }
  return self;
}

# pragma mark -
# pragma mark Public API
# pragma mark -

- (BOOL)resetGame {
  [self.cards removeAllObjects];
  LTDeck *deck = [self createDeck];
  for (int i = 0; i < self.cardCount; i++) {
    LTCard *card = [deck drawRandomCard];
    if (card) {
      [self.cards addObject:card];
    } else {
      return NO;
    }
  }
  [self.gameStateHistory removeAllObjects];
  self.score = 0;
  return YES;
}

- (LTDeck *)createDeck {
  return nil;
}

- (int)match:(NSArray<LTCard *> *)cards{
  return 0;
}

- (LTCard *)cardAtIndex:(NSUInteger)index {
  return index < [self.cards count] ? self.cards[index] : nil;
}

-(void)chooseCard:(LTCard *)chosenCard {
  //auto chosenCards = [[NSMutableArray alloc] init];
  int scoreChange = 0;
  if(chosenCard.isMatched) {
    return;
  }
  
  if (chosenCard.isChosen) {
    chosenCard.chosen = NO;
    [self.chosenCards removeObject:chosenCard];
  } else {
    chosenCard.chosen = YES;
    [self.chosenCards insertObject:chosenCard atIndex:0];
    NSUInteger numberOfOtherChosenCards = [self.chosenCards count];
    
    if (numberOfOtherChosenCards == self.allowedNumberOfChosenCards) {
      int matchScore = [self match: self.chosenCards];
      if (matchScore){
        scoreChange = matchScore * MATCH_BONUS;
        for (LTCard* card in self.chosenCards) {
          card.matched = YES;
        }
        [self.chosenCards removeAllObjects];
      } else {
        scoreChange = (int)-(MISMATCH_PENALTY * numberOfOtherChosenCards);
        for (int i = 1; i < self.chosenCards.count; ++i ) {
          self.chosenCards[i].chosen = NO;
          [self.chosenCards removeObjectAtIndex:i];
        }
      }
      self.score += scoreChange;
    }
    self.score -= COST_TO_CHOOSE;
  }
  [self updateHistory:scoreChange forCards:[self.chosenCards copy]];
}

- (void)chooseCardAtIndex:(NSUInteger)index {
  LTCard *touchedCard = [self cardAtIndex:index];
  [self chooseCard:touchedCard];
}


- (void)updateHistory:(NSInteger)result forCards:(NSArray *)cards {
  [self.gameStateHistory addObject:[[LTGameIterationResult alloc]initWithCards:cards
    withScore:result]];
}

# pragma mark -
# pragma mark Properties
# pragma mark -

- (NSArray<LTGameIterationResult *> *)history {
  return self.gameStateHistory;
}

@end

NS_ASSUME_NONNULL_END
