//
//  LTCardGameConfigProviderProtocol.h
//  Machismo
//
//  Created by Alex Artyomov on 22/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "LTCardMatcherProtocol.h"
#import "LTDeck.h"
/// Protocol that defines functionality of configuration provider for any card mtching game.
@protocol LTCardGameConfigProviderProtocol <NSObject>

/// Defines number of chosen cards that should trigger card matching logic.
@property (readonly, nonatomic) NSUInteger allowedNumberOfChosenCards;

/// Defines initail number of cards that shud be used in the game.
@property (readonly, nonatomic) NSUInteger initialCardCount;

/// Defines the card matcher which contains all the logic of mathching specific sets of cards per
/// game type.
@property (readonly, nonatomic) id <LTCardMatcherProtocol> matcher;

/// Creates new deck of cards.
- (LTDeck *)createDeck;

@end
