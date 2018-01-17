// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardGameViewController.h"
#import "LTSetCardMatchingGame.h"
#import "LTSetCard.h"
#import "LTSetCardView.h"
#import "LTGrid.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardGameViewController

- (LTCardMatchingGame *)createGameWithCardCount:(NSUInteger)count{
  return [[LTSetCardMatchingGame alloc] initWithCardCount:count];
}

- (UIView *)createViewFor:(LTSetCard *)card withFrame:(CGRect)frame {
  auto cardView = [[LTSetCardView alloc]initWithFrame:frame];
  cardView.card = card;
  return cardView;
}

- (void)refreshCardsGridAnimated:(BOOL)animated withCompletion:(nullable void (^)())callback {
  [super refreshCardsGridAnimated:animated withCompletion:nil];
  NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];
  for (int i = 0; i < self.cardsContainerView.subviews.count; ++i) {
    LTCardView *cardView = (LTCardView *)self.cardsContainerView.subviews[i];
    if(cardView.card.isMatched) {
      [viewsToRemove addObject:cardView];
    }
  }
  [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
  int numberOfCardsToDisplayInTheGrid = 0;
  for (LTCard *card in self.game.gameCards) {
    if (!card.isMatched) {
      ++numberOfCardsToDisplayInTheGrid;
    }
  }
  self.cardsDisplayGridHelper.minimumNumberOfCells = numberOfCardsToDisplayInTheGrid;
  __weak LTSetCardGameViewController *weakSelf = self;
  void (^refreshCardsBlock)(void) = ^{
    for (int i = 0; i < weakSelf.cardsContainerView.subviews.count; ++i) {
      LTCardView *cardView = (LTCardView *)weakSelf.cardsContainerView.subviews[i];
      CGRect frame = [weakSelf.cardsDisplayGridHelper
                      frameOfCellAtRow:(i / weakSelf.cardsDisplayGridHelper.columnCount)
                      inColumn:(i % weakSelf.cardsDisplayGridHelper.columnCount)];
      float sigma = 0.00001;
      if(abs(cardView.frame.size.width - frame.size.width) > sigma
         || abs(cardView.frame.size.height - frame.size.height) > sigma
         || abs(cardView.frame.origin.x - frame.origin.x) > sigma
         || abs(cardView.frame.origin.y - frame.origin.y) > sigma) {
          cardView.frame = frame;
      }
    }
  };
  if (animated) {
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.2f
    curve:UIViewAnimationCurveEaseInOut animations:refreshCardsBlock];
    if (callback) {
      [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        callback();
      }];
    }
    [animator startAnimation];
  }
  else {
    refreshCardsBlock();
    callback();
  }
}

#define NUMBER_OF_ADDITIONAL_CARDS_TO_ADD 3

- (void)requestAdditionalCards:(UITapGestureRecognizer *)deckView {
  NSArray *addedCards = [self.game addCardsToGame:NUMBER_OF_ADDITIONAL_CARDS_TO_ADD];
  if ([addedCards count] < NUMBER_OF_ADDITIONAL_CARDS_TO_ADD)
  {
    self.cardDeckView.userInteractionEnabled = NO;
    self.cardDeckView.alpha = 0.7f;
  }
}

- (void)initGame {
  [super initGame];
  self.cardDeckView.userInteractionEnabled = YES;
  self.cardDeckView.alpha = 1;
  [self.cardDeckView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
      action:@selector(requestAdditionalCards:)]];
}

@end

NS_ASSUME_NONNULL_END
