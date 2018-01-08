// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTPlayingCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPlayingCard()
@end

@implementation LTPlayingCard

@synthesize suit = _suit;

static NSArray * _validSuits = nil;
static NSArray * _rankStrings = nil;

+ (NSUInteger)maxRank {
  return [[LTPlayingCard rankStrings] count] - 1;
}

+ (NSArray *)rankStrings {
  if(!_rankStrings) {
    _rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
  }
  return _rankStrings;
}

+ (NSArray *)validSuits {
  if(!_validSuits) {
    _validSuits = @[@"♠️",@"♣️",@"♥️",@"♦️"];
  }
  return _validSuits;
}

- (NSAttributedString *)contents {
  return [[NSAttributedString alloc] initWithString:[[LTPlayingCard rankStrings][self.rank]
    stringByAppendingString: self.suit]];
}	

- (void)setRank:(NSUInteger)rank {
  if(rank <= [LTPlayingCard maxRank])
  {
    _rank = rank;
  }
}

-(void)setSuit:(NSString *)suit {
  if([[LTPlayingCard validSuits] containsObject : suit] )
  {
    _suit = suit;
  }
}

- (NSString *)suit {
  return _suit ? _suit : @"?";
}

@end

NS_ASSUME_NONNULL_END
