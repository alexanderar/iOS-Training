// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTCard.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTCard

- (int)match:(NSArray *)otherCards {
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

NS_ASSUME_NONNULL_END
