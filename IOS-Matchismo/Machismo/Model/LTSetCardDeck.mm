// Copyright (c) 2018 Lightricks. All rights reserved.
// Created by Alex Artyomov.

#import "LTSetCardDeck.h"
#import "LTSetCard.h"
NS_ASSUME_NONNULL_BEGIN


@implementation LTSetCardDeck

- (instancetype)init {
  if (self = [super init]) {
    for (NSString *shape in [LTSetCard validShapes]) {
      for (UIColor *color in [LTSetCard validColors]) {
        for (int shade = LTSetCardShadeOpen; shade <= LTSetCardShadeSolid; shade++) {
          for (int i = 1; i <= [LTSetCard maxNumber] ; i++) {
            LTSetCard *card = [[LTSetCard alloc] initWithShape:shape color:color
              shade:(LTSetCardShade)shade number:i];
            [self addCard:card];
          }
        }
       
      }
    }
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
