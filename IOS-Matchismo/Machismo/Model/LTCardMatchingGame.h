// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@class LTCard, LTDeck, LTGameIterationResult;

/// Abstract object that represents any card matching game. All particular games should derive
/// from this object.
@interface LTCardMatchingGame : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes new card matching game with \c count number of cards using \c deck.
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(LTDeck *) deck
    NS_DESIGNATED_INITIALIZER;

/// Returns card at specific \c index.
- (LTCard *)cardAtIndex:(NSUInteger)index;

/// Chooses a card at specific \c index. Once number of chosen cards reaches an allowed number of
/// chosen cards that is configured for the game, matchisng logic is triggerd.
- (void)chooseCardAtIndex:(NSUInteger)index;

- (void)chooseCard:(LTCard *)card;

/// Creates a deck of cards. Abstract method that should be implemented in derived class.
- (LTDeck *)createDeck;

/// Returns a matching score for the given \c cards array. Abstract method that should be
/// implemented in derived class.
- (int)match:(NSArray *)cards;

/// Resets the game
- (BOOL)resetGame;

/// Number of chosen cards that's when reached should trigger a matching logic.
@property (readonly, nonatomic) NSUInteger allowedNumberOfChosenCards;

/// Current game score
@property (readonly, nonatomic) NSInteger score;

/// Game history - contains all the choises and matching result that were performed through the game
/// since reset.
@property (readonly, nonatomic) NSArray<LTGameIterationResult *> *history;

/// Number of cards that are used in current game.
@property (readonly, nonatomic) NSUInteger cardCount;

@end

NS_ASSUME_NONNULL_END
