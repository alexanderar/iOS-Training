// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTPlayingCardGameViewController.h"
#import "LTPlayingCard.h"
#import "LTPlayCardMatchingGame.h"
#import "LTPlayingCardView.h"
#import "LTGrid.h"
NS_ASSUME_NONNULL_BEGIN

@implementation LTPlayingCardGameViewController

- (LTCardMatchingGame *)createGameWithCardCount:(NSUInteger) count {
  return [[LTPlayCardMatchingGame alloc]initWithCardCount:count];
}

- (UIView *)createViewFor:(LTPlayingCard *)card withFrame:(CGRect)frame {
  auto cardView = [[LTPlayingCardView alloc]initWithFrame:frame];
  cardView.card = card;
  return cardView;
}


@end

NS_ASSUME_NONNULL_END
