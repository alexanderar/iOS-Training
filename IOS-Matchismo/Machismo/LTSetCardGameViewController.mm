// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardGameViewController.h"
#import "LTSetCardGameConfigProvider.h"
#import "LTSetCard.h"
#import "LTSetCardView.h"
#import "LTGrid.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardGameViewController

- (LTCardMatchingGame *)createGame {
  return [[LTCardMatchingGame alloc] initWithConfigurationProvider:
          [[LTSetCardGameConfigProvider alloc] init]];
}

- (void)refreshCardsGridAnimated:(BOOL)animated {
  NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];
  for (int i = 0; i < self.cardsContainerView.subviews.count; ++i) {
    LTCardView *cardView = (LTCardView *)self.cardsContainerView.subviews[i];
    if(cardView.card.matched) {
      [viewsToRemove addObject:cardView];
    }
  }
  [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [super refreshCardsGridAnimated:animated];
}

#define NUMBER_OF_ADDITIONAL_CARDS_TO_ADD 3

- (void)requestAdditionalCards:(UITapGestureRecognizer *)deckView {
  NSArray *addedCards = [self.game addCardsToGame:NUMBER_OF_ADDITIONAL_CARDS_TO_ADD];
  if ([addedCards count] < NUMBER_OF_ADDITIONAL_CARDS_TO_ADD) {
    [self disableCardDeck];
  }
}

- (void)initGame {
  [super initGame];
  [self enableCardDeck];
}

- (void)enableCardDeck {
  self.cardDeckView.userInteractionEnabled = YES;
  self.cardDeckView.alpha = 1;
  [self.cardDeckView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
      action:@selector(requestAdditionalCards:)]];
}

- (void)disableCardDeck {
  self.cardDeckView.userInteractionEnabled = NO;
  self.cardDeckView.alpha = 0.7f;
}

@end

NS_ASSUME_NONNULL_END
