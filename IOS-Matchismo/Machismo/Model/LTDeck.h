// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@class LTCard;

/// Object that repersents a deck of cards that is used in card matching game.
@interface LTDeck : NSObject

/// Adds the given \c card the deck. If \c atTop is \c YES than the card is added to the top of
/// the deck.
- (void)addCard:(LTCard *)card atTop:(BOOL)atTop;

/// Adds the given \c card to the deck.
- (void)addCard:(LTCard *)card;

/// Draws random card from the deck. The returned card is removed from the deck.
- (LTCard *)drawRandomCard;

/// Indicates whether deck is empty.
- (BOOL)isEmpty;

@property (readonly)NSUInteger remainingCardsCount;

@end

NS_ASSUME_NONNULL_END
