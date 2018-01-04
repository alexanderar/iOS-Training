// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@class LTCard;
@interface LTDeck : NSObject

- (void)addCard:(LTCard *)card atTop:(BOOL)atTop;
- (void)addCard:(LTCard *)card;

- (LTCard *) drawRandomCard;
- (BOOL) isEmpty;
@end

NS_ASSUME_NONNULL_END
