// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

@class LTCard;
@interface LTDeck : NSObject

- (void)addCard:(LTCard *)card atTop:(BOOL)atTop;
- (void)addCard:(LTCard *)card;

- (LTCard *) drawRandomCard;
- (BOOL) isEmpty;
@end

