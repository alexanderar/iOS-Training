// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.


#import "LTCard.h"

NS_ASSUME_NONNULL_BEGIN
/// Object that represents a card in playing Card matching game
@interface LTPlayingCard : LTCard

///Returns maximal rank of a card that could be used in the game
+(NSUInteger)maxRank;

///Returns an arrray of all valid suits that could be used in the game
+(NSArray *)validSuits;

///Card rank
@property (nonatomic) NSUInteger rank;

///Card suit
@property (strong, nonatomic) NSString *suit;

@end
NS_ASSUME_NONNULL_END
