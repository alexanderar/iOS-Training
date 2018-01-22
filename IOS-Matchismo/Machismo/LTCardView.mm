//
//  LTCardView.m
//  Machismo
//
//  Created by Alex Artyomov on 14/01/2018.
//  Copyright © 2018 Lightricks. All rights reserved.
//

#import "LTCardView.h"
#import "LTCard.h"
#import "LTCardObserverProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LTCardView

@dynamic card;

#define DEFAULT_CARD_CONTENT_SCALE_FACTOR 0.90

@synthesize cardContentScaleFactor = _cardContentScaleFactor;

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(nullable void *)context {
  if ([keyPath hasPrefix:NSStringFromSelector(@selector(card))]) {
    if([keyPath isEqualToString:@"card.chosen"]) {
      if ([[self class] conformsToProtocol:@protocol(LTCardObserverProtocol)]) {
        [(LTCardView <LTCardObserverProtocol> *)self onCardChosenStatusChanged:self.card];
      } else {
        [self setNeedsDisplay];
      }
    }
    if([keyPath isEqualToString:@"card.matched"]) {
      if ([[self class] conformsToProtocol:@protocol(LTCardObserverProtocol)]) {
        [(LTCardView <LTCardObserverProtocol> *)self onCardMtchedStatusChanged:self.card];
      } else {
        [self setNeedsDisplay];
      }
    }
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

- (void)setup {
  for (NSString *key in LTCard.keyPathsForValuesAffectingCard) {
    [self addObserver:self forKeyPath: [@"card." stringByAppendingString:key]
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
  }
}

-(void)dealloc {
  @try {
    for (NSString *key in LTCard.keyPathsForValuesAffectingCard) {
      [self removeObserver:self forKeyPath: [@"card." stringByAppendingString:key]];
    }
  }
  @catch (NSException * __unused exception) {}
}

@end

NS_ASSUME_NONNULL_END

