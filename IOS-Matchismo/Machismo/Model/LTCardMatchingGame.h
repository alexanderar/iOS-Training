// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCardGameConfigProviderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class LTCard, LTDeck, LTGameIterationResult;

/// Abstract object that represents any card matching game. All particular games should derive
/// from this object.
@interface LTCardMatchingGame : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithConfigurationProvider:(id <LTCardGameConfigProviderProtocol>)provider
    NS_DESIGNATED_INITIALIZER;

/// Returns card at specific \c index.
- (LTCard *)cardAtIndex:(NSUInteger)index;

/// Chooses a card at specific \c index. Once number of chosen cards reaches an allowed number of
/// chosen cards that is configured for the game, matchisng logic is triggerd.
- (void)chooseCardAtIndex:(NSUInteger)index;

/// Chooses a given /c card. Once number of chosen cards reaches an allowed number of chosen cards
/// that is configured for the game, matchisng logic is triggerd.
- (void)chooseCard:(LTCard *)card;

/// Returns a matching score for the given \c cards array. Abstract method that should be
/// implemented in derived class.
- (int)match:(NSArray *)cards;

/// Adds /c numberOfCards to the current game and returns them in the array.
- (NSArray *)addCardsToGame:(NSUInteger) numberOfCards;

/// Resets the game by reseting the score to 0, and redialing new set of cards by using new deck.
- (BOOL)resetGame;

/// Registers the given /c observer to be notified on changes in cards property.
- (void)registerObserverForGameCards:(id)observer;

/// Removes the given /c observer from listening on cards property.
- (void)removeObserverForGameCards:(id)observer ;

/// Current game score.
@property (readonly, nonatomic) NSInteger score;

/// Number of cards that are used in current game.
@property (readonly, nonatomic) NSUInteger cardCount;

/// Array of cards that are currently used in game.
@property (readonly, nonatomic) NSArray *gameCards;

@end

NS_ASSUME_NONNULL_END
