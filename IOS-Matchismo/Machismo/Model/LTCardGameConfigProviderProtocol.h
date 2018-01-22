//
//  LTCardGameConfigProviderProtocol.h
//  Machismo
//
//  Created by Alex Artyomov on 22/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "LTCardMatcherProtocol.h"
#import "LTDeck.h"

@protocol LTCardGameConfigProviderProtocol

@property (readonly, nonatomic) NSUInteger allowedNumberOfChosenCards;

@property (readonly, nonatomic) NSUInteger initialCardCount;

@property (readonly, nonatomic) id <LTCardMatcherProtocol> matcher;

- (LTDeck *)createDeck;

@end
