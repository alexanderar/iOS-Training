//
//  LTCardMatcherProtocol.h
//  Machismo
//
//  Created by Alex Artyomov on 22/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "LTCard.h"

/// Prorocol that defines the functionality of card matching that has to be used in card matching
/// games.
@protocol LTCardMatcherProtocol  <NSObject>

/// Returns a maching score for the given \c cards array. If there is a match the score is positive,
/// otherwise it is set to 0.
- (int)match:(NSArray<LTCard *> *)cards;

@end

