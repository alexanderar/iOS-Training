// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.


#import "LTCard.h"

NS_ASSUME_NONNULL_BEGIN
@interface LTPlayingCard : LTCard

+(NSUInteger)maxRank;
+(NSArray *)validSuits;

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@end
NS_ASSUME_NONNULL_END
