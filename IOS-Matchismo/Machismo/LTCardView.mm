//
//  LTCardView.m
//  Machismo
//
//  Created by Alex Artyomov on 14/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "LTCardView.h"
#import "LTCard.h"
@implementation LTCardView

@dynamic card;
	
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
  if ([keyPath hasPrefix:NSStringFromSelector(@selector(card))]) {
    [self setNeedsDisplay];
  }
}

@end

