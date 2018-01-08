// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@class LTCard, LTDeck, LTGameIterationResult;

@interface LTCardMatchingGame : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(LTDeck *) deck
    NS_DESIGNATED_INITIALIZER;

- (LTCard *)cardAtIndex:(NSUInteger) index;

- (void)chooseCardAtIndex:(NSUInteger) index;

- (BOOL)resetGame;

//abstract
- (LTDeck *)createDeck;

//abstract
- (int)match:(NSArray *)cards;

@property (readonly, nonatomic) NSUInteger allowedNumberOfChosenCards;
@property (readonly, nonatomic) NSInteger score;
@property (readonly, nonatomic) NSArray<LTGameIterationResult *> *history;

@end

NS_ASSUME_NONNULL_END
