// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTPlayingCard.h"


@interface LTPlayingCard()
@end
@implementation LTPlayingCard
@synthesize suit = _suit;

static NSArray * _validSuits = nil;
static NSArray * _rankStrings = nil;

+ (NSArray *) rankStrings{
    if(!_rankStrings)
    {
        _rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    }
    return _rankStrings;
}



+ (NSArray *) validSuits{
    if(!_validSuits)
    {
        _validSuits = @[@"♠️",@"♣️",@"♥️",@"♦️"];
    }
    return _validSuits;
}

+ (NSUInteger) maxRank{
    return [[LTPlayingCard rankStrings] count] - 1;
}

- (NSString *) contents {
    return [[LTPlayingCard rankStrings][self.rank] stringByAppendingString: self.suit];
}

- (void) setRank:(NSUInteger)rank{
    if(rank <= [LTPlayingCard maxRank])
    {
        _rank = rank;
    }
}

- (int)match:(NSArray *)otherCards {
    int score  = 0;
    for (LTPlayingCard *card in otherCards) {
        if(card.rank == self.rank){
            score += 4;
        }
        if([card.suit isEqualToString:self.suit]){
            score += 1;
        }
    }
    return score;
}


-(void)setSuit:(NSString *)suit{
    if([[LTPlayingCard validSuits] containsObject : suit] )
    {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (NSString *) description {
    return self.contents;
}


@end

