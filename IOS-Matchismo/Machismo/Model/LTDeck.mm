// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTDeck.h"
#import "LTCard.h"
NS_ASSUME_NONNULL_BEGIN

@interface LTDeck()

///Property that holds all the cards in the deck.
@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation LTDeck

-(instancetype)init {
  if(self=[super init]) {
    _cards =[[NSMutableArray alloc] init];
  }
  return self;
}

- (void)addCard:(LTCard *)card atTop:(BOOL)atTop {
    if(atTop)
        [self.cards insertObject:card atIndex:0];
    else
        [self.cards addObject:card];
}
- (void)addCard:(LTCard *)card {
    [self addCard:card atTop:NO];
}

- (LTCard *)drawRandomCard {
    LTCard *randomCard = nil;
    if([self.cards count]) {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

- (BOOL)isEmpty {
    return [self.cards count] == 0;
}

@end

NS_ASSUME_NONNULL_END
