// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTDeck.h"
#import "LTCard.h"
@interface LTDeck()
@property (strong, nonatomic) NSMutableArray *cards;
@end



@implementation LTDeck

- (NSMutableArray *) cards{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void)addCard:(LTCard *)card atTop:(BOOL)atTop{
    if(atTop)
        [self.cards insertObject:card atIndex:0];
    else
        [self.cards addObject:card];
}
- (void)addCard:(LTCard *)card{
    [self addCard:card atTop:NO];
}

- (LTCard *) drawRandomCard{
    LTCard *randomCard = nil;
    if([self.cards count]){
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

- (BOOL) isEmpty{
    return [self.cards count] == 0;
}

@end

