// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCardMatchingGame.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that represnts a set card matching game.
@interface LTSetCardMatchingGame : LTCardMatchingGame

- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// Encapsulates base LTCardMatchingGame initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(LTDeck *)deck NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
