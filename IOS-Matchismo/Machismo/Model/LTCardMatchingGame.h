// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@class LTCard, LTDeck;

@interface LTCardMatchingGame : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(LTDeck *) deck
    NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(LTDeck *)deck
   withAllowedNumberOfChosenCards:(NSUInteger)number;

- (LTCard *)cardAtIndex:(NSUInteger) index;

- (void)chooseCardAtIndex:(NSUInteger) index;


@property (nonatomic) NSUInteger allowedNumberOfChosenCards;
@property (nonatomic, readonly) NSArray *lastConsiderationCards;
@property (nonatomic, readonly) NSInteger lastConsiderationResult;
@property (readonly, nonatomic) NSInteger score;

@end

NS_ASSUME_NONNULL_END
