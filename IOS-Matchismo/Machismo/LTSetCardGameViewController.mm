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

- (void)refreshCardsGrid {
  [super refreshCardsGrid];
  BOOL removedViews = NO;
  NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];
  for (int i = 0; i < self.cardsContainerView.subviews.count; ++i) {
    LTCardView *cardView = (LTCardView *)self.cardsContainerView.subviews[i];
    if(cardView.card.isMatched) {
      [viewsToRemove addObject:cardView];
      removedViews = YES;
    }
  }
  [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
  if (removedViews) {
    self.cardsDisplayGridHelper.minimumNumberOfCells = self.cardsContainerView.subviews.count;
    for (int i = 0; i < self.cardsContainerView.subviews.count; ++i) {
      LTCardView *cardView = (LTCardView *)self.cardsContainerView.subviews[i];
      CGRect frame = [self.cardsDisplayGridHelper
                      frameOfCellAtRow:(i / self.cardsDisplayGridHelper.columnCount)
                      inColumn:(i % self.cardsDisplayGridHelper.columnCount)];
      UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.2f
          curve:UIViewAnimationCurveEaseInOut animations:^{
            cardView.frame = frame;
          }];
      [animator startAnimationAfterDelay:i * 0.03f];
      [animator startAnimation];
      
    }
  }
}

@end

NS_ASSUME_NONNULL_END
