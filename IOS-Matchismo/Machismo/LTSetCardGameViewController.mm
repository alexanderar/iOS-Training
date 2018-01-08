// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardGameViewController.h"
#import "LTSetCardMatchingGame.h"
#import "LTSetCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardGameViewController

- (UIImage *)backgroundImageForCard:(LTCard *)card {
  return [UIImage imageNamed:card.isChosen ? @"setCardCardfront" : @"cardfront"];
}
- (NSAttributedString *)titleForCard:(LTCard *)card {
  return card.contents;
}

- (LTCardMatchingGame *)createGameWithCardCount:(NSUInteger) count{
  return [[LTSetCardMatchingGame alloc]initWithCardCount:count];
}

@end

NS_ASSUME_NONNULL_END
