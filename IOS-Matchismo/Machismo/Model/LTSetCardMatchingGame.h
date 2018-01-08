// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCardMatchingGame.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSetCardMatchingGame : LTCardMatchingGame
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCardCount:(NSUInteger)count NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(LTDeck *)deck NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
