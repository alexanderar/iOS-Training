// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTPlayingCardGameViewController.h"
#import "LTPlayingCard.h"
#import "LTPlayingCardGameConfigProvider.h"
#import "LTPlayingCardView.h"
#import "LTGrid.h"
NS_ASSUME_NONNULL_BEGIN

@implementation LTPlayingCardGameViewController

- (LTCardMatchingGame *)createGame{
  return [[LTCardMatchingGame alloc] initWithConfigurationProvider:
          [[LTPlayingCardGameConfigProvider alloc] init]];
}

@end

NS_ASSUME_NONNULL_END
