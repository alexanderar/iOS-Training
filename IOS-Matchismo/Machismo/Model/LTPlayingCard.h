// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.


#import "LTCard.h"

@interface LTPlayingCard : LTCard

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
+(NSUInteger) maxRank;
+(NSArray *) validSuits;

@end


