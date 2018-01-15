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
#define DEFAULT_CARD_CONTENT_SCALE_FACTOR 0.90

@synthesize cardContentScaleFactor = _cardContentScaleFactor;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
  if ([keyPath hasPrefix:NSStringFromSelector(@selector(card))]) {
    [self setNeedsDisplay];
  }
}

- (CGFloat)cardContentScaleFactor
{
  if (!_cardContentScaleFactor) _cardContentScaleFactor = DEFAULT_CARD_CONTENT_SCALE_FACTOR;
  return _cardContentScaleFactor;
}

- (void)setCardContentScaleFactor:(CGFloat)cardContentScaleFactor
{
  _cardContentScaleFactor = cardContentScaleFactor;
  [self setNeedsDisplay];
}

@end

