// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTPlayingCardGameViewController.h"
#import "LTPlayingCardDeck.h"
#import "LTCard.h"
#import "LTPlayCardMatchingGame.h"
NS_ASSUME_NONNULL_BEGIN

@implementation LTPlayingCardGameViewController

- (UIImage *)backgroundImageForCard:(LTCard *)card {
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}
- (NSAttributedString *)titleForCard:(LTCard *)card {
  return card.isChosen ? [self cardContent:card] : [[NSAttributedString alloc]initWithString: @""];
}

//Abstract
- (NSAttributedString *)cardContent:(LTCard *)card {
  return [[NSAttributedString alloc]initWithString: card.contents];
}

-(LTCardMatchingGame *)createGameWithCardCount:(NSUInteger) count {
  return [[LTPlayCardMatchingGame alloc]initWithCardCount:count];
}

@end

NS_ASSUME_NONNULL_END
