// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardGameConfigProvider.h"
#import "LTSetCardDeck.h"
#import "LTSetCardMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTSetCardGameConfigProvider

@synthesize matcher = _matcher;

- (instancetype)init
{
  if (self = [super init]) {
    _matcher = [[LTSetCardMatcher alloc] init];
  }
  return self;
}

- (LTDeck *)createDeck {
  return [[LTSetCardDeck alloc] init];
}

- (id<LTCardMatcherProtocol>)matcher {
  return _matcher;
}

- (NSUInteger)initialCardCount {
  return 12;
}

-(NSUInteger)allowedNumberOfChosenCards {
  return 3;
}

@end

NS_ASSUME_NONNULL_END
