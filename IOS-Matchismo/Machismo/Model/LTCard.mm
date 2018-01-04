// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCard.h"

@implementation LTCard
- (int)match:(NSArray *) otherCards
{
    int score = 0;
    for (LTCard *card in otherCards){
        if([card.contents isEqualToString:self.contents]) {
            score = 1;
            break;
        }
    }
    return score;
    
}
@end

