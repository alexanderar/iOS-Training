//
//  LTCardMatcherProtocol.h
//  Machismo
//
//  Created by Alex Artyomov on 22/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//


#import "LTCard.h"
@protocol LTCardMatcherProtocol

- (int)match:(NSArray<LTCard *> *)cards;

@end

