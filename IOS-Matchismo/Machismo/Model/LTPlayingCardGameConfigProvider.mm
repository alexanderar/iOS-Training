// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTPlayingCardGameConfigProvider.h"
#import "LTPLayingCardMatcher.h"
#import "LTPlayingCardDeck.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTPlayingCardGameConfigProvider

@synthesize matcher = _matcher;

- (instancetype)init
{
  if (self = [super init]) {
     _matcher = [[LTPLayingCardMatcher alloc] init];
  }
  return self;
}

- (NSUInteger)allowedNumberOfChosenCards{
  return 2;
}

- (NSUInteger)initialCardCount {
  return 30;
}

- (LTDeck *)createDeck {
  return [[LTPlayingCardDeck alloc] init];
}

- (id<LTCardMatcherProtocol>) matcher {
  return _matcher;
}

@end

NS_ASSUME_NONNULL_END
