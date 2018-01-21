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

/// Backing property for the public readonly score property.
@property (nonatomic, readwrite) NSInteger score;

@property (nonatomic) NSMutableArray <LTCard *> *chosenCards;

@property (nonatomic) LTDeck *deckOfCards;

@property (nonatomic) NSUInteger cardCount;

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
    _deckOfCards = deck;
    _cards = [[NSMutableArray alloc] init];
    _chosenCards = [[NSMutableArray alloc] init];
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
  self.deckOfCards = [self createDeck];
  for (int i = 0; i < self.cardCount; i++) {
    LTCard *card = [self.deckOfCards drawRandomCard];
    if (card) {
      [self addCardsObject:card];
    } else {
      return NO;
    }
  }
  self.score = 0;
  return YES;
}

- (LTDeck *)createDeck {
  return nil;
}

- (NSArray *)addCardsToGame:(NSUInteger)numberOfCards {
  auto newCards = [[NSMutableArray alloc] initWithCapacity:numberOfCards];
  if(!self.deckOfCards.isEmpty) {
    self.cardCount += MIN(numberOfCards, self.deckOfCards.remainingCardsCount);
  }
  for (int i = 0; i < numberOfCards; ++i) {
    LTCard *card = [self.deckOfCards drawRandomCard];
    if (card) {
      [self addCardsObject:card];
      [newCards addObject:card];
    }
  }
  return newCards;
}

- (int)match:(NSArray<LTCard *> *)cards{
  return 0;
}

- (LTCard *)cardAtIndex:(NSUInteger)index {
  return index < [self.cards count] ? self.cards[index] : nil;
}

-(void)chooseCard:(LTCard *)chosenCard {
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
}

- (void)chooseCardAtIndex:(NSUInteger)index {
  LTCard *touchedCard = [self cardAtIndex:index];
  [self chooseCard:touchedCard];
}

- (void)registerObserverForGameCards:(id)observer {
  [self addObserver:observer
            forKeyPath:@"cards"
               options:(NSKeyValueObservingOptionNew |
                        NSKeyValueObservingOptionOld)
               context:nil];
}

- (void)removeObserverForGameCards:(id)observer {
  @try {
    [self removeObserver:observer forKeyPath:@"cards"];
  }
  @catch (NSException * __unused exception) {}
}

# pragma mark -
# pragma mark - KVC compliant accessors
# pragma mark -

- (void)addCardsObject:(LTCard *)card {
  [self insertObject:card inCardsAtIndex:[self.cards count]];
}

- (void)insertObject:(LTCard *)card inCardsAtIndex:(NSUInteger)index {
  [self.cards insertObject:card atIndex:index];
}

- (void)removeObjectFromCardsAtIndex:(NSUInteger)index {
  [self.cards removeObjectAtIndex:index];
}

# pragma mark -
# pragma mark Properties
# pragma mark -

- (NSArray *)gameCards{
  return self.cards;
}

@end

NS_ASSUME_NONNULL_END
