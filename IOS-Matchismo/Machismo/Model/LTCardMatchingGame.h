// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

NS_ASSUME_NONNULL_BEGIN

@class LTDeck;
@class LTCard;

@interface LTCardMatchingGame : NSObject

//designated initializer
- (instancetype) initWithCardCount:(NSUInteger) count usingDeck:(LTDeck *) deck;

- (instancetype) initWithCardCount:(NSUInteger) count
                         usingDeck:(LTDeck *) deck
    withAllowedNumberOfChosenCards:(NSUInteger) number;

- (void) chooseCardAtIndex:(NSUInteger) index;

- (LTCard *) cardAtIndex:(NSUInteger) index;

@property (nonatomic, readonly) NSInteger score;

@property (nonatomic) NSUInteger allowedNumberOfChosenCards;

@property (nonatomic, readonly) NSInteger lastConsiderationResult;

@property (nonatomic, strong, readonly) NSArray *lastConsiderationCards;

@end

NS_ASSUME_NONNULL_END
