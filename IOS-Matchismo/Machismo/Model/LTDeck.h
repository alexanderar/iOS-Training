// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@class LTCard;

///Object that repersents a generic deck of cards that is used in any card matching game.
@interface LTDeck : NSObject

///Adds card to the deck. If \atTop is YES than the card is added to the top of the deck.
- (void)addCard:(LTCard *)card atTop:(BOOL)atTop;

///Adds card to the deck.
- (void)addCard:(LTCard *)card;

/// Draws random card from the deck.
- (LTCard *)drawRandomCard;

/// Indicates whether deck is empty.
- (BOOL) isEmpty;

@end

NS_ASSUME_NONNULL_END
